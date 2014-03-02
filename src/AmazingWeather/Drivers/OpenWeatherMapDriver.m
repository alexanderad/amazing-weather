//
//  OpenWeatherDataDriver.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 10.02.14.
//
//

#define API_KEY @"d8b1d8fe5065f29a130a8da1fedc6d7f"
#define API_URL @"http://api.openweathermap.org/data/2.5/weather"
#define CITY_ID 702550 // Lviv

#import "OpenWeatherMapDriver.h"

@implementation OpenWeatherMapDriver

static NSString *driverName = @"OpenWeatherMap.org";

@synthesize temperatureKelvin, temperatureCelsius, temperatureFarenheit;
@synthesize location, windSpeed, windDirection;
@synthesize humidity, pressure;
@synthesize sunrise, sunset;

-(id) init {
    return [super init];
}

+(void)load {
    [BaseWeatherDriver registerDriver:[self class] name:driverName];
}

-(NSString *)getDriverName {
    return driverName;
}

-(void) parseData
{
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
    [super parseData];
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
