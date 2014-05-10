//
//  BaseWeatherDriver.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 10.02.14.
//
//

#import "WeatherDriver.h"
#import "WeatherDriver+Helper.h"

#define API_KEY @"fcuxufej65rppfg299cnhy4q"
#define API_URL @"http://api.worldweatheronline.com/free/v1/weather.ashx"

@implementation WeatherDriver

@synthesize temperatureKelvin, temperatureCelsius, temperatureFarenheit;
@synthesize location, windSpeed, windDirection;
@synthesize humidity, pressure;

-(void) setCurrentCoordinates:(CLLocationCoordinate2D)coordinates {
    currentCoordinates = coordinates;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weatherGotNewLocation" object:nil];
}

-(CLLocationCoordinate2D)getCurrentCoordinates {
    return currentCoordinates;
}

-(void) parseData {
    NSDictionary *data = [rawData valueForKey:@"data"];
    NSDictionary *current = [data valueForKey:@"current_condition"];

    // temperatures
    temperatureCelsius = [[[current valueForKey:@"temp_C"] objectAtIndex:0] doubleValue];
    temperatureKelvin = [self convertDegrees:temperatureCelsius
                                    fromUnit:@"Celsius"
                                      toUnit:@"Kelvin"];
    temperatureFarenheit = [self convertDegrees:temperatureKelvin
                                       fromUnit:@"Kelvin"
                                         toUnit:@"Farenheit"];

    // location reported
    NSString *areaName = [[[[[data valueForKey:@"nearest_area"]
                              valueForKey:@"areaName"]
                              valueForKey:@"value"] objectAtIndex:0] objectAtIndex:0];
    NSString *region = [[[[[data valueForKey:@"nearest_area"]
                            valueForKey:@"region"]
                            valueForKey:@"value"] objectAtIndex:0] objectAtIndex:0];
    //NSString *region = @"";
    NSString *country = [[[[[data valueForKey:@"nearest_area"]
                            valueForKey:@"country"]
                           valueForKey:@"value"] objectAtIndex:0] objectAtIndex:0];
    location = [NSString stringWithFormat:@"%@\n%@\n%@", areaName, region, country];

    // wind
    double windKmph = [[[current valueForKey:@"windspeedKmph"] objectAtIndex:0] doubleValue];
    double windMps = windKmph * 0.277777778;
    windSpeed = [NSNumber numberWithDouble:windMps];
    windDirection = [[current valueForKey:@"winddir16Point"] objectAtIndex:0];

    // humidity & pressure
    humidity = [[current valueForKey:@"humidity"] objectAtIndex:0];
    double pressureMb = [[[current valueForKey:@"pressure"] objectAtIndex:0] doubleValue];
    double pressureMm = pressureMb * 0.75218;
    pressure = [NSNumber numberWithDouble:pressureMm];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"weatherDataReady" object:nil];
}

-(void) fetchData {
    NSLog(@"fetchData: %f lat, %f lon", currentCoordinates.latitude, currentCoordinates.longitude);
    NSString *url =
        [NSString stringWithFormat:@"%@?q=%f,%f&format=json&fx=no&includelocation=yes&key=%@",
         API_URL, currentCoordinates.latitude, currentCoordinates.longitude, API_KEY];
    NSLog(@"%@", url);
    [self getJSONFromServer:url];
}

@end
