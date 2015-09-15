//
//  BaseWeatherDriver.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 10.02.14.
//
//

#import "WeatherDriver.h"
#import "WeatherDriver+Helper.h"

#define API_KEY @"1fb7c021c52aef899d2b8f4f498ebeef"
#define API_URL @"http://api.openweathermap.org/data/2.5/weather"

@implementation WeatherDriver

@synthesize temperatureKelvin, temperatureCelsius, temperatureFarenheit;
@synthesize location, weatherCode, weatherDescription, windSpeed, windDirection;
@synthesize humidity, pressure;
@synthesize sunrise, sunset;

-(void) setCurrentCoordinates:(CLLocationCoordinate2D)coordinates {
    currentCoordinates = coordinates;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weatherGotNewLocation" object:nil];
}

-(CLLocationCoordinate2D)getCurrentCoordinates {
    return currentCoordinates;
}

-(void) parseData {
    // temperatures
    temperatureKelvin = [[[rawData valueForKey:@"main"] valueForKey:@"temp"] doubleValue];
    temperatureCelsius = [self convertDegrees:temperatureKelvin
                                     fromUnit:@"Kelvin"
                                       toUnit:@"Celsius"];
    temperatureFarenheit = [self convertDegrees:temperatureKelvin
                                       fromUnit:@"Kelvin"
                                         toUnit:@"Farenheit"];
    
    // location reported
    location = [NSString stringWithFormat:@"%@ (%@)",
                [rawData valueForKey:@"name"],
                [[rawData valueForKey:@"sys"] valueForKey:@"country"]];
    
    // weather code
    weatherCode = [[rawData valueAtIndex:0 inPropertyWithKey:@"weather"] valueForKey:@"id"];

    NSString *descriptionMain = [[rawData valueAtIndex:0 inPropertyWithKey:@"weather"] valueForKey:@"main"];
    NSString *descriptionFull = [[rawData valueAtIndex:0 inPropertyWithKey:@"weather"] valueForKey:@"description"];
    weatherDescription = [[NSString alloc] initWithFormat:@"%@: %@", descriptionMain, descriptionFull];

    // wind
    windSpeed = [[rawData valueForKey:@"wind"] valueForKey:@"speed"];
    double windDirectionDegrees = [[[rawData valueForKey:@"wind"] valueForKey:@"deg"] doubleValue];
    windDirection = [self getWindDirectionDisplay:windDirectionDegrees];
    
    // humidity & pressure
    humidity = [[rawData valueForKey:@"main"] valueForKey:@"humidity"];
    pressure = [[rawData valueForKey:@"main"] valueForKey:@"pressure"];
    
    // sunrise & sunset
    NSTimeInterval interval;
    interval = [[[rawData valueForKey:@"sys"] valueForKey:@"sunrise"] doubleValue];
    sunrise = [NSDate dateWithTimeIntervalSince1970:interval];
    interval = [[[rawData valueForKey:@"sys"] valueForKey:@"sunset"] doubleValue];
    sunset = [NSDate dateWithTimeIntervalSince1970:interval];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"weatherDataReady" object:nil];
}

-(void) fetchData
{
    NSLog(@"fetchData: %f lat, %f lon", currentCoordinates.latitude, currentCoordinates.longitude);
    NSString *url = [NSString stringWithFormat:@"%@?lat=%f&lon=%f&lang=en&APPID=%@",
                     API_URL, currentCoordinates.latitude, currentCoordinates.longitude, API_KEY];
    NSLog(@"%@", url);
    [self getJSONFromServer:url];
}

@end
