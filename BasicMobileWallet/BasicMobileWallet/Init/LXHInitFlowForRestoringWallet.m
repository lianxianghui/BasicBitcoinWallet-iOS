//
//  LXHInitFlowForRestoringWallet.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/17.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHInitFlowForRestoringWallet.h"
#import "LXHWalletMnemonicPassphraseForRestoringViewModel.h"
#import "LXHGenerateWalletViewModel.h"

@implementation LXHInitFlowForRestoringWallet

+ (LXHInitFlow *)sharedInstance {
    static LXHInitFlowForRestoringWallet *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)checkWalletMnemonicWordsClickNextButtonNavigationInfo {
    id viewModel = [[LXHWalletMnemonicPassphraseForRestoringViewModel alloc] initWithWords:self.mnemonicWords];
    return @{@"controllerClassName":@"LXHWalletMnemonicPassphraseViewController", @"viewModel":viewModel};
}

- (nullable NSDictionary *)setPassphraseViewClickOKButtonNavigationInfoWithWithPassphrase:(NSString *)passphrase {
    [LXHInitFlow currentFlow].mnemonicPassphrase = passphrase;
    NSString *controllerClassName = @"LXHGenerateWalletViewController";
    id viewModel = [[LXHRestoreExistWalletViewModel alloc] initWithMnemonicCodeWords:self.mnemonicWords mnemonicPassphrase:passphrase];
    return @{@"controllerClassName":controllerClassName, @"viewModel":viewModel};
}

@end
