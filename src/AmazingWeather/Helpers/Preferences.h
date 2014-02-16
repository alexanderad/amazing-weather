//
//  Preferences.h
//  Amazing Weather
//
//  Created by Alexander Shchapov on 16.02.14.
//
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

// "-init" is an instance method, "+initialize" is a class method...
+(void)initialize;

// "+" refers class method, ha-ha :-)
+(void)setString: (NSString*)value forKey:(NSString*)key;
+(NSString*)getStringForKey: (NSString*)key;

+(void)setInt: (NSInteger)value forKey:(NSString*)key;
+(NSInteger)getIntForKey: (NSString*)key;

+(void)setBool: (BOOL)value forKey:(NSString*)key;
+(BOOL)getBoolForKey: (NSString*)key;

@end
