//
//  BasicMobileWalletTests.m
//  BasicMobileWalletTests
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LXHWallet.h"
#import "LXHAccountAddressSearcher.h"
#import "LXHBitcoinWebApiSmartbit.h"
#import "LXHTransactionDataManager.h"

@interface BasicMobileWalletTests : XCTestCase
@property (nonatomic) NSArray *words;
@end

@implementation BasicMobileWalletTests

- (void)setUp {
   _words = [@"indicate theory winter excite obtain join maximum they error problem index fat" componentsSeparatedByString:@" "];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTmp {
    XCTestExpectation *expectation = [self expectationWithDescription:@"测试成功"];
    [LXHWallet restoreExistWalletDataWithMnemonicCodeWords:self.words mnemonicPassphrase:nil netType:LXHBitcoinNetworkTypeTestnet successBlock:^(NSDictionary * _Nonnull resultDic) {
        [expectation fulfill];
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        
    }];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
    //[[LXHWalletDataManager sharedInstance] clearData];
}

- (void)testAddressGeneration {
//    NSArray *words = @[@"tail", @"fatal", @"photo", @"same", 
//                       @"later", @"above", @"reform", @"zoo",
//                       @"device", @"train", @"achieve", @"omit"];//change btc 
//    NSArray *words = @[@"differ", @"dance", @"mad", @"bargain", 
//                       @"empower", @"mad", @"purity", @"engage",
//                       @"element", @"cattle", @"fuel", @"embrace"];//brd
//    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:self.words password:nil wordListType:BTCMnemonicWordListTypeEnglish];
//    NSData *rootSeed = [mnemonic seed];
//    LXHWallet *wallet = [[LXHWallet alloc] initWithRootSeed:rootSeed currentNetworkType:LXHBitcoinNetworkTypeTestnet];
//    NSArray *address = [wallet receivingAddressesFromZeroToIndex:19];
//    NSLog(@"%@", address);
}

- (void)testClear {
    [[LXHTransactionDataManager sharedInstance] clearCachedData];
}

- (void)testWalletAddressSearcher {
//    NSArray *words = @[@"differ", @"dance", @"mad", @"bargain", 
//                       @"empower", @"mad", @"purity", @"engage",
//                       @"element", @"cattle", @"fuel", @"embrace"];//brd
//    NSArray *words = @[@"tail", @"fatal", @"photo", @"same", 
//                       @"later", @"above", @"reform", @"zoo",
//                       @"device", @"train", @"achieve", @"omit"];//chance_btc
//    [LXHWallet clearData];
    XCTestExpectation *expectation = [self expectationWithDescription:@"测试成功"];
    [LXHWallet restoreExistWalletDataWithMnemonicCodeWords:self.words mnemonicPassphrase:nil netType:LXHBitcoinNetworkTypeTestnet successBlock:^(NSDictionary * _Nonnull resultDic) {
        [expectation fulfill];
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        
        
    }];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testSmartBitRequest {
    //mrQoR4BMyZWyAZfHF4NuqRmkVtp87AqsUh,n1dAqxk6UCb6568d5f28W2sh6LvwkP5snW
    LXHBitcoinWebApiSmartbit *api = [[LXHBitcoinWebApiSmartbit alloc] initWithType:LXHBitcoinNetworkTypeTestnet];
    NSMutableArray *addresses = [NSMutableArray array];
    [addresses addObject:@"mrQoR4BMyZWyAZfHF4NuqRmkVtp87AqsUh"];
    [addresses addObject:@"n1dAqxk6UCb6568d5f28W2sh6LvwkP5snW"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"测试成功"];
    [api requestAllTransactionsWithAddresses:addresses successBlock:^(NSDictionary * _Nonnull resultDic) {
        [expectation fulfill];
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
    }];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
