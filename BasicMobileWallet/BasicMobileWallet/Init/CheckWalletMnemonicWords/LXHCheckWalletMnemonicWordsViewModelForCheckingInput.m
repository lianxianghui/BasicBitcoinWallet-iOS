//
//  LXHCheckWalletMnemonicWordsViewModelForCheckingInput.m
//  BasicMobileWallet
//
//  Created by lian on 2020/7/28.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHCheckWalletMnemonicWordsViewModelForCheckingInput.h"

@implementation LXHCheckWalletMnemonicWordsViewModelForCheckingInput

- (NSString *)prompt {
    return @"请核对下面您刚刚输入的英文单词序列是否与您之前记录的助记词序列完全一致。如果一致点击下一步，否则返回上一页重新输入。";
}
@end
