//
//  LXHWalletMnemonicWordsViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHCheckWalletMnemonicWordsViewModel.h"
#import "LXHWalletMnemonicPassphraseViewModel.h"

@implementation LXHCheckWalletMnemonicWordsViewModel

- (instancetype)initWithWords:(NSArray *)words {
    self = [super init];
    if (self) {
        _words = words;
    }
    return self;
}

- (NSString *)mnemonicWordsText {
    NSString *text = [self.words componentsJoinedByString:@" "];
    return text;
}

- (id)walletMnemonicPassphraseViewModel {
    return [[LXHWalletMnemonicPassphraseViewModel alloc] initWithWords:self.words];
}

- (NSDictionary *)clickNextButtonNavigationInfo {
    id viewModel = [[LXHWalletMnemonicPassphraseViewModel alloc] initWithWords:self.words];
    return @{@"controllerClassName":@"LXHWalletMnemonicPassphraseViewController", @"viewModel":viewModel};
}

@end
