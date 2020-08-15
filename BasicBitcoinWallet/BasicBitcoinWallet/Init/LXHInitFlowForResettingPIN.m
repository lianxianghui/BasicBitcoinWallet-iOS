//
//  LXHInitFlowForResettingPIN.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/4/17.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHInitFlowForResettingPIN.h"
#import "LXHWalletMnemonicPassphraseForResettingPINViewModel.h"
#import "LXHWallet.h"
#import "LXHInputMnemonicWordsViewModel.h"
#import "BTCMnemonic.h"

@implementation LXHInitFlowForResettingPIN

+ (LXHInitFlow *)sharedInstance {
    static LXHInitFlowForResettingPIN *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSDictionary *)selectMnemonicWordLengthViewClickRowNavigationInfo {
    id viewModel = [[LXHInputMnemonicWordsViewModel alloc] initWithWordLength:self.mnemonicWordsLength];
    NSString *controllerClassName = @"LXHInputMnemonicWordsViewController";
    return @{@"controllerClassName":controllerClassName, @"viewModel":viewModel};
}
- (NSDictionary *)checkWalletMnemonicWordsClickNextButtonNavigationInfo {
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:self.mnemonicWords password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    if (!mnemonic) {
        self.mnemonicWords = nil;
        NSError *error = [NSError errorWithDomain:@"LXHErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"您所输入的助记词序列有误，请检查后重新输入。", nil)}];
        return @{@"error":error};
    } else {
        id viewModel = [[LXHWalletMnemonicPassphraseForResettingPINViewModel alloc] initWithWords:self.mnemonicWords];
        return @{@"controllerClassName":@"LXHWalletMnemonicPassphraseForResettingPINViewController", @"viewModel":viewModel};
    }
}

- (NSDictionary *)setPassphraseViewClickOKButtonNavigationInfoWithWithPassphrase:(NSString *)passphrase {
    [LXHInitFlow currentFlow].mnemonicPassphrase = passphrase;
    if ([LXHWallet isCurrentMnemonicCodeWords:self.mnemonicWords andMnemonicPassphrase:passphrase]) {
        NSString *controllerClassName = @"LXHSetPinViewController";
        id viewModel = [NSNull null];
        return @{@"controllerClassName":controllerClassName, @"viewModel":viewModel};
    } else {
        return @{@"errorInfo":@"您所输入的助记词或/和助记词密码有误，或者您选择的重置PIN码方式不对。"};
    }
}


@end
