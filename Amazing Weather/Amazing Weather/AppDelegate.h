//
//  AppDelegate.h
//  Amazing Weather
//
//  Created by Darednaxella on 1/31/14.
//
//

#import <Cocoa/Cocoa.h>
#include <CoreLocation/CoreLocation.h>

#define kTagUpdatedAt   10
#define kTagWeatherData 20

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property (nonatomic,retain) CLLocationManager *locationManager;
@property (strong) NSStatusItem *statusItem;

@end
