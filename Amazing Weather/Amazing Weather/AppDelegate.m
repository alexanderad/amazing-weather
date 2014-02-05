//
//  AppDelegate.m
//  Amazing Weather
//
//  Created by Darednaxella on 1/31/14.
//
//

#import "AppDelegate.h"
#include <stdlib.h>
#include <CoreLocation/CoreLocation.h>

#define API_KEY @"d8b1d8fe5065f29a130a8da1fedc6d7f"
#define API_URL @"http://api.openweathermap.org/data/2.5/weather"
#define CITY_ID 702550



@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // create a menu, set initial values
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
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
    
//    
//    // Turn on CoreLocation
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    [locationManager startUpdatingLocation];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 1000;
    [locationManager startMonitoringSignificantLocationChanges];
    //[locationManager startUpdatingLocation];
    
}

// subscribe to location change event and get city from CoreLocation
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"Location updated from %@ to %@", oldLocation, newLocation);
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         NSLog(@"Received placemarks: %@", placemarks);
         
         
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSString *countryCode = myPlacemark.ISOcountryCode;
         NSString *countryName = myPlacemark.country;
         NSString *city1 = myPlacemark.subLocality;
         NSString *city2 = myPlacemark.locality;
         NSLog(@"My country code: %@, countryName: %@, city1: %@, city2: %@", countryCode, countryName, city1, city2);
     }];
}

- (void)onTick:(NSTimer *) timer {
    
    
    
    NSString *urlAsString = [NSString stringWithFormat:@"%@?id=%d&lang=ua&APPID=%@", API_URL, CITY_ID, API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"failed to fetch data: %@", error);
        } else {
            NSLog(@"data sucessfully received");
    
            NSError *localError = nil;
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            
            //NSArray *results = [parsedObject valueForKey:@"main"];
            
            // fetch current temperature and convert it from Kelvin to Celsius
            double temperature = [[[parsedObject valueForKey:@"main"] valueForKey:@"temp"] doubleValue];
            double temperatureCelsius = temperature - 273.15;
            
            NSLog(@"Temperature received: %f", temperatureCelsius);
            
            // we round it now, allowing user to change that behavior later
            [statusItem setTitle:[NSString stringWithFormat:@"%.0f°C", temperatureCelsius]];
        }
    }];
}

- (void) receiveWakeNote: (NSNotification*) note
{
    // wake up note -- changed state of sleep/wake
    NSLog(@"receivedSleepNote: %@, requesting timer to fire", [note name]);
    [updateTimer fire];
}

- (IBAction)quitAction:(id)sender {
    // quit the application :-)
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
