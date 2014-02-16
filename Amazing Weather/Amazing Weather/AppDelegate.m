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


@implementation AppDelegate

@synthesize statusItem, locationManager;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //OpenWeatherDataDriver *d = [[OpenWeatherDataDriver alloc] init];
    //[d getData];
    
    // create a menu, set initial values
    NSMenuItem *menuUpdatedAtItem = [[NSMenuItem alloc] initWithTitle:@"Updating right now..." action:nil keyEquivalent:@""];
    [menuUpdatedAtItem setTag:kTagUpdatedAt];
    [menuUpdatedAtItem setAction:@selector(updateNow:)];
    [menuUpdatedAtItem setEnabled:YES];
    
    NSMenuItem *menuWeatherDataItem = [[NSMenuItem alloc] initWithTitle:@"Getting weather data..." action:nil keyEquivalent:@""];
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
    
    // start update timer to tick
    updateTimer = [NSTimer scheduledTimerWithTimeInterval: (60 * 15) + arc4random_uniform(25) // once in ~15 minutes
                                                   target: self
                                                 selector: @selector(onTick:)
                                                 userInfo: nil
                                                  repeats: YES];
    // fire immediately
    [updateTimer fire];
    
    // subscribe to wake up event
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(receiveWakeNote:)
                                                               name: NSWorkspaceDidWakeNotification object: NULL];

    locationManager = [[CLLocationManager alloc] init];
    //locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.    distanceFilter = 1000;
    //[locationManager startUpdatingLocation];
}

// subscribe to location change event and get city from CoreLocation
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //NSLog(@"Location updated from %@ to %@", oldLocation, newLocation);
    if(!oldLocation) {
        // this is the first time we got location update and now all we need is a significant changes
        [locationManager startMonitoringSignificantLocationChanges];
        [locationManager stopUpdatingLocation];
        NSLog(@"Not monitoring standard location updates anymore");
    }
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         //NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         //NSLog(@"Received placemarks: %@", placemarks);
         
         
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSString *countryCode = myPlacemark.ISOcountryCode;
         NSString *countryName = myPlacemark.country;
         NSString *city1 = myPlacemark.subLocality;
         NSString *city2 = myPlacemark.locality;
         NSLog(@"My country code: %@, countryName: %@, city1: %@, city2: %@", countryCode, countryName, city1, city2);
     }];
}

- (void)updateNow:(id)sender {
    [updateTimer fire];
}

- (void)onTick:(NSTimer *) timer {
    
}

- (void) receiveWakeNote: (NSNotification*) note
{
    // wake up note -- changed state of sleep/wake
    NSLog(@"receivedSleepNote: %@, requesting timer to fire", [note name]);
    [updateTimer fire];
}

@end
