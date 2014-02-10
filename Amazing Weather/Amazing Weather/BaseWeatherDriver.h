//
//  BaseWeatherDriver.h
//  Amazing Weather
//
//  Created by Darednaxella on 2/10/14.
//
//

#import <Foundation/Foundation.h>

@interface BaseWeatherDriver : NSObject
{
    NSDictionary *rawData;
}

@property NSNumber *temperatureCelsius;
@property NSNumber *temperatureKelvin;
@property NSNumber *temperatureFarenheit;

@property NSNumber *humidity;
@property NSNumber *pressure;

@property NSNumber *windSpeed;
@property NSString *windDirection;

@property NSDate *sunrise;
@property NSDate *sunset;

-(void) getData;
-(void) updateData;
-(void) parseData;

-(void) getJSONFromServer: (NSString*) url;
-(double) convertDegrees: (double)temperature fromUnit:(NSString*)unitFrom toUnit:(NSString*)unitTo;

@end
