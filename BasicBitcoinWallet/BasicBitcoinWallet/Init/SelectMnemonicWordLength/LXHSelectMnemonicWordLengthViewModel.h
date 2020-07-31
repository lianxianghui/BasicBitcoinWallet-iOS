//
//  LXHSelectMnemonicWordLengthViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/4/23.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHSelectMnemonicWordLengthViewModel : NSObject

- (NSDictionary *)clickRowWithWordsLength:(NSUInteger)wordsLength;
@end

NS_ASSUME_NONNULL_END
