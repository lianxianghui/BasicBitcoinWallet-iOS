//
//  LXHWalletMnemonicWordsOneByOneViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWalletMnemonicWordsOneByOneViewModel.h"
#import "BTCMnemonic.h"
#import "BTCData.h"
#import "LXHCheckWalletMnemonicWordsViewModel.h"

@interface LXHWalletMnemonicWordsOneByOneViewModel ()
@property (nonatomic) NSUInteger wordLength;
@property (nonatomic) NSArray<NSString *> *words;
@property (nonatomic) NSUInteger currentWordIndex;
@end

@implementation LXHWalletMnemonicWordsOneByOneViewModel

- (instancetype)initWithWordLength:(NSUInteger)wordLength {
    self = [super init];
    if (self) {
        _wordLength = wordLength;
        [self generateRandomMnemonicWords];
        _currentWordIndex = 0;
    }
    return self;
}

//计算方法参考 https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch05.asciidoc 中的"Table 2. Mnemonic codes: entropy and word length"
- (void)generateRandomMnemonicWords {
    NSUInteger entropyBitCount = self.wordLength * 32/3;
    NSUInteger entropyByteCount = entropyBitCount / 8;
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithEntropy:BTCRandomDataWithLength(entropyByteCount) password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    self.words = mnemonic.words;
}

- (nullable NSString *)currentWord {
    if (self.currentWordIndex < self.words.count) {
        NSString *word = self.words[self.currentWordIndex];
        return word;
    } else {
        return nil;
    }
}

- (NSString *)currentNumberPrompt {
    NSString *currentNumberFormat = NSLocalizedString(@"%@个单词中的第%@个", nil);
    NSString *currentNumberPrompt = [NSString stringWithFormat:currentNumberFormat, @(self.words.count), @(self.currentWordIndex+1)];
    return currentNumberPrompt;
}

- (BOOL)button1Enabled {
    return (self.currentWordIndex != 0);
}

- (NSString *)button2Text {
    NSString *text = self.currentWordIndex == self.words.count-1 ? NSLocalizedString(@"完成", nil) : NSLocalizedString(@"后一个", nil);
    return text;
}

- (void)nextWord {
    _currentWordIndex++;
}

- (void)previousWord {
    _currentWordIndex--;
}

- (BOOL)isLastWord {
    return (_currentWordIndex == self.words.count-1);
}

- (NSArray<NSString *> *)words {
    return _words;
}

- (id)checkWalletMnemonicWordsViewModel {
    return [[LXHCheckWalletMnemonicWordsViewModel alloc] initWithWords:_words];
}

@end
