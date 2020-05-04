//
//  LXHAmount.m
//  BasicMobileWallet
//
//  Created by lian on 2020/5/4.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHAmount.h"
#import "NSDecimalNumber+Convenience.h"
#import "NSString+Base.h"

@implementation LXHAmount

+ (BOOL)isValidWithDecimalValue:(NSDecimalNumber *)value {
    if ([value lessThanZero])
        return NO;
    NSDecimalNumber *maxMoney = [NSDecimalNumber decimalNumberWithMantissa:LXHBTC_MAX_MONEY exponent:1 isNegative:NO];
    if ([value greaterThan:maxMoney])
        return NO;
    return YES;
}

+ (BOOL)isValidWithString:(NSString *)string {
    if (![string isLongLong])
        return NO;
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:string];
    return [self isValidWithDecimalValue:value];
}

@end
