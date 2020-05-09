//
//  NSDecimalNumber+LXHBTCSatConverter.m
//  BasicMobileWallet
//
//  Created by lian on 2020/5/2.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "NSDecimalNumber+LXHBTCSatConverter.h"


@implementation NSDecimalNumber (LXHBTCSatConverter)

+ (NSDecimalNumber *)decimalBTCValueWithSatValue:(LXHBTCAmount)satValue {
    return [NSDecimalNumber decimalNumberWithMantissa:satValue exponent:-8 isNegative:NO];
}

+ (LXHBTCAmount)amountSatValueWithBTCValue:(NSDecimalNumber *)btcValue {
    return [[btcValue decimalNumberByMultiplyingByPowerOf10:8] longLongValue];
}

@end
