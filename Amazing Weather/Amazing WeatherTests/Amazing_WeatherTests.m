//
//  Amazing_WeatherTests.m
//  Amazing WeatherTests
//
//  Created by Darednaxella on 1/31/14.
//
//

#import <XCTest/XCTest.h>

@interface Amazing_WeatherTests : XCTestCase

- (void) testExample;

@end

@implementation Amazing_WeatherTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"test setUp");
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTAssertFalse(true);
}

- (void)testHello
{
    XCTAssertNotEqual(1, 1);
}

@end
