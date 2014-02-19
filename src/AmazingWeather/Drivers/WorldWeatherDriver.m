//
//  WorldWeatherDriver.m
//  AmazingWeather
//
//  Created by Darednaxella on 2/18/14.
//
//

#define API_KEY @"fcuxufej65rppfg299cnhy4q"
#define API_URL @"http://api.worldweatheronline.com/free/v1/weather.ashx"
#define CITY_ID @"Lviv"

#import "WorldWeatherDriver.h"

@implementation WorldWeatherDriver

@synthesize driverName;
@synthesize temperatureKelvin, temperatureCelsius, temperatureFarenheit;
@synthesize location, windSpeed, windDirection;
@synthesize humidity, pressure;
@synthesize sunrise, sunset;

-(id) init {
    driverName = @"WorldWeather";
    return [super init];
}

-(void) parseData {
    NSDictionary *data = [rawData valueForKey:@"data"];
    NSDictionary *request = [data valueForKey:@"request"];
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
    location = [[request valueForKey:@"query"] objectAtIndex:0];

    // wind
    double windKmph = [[[current valueForKey:@"windspeedKmph"] objectAtIndex:0] doubleValue];
    double windMps = windKmph * 0.277777778;
    windSpeed = [NSNumber numberWithDouble:windMps];
    windDirection = [[current valueForKey:@"winddir16Point"] objectAtIndex:0];

    // humidity & pressure
    humidity = [[current valueForKey:@"humidity"] objectAtIndex:0];
    pressure = [[current valueForKey:@"pressure"] objectAtIndex:0];

    // sunrise & sunset
    // no data from WorldWeather

    [super parseData];
}

-(void) fetchData {
    NSString *url = [NSString stringWithFormat:@"%@?q=%@&format=json&fx=no&key=%@",
                     API_URL, CITY_ID, API_KEY];
    [self getJSONFromServer:url];
}

@end
