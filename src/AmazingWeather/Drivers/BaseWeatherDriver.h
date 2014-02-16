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

@property (readonly) NSNumber *temperatureCelsius;
@property (readonly) NSNumber *temperatureKelvin;
@property (readonly) NSNumber *temperatureFarenheit;

@property (readonly) NSNumber *humidity;
@property (readonly) NSNumber *pressure;

@property (readonly) NSNumber *windSpeed;
@property (readonly) NSString *windDirection;

@property (readonly) NSDate *sunrise;
@property (readonly) NSDate *sunset;

-(void) getData;
-(void) updateDisplay;
-(void) parseData;

-(NSDictionary*) getJSONFromServer: (NSString*)urlString;
-(double) convertDegrees: (double)temperature fromUnit:(NSString*)unitFrom toUnit:(NSString*)unitTo;

@end
