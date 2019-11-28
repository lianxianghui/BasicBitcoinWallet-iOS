//
//  LXHFeeEstimator.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/28.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHFeeEstimator : NSObject

@property (nonatomic) NSUInteger inputCount;
@property (nonatomic) NSUInteger feeRateInSat;
@property (nonatomic) NSUInteger outputCount;

- (nullable NSDecimalNumber *)estimatedFeeInBTC;
//判断某个输入或输出值，是不是比它所带来的
- (BOOL)inputValueLessThanFeeWithValue:(NSDecimalNumber *)inputValue;
- (BOOL)outputValueLessThanFeeWithValue:(NSDecimalNumber *)inputValue;
@end

NS_ASSUME_NONNULL_END
