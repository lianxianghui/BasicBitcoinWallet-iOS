//
//  LXHInitFlowForResettingPIN.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/17.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHInitFlowForResettingPIN.h"
#import "LXHWalletMnemonicPassphraseForResettingPINViewModel.h"

@implementation LXHInitFlowForResettingPIN

+ (LXHInitFlow *)sharedInstance {
    static LXHInitFlowForResettingPIN *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)checkWalletMnemonicWordsClickNextButtonNavigationInfo {
    id viewModel = [[LXHWalletMnemonicPassphraseForResettingPINViewModel alloc] initWithWords:self.mnemonicWords];
    return @{@"controllerClassName":@"LXHWalletMnemonicPassphraseForResettingPINViewController", @"viewModel":viewModel};
}
@end
