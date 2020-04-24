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

@interface LXHWalletMnemonicPassphraseForRestoringViewModel ()
@property (nonatomic) NSArray *words;
@end

@implementation LXHWalletMnemonicPassphraseForRestoringViewModel

- (instancetype)initWithWords:(NSArray *)words {
    self = [super init];
    if (self) {
        _words = words;
    }
    return self;
}

- (id)setPassphraseViewModel {
    return [[LXHSetPassphraseViewModelForRestoringWallet alloc] initWithWords:self.words];
}

- (id)generateWalletViewModelWithPassphrase:(NSString *)passphrase {
    id viewModel = [[LXHRestoreExistWalletViewModel alloc] initWithMnemonicCodeWords:self.words mnemonicPassphrase:passphrase];
    return viewModel;
}

@end
