//
//  LXHInitFlowForCreatingNewWallet.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/17.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHInitFlowForCreatingNewWallet.h"
#import "LXHWalletMnemonicPassphraseViewModel.h"

@implementation LXHInitFlowForCreatingNewWallet

+ (LXHInitFlow *)sharedInstance {
    static LXHInitFlowForCreatingNewWallet *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)checkWalletMnemonicWordsClickNextButtonNavigationInfo {
    id viewModel = [[LXHWalletMnemonicPassphraseViewModel alloc] initWithWords:self.mnemonicWords];
    return @{@"controllerClassName":@"LXHWalletMnemonicPassphraseViewController", @"viewModel":viewModel};
}

@end
