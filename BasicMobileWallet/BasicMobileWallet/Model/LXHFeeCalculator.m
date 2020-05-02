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
//        _feeRate.value = 0;
    }
    return self;
}

- (LXHBTCAmount)estimatedFeeInSat {
    return [self estimatedFeeInSatWithOutputs:_outputs];
}

- (LXHBTCAmount)estimatedFeeInSatWithOutputs:(NSArray *)outputs {
    if (_inputs.count == 0 || outputs.count == 0 || _feeRate.value == 0)
        return LXHBTCAmountError;
    return [LXHFeeCalculator estimatedFeeInSatWithFeeRate:_feeRate.value inputCount:_inputs.count outputCount:outputs.count];
}

- (nullable NSDecimalNumber *)estimatedFeeInBTC {
    if (_inputs.count == 0 || _outputs.count == 0 || _feeRate.value == 0)
        return nil;
    return [LXHFeeCalculator esmitatedFeeInBTCWithFeeRate:_feeRate.value inputCount:_inputs.count outputCount:_outputs.count];
}

//- (nullable NSDecimalNumber *)estimatedFeeInBTCWithInputs:(NSArray *)inputs {
//    if (inputs.count == 0 || _outputs.count == 0 || _feeRate.value == 0)
//        return nil;
//    return [LXHFeeCalculator esmitatedFeeInBTCWithFeeRate:_feeRate.value inputCount:inputs.count outputCount:_outputs.count];
//}

- (nullable NSDecimalNumber *)estimatedFeeInBTCWithOutputs:(NSArray *)outputs {
    if (_inputs.count == 0 || outputs.count == 0 || _feeRate.value == 0)
        return nil;
    return [LXHFeeCalculator esmitatedFeeInBTCWithFeeRate:_feeRate.value inputCount:_inputs.count outputCount:outputs.count];
}

- (BOOL)feeGreaterThanValueWithInput:(LXHTransactionInputOutputCommon *)input {
    //目前不支持隔离见证输入输出，所以目前与输入无关
    LXHBTCAmount feePerInputInSat = 148 * _feeRate.value;//目前不支持隔离见证输入输出
    return feePerInputInSat > input.valueSat;
}

- (BOOL)feeGreaterThanValueWithOutput:(LXHTransactionInputOutputCommon *)output {
    LXHBTCAmount fee = [LXHFeeCalculator feeInSatWithOutput:output feeRateInSat:_feeRate.value];
    return fee > output.valueSat;
}

//+ (BOOL)feeGreaterThanValueWithOutput:(LXHTransactionInputOutputCommon *)output feeRateInSat:(NSUInteger)feeRateInSat {
//    NSDecimalNumber *feeInBTC = [self feeInBTCWithOutput:output feeRateInSat:feeRateInSat];
//    return [feeInBTC compare:output.valueBTC] == NSOrderedDescending;
//}
//
//+ (NSDecimalNumber *)feeInBTCWithOutput:(LXHTransactionInputOutputCommon *)output feeRateInSat:(NSUInteger)feeRateInSat {
//    //目前不支持隔离见证输入输出，所以目前与输出无关
//    NSUInteger feeInSat = 34 * feeRateInSat;
//    NSDecimalNumber *feeInBTC = [NSDecimalNumber decimalNumberWithMantissa:feeInSat exponent:-8 isNegative:NO];
//    return feeInBTC;
//}

+ (LXHBTCAmount)feeInSatWithOutput:(LXHTransactionInputOutputCommon *)output feeRateInSat:(NSUInteger)feeRateInSat {
    //目前不支持隔离见证输入输出，所以目前与输出无关
    LXHBTCAmount ret = 34 * feeRateInSat;//目前不支持隔离见证输入输出
    return ret;
}

//参考 https://bitcoin.stackexchange.com/questions/1195/how-to-calculate-transaction-size-before-sending-legacy-non-segwit-p2pkh-p2sh
+ (LXHBTCAmount)estimatedFeeInSatWithFeeRate:(NSUInteger)feeRateInSat inputCount:(NSUInteger)inputCount outputCount:(NSUInteger)outputCount  {
    NSUInteger byteCount = inputCount * 148 + outputCount * 34 + 10;//目前不支持隔离见证输入输出
    LXHBTCAmount ret = byteCount * feeRateInSat;
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

+ (LXHBTCAmount)differenceBetweenSumOfInputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputs sumOfOutputs:(NSArray<LXHTransactionInputOutputCommon *> *)outputs {
    LXHBTCAmount inputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:inputs];
    LXHBTCAmount outputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:outputs];
    return inputsValueSum - outputsValueSum;
}
@end
