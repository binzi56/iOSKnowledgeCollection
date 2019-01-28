//
//  Demo1VCTest.m
//  PerformanceOptimizationTests
//
//  Created by 帅斌 on 2019/1/28.
//  Copyright © 2019年 personal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Demo1ViewController.h"

@interface Demo1VCTest : XCTestCase
@property (nonatomic, strong) Demo1ViewController *demo1;
@end

@implementation Demo1VCTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.demo1 = [Demo1ViewController new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.demo1 = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testDemo1VC{
    [self.demo1 printDemo1];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
