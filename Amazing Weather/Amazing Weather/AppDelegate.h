//
//  AppDelegate.h
//  Amazing Weather
//
//  Created by Darednaxella on 1/31/14.
//
//

#import <Cocoa/Cocoa.h>
#include <CoreLocation/CoreLocation.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSTimer *updateTimer;
    CLLocationManager *locationManager;
}
- (IBAction)quitAction:(id)sender;
@property (nonatomic,retain) CLLocationManager *locationManager;

@end
