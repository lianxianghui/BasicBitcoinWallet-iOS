//
//  LXHInputMnemonicWordsViewModelForResettingPIN.m
//  BasicMobileWallet
//
//  Created by lian on 2020/3/6.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHInputMnemonicWordsViewModelForResettingPIN.h"
#import "LXHCheckWalletMnemonicWordsViewModelForResettingPIN.h"

@implementation LXHInputMnemonicWordsViewModelForResettingPIN

- (id)checkWalletMnemonicWordsViewModel {
    return [[LXHCheckWalletMnemonicWordsViewModelForResettingPIN alloc] initWithWords:self.inputWords];
}

@end
