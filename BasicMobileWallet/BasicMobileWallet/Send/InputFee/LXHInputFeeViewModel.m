//
//  LXHInputFeeViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHInputFeeViewModel.h"
#import "LXHAmount.h"
#import "LXHFeeRate.h"
#import "NSString+Base.h"

@interface LXHInputFeeViewModel ()
@property (nonatomic, readwrite) NSNumber *inputFeeRateSat;
@end

@implementation LXHInputFeeViewModel

- (BOOL)setInputFeeRateString:(NSString *)inputFeeRateString errorDesc:(NSString **)errorDesc {
    BOOL inputFeeRateIsValid = [LXHFeeRate isValidWithFeeRateString:inputFeeRateString];
    if (inputFeeRateIsValid) {
        NSDecimalNumber *inputFeeRate = [NSDecimalNumber decimalNumberWithString:inputFeeRateString];
        _inputFeeRateSat = inputFeeRate;
        *errorDesc = nil;
        return YES;
    } else {
        *errorDesc = NSLocalizedString(@"请输入有效形式的费率(非负整数)", nil);
        return NO;
    }
}

- (NSString *)inputFeeRateString {
    if (!_inputFeeRateSat)
        return nil;
    else
        return [NSString stringWithFormat:@"%@", _inputFeeRateSat];
}

@end
