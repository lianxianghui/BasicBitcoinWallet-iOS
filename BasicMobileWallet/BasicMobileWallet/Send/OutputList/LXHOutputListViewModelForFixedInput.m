//
//  LXHOutputListViewModelForFixedInput.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/4.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHOutputListViewModelForFixedInput.h"
#import "LXHFeeCalculator.h"
#import "LXHTransactionOutput.h"
#import "LXHAddOutputViewModel.h"

@interface LXHOutputListViewModelForFixedInput ()
@property (nonatomic) LXHFeeCalculator *feeCalculator;
@end

@implementation LXHOutputListViewModelForFixedInput

- (LXHAddOutputViewModel *)getNewOutputViewModel {
    NSDecimalNumber *differenceBetweenInputsAndOuputs = [LXHFeeCalculator differenceBetweenInputs:self.inputs outputs:self.outputs];
    
    LXHTransactionOutput *output = [LXHTransactionOutput new];
    NSMutableArray *outputs = [self.outputs mutableCopy] ?: [NSMutableArray array];
    [outputs addObject:output];
    self.feeCalculator.outputs = outputs;
    NSDecimalNumber *estimatedFeeInBTC = [self.feeCalculator estimatedFeeInBTC];
    
    NSDecimalNumber *maxValueOfNewOutput = [differenceBetweenInputsAndOuputs decimalNumberBySubtracting:estimatedFeeInBTC];
    LXHAddOutputViewModel *ret = [LXHAddOutputViewModel new];
    ret.maxValue = maxValueOfNewOutput;
    return ret;
}

- (LXHFeeCalculator *)feeCalculator {
    if (!_feeCalculator) {
        _feeCalculator = [LXHFeeCalculator new];
        _feeCalculator.inputs = self.inputs;
        _feeCalculator.feeRateInSat = self.feeRateInSat;
    }
    return _feeCalculator;
}

@end
