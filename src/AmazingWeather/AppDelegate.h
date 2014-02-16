//
//  AppDelegate.h
//  Amazing Weather
//
//  Created by Alexander Shchapov on 31.01.14.
//
//

#import <Cocoa/Cocoa.h>
#include <CoreLocation/CoreLocation.h>

// these are menu tags constants in order to allow programmatic access
#define kTagUpdatedAt   10
#define kTagWeatherData 20

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate> {
     NSTimer *updateTimer;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong) NSStatusItem *statusItem;

@end
