//
//  BaseWeatherDriver.m
//  Amazing Weather
//
//  Created by Darednaxella on 2/10/14.
//
//

#import "BaseWeatherDriver.h"

@implementation BaseWeatherDriver

-(void) getJSONFromServer: (NSString*) url
{
    
}


-(double) convertDegrees: (double)temperature fromUnit:(NSString*)unitFrom toUnit:(NSString*)unitTo
{
    // this should support Celsius, Kelvin and Farenheit
    
    /*
     ºF =ºC * 1.8000 + 32.00
     ºC =(ºF - 32) / 1.8000
     
     ºK =ºC + 273.15
     ºC =ºK - 273.15
     */
    
    NSLog(@"convert form %@ to %@ of %f", unitFrom, unitTo, temperature);
    return temperature;
}

-(void) updateData
{
    
}

@end
