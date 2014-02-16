//
//  HelpersTests.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 16.02.14.
//
//

#import <XCTest/XCTest.h>
#import "Preferences.h"

@interface HelpersTests : XCTestCase

@end

@implementation HelpersTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPreferencesString
{
    NSString *stringToSave = @"Hello, my name is";
    [Preferences setString:stringToSave forKey:@"firstname"];
    NSString *stringSaved = [Preferences getStringForKey:@"firstname"];
    XCTAssertTrue([stringSaved isEqualToString:stringToSave]);
}

- (void)testPreferencesInteger
{
    NSInteger intToSave = 10;
    [Preferences setInt:intToSave forKey:@"age"];
    NSInteger intSaved = [Preferences getIntForKey:@"age"];
    XCTAssertEqual(intToSave, intSaved);
}

- (void)testPreferencesBool
{
    BOOL boolToSave = YES;
    [Preferences setBool:boolToSave forKey:@"is_active"];
    BOOL boolSaved = [Preferences getBoolForKey:@"is_active"];
    XCTAssertTrue(boolSaved);
}

@end
