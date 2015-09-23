//
//  AppDelegate.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 31.01.14.
//
//

#import "AppDelegate.h"
#import <stdlib.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherDriver.h"
#import "NSString+Addons.h"
#import "Preferences.h"
//#import "LLManager.h"
#import "Icons.h"

#define UPDATE_INTERVAL (60 * 10) + arc4random_uniform(25)

@implementation AppDelegate {
    WeatherDriver *driver;
    NSWindowController *aboutWindowController;
}

@synthesize statusItem, locationManager, updateTimer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    /*
     * Let The Show begin!
     */
    
    [self initDriver];
    [self initDisplay];

    [self initLocationManager];
    [self subscribeToEvents];

    // make update timer to tick at semi-random intervals
    updateTimer = [NSTimer scheduledTimerWithTimeInterval: UPDATE_INTERVAL
                                                   target: self
                                                 selector: @selector(onTick:)
                                                 userInfo: nil
                                                  repeats: YES];
}

- (void) initLocationManager {
    /*
     * Init a location manager to get location updates.
     */
    
    if (nil == locationManager) {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void) subscribeToEvents {
    /*
     * Subscribe to some of system events we may use to manage weather updates.
     */
    
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

- (void) initDriver {
    /* 
     * Initialize weather driver.
     */
    
    driver = [[WeatherDriver alloc] init];
}

- (void) initDisplay {
    /*
     * Initialize display (menu, title, etc).
     */
    
    NSMenuItem *menuUpdatedAtItem = [[NSMenuItem alloc] initWithTitle:@"Updating data..."
                                                               action:nil
                                                        keyEquivalent:@""];
    [menuUpdatedAtItem setTag:kTagUpdatedAt];
    [menuUpdatedAtItem setAction:@selector(updateNow:)];
    [menuUpdatedAtItem setEnabled:YES];
    
    NSMenuItem *menuWeatherDataItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                 action:nil
                                                          keyEquivalent:@""];
    [menuWeatherDataItem setTag:kTagWeatherData];
    [menuWeatherDataItem setEnabled:NO];
    [menuWeatherDataItem setHidden:YES];

    NSMenuItem *menuLocationDataItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    [menuLocationDataItem setTag:kTagLocation];
    [menuLocationDataItem setEnabled:NO];
    [menuLocationDataItem setHidden:YES];
    
    NSMenuItem *startAtLoginMenu = [[NSMenuItem alloc] initWithTitle:@"Start at login"
                                                              action:@selector(toggleStartAtLogin:)
                                                       keyEquivalent:@""];
    [startAtLoginMenu setTarget:self];
    [startAtLoginMenu setTag:kStartAtLogin];

    //[startAtLoginMenu setState:([LLManager launchAtLogin]) ? NSOnState : NSOffState];

    // preferences
    NSMenu *preferencesSubmenu = [NSMenu alloc];
    [preferencesSubmenu addItem:startAtLoginMenu];
    NSMenuItem *preferencesItem = [[NSMenuItem alloc] initWithTitle:@"Preferences"
                                                             action:nil
                                                      keyEquivalent:@""];
    [preferencesItem setSubmenu:preferencesSubmenu];

    NSMenu *statusBarMenu = [[NSMenu alloc] init];
    [statusBarMenu setDelegate:self];
    [statusBarMenu addItem:menuUpdatedAtItem];

    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItem:menuLocationDataItem];
    [statusBarMenu addItem:menuWeatherDataItem];

    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItem:preferencesItem];

    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItemWithTitle:@"About" action:@selector(about:) keyEquivalent:@""];
    [statusBarMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    
    // create status bar finally and assign the menu
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.menu = statusBarMenu;
    [statusItem setHighlightMode:NO];

    [self setWeatherIconPending];
}

- (void) setWeatherIconPending {
    /*
     * Set weather icon to "Getting weather data".
     */
    NSMutableAttributedString *title = [self getWeatherIconFormatted:kWeatherRefreshIcon];
    [title addAttribute: NSBaselineOffsetAttributeName
                      value: @(3.0)
                      range: NSMakeRange(0, title.length)];
    [statusItem setAttributedTitle:title];
}

- (void) setWeather:(NSString *)icon withData:(NSString *)data {
    /*
     * Sets weather with given icon and data.
     */
    
    NSLog(@"setWeather call: icon %@, data %@", icon, data);
    
    NSString *iconConstant = [[Icons getIconsDictionary] objectForKey:icon];
    if(iconConstant == (id)[NSNull null]) {
        iconConstant = kWeatherDefaultIcon;
    }

    NSMutableAttributedString *titleIcon = [[NSMutableAttributedString alloc] initWithAttributedString:[self getWeatherIconFormatted:iconConstant]];
    if (data.length > 0) {
        NSMutableAttributedString *titleData = [self getWeatherDataFormatted:data];
        [titleIcon appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [titleIcon appendAttributedString:titleData];
    };

    [titleIcon addAttribute: NSBaselineOffsetAttributeName
                  value: @(10.0)
                  range: NSMakeRange(0, titleIcon.length)];

    [statusItem setAttributedTitle:titleIcon];
}

- (NSMutableAttributedString*) getWeatherDataFormatted:(NSString *) data {
    /*
     * Prepare weather data (actual temperature value) to be displayed.
     */
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:data];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:@"°"]];

    return title;
}

- (NSMutableAttributedString*) getWeatherIconFormatted:(NSString *) code {
    /*
     * Prepare given weather icon to be displayed.
     */
    
    NSFont *titleFont = [NSFont fontWithName:@"Weather Icons" size:[NSFont systemFontSize]];
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject: titleFont
                                                                forKey: NSFontAttributeName];
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc] initWithString: code
                                                                              attributes: titleAttributes];
    return title;
}

- (void) updateDisplay {
    /*
     * Process weather update event.
     */
     
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    [self setWeather:[driver weatherCode] withData:[NSString stringWithFormat:@"%.0f", [driver temperatureCelsius]]];
        
    // format all the data to strings
    NSString *temperature = [NSString stringWithFormat:@"Temperature is %.2f°C", [driver temperatureCelsius]];
        
    NSString *wind = [NSString stringWithFormat:@"Wind is at %.0f m/s to %@",
                      [[driver windSpeed] floatValue],
                      [driver windDirection]];
        
        NSString *humidity = [NSString stringWithFormat:@"Humidity %@%%",
                              [driver humidity]];

        // ugly way to change colours
        NSDictionary *weatherAttributes = [NSDictionary
                                           dictionaryWithObjectsAndKeys:
                                           [NSColor darkGrayColor], NSForegroundColorAttributeName,
                                           [NSFont systemFontOfSize:14.0],
                                           NSFontAttributeName, nil];
        
        NSArray *weatherDataArray = [NSArray arrayWithObjects:
                                     temperature, wind, humidity, nil];

        // dumb filtering of null values in rendered strings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT(SELF contains[c] '(null)')"];
        weatherDataArray = [weatherDataArray filteredArrayUsingPredicate:predicate];
        
        NSString *joined = [weatherDataArray componentsJoinedByString:@"\n"];
        NSAttributedString *weatherDataAString = [[NSAttributedString alloc]
                                                           initWithString:joined
                                                           attributes:weatherAttributes];
        [self.statusItem.menu itemWithTag:kTagWeatherData].attributedTitle = weatherDataAString;
        [self.statusItem.menu itemWithTag:kTagWeatherData].hidden = NO;

        // statement
        NSString *statement = [NSString stringWithFormat:@"%@ in %@", [driver weatherDescription], [driver location]];
        NSAttributedString *location = [[NSAttributedString alloc]
                                        initWithString:statement
                                        attributes:weatherAttributes];
        [self.statusItem.menu itemWithTag:kTagLocation].attributedTitle = location;
        [self.statusItem.menu itemWithTag:kTagLocation].hidden = NO;

        // updated at
        NSString *dateString = [NSString stringWithFormat:@"Updated at %@",
                                [dateFormatter stringFromDate:[NSDate date]]];
        [self.statusItem.menu itemWithTag:kTagUpdatedAt].title = dateString;
}

// subscribe to location change event and get city from CoreLocation
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"got location update");
    CLLocation *location = [locations lastObject];
    [driver setCurrentCoordinates:location.coordinate];
    [locationManager stopUpdatingLocation];
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
}

- (void)updateNow:(id)sender {
    [updateTimer fire];
}

- (void)toggleStartAtLogin:(id)sender
{
//    if ([LLManager launchAtLogin] == YES) {
//        [LLManager setLaunchAtLogin:NO];
//        [[self.statusItem.menu itemWithTag:kStartAtLogin] setState:NSOffState];
//    }
//    else {
//        [LLManager setLaunchAtLogin:YES];
//        [[self.statusItem.menu itemWithTag:kStartAtLogin] setState:NSOnState];
//    }
}

@end
