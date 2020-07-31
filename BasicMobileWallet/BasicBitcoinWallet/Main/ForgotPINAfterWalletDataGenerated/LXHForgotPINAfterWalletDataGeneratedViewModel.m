//
//  LXHForgotPINAfterWalletDataGeneratedViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/4/23.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHForgotPINAfterWalletDataGeneratedViewModel.h"
#import "LXHInitFlow.h"
#import "LXHSelectMnemonicWordLengthViewModel.h"
#import "LXHWallet.h"

@implementation LXHForgotPINAfterWalletDataGeneratedViewModel

- (id)inputMnemonicWordButtonClicked {
    [LXHInitFlow startResettingPINFlow];
    id viewModel = [[LXHSelectMnemonicWordLengthViewModel alloc] init];
    return viewModel;
}

- (BOOL)checkExtendedPublicKeyWithQRString:(NSString *)string {
    if ([LXHWallet isFullFunctional]) //是全功能钱包，不应该检查扩展公钥
        return NO;
    BOOL match = [string isEqualToString:[LXHWallet mainAccount].extendedPublicKey];
    return match;
}

@end
