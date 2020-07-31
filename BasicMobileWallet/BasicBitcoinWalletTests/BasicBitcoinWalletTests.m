//
//  BasicBitcoinWalletTests.m
//  BasicBitcoinWalletTests
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LXHWallet.h"
#import "LXHAccountAddressSearcher.h"
#import "LXHBitcoinWebApiSmartbit.h"
#import "LXHTransactionDataManager.h"
#import "CoreBitcoin.h"
#import "BTCQRCode.h"
#import "LXHBitcoinWebApiBlockchainInfo.h"

@interface BasicBitcoinWalletTests : XCTestCase
@property (nonatomic) NSArray *words;
@end

@implementation BasicBitcoinWalletTests

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

- (void)testBTCQRCode {
//    + (UIImage*) imageForString:(NSString*)string size:(CGSize)size scale:(CGFloat)scale;
//    UIImage *image = [BTCQRCode imageForString:
    [self imageForString:@"" size:CGSizeMake(200, 200) scale:1];
}
                       
- (UIImage*) imageForString:(NSString*)string size:(CGSize)size scale:(CGFloat)scale {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
//    NSData *data = [string dataUsingEncoding:NSISOLatin1StringEncoding];
    NSMutableData *data = [[NSMutableData alloc] initWithLength:2954];

    
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"L" forKey:@"inputCorrectionLevel"];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef cgimage = [[CIContext contextWithOptions:nil] createCGImage:filter.outputImage
                                                                  fromRect:filter.outputImage.extent];
    
    UIImage* image = nil;
    if (context) {
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgimage);
        image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage
                                    scale:scale
                              orientation:UIImageOrientationDownMirrored];
    }
    
    UIGraphicsEndImageContext();
    CGImageRelease(cgimage);
    
    return image;
}


- (void)testBTCHash160 {
//    BTCKeychain *keychain = [LXHWallet.mainAccount.change keychainAtIndex:1000];
//    for (NSInteger i = 0; i < 1000; i++) {
//        BTCKeychain *kechain1 = [[BTCKeychain alloc] initWithExtendedKey:keychain.extendedPublicKey];
//    }
//    NSData *data = keychain.key.publicKey;
//    for (NSInteger i = 0; i < 1000; i++) {
//        BTCHash160(data);
//    }
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


//curl -d '{"hex":"01000000018240bdd0a778a4eb2283f674f8f3fd0e14c7974c6cfdbc09480e94146e11abb9000000006b483045022100a52016ae80090d8160425325e79cb9961f56972d80caee84b8b5d017b7faa634022031d5820a0a72a4d420874bd2921fcf7583fd227aade5e219c4ff14723cc280b90121023b17cd545bb735c8662901e984350ada175828460c355fc0763c0fe53aef878effffffff0220a10700000000001976a91470bf410b2c75b87b1a35eb909699c431890140ab88ace4681600000000001976a9148268e75eb014078a5519bf3dd46a4edcddc6900488ac00000000"}' -H "Content-Type: application/json" -X POST https://testnet-api.smartbit.com.au/v1/blockchain/pushtx

- (void)testTransactionHex {
    BTCTransaction *transaction =  [[BTCTransaction alloc] initWithHex:@"01000000018240bdd0a778a4eb2283f674f8f3fd0e14c7974c6cfdbc09480e94146e11abb9000000006b483045022100a52016ae80090d8160425325e79cb9961f56972d80caee84b8b5d017b7faa634022031d5820a0a72a4d420874bd2921fcf7583fd227aade5e219c4ff14723cc280b90121023b17cd545bb735c8662901e984350ada175828460c355fc0763c0fe53aef878effffffff0220a10700000000001976a91470bf410b2c75b87b1a35eb909699c431890140ab88ace4681600000000001976a9148268e75eb014078a5519bf3dd46a4edcddc6900488ac00000000"];
    
}

- (void)testBlockInfoRequest {
    LXHBitcoinWebApiBlockchainInfo *api = [[LXHBitcoinWebApiBlockchainInfo alloc] initWithType:LXHBitcoinNetworkTypeTestnet];
    NSMutableArray *addresses = [NSMutableArray array];
    [addresses addObject:@"2NAn85hBo6wH2HmZzKr39GudUNfnVcS5rwd"];
    [addresses addObject:@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"测试成功"];
    //expectation.expectedFulfillmentCount = 10;
    [api requestAllTransactionsWithAddresses:addresses successBlock:^(NSDictionary * _Nonnull resultDic) {
        [expectation fulfill];
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
    }];
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
