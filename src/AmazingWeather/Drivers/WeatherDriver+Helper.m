//
//  WeatherDriver+Helper.m
//  AmazingWeather
//
//  Created by Darednaxella on 3/4/14.
//
//

#import "WeatherDriver+Helper.h"

@implementation WeatherDriver (Helper)

-(id)fetchDictKey:(NSString*)key fromDictionary:(NSDictionary*)sourceDict {
    NSArray *parts = [key componentsSeparatedByString:@"."];
    return parts;
}

-(void)getJSONFromServer: (NSString *)urlString
{
    // FIXME: this should reside somewhere in helpers
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if(error) {
                                   NSLog(@"driver: async request ended with error: %@", error);
                               } else {
                                   NSLog(@"driver: async request successfull");
                                   NSError *parserError = nil;
                                   rawData = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:0
                                                                               error:&parserError];
                                   if(parserError) {
                                       NSLog(@"driver: json parser error: %@", parserError);
                                   } else {
                                       NSLog(@"driver: json parsed successfully");
                                       [self parseData];
                                   }
                               }
                           }
     ];
}

-(double) convertDegrees: (double)temperature
                fromUnit:(NSString *)unitFrom
                  toUnit:(NSString *)unitTo
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

-(NSString *) getWindDirectionDisplay: (double)degrees {
    NSArray *lookup = [NSArray arrayWithObjects:
                       [NSArray arrayWithObjects:@348.75, @360.0, @"N", nil],
                       [NSArray arrayWithObjects:@0.0, @11.25, @"N", nil],
                       [NSArray arrayWithObjects:@11.25, @33.75, @"NNE", nil],
                       [NSArray arrayWithObjects:@33.75, @56.25, @"NE", nil],
                       [NSArray arrayWithObjects:@56.25, @78.75, @"ENE", nil],
                       [NSArray arrayWithObjects:@78.75, @101.25, @"E", nil],
                       [NSArray arrayWithObjects:@101.25, @123.75, @"ESE", nil],
                       [NSArray arrayWithObjects:@123.75, @146.25, @"SE", nil],
                       [NSArray arrayWithObjects:@146.25, @168.75, @"SSE", nil],
                       [NSArray arrayWithObjects:@168.75, @191.25, @"S", nil],
                       [NSArray arrayWithObjects:@191.25, @213.75 ,@"SSW", nil],
                       [NSArray arrayWithObjects:@213.75, @236.25, @"SW", nil],
                       [NSArray arrayWithObjects:@236.25, @258.75, @"WSW", nil],
                       [NSArray arrayWithObjects:@258.75, @281.25, @"W", nil],
                       [NSArray arrayWithObjects:@281.25, @303.75, @"WNW", nil],
                       [NSArray arrayWithObjects:@303.75, @326.25, @"NW", nil],
                       [NSArray arrayWithObjects:@326.25, @348.75, @"NNW", nil], nil];
    for(id range in lookup) {
        double range_start = [[range objectAtIndex:0] doubleValue];
        double range_end = [[range objectAtIndex:1] doubleValue];
        NSString *direction = [range objectAtIndex:2];
        if(degrees >= range_start && degrees < range_end) {
            return direction;
        }
    }
    return @"";
}

@end
