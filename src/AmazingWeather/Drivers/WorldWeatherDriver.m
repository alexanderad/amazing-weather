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
    
}

-(void) fetchData {
    NSString *url = [NSString stringWithFormat:@"%@?q=%@&format=json&fx=no&key=%@",
                     API_URL, CITY_ID, API_KEY];
    [self getJSONFromServer:url];
}

@end
