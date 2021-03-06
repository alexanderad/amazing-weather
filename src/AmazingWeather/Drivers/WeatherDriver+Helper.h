//
//  WeatherDriver+Helper.h
//  AmazingWeather
//
//  Created by Darednaxella on 3/4/14.
//
//

#import "WeatherDriver.h"

@interface WeatherDriver (Helper)

-(id)fetchDictKey:(NSString*)key fromDictionary:(NSDictionary*)sourceDict;
-(void) getJSONFromServer:(NSString *)urlString;
-(double) convertDegrees:(double)temperature
                fromUnit:(NSString *)unitFrom
                  toUnit:(NSString *)unitTo;
-(NSString *) getWindDirectionDisplay: (double)degrees;

@end
