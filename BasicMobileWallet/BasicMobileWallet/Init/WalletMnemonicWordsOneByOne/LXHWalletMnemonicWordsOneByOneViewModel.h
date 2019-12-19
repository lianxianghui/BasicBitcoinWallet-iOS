//
//  LXHWalletMnemonicWordsOneByOneViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHWalletMnemonicWordsOneByOneViewModel : NSObject

- (instancetype)initWithWordLength:(NSUInteger)wordLength;

- (nullable NSString *)currentWord;
- (NSString *)currentNumberPrompt;
- (BOOL)button1Enabled;
- (NSString *)button2Text;

- (void)nextWord;
- (void)previousWord;
- (BOOL)isLastWord;

- (NSArray<NSString *> *)words;
@end

NS_ASSUME_NONNULL_END
