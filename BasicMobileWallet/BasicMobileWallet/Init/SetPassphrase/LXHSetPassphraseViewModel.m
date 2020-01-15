//
//  LXHSetPassphraseViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSetPassphraseViewModel.h"
#import "NSString+Base.h"
#import "LXHGenerateWalletViewModel.h"

@interface LXHSetPassphraseViewModel ()
@end

@implementation LXHSetPassphraseViewModel

- (instancetype)initWithWords:(NSArray *)words {
    self = [super init];
    if (self) {
        _words = words;
    }
    return self;
}

- (NSString *)navigationBarTitle {
    return NSLocalizedString(@"设置助记词密码", nil);
}

- (NSString *)prompt {
    return NSLocalizedString(@"请设置密码", nil);
}

- (NSInteger)checkInputText:(NSString *)inputText inputAgainText:(NSString *)inputAgainText {
    if (inputText.length == 0 || inputAgainText.length == 0)
        return -1;
    if (![inputText isEqualToString:inputAgainText])
        return -2;
    if (![inputText isEqualToString:[inputText stringByEliminatingWhiteSpace]])
        return -3;
    return 1;
}

- (id)generateWalletViewModelWithPassphrase:(NSString *)passphrase {
    id viewModel = [[LXHGenerateNewWalletViewModel alloc] initWithMnemonicCodeWords:self.words mnemonicPassphrase:passphrase];
    return viewModel;
}

@end
