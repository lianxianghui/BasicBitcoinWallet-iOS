//
//  LXHGenerateWalletViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/1/14.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHGenerateWalletViewModel.h"
#import "LXHBitcoinNetwork.h"
#import "LXHTabBarPageViewModel.h"
#import "LXHWallet.h"
#import "LXHSearchAddressesAndGenerateWalletViewModel.h"

@interface LXHGenerateWalletViewModel ()
@end

@implementation LXHGenerateWalletViewModel

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase {
    self = [super init];
    if (self) {
        self.mnemonicCodeWords = mnemonicCodeWords;
        self.mnemonicPassphrase = mnemonicPassphrase;
    }
    return self;
}

- (NSDictionary *)clickMainnetNavigationInfo {
    return nil;
}

- (NSDictionary *)clickTestnetButtonNavigationInfo {
    return nil;
}

@end

@implementation LXHGenerateNewWalletViewModel

- (NSDictionary *)clickButtonNavigationInfoWithNetworkType:(LXHBitcoinNetworkType)networkType {
    if ([LXHWallet generateWalletDataWithMnemonicCodeWords:self.mnemonicCodeWords mnemonicPassphrase:self.mnemonicPassphrase netType:networkType]) {
        LXHTabBarPageViewModel *viewModel = [[LXHTabBarPageViewModel alloc] init];
        return @{@"controllerName":@"LXHTabBarPageViewController", @"viewModel":viewModel};
    } else {
        return nil;
    }
}

- (NSDictionary *)clickMainnetNavigationInfo {
    return [self clickButtonNavigationInfoWithNetworkType:LXHBitcoinNetworkTypeMainnet];
}

- (NSDictionary *)clickTestnetButtonNavigationInfo {
    return [self clickButtonNavigationInfoWithNetworkType:LXHBitcoinNetworkTypeTestnet];
}

@end

@implementation LXHRestoreExistWalletViewModel

- (NSDictionary *)clickButtonNavigationInfoWithNetworkType:(LXHBitcoinNetworkType)networkType {
    LXHSearchAddressesAndGenerateWalletViewModel *viewModel = [[LXHSearchAddressesAndGenerateWalletViewModel alloc] initWithMnemonicCodeWords:self.mnemonicCodeWords mnemonicPassphrase:self.mnemonicPassphrase networkType:networkType];
    return @{@"controllerName":@"LXHSearchAddressesAndGenerateWalletViewController", @"viewModel":viewModel};
}

- (NSDictionary *)clickMainnetNavigationInfo {
    return [self clickButtonNavigationInfoWithNetworkType:LXHBitcoinNetworkTypeMainnet];
}

- (NSDictionary *)clickTestnetButtonNavigationInfo {
    return [self clickButtonNavigationInfoWithNetworkType:LXHBitcoinNetworkTypeTestnet];
}


@end

