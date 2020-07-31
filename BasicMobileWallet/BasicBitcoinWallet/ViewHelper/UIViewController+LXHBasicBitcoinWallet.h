//
//  UIViewController+LXHBasicBitcoinWallet.h
//  BasicBitcoinWallet
//
//  Created by lianxianghui on 2019/9/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LXHBasicBitcoinWallet)

- (void)validatePINWithPassedHandler:(void (^)(void))handler;

@end

NS_ASSUME_NONNULL_END
