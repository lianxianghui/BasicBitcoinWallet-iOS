//
//  LXHTransactionOutput.h
//  BasicMobileWallet
//
//  Created by lian on 2019/10/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHTransactionInputOutputCommon.h"

NS_ASSUME_NONNULL_BEGIN

/*脚本类型参考
 *https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch06.asciidoc#tx_script
 *https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch07.asciidoc
 */

@interface LXHTransactionOutput : LXHTransactionInputOutputCommon <NSSecureCoding>
/**
 * same as witness script, or scriptPubKey
 * pubkeyhash "OP_DUP OP_HASH160 4a74c9313284709ea893c40ce666d5159eebdab5 OP_EQUALVERIFY OP_CHECKSIG"
 */
@property (nonatomic) NSString *lockingScript;
@property (nonatomic) NSString *lockingScriptHex;
@property (nonatomic) LXHLockingScriptType scriptType;

@property (nonatomic) NSString *spendTxid;

@property (nonatomic) NSMutableDictionary *tempData;

- (BOOL)isUnspent;

+ (NSDecimalNumber *)valueSumOfOutputs:(NSArray<LXHTransactionOutput *> *)outputs;
@end

NS_ASSUME_NONNULL_END
