//
//  LXHInputMnemonicWordsViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHInputMnemonicWordsViewModel : NSObject
@property (nullable, nonatomic) NSMutableArray *inputWords;

- (instancetype)initWithWordLength:(NSUInteger)wordLength;

- (NSMutableArray *)cellDataArrayForListView;
- (NSString *)currentInputPlaceHolder;

- (BOOL)refreshCellDataArrayForListViewByCurrentInputText:(NSString *)currentInputText;
- (void)resetCellDataArrayForListView;
- (void)selectWordAtIndex:(NSUInteger)index;
- (BOOL)selectWordsUnfinshed;
- (id)checkWalletMnemonicWordsViewModel;
@end

NS_ASSUME_NONNULL_END
