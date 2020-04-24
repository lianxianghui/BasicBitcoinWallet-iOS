//
//  LXHWalletMnemonicPassphraseViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHWalletMnemonicPassphraseViewModel : NSObject

- (instancetype)initWithWords:(NSArray *)words;
- (id)setPassphraseViewModel;
- (id)generateWalletViewModelWithPassphrase:(nullable NSString *)passphrase;
@end

NS_ASSUME_NONNULL_END
