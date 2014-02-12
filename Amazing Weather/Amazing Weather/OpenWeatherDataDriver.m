//
//  OpenWeatherDataDriver.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 10.02.14.
//
//

#import "OpenWeatherDataDriver.h"

@implementation OpenWeatherDataDriver

-(void) updateData
{
    
}

-(void) parseData
{
}

-(void) getData
{
    NSLog(@"Hello, I'm just here to check that inheritance works :-)");
    NSDictionary *data = [self getJSONFromServer:@"http://openweathermap.org/data/2.0/find/city?lat=55&lon=37&cnt=10"];
    NSLog(@"Data received");
}

@end
