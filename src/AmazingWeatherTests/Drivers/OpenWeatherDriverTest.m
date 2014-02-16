//
//  OpenWeatherTest.m
//  Amazing Weather
//
//  Created by Alexander Shchapov on 16.02.14.
//
//

#import <XCTest/XCTest.h>
#import "OpenWeatherDataDriver.h"

@interface OpenWeatherDriverTest : XCTestCase

@property OpenWeatherDataDriver *driver;

@end

@implementation OpenWeatherDriverTest

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

- (void)testExample
{

}

@end
