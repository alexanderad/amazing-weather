//
//  Icons.m
//  AmazingWeather
//
//  Created by Darednaxella on 9/15/15.
//
//

#include "Icons.h"

@implementation Icons

+(NSDictionary*)getIconsDictionary {
    static NSDictionary *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = @{
                     @200: kOWDWeatherCode200,
                     @201: kOWDWeatherCode201,
                     @202: kOWDWeatherCode202,
                     @210: kOWDWeatherCode210,
                     @211: kOWDWeatherCode211,
                     @212: kOWDWeatherCode212,
                     @221: kOWDWeatherCode221,
                     @230: kOWDWeatherCode230,
                     @231: kOWDWeatherCode231,
                     @232: kOWDWeatherCode232,
                     @300: kOWDWeatherCode300,
                     @301: kOWDWeatherCode301,
                     @302: kOWDWeatherCode302,
                     @310: kOWDWeatherCode310,
                     @311: kOWDWeatherCode311,
                     @312: kOWDWeatherCode312,
                     @313: kOWDWeatherCode313,
                     @314: kOWDWeatherCode314,
                     @321: kOWDWeatherCode321,
                     @500: kOWDWeatherCode500,
                     @501: kOWDWeatherCode501,
                     @502: kOWDWeatherCode502,
                     @503: kOWDWeatherCode503,
                     @504: kOWDWeatherCode504,
                     @511: kOWDWeatherCode511,
                     @520: kOWDWeatherCode520,
                     @521: kOWDWeatherCode521,
                     @522: kOWDWeatherCode522,
                     @531: kOWDWeatherCode531,
                     @600: kOWDWeatherCode600,
                     @601: kOWDWeatherCode601,
                     @602: kOWDWeatherCode602,
                     @611: kOWDWeatherCode611,
                     @612: kOWDWeatherCode612,
                     @615: kOWDWeatherCode615,
                     @616: kOWDWeatherCode616,
                     @620: kOWDWeatherCode620,
                     @621: kOWDWeatherCode621,
                     @622: kOWDWeatherCode622,
                     @701: kOWDWeatherCode701,
                     @711: kOWDWeatherCode711,
                     @721: kOWDWeatherCode721,
                     @731: kOWDWeatherCode731,
                     @741: kOWDWeatherCode741,
                     @761: kOWDWeatherCode761,
                     @762: kOWDWeatherCode762,
                     @771: kOWDWeatherCode771,
                     @781: kOWDWeatherCode781,
                     @800: kOWDWeatherCode800,
                     @801: kOWDWeatherCode801,
                     @802: kOWDWeatherCode802,
                     @803: kOWDWeatherCode803,
                     @804: kOWDWeatherCode804,
                     @900: kOWDWeatherCode900,
                     @901: kOWDWeatherCode901,
                     @902: kOWDWeatherCode902,
                     @903: kOWDWeatherCode903,
                     @904: kOWDWeatherCode904,
                     @905: kOWDWeatherCode905,
                     @906: kOWDWeatherCode906,
                     @957: kOWDWeatherCode957,
        };
    });
    return instance;
}

@end

