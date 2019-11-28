//
//  LXHFeeEstimator.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/28.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHFeeCalculator.h"

@implementation LXHFeeCalculator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _inputCount = 0;
        _outputCount = 0;
        _feeRateInSat = 0;
    }
    return self;
}

- (nullable NSDecimalNumber *)estimatedFeeInBTC {
    if (_inputCount == 0 || _outputCount == 0 || _feeRateInSat == 0)
        return nil;
    return [LXHFeeCalculator esmitatedFeeInBTCWithFeeRate:_feeRateInSat inputCount:_inputCount outputCount:_outputCount];
}

//参考 https://bitcoin.stackexchange.com/questions/1195/how-to-calculate-transaction-size-before-sending-legacy-non-segwit-p2pkh-p2sh
+ (unsigned long long)estimatedFeeInSatWithFeeRate:(NSUInteger)feeRateInSat inputCount:(NSUInteger)inputCount outputCount:(NSUInteger)outputCount  {
    NSUInteger byteCount = inputCount * 148 + outputCount * 34 + 10;//目前不支持隔离见证输入输出
    unsigned long long ret = byteCount * feeRateInSat;
    return ret;
}

+ (NSDecimalNumber *)esmitatedFeeInBTCWithFeeRate:(NSUInteger)feeRateInSat inputCount:(NSUInteger)inputCount outputCount:(NSUInteger)outputCount {
    unsigned long long estimatedFeeInSat = [self estimatedFeeInSatWithFeeRate:feeRateInSat inputCount:inputCount outputCount:outputCount];
    NSDecimalNumber *ret = [NSDecimalNumber decimalNumberWithMantissa:estimatedFeeInSat exponent:-8 isNegative:NO];
    return ret;
}
@end
