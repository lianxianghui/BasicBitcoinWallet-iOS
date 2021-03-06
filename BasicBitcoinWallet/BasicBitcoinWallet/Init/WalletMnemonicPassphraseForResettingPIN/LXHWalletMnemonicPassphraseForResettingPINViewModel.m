//
//  LXHWalletMnemonicPassphraseForResettingPINViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/3/6.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHWalletMnemonicPassphraseForResettingPINViewModel.h"
#import "LXHInputExistingPassphraseViewModel.h"
#import "LXHWallet.h"

@implementation LXHWalletMnemonicPassphraseForResettingPINViewModel

- (instancetype)initWithWords:(NSArray *)words {
    self = [super init];
    if (self) {
        _words = words;
    }
    return self;
}

- (id)viewModelOfSetPassphrasePage {
    id viewModel = [[LXHInputExistingPassphraseViewModel alloc] initWithWords:_words];
    return viewModel;
}

- (BOOL)isCurrentMnemonicWords {
    return [LXHWallet isCurrentMnemonicCodeWords:_words andMnemonicPassphrase:nil];
}

@end
