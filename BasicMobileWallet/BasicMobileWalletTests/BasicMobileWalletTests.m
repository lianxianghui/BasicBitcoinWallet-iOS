//
//  BasicMobileWalletTests.m
//  BasicMobileWalletTests
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LXHWalletDataManager.h"

@interface BasicMobileWalletTests : XCTestCase

@end

@implementation BasicMobileWalletTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testWalletAddressSearcher {
    NSArray *words = @[@"differ", @"dance", @"mad", @"bargain", 
                       @"empower", @"mad", @"purity", @"engage",
                       @"element", @"cattle", @"fuel", @"embrace"];
    [[LXHWalletDataManager sharedInstance] restoreExistWalletAndSaveDataWithMnemonicCodeWords:words mnemonicPassphrase:nil netType:LXHBitcoinNetworkTypeTestnet successBlock:^(NSDictionary * _Nonnull resultDic) {
        
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        
    }];
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
