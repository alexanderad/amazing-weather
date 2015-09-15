//
//  main.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 31.01.14.
//
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // initialize NSApp instance
        [NSApplication sharedApplication];
        
        // allocate our delegate and run all that shi
        AppDelegate *appDelegate = [[AppDelegate alloc] init];
        [NSApp setDelegate:appDelegate];

        // run main loop
        [NSApp run];
    }
    return 0;
}