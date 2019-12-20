//
//  LXHWalletMnemonicWordsViewModelForRestoringWallet.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWalletMnemonicWordsViewModelForRestoringWallet.h"
#import "LXHWalletMnemonicPassphraseForRestoringViewModel.h"

@implementation LXHWalletMnemonicWordsViewModelForRestoringWallet

- (id)walletMnemonicPassphraseViewModel {
    return [[LXHWalletMnemonicPassphraseForRestoringViewModel alloc] initWithWords:self.words];
}

@end
