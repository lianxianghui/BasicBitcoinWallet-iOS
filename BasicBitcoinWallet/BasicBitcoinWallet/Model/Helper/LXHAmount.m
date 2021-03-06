//
//  LXHAmount.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/5/4.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHAmount.h"
#import "NSDecimalNumber+Convenience.h"
#import "NSString+Base.h"

@implementation LXHAmount

+ (BOOL)isValidWithValue:(LXHBTCAmount)value {
    if (value >= 0 && value <= LXHBTC_MAX_MONEY)
        return YES;
    return NO;
}

+ (BOOL)isValidWithDecimalValue:(NSDecimalNumber *)value {
    NSDecimalNumber *longlongValue =  [NSDecimalNumber decimalNumberWithMantissa:[value longLongValue] exponent:0 isNegative:NO];
    if ([value compare:longlongValue] != NSOrderedSame)
        return NO;
    return [self isValidWithValue:[value longLongValue]];
}

+ (BOOL)isValidWithNumberValue:(NSNumber *)value {
    NSDecimalNumber *decimalValue = [[NSDecimalNumber alloc] initWithDecimal:value.decimalValue];
    return [self isValidWithDecimalValue:decimalValue];
}

+ (BOOL)isValidWithString:(NSString *)string {
    if (![string isLongLong])
        return NO;
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:string];
    return [self isValidWithDecimalValue:value];
}

@end
