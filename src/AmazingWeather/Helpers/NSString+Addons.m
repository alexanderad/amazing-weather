//
//  NSString+Addons.m
//  AmazingWeather
//
//  Created by Darednaxella on 9/20/15.
//
//

#import "NSString+Addons.h"

@implementation NSString (Addons)

- (NSString *)sentenceCapitalizedString {
    if (![self length]) {
        return [NSString string];
    }
    NSString *uppercase = [[self substringToIndex:1] uppercaseString];
    NSString *lowercase = [[self substringFromIndex:1] lowercaseString];
    return [uppercase stringByAppendingString:lowercase];
}

@end
