//
//  LXHSetPassphraseViewModelForRestoringWallet.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSetPassphraseViewModelForRestoringWallet.h"
#import "LXHGenerateWalletViewModel.h"

@implementation LXHSetPassphraseViewModelForRestoringWallet

- (NSString *)navigationBarTitle {
    return NSLocalizedString(@"输入助记词密码", nil);
}

- (NSString *)prompt {
    return NSLocalizedString(@"请输入助记词密码", nil);
}

- (NSDictionary *)clickOKButtonNavigationInfoWithWithPassphrase:(NSString *)passphrase {
    NSString *controllerClassName = @"LXHGenerateWalletViewController";
    id viewModel = [[LXHRestoreExistWalletViewModel alloc] initWithMnemonicCodeWords:self.words mnemonicPassphrase:passphrase];
    return @{@"controllerClassName":controllerClassName, @"viewModel":viewModel};
}

@end
