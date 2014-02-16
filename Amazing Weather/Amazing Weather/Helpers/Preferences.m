//
//  Preferences.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 16.02.14.
//
//

#import "Preferences.h"

static NSUserDefaults *userDefaults;

@implementation Preferences

+(void)initialize {
    userDefaults = [NSUserDefaults standardUserDefaults];
}

+(void)setString: (NSString*)value forKey:(NSString*)key {
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+(NSString*)getStringForKey: (NSString *)key {
    NSString *value = [userDefaults stringForKey:key];
    if(value) return value;
    return @"";
}

+(void)setInt: (NSInteger)value forKey:(NSString*)key {
    [userDefaults setInteger:value forKey:key];
    [userDefaults synchronize];
}

+(NSInteger)getIntForKey: (NSString *)key {
    return [userDefaults integerForKey:key];
}

+(void)setBool: (BOOL)value forKey:(NSString*)key {
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

+(BOOL)getBoolForKey: (NSString *)key {
    return [userDefaults boolForKey:key];
}

@end
