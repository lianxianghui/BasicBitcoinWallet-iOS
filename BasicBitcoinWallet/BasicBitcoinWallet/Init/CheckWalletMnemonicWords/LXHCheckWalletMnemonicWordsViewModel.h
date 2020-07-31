//
//  LXHWalletMnemonicWordsViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 创建新钱包时的ViewModel
 */
@interface LXHCheckWalletMnemonicWordsViewModel : NSObject

@property (nonatomic) NSArray *words;

- (instancetype)initWithWords:(NSArray *)words;

- (NSString *)prompt;

- (NSString *)mnemonicWordsText;

- (NSDictionary *)clickNextButtonNavigationInfo;
@end

NS_ASSUME_NONNULL_END
