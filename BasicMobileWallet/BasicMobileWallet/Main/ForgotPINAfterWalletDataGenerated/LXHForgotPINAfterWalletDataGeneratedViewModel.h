//
//  LXHForgotPINAfterWalletDataGeneratedViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2020/4/23.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHForgotPINAfterWalletDataGeneratedViewModel : NSObject

- (id)inputMnemonicWordButtonClicked;
- (BOOL)checkExtenedPublicKeyWithQRString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END