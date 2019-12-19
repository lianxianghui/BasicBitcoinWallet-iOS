//
//  LXHInputMnemonicWordsViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHInputMnemonicWordsViewModel.h"
#import "BTCMnemonic.h"

@interface LXHInputMnemonicWordsViewModel ()
@property (nonatomic) NSUInteger wordLength;
@property (nonatomic) NSArray *currentPromptWords;
@property (nonatomic) NSMutableArray *cellDataArrayForListview;
@end

@implementation LXHInputMnemonicWordsViewModel

- (instancetype)initWithWordLength:(NSUInteger)wordLength {
    self = [super init];
    if (self) {
        _wordLength = wordLength;
    }
    return self;
}

- (NSMutableArray *)cellDataArrayForListView {
    if (!_cellDataArrayForListview) {
        _cellDataArrayForListview = [NSMutableArray array];
        for (NSString *word in self.currentPromptWords) {
            NSDictionary *dic = @{@"text":word, @"isSelectable":@"1", @"cellType":@"LXHWordCell"};
            [_cellDataArrayForListview addObject:dic];
        }
    }
    return _cellDataArrayForListview;
}

- (NSString *)currentInputPlaceHolder {
    NSString *format = NSLocalizedString(@"请输入第%@个助记词", nil);
    NSString *currentInputPlaceHolder = [NSString stringWithFormat:format, @(self.inputWords.count+1)];
    return currentInputPlaceHolder;
}

- (BOOL)refreshCellDataArrayForListViewByCurrentInputText:(NSString *)currentInputText {
    if (currentInputText.length > 0) {
        NSMutableArray *currentPromptWords = [NSMutableArray array];
        for (NSString *word in [BTCMnemonic englishWordList]) {
            if ([word hasPrefix:currentInputText])
                [currentPromptWords addObject:word];
        }
        _currentPromptWords = currentPromptWords;
        _cellDataArrayForListview = nil;
        return YES;
    } else {
        return NO;
    }
}

- (void)resetCellDataArrayForListView {
    _currentPromptWords = nil;
    _cellDataArrayForListview = nil;
}

- (void)selectWordAtIndex:(NSUInteger)index {
    if (!self.inputWords)
        self.inputWords = [NSMutableArray array];
    NSString *selectedWord = self.currentPromptWords[index];
    [self.inputWords addObject:selectedWord];
    
    //测试用
    //    self.inputWords = [@"indicate theory winter excite obtain join maximum they error problem index fat" componentsSeparatedByString:@" "].mutableCopy;
}

- (BOOL)selectWordsFinshed {
    return self.inputWords.count < self.wordLength;
}

@end
