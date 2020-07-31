//
//  LXHWalletMnemonicPassphraseForRestoringViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWalletMnemonicPassphraseForRestoringViewModel.h"
#import "LXHInputExistingPassphraseViewModel.h"
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
    return [[LXHInputExistingPassphraseViewModel alloc] initWithWords:self.words];
}

- (id)generateWalletViewModelWithPassphrase:(NSString *)passphrase {
    id viewModel = [[LXHGenerateWalletViewModel alloc] initWithMnemonicCodeWords:self.words mnemonicPassphrase:passphrase];
    return viewModel;
}

@end
