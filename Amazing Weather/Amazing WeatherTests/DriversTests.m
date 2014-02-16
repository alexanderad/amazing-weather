//
//  Amazing_WeatherTests.m
//  Amazing WeatherTests
//
//  Created by Alexander Shchapov on 31.01.14.
//
//

#import <XCTest/XCTest.h>
#import "OpenWeatherDataDriver.h"

@interface DriversTests : XCTestCase

@property OpenWeatherDataDriver *driver;

@end

@implementation DriversTests

@synthesize driver;

- (void)setUp
{
    [super setUp];
    driver = [[OpenWeatherDataDriver alloc] init];
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

@end
