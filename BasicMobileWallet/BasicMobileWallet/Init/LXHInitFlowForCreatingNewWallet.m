//
//  LXHInitFlowForCreatingNewWallet.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/17.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHInitFlowForCreatingNewWallet.h"
#import "LXHWalletMnemonicPassphraseViewModel.h"
#import "LXHGenerateWalletViewModel.h"
#import "LXHWalletMnemonicWordsOneByOneViewModel.h"

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

- (NSDictionary *)setPassphraseViewClickOKButtonNavigationInfoWithWithPassphrase:(NSString *)passphrase {
    self.mnemonicPassphrase = passphrase;
    NSString *controllerClassName = @"LXHGenerateWalletViewController";
    id viewModel = [[LXHGenerateWalletViewModel alloc] initWithMnemonicCodeWords:self.mnemonicWords mnemonicPassphrase:passphrase];
    return @{@"controllerClassName":controllerClassName, @"viewModel":viewModel};
}

- (NSDictionary *)selectMnemonicWordLengthViewClickRowNavigationInfo {
    id viewModel = [[LXHWalletMnemonicWordsOneByOneViewModel alloc] initWithWordLength:self.mnemonicWordsLength];
    NSString *controllerClassName = @"LXHWalletMnemonicWordsOneByOneViewController";
    return @{@"controllerClassName":controllerClassName, @"viewModel":viewModel};
}


//GenerateWalletView
- (NSDictionary *)generateWalletViewClickButtonNavigationInfoWithNetworkType:(LXHBitcoinNetworkType)networkType {
    if ([LXHWallet generateWalletDataWithMnemonicCodeWords:self.mnemonicWords mnemonicPassphrase:self.mnemonicPassphrase netType:networkType]) {
        return @{@"willEnterTabBarPage":@(YES)};
    } else {
        return nil;
    }
}

- (NSDictionary *)generateWalletViewClickMainnetNavigationInfo {
    return [self generateWalletViewClickButtonNavigationInfoWithNetworkType:LXHBitcoinNetworkTypeMainnet];
}

- (NSDictionary *)generateWalletViewClickTestnetButtonNavigationInfo {
    return [self generateWalletViewClickButtonNavigationInfoWithNetworkType:LXHBitcoinNetworkTypeTestnet];
}


@end
