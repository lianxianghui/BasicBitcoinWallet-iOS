//
//  LXHWalletMnemonicWordsViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 创建新钱包时的ViewModel
 */
@interface LXHWalletMnemonicWordsViewModel : NSObject

@property (nonatomic) NSArray *words;

- (instancetype)initWithWords:(NSArray *)words;

- (NSString *)mnemonicWordsText;
- (id)walletMnemonicPassphraseViewModel;
@end

NS_ASSUME_NONNULL_END
