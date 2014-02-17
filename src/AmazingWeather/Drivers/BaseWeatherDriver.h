//
//  BaseWeatherDriver.h
//  Amazing Weather
//
//  Created by Alexander Shchapov on 10.02.14.
//
//

#import <Foundation/Foundation.h>

@interface BaseWeatherDriver : NSObject
{
    NSDictionary *rawData;
}

@property (readonly) NSString *location;

@property (readonly) double temperatureCelsius;
@property (readonly) double temperatureKelvin;
@property (readonly) double temperatureFarenheit;

@property (readonly) NSNumber *humidity;
@property (readonly) NSNumber *pressure;

@property (readonly) NSNumber *windSpeed;
@property (readonly) NSString *windDirection;

@property (readonly) NSDate *sunrise;
@property (readonly) NSDate *sunset;

-(void) getData;
-(void) updateDisplay;
-(void) parseData;

-(void) getJSONFromServer: (NSString*)urlString;
-(double) convertDegrees: (double)temperature fromUnit:(NSString*)unitFrom toUnit:(NSString*)unitTo;

@end
