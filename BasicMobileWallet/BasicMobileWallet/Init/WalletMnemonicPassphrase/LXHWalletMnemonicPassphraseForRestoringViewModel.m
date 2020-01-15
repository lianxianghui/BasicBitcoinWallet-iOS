//
//  LXHWalletMnemonicPassphraseForRestoringViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWalletMnemonicPassphraseForRestoringViewModel.h"
#import "LXHSetPassphraseViewModelForRestoringWallet.h"
#import "LXHGenerateWalletViewModel.h"

@implementation LXHWalletMnemonicPassphraseForRestoringViewModel

- (NSString *)viewClassName {
    return @"LXHWalletMnemonicPassphraseForRestoringView";
}

- (id)setPassphraseViewModel {
    return [[LXHSetPassphraseViewModelForRestoringWallet alloc] initWithWords:self.words];
}

- (id)generateWalletViewModelWithPassphrase:(NSString *)passphrase {
    id viewModel = [[LXHRestoreExistWalletViewModel alloc] initWithMnemonicCodeWords:self.words mnemonicPassphrase:passphrase];
    return viewModel;
}

@end
