//
//  LXHSelectMnemonicWordLengthViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/4/23.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHSelectMnemonicWordLengthViewModel.h"
#import "LXHInitFlow.h"

@implementation LXHSelectMnemonicWordLengthViewModel

- (NSDictionary *)clickRowWithWordsLength:(NSUInteger)wordsLength {
    LXHInitFlow *currentFlow = [LXHInitFlow currentFlow];
    currentFlow.mnemonicWordsLength = wordsLength;
    return [currentFlow selectMnemonicWordLengthViewClickRowNavigationInfo];
}
@end
