//
//  LXHWalletMnemonicPassphraseForRestoringViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHWalletMnemonicPassphraseViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface LXHWalletMnemonicPassphraseForRestoringViewModel : NSObject

- (instancetype)initWithWords:(NSArray *)words;
- (id)setPassphraseViewModel;
- (id)generateWalletViewModelWithPassphrase:(nullable NSString *)passphrase;
@end

NS_ASSUME_NONNULL_END
