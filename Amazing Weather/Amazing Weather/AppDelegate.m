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
#include "OpenWeatherDataDriver.h"

#define API_KEY @"d8b1d8fe5065f29a130a8da1fedc6d7f"
#define API_URL @"http://api.openweathermap.org/data/2.5/weather"
#define CITY_ID 702550

@implementation AppDelegate

@synthesize statusItem, locationManager;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    OpenWeatherDataDriver *d = [[OpenWeatherDataDriver alloc] init];
    [d getData];
    
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
    //[updateTimer fire];
    
    // subscribe to wake up event
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(receiveWakeNote:)
                                                               name: NSWorkspaceDidWakeNotification object: NULL];

    locationManager = [[CLLocationManager alloc] init];
    //locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 1000;
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

    NSString *urlAsString = [NSString stringWithFormat:@"%@?id=%d&lang=en&APPID=%@", API_URL, CITY_ID, API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"failed to fetch data: %@", error);
        } else {
            NSLog(@"data sucessfully received");
    
            NSError *localError = nil;
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            // fetch current temperature and convert it from Kelvin to Celsius
            double temperatureKelvin = [[[parsedObject valueForKey:@"main"] valueForKey:@"temp"] doubleValue];
            double temperatureCelsius = temperatureKelvin - 273.15;
            
            NSLog(@"Temperature received: %f", temperatureCelsius);
            
            // we round it now, allowing user to change that behavior later
            [statusItem setTitle:[NSString stringWithFormat:@"%.0f°C", temperatureCelsius]];
            
            // updated at
            NSDate *currDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString *dateString = [dateFormatter stringFromDate:currDate];
            [self.statusItem.menu itemWithTag:kTagUpdatedAt].title =
                [NSString stringWithFormat:@"Updated at %@", dateString];
            
            // collect all the data
            NSString *location = [NSString stringWithFormat:@"Location: %@ (%@)",
                                  [parsedObject valueForKey:@"name"],
                                  [[parsedObject valueForKey:@"sys"] valueForKey:@"country"]];
            
            NSString *temperature = [NSString stringWithFormat:@"Temperature: %.2f°C", temperatureCelsius];
        
            NSString *wind = [NSString stringWithFormat:@"Wind: %@ m/s",
                              [[parsedObject valueForKey:@"wind"] valueForKey:@"speed"]];
            
            NSString *humidity = [NSString stringWithFormat:@"Humidity: %@%%",
                                  [[parsedObject valueForKey:@"main"] valueForKey:@"humidity"]];
            
            NSString *pressure = [NSString stringWithFormat:@"Pressure: %@ mm",
                                  [[parsedObject valueForKey:@"main"] valueForKey:@"pressure"]];
            
            NSTimeInterval interval;
            interval = [[[parsedObject valueForKey:@"sys"] valueForKey:@"sunrise"] doubleValue];
            NSString *sunrise = [NSString stringWithFormat:@"Sunrise: %@",
                                 [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]]];
            interval = [[[parsedObject valueForKey:@"sys"] valueForKey:@"sunset"] doubleValue];
            NSString *sunset = [NSString stringWithFormat:@"Sunset: %@",
                                [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]]];
            
            
            NSDictionary *attributes = [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSColor darkGrayColor], NSForegroundColorAttributeName,
                                        [NSFont systemFontOfSize:14.0],
                                        NSFontAttributeName, nil];
            
            NSArray *weatherDataArray = [NSArray arrayWithObjects:
                                         location,
                                         temperature,
                                         wind,
                                         humidity,
                                         pressure,
                                         sunrise,
                                         sunset,
                                         nil];
            
            NSAttributedString *weatherDataAttributedString = [[NSAttributedString alloc] initWithString:[weatherDataArray componentsJoinedByString:@"\n"] attributes:attributes];
            
            [self.statusItem.menu itemWithTag:kTagWeatherData].attributedTitle = weatherDataAttributedString;
        }
    }];
}

- (void) receiveWakeNote: (NSNotification*) note
{
    // wake up note -- changed state of sleep/wake
    NSLog(@"receivedSleepNote: %@, requesting timer to fire", [note name]);
    [updateTimer fire];
}

@end
