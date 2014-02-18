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
#include "OpenWeatherDataDriver.h"


@implementation AppDelegate {
    OpenWeatherDataDriver *driver;
}

@synthesize statusItem, locationManager, updateTimer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initDisplay];
    [self initDriver];
    
    //[self initLocationManager];
    [self subscribeToEvents];
    
    // start update timer to tick
    updateTimer = [NSTimer scheduledTimerWithTimeInterval: (60 * 15) + arc4random_uniform(25)
                                                   target: self
                                                 selector: @selector(onTick:)
                                                 userInfo: nil
                                                  repeats: YES];
    // fire immediately
    [updateTimer fire];
}

- (void) initLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 1000;
    [locationManager startUpdatingLocation];
}

- (void) initDriver {
    driver = [[OpenWeatherDataDriver alloc] init];
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
}

- (void) initDisplay {
    // create a menu, set initial values
    NSMenuItem *menuUpdatedAtItem = [[NSMenuItem alloc] initWithTitle:@"Updating right now..."
                                                               action:nil
                                                        keyEquivalent:@""];
    [menuUpdatedAtItem setTag:kTagUpdatedAt];
    [menuUpdatedAtItem setAction:@selector(updateNow:)];
    [menuUpdatedAtItem setEnabled:YES];
    
    NSMenuItem *menuWeatherDataItem = [[NSMenuItem alloc] initWithTitle:@"Getting weather data..."
                                                                 action:nil
                                                          keyEquivalent:@""];
    [menuWeatherDataItem setTag:kTagWeatherData];
    [menuWeatherDataItem setEnabled:NO];
    
    NSMenu *statusBarMenu = [[NSMenu alloc] init];
    [statusBarMenu setDelegate:self];
    [statusBarMenu addItem:menuUpdatedAtItem];
    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItem:menuWeatherDataItem];
    [statusBarMenu addItem:[NSMenuItem separatorItem]];
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
        NSString *location = [NSString stringWithFormat:@"Location: %@",
                              [driver location]];
        NSString *temperature = [NSString stringWithFormat:@"Temperature: %.2f°C",
                                 [driver temperatureCelsius]];
        
        NSString *wind = [NSString stringWithFormat:@"Wind: %@ m/s (%@)",
                          [driver windSpeed],
                          [driver windDirection]];
        
        NSString *humidity = [NSString stringWithFormat:@"Humidity: %@%%", [driver humidity]];
        NSString *pressure = [NSString stringWithFormat:@"Pressure: %@ mm", [driver pressure]];
        
        NSString *sunrise = [NSString stringWithFormat:@"Sunrise: %@",
                             [dateFormatter stringFromDate:[driver sunrise]]];
        NSString *sunset = [NSString stringWithFormat:@"Sunset: %@",
                            [dateFormatter stringFromDate:[driver sunset]]];
        
        // ugly way to change colours
        NSDictionary *attributes = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSColor darkGrayColor], NSForegroundColorAttributeName,
                                    [NSFont systemFontOfSize:14.0],
                                    NSFontAttributeName, nil];
        
        NSArray *weatherDataArray = [NSArray arrayWithObjects:
                                     location, temperature, wind,
                                     humidity, pressure,
                                     sunrise, sunset,
                                     nil];
        
        NSString *joined = [weatherDataArray componentsJoinedByString:@"\n"];
        NSAttributedString *weatherDataAString = [[NSAttributedString alloc]
                                                           initWithString:joined
                                                           attributes:attributes];
        [self.statusItem.menu itemWithTag:kTagWeatherData].attributedTitle = weatherDataAString;
        
        // updated at
        NSString *dateString = [NSString stringWithFormat:@"Updated at %@",
                                [dateFormatter stringFromDate:[NSDate date]]];
        [self.statusItem.menu itemWithTag:kTagUpdatedAt].title = dateString;
    }
}

// subscribe to location change event and get city from CoreLocation
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSLog(@"location: location updated from %@ to %@", oldLocation, newLocation);
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:newLocation
                          completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"location: geocode failed with error: %@", error);
             return;
         }
         
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSString *countryCode = myPlacemark.ISOcountryCode;
         NSString *countryName = myPlacemark.country;
         NSString *city1 = myPlacemark.subLocality;
         NSString *city2 = myPlacemark.locality;
         NSLog(@"location: country code: %@, country name: %@, city1: %@, city2: %@",
               countryCode, countryName,
               city1, city2);
     }];
}

- (void)updateNow:(id)sender {
    [updateTimer fire];
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

- (void) receiveWakeNote: (NSNotification*) note
{
    // wake up note -- changed state of sleep/wake
    NSLog(@"received wake note: %@, requesting timer to fire", [note name]);
    [updateTimer fire];
}

@end
