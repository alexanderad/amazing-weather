//
//  BaseWeatherDriver.h
//  Amazing Weather
//
//  Created by Alexander Shchapov on 10.02.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherDriver : NSObject
{
    NSDictionary *rawData;
    CLLocationCoordinate2D currentCoordinates;
}

@property (readonly) NSString *location;
@property (readonly) NSString *weatherCode;

@property (readonly) double temperatureCelsius;
@property (readonly) double temperatureKelvin;
@property (readonly) double temperatureFarenheit;

@property (readonly) NSNumber *humidity;
@property (readonly) NSNumber *pressure;

@property (readonly) NSDate *sunrise;
@property (readonly) NSDate *sunset;

@property (readonly) NSNumber *windSpeed;
@property (readonly) NSString *windDirection;

-(void) fetchData;
-(void) parseData;

-(void)setCurrentCoordinates:(CLLocationCoordinate2D)currentCoordinates;
-(CLLocationCoordinate2D)getCurrentCoordinates;

@end
