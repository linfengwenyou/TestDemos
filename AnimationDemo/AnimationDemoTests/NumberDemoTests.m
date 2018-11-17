//
//  AnimationDemoTests.m
//  AnimationDemoTests
//
//  Created by fumi on 2018/11/1.
//  Copyright © 2018 fumi. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AnimationDemoTests : XCTestCase

@end

@implementation AnimationDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testEmojiClip
{
    NSString *str = @"12345678🐶✈️";
    NSString *subedStr = [str skipCharacterFromIndex:6];
    
    NSLog(@"%@",subedStr);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
