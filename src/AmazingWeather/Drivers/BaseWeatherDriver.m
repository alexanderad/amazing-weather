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

-(void)getJSONFromServer: (NSString*)urlString
{
    // FIXME: this should reside somewhere in helpers
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error) {
                                   NSLog(@"driver: async request ended with error: %@", error);
                               } else {
                                   NSLog(@"driver: async request successfull");
                                   NSError *parserError = nil;
                                   rawData = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:0
                                                                               error:&parserError];
                                   if(parserError) {
                                       NSLog(@"driver: JSON parser error: %@", parserError);
                                   } else {
                                       NSLog(@"driver: JSON parsed successfully");
                                       [self parseData];
                                   }
                               }
                           }
     ];
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

-(NSString*) getWindDirectionDisplay: (double)degrees {
    /*
    N 348.75 - 11.25
    NNE 11.25 - 33.75
    NE 33.75 - 56.25
    ENE 56.25 - 78.75
    E 78.75 - 101.25
    ESE 101.25 - 123.75
    SE 123.75 - 146.25
    SSE 146.25 - 168.75
    S 168.75 - 191.25
    SSW 191.25 - 213.75
    SW 213.75 - 236.25
    WSW 236.25 - 258.75
    W 258.75 - 281.25
    WNW 281.25 - 303.75
    NW 303.75 - 326.25
    NNW 326.25 - 348.75
    */
    return @"ХЗ";
}

-(void) parseData
{
    // this should be only used in a super call, after actual data parsing is done
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weatherDataReady" object:nil];
}

-(void) fetchData
{
    methodNotImplemented();
}

@end
