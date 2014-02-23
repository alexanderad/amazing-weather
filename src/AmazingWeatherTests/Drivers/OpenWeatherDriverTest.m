//
//  OpenWeatherTest.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 16.02.14.
//
//

#import <XCTest/XCTest.h>
#import "OpenWeatherMapDriver.h"

@interface OpenWeatherDriverTest : XCTestCase

@property OpenWeatherMapDriver *driver;

@end

@implementation OpenWeatherDriverTest

@synthesize driver;

- (void)setUp
{
    [super setUp];
    driver = [[OpenWeatherMapDriver alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testExample
{

}

@end
