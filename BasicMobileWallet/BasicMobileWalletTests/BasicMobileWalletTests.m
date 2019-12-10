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


//curl -d '{"hex":"0100000001b9d2f9b05dacb1f302b10427c494020dd5e4bdb0cd60e2c38589cee769a0e871000000006b483045022100988c345be9f20a57103bb68cb440849b1f689747eae4b546ab4d69b5671ca98f02200889390ee916af456a46b2c6f96c92eef1531372ba0bf57b6831c50689dd824a012103b65a4b859253025fed822a3619ed97a58f3655401dbba353fd2f158c69261d26ffffffff02acae2500000000001976a9148268e75eb014078a5519bf3dd46a4edcddc6900488ac20a10700000000001976a91470bf410b2c75b87b1a35eb909699c431890140ab88ac00000000"}' -H "Content-Type: application/json" -X POST https://testnet-api.smartbit.com.au/v1/blockchain/pushtx
//0100000001b9d2f9b05dacb1f302b10427c494020dd5e4bdb0cd60e2c38589cee769a0e871000000006b483045022100988c345be9f20a57103bb68cb440849b1f689747eae4b546ab4d69b5671ca98f02200889390ee916af456a46b2c6f96c92eef1531372ba0bf57b6831c50689dd824a012103b65a4b859253025fed822a3619ed97a58f3655401dbba353fd2f158c69261d26ffffffff02acae2500000000001976a9148268e75eb014078a5519bf3dd46a4edcddc6900488ac20a10700000000001976a91470bf410b2c75b87b1a35eb909699c431890140ab88ac00000000


//01000000015a23e67a0698f2178deac3d370c9aa321207c024b730487c440164ddfee5ac86000000006b483045022100bf0df28e75e2df2f6f3118613c4f233a51ae14d0ea8dbce9be83bcf8d080b28e02205591870e3110de810c31f5d165346e1a899435e9c3f0a41dce2b39a2577aed320121023b17cd545bb735c8662901e984350ada175828460c355fc0763c0fe53aef878effffffff02c80b1e00000000001976a9148268e75eb014078a5519bf3dd46a4edcddc6900488ac20a10700000000001976a91470bf410b2c75b87b1a35eb909699c431890140ab88ac00000000

- (void)testSmartBitRequest {
    //mrQoR4BMyZWyAZfHF4NuqRmkVtp87AqsUh,n1dAqxk6UCb6568d5f28W2sh6LvwkP5snW
    LXHBitcoinWebApiSmartbit *api = [[LXHBitcoinWebApiSmartbit alloc] initWithType:LXHBitcoinNetworkTypeTestnet];
//    NSMutableArray *addresses = [NSMutableArray array];
//    [addresses addObject:@"mrQoR4BMyZWyAZfHF4NuqRmkVtp87AqsUh"];
//    [addresses addObject:@"n1dAqxk6UCb6568d5f28W2sh6LvwkP5snW"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"测试成功"];
//    [api requestAllTransactionsWithAddresses:addresses successBlock:^(NSDictionary * _Nonnull resultDic) {
//        [expectation fulfill];
//    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
//    }];
    NSString *hex = @"01000000000101522dd6a1b041135d261390a9b27c8a7006f0f707e94096cc8b252ba5b2a018d70100000000f0ffffff0340420f00000000001976a914e72a554a5f69079401fed4fb0cb3561ed3260e2f88ac9b7b3b0000000000160014df3397824da9a5c90666b2ccf9c0643d0494cb650000000000000000196a1768747470733a2f2f746274632e6269746170732e636f6d024730440220046e51ec44ef234b6b3789e7ca8bbc58a9446ffdb23389b55ce7fc4f236f7409022043bfc39b653f65f6ae195523938a959dd7b1e4e33bebc99346ea641501ccea5c01210259948c4e7d62fcb8e634a42f1c161e9520177c25fd6865f325d1ecbea02acd9700000000";
    
    
    [api pushTransactionWithHex:hex successBlock:^(NSDictionary * _Nonnull resultDic) {
        [expectation fulfill];
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        
    }];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testSignTransaction {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
