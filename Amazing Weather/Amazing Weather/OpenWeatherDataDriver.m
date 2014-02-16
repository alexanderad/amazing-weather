//
//  OpenWeatherDataDriver.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 10.02.14.
//
//

#define API_KEY @"d8b1d8fe5065f29a130a8da1fedc6d7f"
#define API_URL @"http://api.openweathermap.org/data/2.5/weather"
#define CITY_ID 702550

#import "OpenWeatherDataDriver.h"


@implementation OpenWeatherDataDriver

-(void) updateDisplay
{
    NSLog(@"in update data now");
}

-(void) parseData
{
    NSLog(@"in parse data now");
    [self updateDisplay];
}

-(void) getData
{
    NSString *url = [NSString stringWithFormat:@"%@?id=%d&lang=en&APPID=%@", API_URL, CITY_ID, API_KEY];
    rawData = [self getJSONFromServer:url];
    [self parseData];
    
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

@end
