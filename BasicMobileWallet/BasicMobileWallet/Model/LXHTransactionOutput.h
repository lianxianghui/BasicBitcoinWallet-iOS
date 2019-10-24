//
//  LXHTransactionOutput.h
//  BasicMobileWallet
//
//  Created by lian on 2019/10/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*脚本类型参考
 *https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch06.asciidoc#tx_script
 *https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch07.asciidoc
 */
typedef NS_ENUM(NSInteger, LXHLockingScriptType) {
    LXHLockingScriptTypeUnSupported = 0,
    LXHLockingScriptTypeP2PKH,//Pay-to-Public-Key-Hash (P2PKH)
    LXHLockingScriptTypeP2SH,//Pay-to-Script-Hash (P2SH)
//    LXHLockingScriptTypeP2WPKH, // Pay-to-Witness-Public-Key-Hash (P2WPKH)
//    LXHLockingScriptTypeP2WSH, //Pay-to-Witness-Script-Hash (P2WSH)
};

@class LXHTransaction;
@interface LXHTransactionOutput : NSObject <NSSecureCoding>
@property (nonatomic) NSString *address;
@property (nonatomic) NSDecimalNumber *value;
/**
 * same as witness script, or scriptPubKey
 * pubkeyhash "OP_DUP OP_HASH160 4a74c9313284709ea893c40ce666d5159eebdab5 OP_EQUALVERIFY OP_CHECKSIG"
 */
@property (nonatomic) NSString *lockingScript;
@property (nonatomic) LXHLockingScriptType scriptType;

@property (nonatomic) NSString *spendTxid;

@property (nonatomic) NSString *txid;//所在交易的Id

@property (nonatomic) NSMutableDictionary *tempData;

- (BOOL)isUnspent;

+ (NSDecimalNumber *)valueSumOfOutputs:(NSArray<LXHTransactionOutput *> *)outputs;
@end

NS_ASSUME_NONNULL_END
