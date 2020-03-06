//
//  LXHCheckWalletMnemonicWordsViewModelForResettingPIN.m
//  BasicMobileWallet
//
//  Created by lian on 2020/3/6.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHCheckWalletMnemonicWordsViewModelForResettingPIN.h"
#import "LXHWalletMnemonicPassphraseForResettingPINViewModel.h"

@implementation LXHCheckWalletMnemonicWordsViewModelForResettingPIN

- (NSDictionary *)clickNextButtonNavigationInfo {
    id viewModel = [[LXHWalletMnemonicPassphraseForResettingPINViewModel alloc] initWithWords:self.words];
    return @{@"controllerClassName":@"LXHWalletMnemonicPassphraseForResettingPINViewController", @"viewModel":viewModel};
}

@end
