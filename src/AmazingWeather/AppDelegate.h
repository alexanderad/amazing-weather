//
//  AppDelegate.h
//  Amazing Weather
//
//  Created by Alexander Shchapov on 31.01.14.
//
//

#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>

// these are menu tags constants in order to allow programmatic access
#define kTagUpdatedAt   10
#define kTagWeatherData 20
#define kTagLocation    30
#define kStartAtLogin   40

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong) NSStatusItem *statusItem;
@property NSTimer *updateTimer;

- (void) initDriver;
- (void) initDisplay;
- (void) updateDisplay;
- (void) subscribeToEvents;
- (void) initLocationManager;

@end
