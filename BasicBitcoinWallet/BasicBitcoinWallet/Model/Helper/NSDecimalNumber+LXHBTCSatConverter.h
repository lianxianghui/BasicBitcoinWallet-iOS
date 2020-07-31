//
//  NSDecimalNumber+LXHBTCSatConverter.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/5/2.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHGlobalHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (LXHBTCSatConverter)

+ (NSDecimalNumber *)decimalBTCValueWithSatValue:(LXHBTCAmount)sat;
+ (LXHBTCAmount)amountSatValueWithBTCValue:(NSDecimalNumber *)btcValue;
@end

NS_ASSUME_NONNULL_END
