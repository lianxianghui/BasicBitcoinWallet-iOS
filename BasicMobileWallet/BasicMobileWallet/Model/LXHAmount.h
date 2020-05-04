//
//  LXHAmount.h
//  BasicMobileWallet
//
//  Created by lian on 2020/5/4.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXHGlobalHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHAmount : NSObject

+ (BOOL)isValidWithDecimalValue:(NSDecimalNumber *)value;
+ (BOOL)isValidWithString:(NSString *)string;
+ (BOOL)isValidWithNumberValue:(NSNumber *)value;
@end

NS_ASSUME_NONNULL_END
