//
//  LXHCurrentAccountInfoViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHCurrentAccountInfoViewModel.h"
#import "LXHWallet.h"
#import "LXHGlobalHeader.h"

@implementation LXHCurrentAccountInfoViewModel

- (NSString *)netTypeText {
    LXHAccount *mainAccount = [LXHWallet mainAccount];
    NSString *text = mainAccount.currentNetworkType == LXHBitcoinNetworkTypeMainnet ? @"Mainnet" : @"Testnet";
    return text;
}

- (NSString *)isWatchOnlyText {
    return [LXHWallet isWatchOnly] ? @"是" : @"否";
}
@end
