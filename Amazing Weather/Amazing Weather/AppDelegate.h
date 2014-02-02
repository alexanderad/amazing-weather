//
//  AppDelegate.h
//  Amazing Weather
//
//  Created by Darednaxella on 1/31/14.
//
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSTimer *updateTimer;
}
- (IBAction)quitAction:(id)sender;  

@end
