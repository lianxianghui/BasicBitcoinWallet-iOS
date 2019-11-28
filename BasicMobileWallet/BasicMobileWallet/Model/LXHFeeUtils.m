//
//  LXHFeeUtils.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/28.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHFeeUtils.h"


@implementation LXHFeeUtils



+ (NSDecimalNumber *)differenceBetweenInputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputs outputs:(NSArray<LXHTransactionInputOutputCommon *> *)outputs {
    NSDecimalNumber *inputsValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:inputs];
    NSDecimalNumber *outputsValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:outputs];
    return [inputsValueSum decimalNumberBySubtracting:outputsValueSum];
}



@end
