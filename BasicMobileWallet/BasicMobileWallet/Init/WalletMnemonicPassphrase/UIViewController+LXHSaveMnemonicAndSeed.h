//
//  UIViewController+LXHSaveMnemonicAndSeed.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/14.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LXHSaveMnemonicAndSeed)
- (void)saveToKeychainWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords mnemonicPassphrase:(NSString *)mnemonicPassphrase;
@end

NS_ASSUME_NONNULL_END
