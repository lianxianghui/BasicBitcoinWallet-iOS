//
//  LXHShowWalletMnemonicWordsViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/4/29.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHShowWalletMnemonicWordsViewModel.h"
#import "LXHWallet.h"

@implementation LXHShowWalletMnemonicWordsViewModel

- (NSString *)mnemonicWordsText {
    NSArray *mnemonicCodeWords = [LXHWallet mnemonicCodeWordsWithErrorPointer:nil];
    NSString *text = [mnemonicCodeWords componentsJoinedByString:@" "];
    return text ?: @"";
}
@end
