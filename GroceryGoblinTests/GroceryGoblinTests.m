//
//  GroceryGoblinTests.m
//  GroceryGoblinTests
//
//  Created by Morgan on 1/18/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GGSingleton.h"

@interface GroceryGoblinTests : XCTestCase

@end

@implementation GroceryGoblinTests {
    GGSingleton *singleton;
    GGSingleton *doubleton;
    NSString *testString;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    //Create the test singletons
    singleton = [GGSingleton sharedData];
    doubleton = [GGSingleton sharedData];
    //Create the test string
    testString = @"This is a test";
    //Store the string in the singleton
    [singleton.items setObject:testString forKey:@"test"];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSingleton
{
    //See if the data is still there and correctly stored
    XCTAssertTrue([[singleton.items valueForKey:@"test"] isEqualToString:testString], @"String saved to singleton should equal testString'");
    XCTAssertTrue([[doubleton.items valueForKey:@"test"] isEqualToString:testString], @"String saved to doubleton should equal testString'");
}

@end
