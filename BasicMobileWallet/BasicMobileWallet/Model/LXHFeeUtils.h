//
//  LXHFeeUtils.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/28.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHTransactionInputOutputCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHFeeUtils : NSObject
+ (NSDecimalNumber *)esmitatedFeeInBTCWithFeeRate:(NSUInteger)feeRateInSat inputCount:(NSUInteger)inputCount outputCount:(NSUInteger)outputCount;
+ (NSDecimalNumber *)differenceBetweenInputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputs outputs:(NSArray<LXHTransactionInputOutputCommon *> *)outputs;
@end

NS_ASSUME_NONNULL_END
