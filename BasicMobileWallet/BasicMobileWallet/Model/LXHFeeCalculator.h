//
//  LXHFeeEstimator.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/28.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHTransactionInputOutputCommon;
@interface LXHFeeCalculator : NSObject

@property (nonatomic) NSArray *inputs;
@property (nonatomic) NSArray *outputs;
@property (nonatomic) NSUInteger feeRateInSat;

- (nullable NSDecimalNumber *)estimatedFeeInBTC;
//判断某个输入或输出，是不是消耗的Fee比它的值还大
- (BOOL)feeGreaterThanValueWithInput:(LXHTransactionInputOutputCommon *)input;
- (BOOL)feeGreaterThanValueWithOutput:(LXHTransactionInputOutputCommon *)output;

+ (BOOL)feeGreaterThanValueWithOutput:(LXHTransactionInputOutputCommon *)output feeRateInSat:(NSUInteger)feeRateInSat;

+ (NSDecimalNumber *)feeInBTCWithOutput:(LXHTransactionInputOutputCommon *)output feeRateInSat:(NSUInteger)feeRateInSat;//该输出带来的手续费
+ (NSDecimalNumber *)differenceBetweenInputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputs outputs:(NSArray<LXHTransactionInputOutputCommon *> *)outputs;
@end

NS_ASSUME_NONNULL_END
