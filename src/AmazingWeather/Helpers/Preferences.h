//
//  Preferences.h
//  Amazing Weather
//
//  Created by Alexander Shchapov on 16.02.14.
//
//

#define kOptionUserSelectedDriver @"userSelectedDriver"

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

// "-init" is an instance method, "+initialize" is a class method...
+(void)initialize;

// "+" refers class method, ha-ha :-)
+(NSString*)setString: (NSString*)value forKey:(NSString*)key;
+(NSString*)getStringForKey: (NSString*)key;

+(NSInteger)setInt: (NSInteger)value forKey:(NSString*)key;
+(NSInteger)getIntForKey: (NSString*)key;

+(BOOL)setBool: (BOOL)value forKey:(NSString*)key;
+(BOOL)getBoolForKey: (NSString*)key;

@end
