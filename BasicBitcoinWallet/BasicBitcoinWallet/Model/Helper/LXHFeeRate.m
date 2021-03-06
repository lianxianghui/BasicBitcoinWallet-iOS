//
//  LXHFeeRate.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/5/2.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHFeeRate.h"
#import "LXHWallet.h"
#import "LXHAmount.h"

@implementation LXHFeeRate


- (BOOL)isValid {
    if (_value >= LXHBTC_MAX_MONEY)
        return NO;
    switch ([LXHWallet mainAccount].currentNetworkType) {
        case LXHBitcoinNetworkTypeTestnet:
        case LXHBitcoinNetworkTypeMainnet:
            return _value > 0;
        default:
            return NO;
            break;
    }
}

+ (BOOL)isValidWithFeeRateValue:(LXHBTCAmount)feeRateValue {
    LXHFeeRate *feeRate = [[LXHFeeRate alloc] init];
    feeRate.value = feeRateValue;
    return [feeRate isValid];
}

+ (BOOL)isValidWithFeeRateString:(NSString *)feeRateString {
    if (![LXHAmount isValidWithString:feeRateString])
        return NO;
    return [self isValidWithFeeRateValue:[feeRateString longLongValue]];
}

+ (BOOL)isValidWithFeeRateNumber:(NSNumber *)feeRateNumber {
    if (![LXHAmount isValidWithNumberValue:feeRateNumber])
        return NO;
    return [self isValidWithFeeRateValue:[feeRateNumber longLongValue]];
}
@end
