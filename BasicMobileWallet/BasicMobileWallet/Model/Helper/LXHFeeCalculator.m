//
//  LXHFeeEstimator.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/28.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHFeeCalculator.h"
#import "LXHTransactionOutput.h"
#import "NSDecimalNumber+LXHBTCSatConverter.h"
#import "LXHAmount.h"

@implementation LXHFeeCalculator

- (LXHBTCAmount)estimatedFeeInSat {
    return [self estimatedFeeInSatWithOutputs:_outputs];
}

- (LXHBTCAmount)estimatedFeeInSatWithOutputs:(NSArray *)outputs {
    if (_inputs.count == 0 || outputs.count == 0)
        return LXHBTCAmountError;
    return [LXHFeeCalculator estimatedFeeInSatWithFeeRate:_feeRate.value inputCount:_inputs.count outputCount:outputs.count];
}

- (BOOL)feeGreaterThanValueWithInput:(LXHTransactionOutput *)utxoAsInput {
    return [LXHFeeCalculator feeGreaterThanValueWithInput:utxoAsInput feeRateValue:_feeRate.value];
}

+ (BOOL)feeGreaterThanValueWithInput:(LXHTransactionOutput *)utxoAsInput feeRateValue:(LXHBTCAmount)feeRateValue {
    //目前不支持隔离见证输入输出，所以目前与输入内容无关
    LXHBTCAmount feePerInputInSat = 148 * feeRateValue;
    return feePerInputInSat > utxoAsInput.valueSat;
}

//- (BOOL)feeGreaterThanValueWithOutput:(LXHTransactionOutput *)output {
//    //目前不支持隔离见证输入输出，所以目前与输出内容无关
//    LXHBTCAmount feeOfOutput = 34 * _feeRate.value;//目前不支持隔离见证输入输出
//    return feeOfOutput > output.valueSat;
//}

//参考 https://bitcoin.stackexchange.com/questions/1195/how-to-calculate-transaction-size-before-sending-legacy-non-segwit-p2pkh-p2sh
+ (LXHBTCAmount)estimatedFeeInSatWithFeeRate:(NSUInteger)feeRateInSat inputCount:(NSUInteger)inputCount outputCount:(NSUInteger)outputCount  {
    NSUInteger byteCount = inputCount * 148 + outputCount * 34 + 10;//目前不支持隔离见证输入输出
    LXHBTCAmount ret = byteCount * feeRateInSat;
    if ([LXHAmount isValidWithValue:ret])
        return ret;
    else
        return LXHBTCAmountError;
}

@end
