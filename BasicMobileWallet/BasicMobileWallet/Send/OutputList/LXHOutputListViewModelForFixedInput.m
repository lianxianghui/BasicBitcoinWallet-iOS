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
    //计算可输入的最大值
    NSDecimalNumber *differenceBetweenInputsAndOuputs = [LXHFeeCalculator differenceBetweenInputs:self.inputs outputs:self.outputs];
    
    LXHTransactionOutput *output = [LXHTransactionOutput new];
    NSMutableArray *outputs = [self.outputs mutableCopy] ?: [NSMutableArray array];
    [outputs addObject:output];
    NSDecimalNumber *estimatedFeeInBTC = [self.feeCalculator estimatedFeeInBTCWithOutputs:outputs];
    
    NSDecimalNumber *maxValueOfNewOutput = [differenceBetweenInputsAndOuputs decimalNumberBySubtracting:estimatedFeeInBTC];
    
    if ([maxValueOfNewOutput compare:[NSDecimalNumber zero]] == NSOrderedDescending) {
        //返回viewModel
        LXHAddOutputViewModel *ret = [LXHAddOutputViewModel new];
        ret.maxValue = maxValueOfNewOutput;
        return ret;
    } else {
        return nil;
    }
}

- (void)refreshViewModelAtIndex:(NSUInteger)index {
    [self refreshViewModeMaxValueAtIndex:index];
}

- (void)refreshViewModeMaxValueAtIndex:(NSUInteger)index {
    if (index < self.outputViewModels.count) {
        LXHAddOutputViewModel *viewModel = self.outputViewModels[index];
        NSDecimalNumber *inputsValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:self.inputs];
        NSDecimalNumber *estimatedFeeInBTC = [self.feeCalculator estimatedFeeInBTCWithOutputs:self.outputs];
        
        NSMutableArray *otherOutputs = [self.outputs mutableCopy];
        [otherOutputs removeObject:viewModel.output];
        NSDecimalNumber *otherOutputsValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:otherOutputs];

        NSDecimalNumber *maxValueOfCurrentOutput = [[inputsValueSum decimalNumberBySubtracting:estimatedFeeInBTC] decimalNumberBySubtracting:otherOutputsValueSum];
        if ([maxValueOfCurrentOutput compare:[NSDecimalNumber zero]] == NSOrderedAscending)
            maxValueOfCurrentOutput = [NSDecimalNumber zero];
        viewModel.maxValue = maxValueOfCurrentOutput;
    }
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
