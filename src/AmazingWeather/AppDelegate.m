//
//  AppDelegate.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 31.01.14.
//
//

#import "AppDelegate.h"
#include <stdlib.h>
#include <CoreLocation/CoreLocation.h>
#include "OpenWeatherMapDriver.h"
#include "WorldWeatherOnlineDriver.h"
#include "Preferences.h"

#define DEFAULT_DRIVER @"OpenWeatherMap.org"
#define UPDATE_INTERVAL (60 * 5) + arc4random_uniform(25)

@implementation AppDelegate {
    BaseWeatherDriver *driver;
    NSWindowController *aboutWindowController;
}

@synthesize statusItem, locationManager, updateTimer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initDriver:[self getUserDriverName]];
    [self initDisplay];

    [self initLocationManager];
    [self subscribeToEvents];
    
    // start update timer to tick
    updateTimer = [NSTimer scheduledTimerWithTimeInterval: UPDATE_INTERVAL
                                                   target: self
                                                 selector: @selector(onTick:)
                                                 userInfo: nil
                                                  repeats: YES];
}

- (void) initLocationManager {
    if (nil == locationManager) {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void) initDriver:(NSString *)driverName {
    NSLog(@"init driver request %@", driverName);
    Class driverClass = [[BaseWeatherDriver getDriverList] objectForKey:driverName];
    driver = [[driverClass alloc] init];
}

- (void) subscribeToEvents {
    // we're interested in lid opened/closed to keep the data updated
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(receiveWakeNote:)
                                                               name: NSWorkspaceDidWakeNotification
                                                             object: NULL];

    // we're also want to know the new weather data is received and parsed by the weather driver
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weatherDataReady:)
                                                 name:@"weatherDataReady" object:nil];

    // we're also want to know when location changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weatherGotNewLocation:)
                                                 name:@"weatherGotNewLocation" object:nil];
}

- (void) initDisplay {
    // create a menu, set initial values
    NSMenuItem *menuUpdatedAtItem = [[NSMenuItem alloc] initWithTitle:@"Updating data..."
                                                               action:nil
                                                        keyEquivalent:@""];
    [menuUpdatedAtItem setTag:kTagUpdatedAt];
    [menuUpdatedAtItem setAction:@selector(updateNow:)];
    [menuUpdatedAtItem setEnabled:YES];
    
    NSMenuItem *menuWeatherDataItem = [[NSMenuItem alloc] initWithTitle:@"Weather data her"
                                                                 action:nil
                                                          keyEquivalent:@""];
    [menuWeatherDataItem setTag:kTagWeatherData];
    [menuWeatherDataItem setEnabled:NO];

    NSMenuItem *menuLocationDataItem = [[NSMenuItem alloc] initWithTitle:@"Determining your location..."
                                                                  action:nil
                                                           keyEquivalent:@""];
    [menuLocationDataItem setTag:kTagLocation];
    [menuLocationDataItem setEnabled:NO];

    NSMenu *datasourceSubmenu = [[NSMenu alloc] init];
    NSMutableDictionary *driversDict = [BaseWeatherDriver getDriverList];
    for (id driverNameLabel in driversDict) {
        NSMenuItem *driverMenuItem = [[NSMenuItem alloc] initWithTitle:driverNameLabel
                                                                action:@selector(toggleDatasource:)
                                                         keyEquivalent:@""];

        if([[driver getDriverName] isEqualToString:driverNameLabel]) {
            driverMenuItem.state = NSOnState;
        }

        [datasourceSubmenu addItem:driverMenuItem];
    }
    NSMenuItem *datasourceMenu = [[NSMenuItem alloc] initWithTitle:@"Datasource"
                                                            action:nil
                                                     keyEquivalent:@""];
    [datasourceMenu setTag:kTagDatasource];
    [datasourceMenu setSubmenu:datasourceSubmenu];
    
    
    NSMenu *statusBarMenu = [[NSMenu alloc] init];
    [statusBarMenu setDelegate:self];
    [statusBarMenu addItem:menuUpdatedAtItem];
    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItem:menuLocationDataItem];
    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItem:menuWeatherDataItem];
    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItem:datasourceMenu];
    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItemWithTitle:@"About" action:@selector(about:) keyEquivalent:@""];
    [statusBarMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    
    // create status bar and assign menu
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.menu = statusBarMenu;
    [statusItem setTitle:@"Amazing Weather"];
    [statusItem setHighlightMode:YES];
}

- (void) updateDisplay {
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        
        // we round it now, allowing user to change that behavior later
        [statusItem setTitle:[NSString stringWithFormat:@"%.0f°C", [driver temperatureCelsius]]];
        
        // format all the data to strings
        NSString *temperature = [NSString stringWithFormat:@"Temperature: %.2f°C",
                                 [driver temperatureCelsius]];
        
        NSString *wind = [NSString stringWithFormat:@"Wind: %.0f m/s (%@)",
                          [[driver windSpeed] floatValue],
                          [driver windDirection]];
        
        NSString *humidity = [NSString stringWithFormat:@"Humidity: %@%%", [driver humidity]];
        NSString *pressure = [NSString stringWithFormat:@"Pressure: %@ mm", [driver pressure]];
        
        NSString *sunrise = [NSString stringWithFormat:@"Sunrise: %@",
                             [dateFormatter stringFromDate:[driver sunrise]]];
        NSString *sunset = [NSString stringWithFormat:@"Sunset: %@",
                            [dateFormatter stringFromDate:[driver sunset]]];
        
        // ugly way to change colours
        NSDictionary *weatherAttributes = [NSDictionary
                                           dictionaryWithObjectsAndKeys:
                                           [NSColor darkGrayColor], NSForegroundColorAttributeName,
                                           [NSFont systemFontOfSize:14.0],
                                           NSFontAttributeName, nil];
        
        NSArray *weatherDataArray = [NSArray arrayWithObjects:
                                     temperature, wind,
                                     humidity, pressure,
                                     sunrise, sunset,
                                     nil];

        // dumb filtering of null values in rendered strings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT(SELF contains[c] '(null)')"];
        weatherDataArray = [weatherDataArray filteredArrayUsingPredicate:predicate];
        
        NSString *joined = [weatherDataArray componentsJoinedByString:@"\n"];
        NSAttributedString *weatherDataAString = [[NSAttributedString alloc]
                                                           initWithString:joined
                                                           attributes:weatherAttributes];
        [self.statusItem.menu itemWithTag:kTagWeatherData].attributedTitle = weatherDataAString;

        // location
        NSAttributedString *location = [[NSAttributedString alloc]
                                        initWithString:[driver location]
                                        attributes:weatherAttributes];
        [self.statusItem.menu itemWithTag:kTagLocation].attributedTitle = location;

        // updated at
        NSString *dateString = [NSString stringWithFormat:@"Updated at %@",
                                [dateFormatter stringFromDate:[NSDate date]]];
        [self.statusItem.menu itemWithTag:kTagUpdatedAt].title = dateString;
    }
}

// subscribe to location change event and get city from CoreLocation
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"got location update");
    CLLocation *location = [locations lastObject];
    [driver setCurrentCoordinates:location.coordinate];
    [locationManager stopUpdatingLocation];
}

- (void)toggleDatasource:(id)sender {
    // toggle all off
    for (NSMenuItem *datasource in [[sender menu] itemArray]) {
        datasource.state = NSOffState;
    }

    // get new selection, set it, reinitialize driver
    NSMenuItem *item = (NSMenuItem*)sender;
    item.state = NSOnState;

    CLLocationCoordinate2D coordinates = [driver getCurrentCoordinates];
    [self initDriver:[item title]];
    [driver setCurrentCoordinates:coordinates];

    // save in user prefs
    [Preferences setString:[item title] forKey:kOptionUserSelectedDriver];

    // request an update
    //[updateTimer fire];
}

- (void)onTick:(NSTimer *) timer {
    NSLog(@"timer fired, requsting data update");
    [driver fetchData];
}

- (void) weatherDataReady: (NSNotification*) notification
{
    NSLog(@"received weatherDataReady");
    [self updateDisplay];
}

- (void) weatherGotNewLocation: (NSNotification*) notification
{
    NSLog(@"received weatherGotNewLocation");
    [updateTimer fire];
}

- (void) receiveWakeNote: (NSNotification*) note
{
    // wake up note -- changed state of sleep/wake
    NSLog(@"received wake note: %@, requesting timer to fire", [note name]);
    [self performSelector:@selector(updateNowAndCheckLocation:) withObject:self afterDelay:5];
}



- (void)about:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    aboutWindowController = [[NSWindowController alloc] initWithWindowNibName:@"About"];
    [aboutWindowController showWindow:self];
}

- (void)updateNowAndCheckLocation:(id)sender {
    [locationManager startUpdatingLocation];
    [updateTimer fire];
}

- (void)updateNow:(id)sender {
    [locationManager startUpdatingLocation];
    //[updateTimer fire];
}

- (NSString *)getUserDriverName
{
    NSString *driverName = [Preferences getStringForKey:kOptionUserSelectedDriver];

    if(!driverName) {
        driverName = [Preferences setString:DEFAULT_DRIVER forKey:kOptionUserSelectedDriver];
    }

    return driverName;

}

@end
