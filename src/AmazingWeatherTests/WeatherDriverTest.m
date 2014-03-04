//
//  Amazing_WeatherTests.m
//  Amazing WeatherTests
//
//  Created by Alexander Shchapov on 31.01.14.
//
//

#import <XCTest/XCTest.h>
#import "WeatherDriver.h"
#import "WeatherDriver+Helper.h"

@interface WeatherDriverTest : XCTestCase

@property WeatherDriver *driver;

@end

@implementation WeatherDriverTest

@synthesize driver;

- (void)setUp
{
    [super setUp];
    driver = [[WeatherDriver alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testConverter
{
    double result, expectedResult;
    double testValue = 100.0;
    
    expectedResult = 37.77;
    result = [driver convertDegrees:testValue fromUnit:@"Farenheit" toUnit:@"Celsius"];
    XCTAssertEqualWithAccuracy(result, expectedResult, 0.01);
    
    expectedResult = 212.0;
    result = [driver convertDegrees:testValue fromUnit:@"Celsius" toUnit:@"Farenheit"];
    XCTAssertEqualWithAccuracy(result, expectedResult, 0.01);
    
    expectedResult = 373.15;
    result = [driver convertDegrees:testValue fromUnit:@"Celsius" toUnit:@"Kelvin"];
    XCTAssertEqualWithAccuracy(result, expectedResult, 0.01);
    
    expectedResult = -173.15;
    result = [driver convertDegrees:testValue fromUnit:@"Kelvin" toUnit:@"Celsius"];
    XCTAssertEqualWithAccuracy(result, expectedResult, 0.01);
    
    expectedResult = -279.67;
    result = [driver convertDegrees:testValue fromUnit:@"Kelvin" toUnit:@"Farenheit"];
    XCTAssertEqualWithAccuracy(result, expectedResult, 0.01);
    
    expectedResult = 310.92;
    result = [driver convertDegrees:testValue fromUnit:@"Farenheit" toUnit:@"Kelvin"];
    XCTAssertEqualWithAccuracy(result, expectedResult, 0.01);
}

-(void)testWindDirectionDisplay {
    XCTAssertTrue([@"N" isEqualToString:[driver getWindDirectionDisplay:[@350.5 doubleValue]]]);
    XCTAssertTrue([@"N" isEqualToString:[driver getWindDirectionDisplay:[@0.0 doubleValue]]]);
    XCTAssertTrue([@"NNE" isEqualToString:[driver getWindDirectionDisplay:[@12 doubleValue]]]);
    XCTAssertTrue([@"S" isEqualToString:[driver getWindDirectionDisplay:[@170.0 doubleValue]]]);
    XCTAssertTrue([@"W" isEqualToString:[driver getWindDirectionDisplay:[@260.5 doubleValue]]]);
    XCTAssertTrue([@"NW" isEqualToString:[driver getWindDirectionDisplay:[@320.0 doubleValue]]]);
    XCTAssertTrue([@"ENE" isEqualToString:[driver getWindDirectionDisplay:[@57.0 doubleValue]]]);
    XCTAssertTrue([@"NE" isEqualToString:[driver getWindDirectionDisplay:[@34.0 doubleValue]]]);
}

@end
