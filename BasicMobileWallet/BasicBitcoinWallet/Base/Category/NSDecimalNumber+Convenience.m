//
//  NSDecimalNumber+Convenience.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "NSDecimalNumber+Convenience.h"

@implementation NSDecimalNumber (Convenience)

- (BOOL)greaterThanZero {
    return [self greaterThan:[NSDecimalNumber zero]];
}

- (BOOL)lessThanZero {
    return [self lessThan:[NSDecimalNumber zero]];
}

- (BOOL)isEqualToZero {
    return [self isEqualToValue:[NSDecimalNumber zero]];
}

- (BOOL)greaterThan:(NSDecimalNumber *)number {
    return [self compare:number] == NSOrderedDescending;
}

- (BOOL)lessThan:(NSDecimalNumber *)number {
    return [self compare:number] == NSOrderedAscending;
}

- (BOOL)isEqualTo:(NSDecimalNumber *)number {
    return [self compare:number] == NSOrderedSame;
}

@end
