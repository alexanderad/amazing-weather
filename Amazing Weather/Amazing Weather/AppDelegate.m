//
//  AppDelegate.m
//  Amazing Weather
//
//  Created by Darednaxella on 1/31/14.
//
//

#import "AppDelegate.h"
#include <stdlib.h>


#define API_KEY @"d8b1d8fe5065f29a130a8da1fedc6d7f"
#define API_URL @"http://api.openweathermap.org/data/2.5/weather"
#define CITY_ID 702550



@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // create a menu, set initial values
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Amazing Weather"];
    [statusItem setHighlightMode:YES];
    
    // start update timer to tick
    updateTimer = [NSTimer scheduledTimerWithTimeInterval: (60 * 15) + arc4random_uniform(25) // once in ~15 minutes
                                                   target: self
                                                 selector: @selector(onTick:)
                                                 userInfo: nil
                                                  repeats: YES];
    // fire immediately
    [updateTimer fire];
    
    // subscribe to wake up event
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(receiveWakeNote:)
                                                               name: NSWorkspaceDidWakeNotification object: NULL];
}

- (void)onTick:(NSTimer *) timer {
    
    
    
    NSString *urlAsString = [NSString stringWithFormat:@"%@?id=%d&lang=ua&APPID=%@", API_URL, CITY_ID, API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"failed to fetch data: %@", error);
        } else {
            NSLog(@"data sucessfully received");
    
            NSError *localError = nil;
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            NSArray *results = [parsedObject valueForKey:@"main"];
            
            // fetch current temperature and convert it from Kelvin to Celsius
            double temp = [[results valueForKey:@"temp"] doubleValue];
            temp = temp - 273.15;
            [statusItem setTitle:[NSString stringWithFormat:@"%.1f°C", temp]];
        }
    }];
}

- (void) receiveWakeNote: (NSNotification*) note
{
    // wake up note -- changed state of sleep/wake
    NSLog(@"receivedSleepNote: %@, requesting timer to fire", [note name]);
    [updateTimer fire];
}

- (IBAction)quitAction:(id)sender {
    // quit the application :-)
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
