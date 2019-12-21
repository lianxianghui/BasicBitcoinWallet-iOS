//
//  NSDecimalNumber+Convenience.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (Convenience)

- (BOOL)greaterThanZero;
- (BOOL)lessThanZero;
- (BOOL)isEqualToZero;

- (BOOL)greaterThan:(NSDecimalNumber *)number;
- (BOOL)lessThan:(NSDecimalNumber *)number;
- (BOOL)isEqualTo:(NSDecimalNumber *)number;
@end

NS_ASSUME_NONNULL_END
