//
//  LXHInitFlowForRestoringWallet.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/4/17.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHInitFlowForRestoringWallet.h"
#import "LXHWalletMnemonicPassphraseForRestoringViewModel.h"
#import "LXHGenerateWalletViewModel.h"
#import "LXHInputMnemonicWordsViewModel.h"
#import "LXHSearchAddressesAndGenerateWalletViewModel.h"
#import "BTCMnemonic.h"

@implementation LXHInitFlowForRestoringWallet

+ (LXHInitFlow *)sharedInstance {
    static LXHInitFlowForRestoringWallet *sharedInstance = nil;
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
        id viewModel = [[LXHWalletMnemonicPassphraseForRestoringViewModel alloc] initWithWords:self.mnemonicWords];
        return @{@"controllerClassName":@"LXHWalletMnemonicPassphraseForRestoringViewController", @"viewModel":viewModel};
    }
}

- (NSDictionary *)setPassphraseViewClickOKButtonNavigationInfoWithWithPassphrase:(NSString *)passphrase {
    [LXHInitFlow currentFlow].mnemonicPassphrase = passphrase;
    NSString *controllerClassName = @"LXHGenerateWalletViewController";
    id viewModel = [[LXHGenerateWalletViewModel alloc] initWithMnemonicCodeWords:self.mnemonicWords mnemonicPassphrase:passphrase];
    return @{@"controllerClassName":controllerClassName, @"viewModel":viewModel};
}

- (NSDictionary *)generateWalletViewClickButtonNavigationInfoWithNetworkType:(LXHBitcoinNetworkType)networkType {
    LXHSearchAddressesAndGenerateWalletViewModel *viewModel = [[LXHSearchAddressesAndGenerateWalletViewModel alloc] initWithMnemonicCodeWords:self.mnemonicWords mnemonicPassphrase:self.mnemonicPassphrase networkType:networkType];
    return @{@"controllerName":@"LXHSearchAddressesAndGenerateWalletViewController", @"viewModel":viewModel};
}

- (NSDictionary *)generateWalletViewClickMainnetNavigationInfo {
    return [self generateWalletViewClickButtonNavigationInfoWithNetworkType:LXHBitcoinNetworkTypeMainnet];
}

- (NSDictionary *)generateWalletViewClickTestnetButtonNavigationInfo {
    return [self generateWalletViewClickButtonNavigationInfoWithNetworkType:LXHBitcoinNetworkTypeTestnet];
}
@end
