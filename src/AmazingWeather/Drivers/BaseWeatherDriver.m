//
//  BaseWeatherDriver.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 10.02.14.
//
//

#import "BaseWeatherDriver.h"
#define methodNotImplemented() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]


@implementation BaseWeatherDriver

-(NSDictionary*) getJSONFromServer: (NSString*)urlString
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
    // this should support Celsius, Kelvin (for geeks) and Farenheit
    double result = 0.0;
    
    double (^Kelvin2Celsius)(double) = ^ double (double K) {
        return K - 273.15;
    };
    
    double (^Celsius2Kelvin)(double) = ^ double (double C) {
        return C + 273.15;
    };
    
    double (^Farenheit2Celsius)(double) = ^ double (double F) {
        return (F - 32.0) / 1.8;
    };
    
    double (^Celsius2Farenheit)(double) = ^ double (double C) {
        return C * 1.8 + 32.0;
    };
    
    double (^Farenheit2Kelvin)(double) = ^ double (double F) {
        return Celsius2Kelvin(Farenheit2Celsius(F));
    };
    
    double (^Kelvin2Ferenheit)(double) = ^ double (double K) {
        return Celsius2Farenheit(Kelvin2Celsius(K));
    };
    
    NSDictionary *name2Function = @{@"Kelvin2Celsius": Kelvin2Celsius,
                                    @"Celsius2Kelvin": Celsius2Kelvin,
                                    @"Farenheit2Celsius": Farenheit2Celsius,
                                    @"Celsius2Farenheit": Celsius2Farenheit,
                                    @"Farenheit2Kelvin": Farenheit2Kelvin,
                                    @"Kelvin2Farenheit": Kelvin2Ferenheit};
    
    
    NSString *targetFunctionName = [NSString stringWithFormat:@"%@2%@", unitFrom, unitTo];
    if([name2Function objectForKey:targetFunctionName]) {
        double (^targetFunction)(double) = [name2Function objectForKey:targetFunctionName];
        result = targetFunction(temperature);
    } else {
        [NSException raise:@"No suitable converter" format:@"unit %@ to %@", unitFrom, unitTo];
    }
    
    return result;
}

-(void) updateDisplay
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
