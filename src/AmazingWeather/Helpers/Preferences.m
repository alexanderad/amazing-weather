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

+(NSString*)setString: (NSString*)value forKey:(NSString*)key {
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
    return [userDefaults stringForKey:key];
}

+(NSString*)getStringForKey: (NSString *)key {
    NSString *value = [userDefaults stringForKey:key];
    return value;
}

+(NSInteger)setInt: (NSInteger)value forKey:(NSString*)key {
    [userDefaults setInteger:value forKey:key];
    [userDefaults synchronize];
    return [userDefaults integerForKey:key];
}

+(NSInteger)getIntForKey: (NSString *)key {
    return [userDefaults integerForKey:key];
}

+(BOOL)setBool: (BOOL)value forKey:(NSString*)key {
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
    return [userDefaults boolForKey:key];
}

+(BOOL)getBoolForKey: (NSString *)key {
    return [userDefaults boolForKey:key];
}

@end
