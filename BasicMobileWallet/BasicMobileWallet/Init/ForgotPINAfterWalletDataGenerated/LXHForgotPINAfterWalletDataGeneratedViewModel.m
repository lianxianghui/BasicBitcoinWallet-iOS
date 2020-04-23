//
//  LXHForgotPINAfterWalletDataGeneratedViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/23.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHForgotPINAfterWalletDataGeneratedViewModel.h"
#import "LXHInitFlow.h"
#import "LXHSelectMnemonicWordLengthViewModel.h"

@implementation LXHForgotPINAfterWalletDataGeneratedViewModel

- (id)inputMnemonicWordButtonClicked {
    [LXHInitFlow startResettingPINFlow];
    id viewModel = [[LXHSelectMnemonicWordLengthViewModel alloc] init];
    return viewModel;
}

@end
