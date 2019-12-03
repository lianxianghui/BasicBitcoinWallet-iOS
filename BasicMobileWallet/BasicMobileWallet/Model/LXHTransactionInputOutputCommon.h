//
//  LXHTransactionInputOutputCommon.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/15.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, LXHLockingScriptType) {
    LXHLockingScriptTypeUnSupported = 0,
    LXHLockingScriptTypeP2PKH,//Pay-to-Public-Key-Hash (P2PKH)
    LXHLockingScriptTypeP2SH,//Pay-to-Script-Hash (P2SH)
    //    LXHLockingScriptTypeP2WPKH, // Pay-to-Witness-Public-Key-Hash (P2WPKH)
    //    LXHLockingScriptTypeP2WSH, //Pay-to-Witness-Script-Hash (P2WSH)
};

/**
 只是用来继承，放置一些共有的数据字段在这个类里
 */
@class LXHAddress;
@interface LXHTransactionInputOutputCommon : NSObject
@property (nonatomic) LXHAddress *address;
//@property (nonatomic) NSString *address;
@property (nonatomic) NSDecimalNumber *value;
@property (nonatomic) NSString *txid;//所在交易的Id

+ (NSDecimalNumber *)valueSumOfInputsOrOutputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputsOrOutputs;
@end

NS_ASSUME_NONNULL_END
