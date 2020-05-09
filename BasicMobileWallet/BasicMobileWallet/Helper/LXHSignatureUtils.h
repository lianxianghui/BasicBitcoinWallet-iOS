//
//  LXHSignatureUtils.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHGlobalHeader.h"
#import "CoreBitcoin.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHSignatureUtils : NSObject

+ (NSArray *)outputBase58AddressesWithBTCOutputs:(NSArray<BTCTransactionOutput *> *)btcOutputs networkType:(LXHBitcoinNetworkType)networkType;
+ (BTCTransaction *)signBTCTransaction:(BTCTransaction *)unsignedBTCTransaction;
@end

NS_ASSUME_NONNULL_END
