//
//  LXHWalletMnemonicWordsViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHCheckWalletMnemonicWordsViewModel.h"
#import "LXHWalletMnemonicPassphraseViewModel.h"
#import "LXHInitFlow.h"

@implementation LXHCheckWalletMnemonicWordsViewModel

- (instancetype)initWithWords:(NSArray *)words {
    self = [super init];
    if (self) {
        _words = words;
    }
    return self;
}

- (NSString *)prompt {
    return nil;
}

- (NSString *)mnemonicWordsText {
    NSString *text = [self.words componentsJoinedByString:@" "];
    return text;
}

- (NSDictionary *)clickNextButtonNavigationInfo {
    LXHInitFlow *currentFlow = [LXHInitFlow currentFlow];
    currentFlow.mnemonicWords = self.words;
    return [currentFlow checkWalletMnemonicWordsClickNextButtonNavigationInfo];
}

@end
