//
//  main.m
//  Amazing Weather
//
//  Created by Darednaxella on 1/31/14.
//
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[])
{
    // create an autorelease pool
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    // make sure the application singleton has been instantiated
    NSApplication * application = [NSApplication sharedApplication];
    
    // drain the autorelease pool
    [pool drain];
	
    // execution never gets here ..
    return 0;
}
