//
//  LXHWalletMnemonicWordsViewModelForRestoringWallet.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHCheckWalletMnemonicWordsViewModelForRestoringWallet.h"
#import "LXHWalletMnemonicPassphraseForRestoringViewModel.h"

@implementation LXHCheckWalletMnemonicWordsViewModelForRestoringWallet

- (id)walletMnemonicPassphraseViewModel {
    return [[LXHWalletMnemonicPassphraseForRestoringViewModel alloc] initWithWords:self.words];
}

@end
