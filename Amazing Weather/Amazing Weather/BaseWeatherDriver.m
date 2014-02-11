//
//  BaseWeatherDriver.m
//  Amazing Weather
//
//  Created by Darednaxella on 2/10/14.
//
//

#import "BaseWeatherDriver.h"
#define methodNotImplemented() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]


@implementation BaseWeatherDriver

-(NSDictionary*) getJSONFromServer: (NSString*) urlString
{
    // this method is not weather-related, it it just fetches the data from an URL and parses it into JSON
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    __block NSDictionary *parsedObject;
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
    if (error) {
        NSLog(@"getJSONFromServer: failed to fetch data: %@", error);
        parsedObject = [[NSDictionary alloc] init];
    } else {
        NSLog(@"getJSONFromServer: data sucessfully received");
            
        NSError *localError = nil;
        parsedObject = [NSJSONSerialization JSONObjectWithData:data
                                                       options:0
                                                         error:&localError];
    }
    }];
    return parsedObject;
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
    methodNotImplemented();
}

-(void) parseData
{
    methodNotImplemented();
}

-(void) getData
{
    methodNotImplemented();
}

@end
