//
//  LXHAmount.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/5/4.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXHGlobalHeader.h"

NS_ASSUME_NONNULL_BEGIN

//这里的value都是以Sat为单位
@interface LXHAmount : NSObject

+ (BOOL)isValidWithValue:(LXHBTCAmount)value;
+ (BOOL)isValidWithDecimalValue:(NSDecimalNumber *)value;
+ (BOOL)isValidWithString:(NSString *)string;
+ (BOOL)isValidWithNumberValue:(NSNumber *)value;
@end

NS_ASSUME_NONNULL_END
