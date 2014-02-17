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

-(void) updateDisplay
{
    NSLog(@"update display here");
    /*
     // fetch current temperature and convert it from Kelvin to Celsius
     double temperatureKelvin = [[[parsedObject valueForKey:@"main"] valueForKey:@"temp"] doubleValue];
     double temperatureCelsius = temperatureKelvin - 273.15;
     
     NSLog(@"Temperature received: %f", temperatureCelsius);
     
     // we round it now, allowing user to change that behavior later
     [statusItem setTitle:[NSString stringWithFormat:@"%.0f°C", temperatureCelsius]];
     
     // updated at
     NSDate *currDate = [NSDate date];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
     [dateFormatter setDateFormat:@"HH:mm"];
     NSString *dateString = [dateFormatter stringFromDate:currDate];
     [self.statusItem.menu itemWithTag:kTagUpdatedAt].title =
     [NSString stringWithFormat:@"Updated at %@", dateString];
     
     // collect all the data
     NSString *location = [NSString stringWithFormat:@"Location: %@ (%@)",
     [parsedObject valueForKey:@"name"],
     [[parsedObject valueForKey:@"sys"] valueForKey:@"country"]];
     
     NSString *temperature = [NSString stringWithFormat:@"Temperature: %.2f°C", temperatureCelsius];
     
     NSString *wind = [NSString stringWithFormat:@"Wind: %@ m/s",
     [[parsedObject valueForKey:@"wind"] valueForKey:@"speed"]];
     
     NSString *humidity = [NSString stringWithFormat:@"Humidity: %@%%",
     [[parsedObject valueForKey:@"main"] valueForKey:@"humidity"]];
     
     NSString *pressure = [NSString stringWithFormat:@"Pressure: %@ mm",
     [[parsedObject valueForKey:@"main"] valueForKey:@"pressure"]];
     
     NSTimeInterval interval;
     interval = [[[parsedObject valueForKey:@"sys"] valueForKey:@"sunrise"] doubleValue];
     NSString *sunrise = [NSString stringWithFormat:@"Sunrise: %@",
     [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]]];
     interval = [[[parsedObject valueForKey:@"sys"] valueForKey:@"sunset"] doubleValue];
     NSString *sunset = [NSString stringWithFormat:@"Sunset: %@",
     [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]]];
     
     
     NSDictionary *attributes = [NSDictionary
     dictionaryWithObjectsAndKeys:
     [NSColor darkGrayColor], NSForegroundColorAttributeName,
     [NSFont systemFontOfSize:14.0],
     NSFontAttributeName, nil];
     
     NSArray *weatherDataArray = [NSArray arrayWithObjects:
     location,
     temperature,
     wind,
     humidity,
     pressure,
     sunrise,
     sunset,
     nil];
     
     NSAttributedString *weatherDataAttributedString = [[NSAttributedString alloc] initWithString:[weatherDataArray componentsJoinedByString:@"\n"] attributes:attributes];
     
     [self.statusItem.menu itemWithTag:kTagWeatherData].attributedTitle = weatherDataAttributedString;
     }
     }];
     
     
     */
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
