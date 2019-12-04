//
//  LXHFeeEstimator.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/28.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHFeeCalculator.h"
#import "LXHTransactionInputOutputCommon.h"

@implementation LXHFeeCalculator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _feeRateInSat = 0;
    }
    return self;
}

- (nullable NSDecimalNumber *)estimatedFeeInBTC {
    if (_inputs.count == 0 || _outputs.count == 0 || _feeRateInSat == 0)
        return nil;
    return [LXHFeeCalculator esmitatedFeeInBTCWithFeeRate:_feeRateInSat inputCount:_inputs.count outputCount:_outputs.count];
}

- (nullable NSDecimalNumber *)estimatedFeeInBTCWithInputs:(NSArray *)inputs {
    if (inputs.count == 0 || _outputs.count == 0 || _feeRateInSat == 0)
        return nil;
    return [LXHFeeCalculator esmitatedFeeInBTCWithFeeRate:_feeRateInSat inputCount:inputs.count outputCount:_outputs.count];
}

- (nullable NSDecimalNumber *)estimatedFeeInBTCWithOutputs:(NSArray *)outputs {
    if (_inputs.count == 0 || outputs.count == 0 || _feeRateInSat == 0)
        return nil;
    return [LXHFeeCalculator esmitatedFeeInBTCWithFeeRate:_feeRateInSat inputCount:_inputs.count outputCount:outputs.count];
}

- (BOOL)feeGreaterThanValueWithInput:(LXHTransactionInputOutputCommon *)input {
    NSUInteger feePerInputInSat = 148 * _feeRateInSat;//目前不支持隔离见证输入输出
    NSDecimalNumber *feePerInputInBTC = [NSDecimalNumber decimalNumberWithMantissa:feePerInputInSat exponent:-8 isNegative:NO];
    return [feePerInputInBTC compare:input.value] == NSOrderedDescending;
}

- (BOOL)feeGreaterThanValueWithOutput:(LXHTransactionInputOutputCommon *)output {
    return [LXHFeeCalculator feeGreaterThanValueWithOutput:output feeRateInSat:_feeRateInSat];
}

+ (BOOL)feeGreaterThanValueWithOutput:(LXHTransactionInputOutputCommon *)output feeRateInSat:(NSUInteger)feeRateInSat {
    NSDecimalNumber *feeInBTC = [self feeInBTCWithOutput:output feeRateInSat:feeRateInSat];
    return [feeInBTC compare:output.value] == NSOrderedDescending;
}

+ (NSDecimalNumber *)feeInBTCWithOutput:(LXHTransactionInputOutputCommon *)output feeRateInSat:(NSUInteger)feeRateInSat {
    NSUInteger feeInSat = 34 * feeRateInSat;//目前不支持隔离见证输入输出
    NSDecimalNumber *feeInBTC = [NSDecimalNumber decimalNumberWithMantissa:feeInSat exponent:-8 isNegative:NO];
    return feeInBTC;
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

+ (NSDecimalNumber *)differenceBetweenInputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputs outputs:(NSArray<LXHTransactionInputOutputCommon *> *)outputs {
    NSDecimalNumber *inputsValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:inputs];
    NSDecimalNumber *outputsValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:outputs];
    return [inputsValueSum decimalNumberBySubtracting:outputsValueSum];
}
@end
