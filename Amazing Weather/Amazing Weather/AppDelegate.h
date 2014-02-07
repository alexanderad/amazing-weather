//
//  AppDelegate.h
//  Amazing Weather
//
//  Created by Darednaxella on 1/31/14.
//
//

#import <Cocoa/Cocoa.h>
#include <CoreLocation/CoreLocation.h>

#define tagUpdatedAt            10
#define tagLocation             15
#define tagCurrentTemperature   25
#define tagTemperatureRange     30
#define tagWindSpeed            35
#define tagHumidity             40
#define tagPressure             45
#define tagSunrise              50
#define tagSunset               55

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property (nonatomic,retain) CLLocationManager *locationManager;
@property (strong) NSStatusItem *statusItem;

@end
