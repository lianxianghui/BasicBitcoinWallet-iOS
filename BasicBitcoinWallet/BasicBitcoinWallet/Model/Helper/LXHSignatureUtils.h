//
//  LXHSignatureUtils.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHGlobalHeader.h"
#import "CoreBitcoin.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHSignatureUtils : NSObject

//目前输出只支持公钥哈希和脚本哈希
+ (NSArray *)outputBase58AddressesWithBTCOutputs:(NSArray<BTCTransactionOutput *> *)btcOutputs networkType:(LXHBitcoinNetworkType)networkType;
//目前输入只支持公钥哈希
+ (NSArray *)inputBase58AddressesWithUnsignedBTCInputs:(NSArray<BTCTransactionInput *> *)btcInputs networkType:(LXHBitcoinNetworkType)networkType;
//目前输入只支持公钥哈希
+ (NSArray *)inputBase58AddressesWithSignedBTCInputs:(NSArray<BTCTransactionInput *> *)btcInputs networkType:(LXHBitcoinNetworkType)networkType;
+ (BTCTransaction *)signBTCTransaction:(BTCTransaction *)unsignedBTCTransaction;
@end

NS_ASSUME_NONNULL_END
