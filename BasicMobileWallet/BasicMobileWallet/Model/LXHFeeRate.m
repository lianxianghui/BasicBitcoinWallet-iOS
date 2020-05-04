//
//  LXHFeeRate.m
//  BasicMobileWallet
//
//  Created by lian on 2020/5/2.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHFeeRate.h"
#import "LXHWallet.h"

@implementation LXHFeeRate


- (BOOL)isValid {
    if (_value >= LXHBTC_MAX_MONEY)
        return NO;
    switch ([LXHWallet mainAccount].currentNetworkType) {
        case LXHBitcoinNetworkTypeUndefined:
            return NO;
            break;
        case LXHBitcoinNetworkTypeTestnet:
            return _value >= 0;//在Testnet下，用户可以测试手续费为0的情况
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
@end
