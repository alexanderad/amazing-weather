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

@interface AppDelegate ()
{
    NSTimer *updateTimer;
}

-(void)updateStatusItem;

@end

@implementation AppDelegate

// WTF?
@synthesize statusItem, locationManager;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // create a menu, set initial values
    /*
     Updated at: {{ updated_at_timestamp }}
     Location: {{ location }} ({{ country_code }})
     ----------------------------------
     Temperature: {{ temp }}
     Temperature range: {{ temp_min }} .. {{ temp_max }}
     ----------------------------------
     Wind: {{ wind_speed }} {{ wind_direction }}
     Humidity: {{ humidity }}
     Pressure: {{ pressure }}
     ----------------------------------
     Sunrise: {{ sunrise }}
     Sunset: {{ sunset }}
     ----------------------------------
     Settings ->
        * be more precise (YES / NO)
     ----------------------------------
     About Amazing Weather
     Quit
    */
    
    NSMenuItem *menuUpdatedAtItem = [[NSMenuItem alloc] init];
    [menuUpdatedAtItem setTag:tagUpdatedAt];
    [menuUpdatedAtItem setEnabled:NO];
    
    NSMenuItem *menuLocationItem = [[NSMenuItem alloc] init];
    [menuLocationItem setTag:tagLocation];
    [menuLocationItem setEnabled:NO];
    
    NSMenuItem *menuCurrentTemperatureItem = [[NSMenuItem alloc] init];
    [menuCurrentTemperatureItem setTag:tagCurrentTemperature];
    [menuCurrentTemperatureItem setEnabled:NO];
    
    NSMenuItem *menuTemperatureRangeItem = [[NSMenuItem alloc] init];
    [menuTemperatureRangeItem setTag:tagTemperatureRange];
    [menuTemperatureRangeItem setEnabled:NO];
    
    NSMenuItem *menuWindSpeedItem = [[NSMenuItem alloc] init];
    [menuWindSpeedItem setTag:tagWindSpeed];
    [menuWindSpeedItem setEnabled:NO];
    
    NSMenuItem *menuHumidityItem = [[NSMenuItem alloc] init];
    [menuHumidityItem setTag:tagHumidity];
    [menuHumidityItem setEnabled:NO];
    
    NSMenuItem *menuPressureItem = [[NSMenuItem alloc] init];
    [menuPressureItem setTag:tagPressure];
    [menuPressureItem setEnabled:NO];
    
    NSMenuItem *menuSunriseItem = [[NSMenuItem alloc] init];
    [menuSunriseItem setTag:tagSunrise];
    [menuSunriseItem setEnabled:NO];
    
    NSMenuItem *menuSunsetItem = [[NSMenuItem alloc] init];
    [menuSunsetItem setTag:tagSunset];
    [menuSunsetItem setEnabled:NO];
    
    
    NSMenu *statusBarMenu = [[NSMenu alloc] initWithTitle:@"Status Menu"];
    [statusBarMenu setDelegate:self];
    [statusBarMenu addItem:menuUpdatedAtItem];
    [statusBarMenu addItem:menuLocationItem];
    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItem:menuCurrentTemperatureItem];
    [statusBarMenu addItem:menuTemperatureRangeItem];
    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItem:menuWindSpeedItem];
    [statusBarMenu addItem:menuHumidityItem];
    [statusBarMenu addItem:menuPressureItem];
    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    [statusBarMenu addItem:menuSunriseItem];
    [statusBarMenu addItem:menuSunsetItem];
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
    locationManager.delegate = self;
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

- (void)onTick:(NSTimer *) timer {

    NSString *urlAsString = [NSString stringWithFormat:@"%@?id=%d&lang=en&APPID=%@", API_URL, CITY_ID, API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"failed to fetch data: %@", error);
        } else {
           //
            
            NSLog(@"data sucessfully received");
    
            NSError *localError = nil;
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            
            //NSArray *results = [parsedObject valueForKey:@"main"];
            
            // fetch current temperature and convert it from Kelvin to Celsius
            double temperature = [[[parsedObject valueForKey:@"main"] valueForKey:@"temp"] doubleValue];
            double temperatureCelsius = temperature - 273.15;
            double temperatureMin = [[[parsedObject valueForKey:@"main"] valueForKey:@"temp_min"] doubleValue];
            double temperatureMinCelsius = temperatureMin - 273.15;
            double temperatureMax = [[[parsedObject valueForKey:@"main"] valueForKey:@"temp_max"] doubleValue];
            double temperatureMaxCelsius = temperatureMax - 273.15;
            
            NSLog(@"Temperature received: %f", temperatureCelsius);
            
            // we round it now, allowing user to change that behavior later
            [statusItem setTitle:[NSString stringWithFormat:@"%.0f°C", temperatureCelsius]];
            
            // updated at
            NSDate *currDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd.MM.YYYY HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currDate];
            [self.statusItem.menu itemWithTag:tagUpdatedAt].title =
                [NSString stringWithFormat:@"Updated at: %@", dateString];
            
            // location
            [self.statusItem.menu itemWithTag:tagLocation].title =
                [NSString stringWithFormat:@"Location: %@ (%@)",
                 [parsedObject valueForKey:@"name"],
                 [[parsedObject valueForKey:@"sys"] valueForKey:@"country"]];
            
            // temperature
            [self.statusItem.menu itemWithTag:tagCurrentTemperature].title =
                [NSString stringWithFormat:@"Temperature: %.2f°C", temperatureCelsius];
            
            // temperature range
            [self.statusItem.menu itemWithTag:tagTemperatureRange].title =
            [NSString stringWithFormat:@"Temperature range: %.2f .. %.2f°C",
             temperatureMinCelsius,
             temperatureMaxCelsius];
            
            // wind
            [self.statusItem.menu itemWithTag:tagWindSpeed].title =
            [NSString stringWithFormat:@"Wind: %@ m/s",
             [[parsedObject valueForKey:@"wind"] valueForKey:@"speed"]];
            
            // humidity
            [self.statusItem.menu itemWithTag:tagHumidity].title =
            [NSString stringWithFormat:@"Humidity: %@%%",
             [[parsedObject valueForKey:@"main"] valueForKey:@"humidity"]];
            
            // Pressure
            [self.statusItem.menu itemWithTag:tagPressure].title =
            [NSString stringWithFormat:@"Pressure: %@ mm",
             [[parsedObject valueForKey:@"main"] valueForKey:@"pressure"]];
            
            // Sunrise
            NSTimeInterval interval;
            interval = [[[parsedObject valueForKey:@"sys"] valueForKey:@"sunrise"] doubleValue];
            [self.statusItem.menu itemWithTag:tagSunrise].title =
            [NSString stringWithFormat:@"Sunrise: %@", [NSDate dateWithTimeIntervalSince1970:interval]];
            
            // Sunset
            interval = [[[parsedObject valueForKey:@"sys"] valueForKey:@"sunset"] doubleValue];
            [self.statusItem.menu itemWithTag:tagSunset].title =
            [NSString stringWithFormat:@"Sunset: %@", [NSDate dateWithTimeIntervalSince1970:interval]];
            
        }
    }];
}

- (void) receiveWakeNote: (NSNotification*) note
{
    // wake up note -- changed state of sleep/wake
    NSLog(@"receivedSleepNote: %@, requesting timer to fire", [note name]);
    [updateTimer fire];
}

- (void) updateStatusItem {
    NSLog(@"Update status item called");
}

//- (IBAction)quitAction:(id)sender {
//    // quit the application :-)
//    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
//}

@end
