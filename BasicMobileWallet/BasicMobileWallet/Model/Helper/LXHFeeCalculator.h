//
//  LXHFeeEstimator.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/28.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHGlobalHeader.h"
#import "LXHFeeRate.h"

NS_ASSUME_NONNULL_BEGIN

@class LXHTransactionOutput;
@interface LXHFeeCalculator : NSObject

@property (nonatomic) NSArray *inputs;
@property (nonatomic) NSArray *outputs;
@property (nonatomic) LXHFeeRate *feeRate;

- (LXHBTCAmount)estimatedFeeInSat;
- (LXHBTCAmount)estimatedFeeInSatWithOutputs:(NSArray *)outputs;
//判断某个输入或输出，是不是消耗的Fee比它的值还大
- (BOOL)feeGreaterThanValueWithInput:(LXHTransactionOutput *)utxoAsInput;
+ (BOOL)feeGreaterThanValueWithInput:(LXHTransactionOutput *)utxoAsInput feeRateValue:(LXHBTCAmount)feeRateValue;
//- (BOOL)feeGreaterThanValueWithOutput:(LXHTransactionOutput *)output;
@end

NS_ASSUME_NONNULL_END
