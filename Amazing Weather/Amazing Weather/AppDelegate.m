//
//  AppDelegate.m
//  Amazing Weather
//
//  Created by Darednaxella on 1/31/14.
//
//

#import "AppDelegate.h"
#include <stdlib.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // create a menu, set initial values
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Amazing Weather"];
    [statusItem setHighlightMode:YES];
    
    // start update timer to tick
    updateTimer = [NSTimer scheduledTimerWithTimeInterval: (60 * 10) + 15
                                                   target: self
                                                 selector: @selector(onTick:)
                                                 userInfo: nil
                                                  repeats: YES];
    [updateTimer fire];
}

- (void)onTick:(NSTimer *) timer {
    
    NSString *urlAsString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=Lviv,ua&lang=ua&APPID=d8b1d8fe5065f29a130a8da1fedc6d7f"];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    //NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
            NSLog(@"ERROR: %@", error);
            [statusItem setTitle:@"n/a°C"];
        } else {
            NSLog(@"data received");
            
            
            NSError *localError = nil;
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
//            if (localError != nil) {
//                *error = localError;
//                return nil;
//            }
//            
//            NSMutableArray *groups = [[NSMutableArray alloc] init];
//            
            NSArray *results = [parsedObject valueForKey:@"main"];
            double temp = [[results valueForKey:@"temp"] doubleValue];
            temp = temp - 273.15;
            [statusItem setTitle:[NSString stringWithFormat:@"%.1f°C", temp]];
            
        }
    }];
    
    //http://api.openweathermap.org/data/2.5/weather?q=Lviv,ua&lang=ua&APPID=d8b1d8fe5065f29a130a8da1fedc6d7f
}

- (IBAction)quitAction:(id)sender {
    // quit the application :-)
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
