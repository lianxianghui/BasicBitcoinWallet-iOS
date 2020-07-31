//
//  LXHWalletMnemonicPassphraseForResettingPINViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/3/6.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHWalletMnemonicPassphraseForResettingPINViewModel : NSObject

@property (nonatomic) NSArray *words;

- (instancetype)initWithWords:(NSArray *)words;
- (id)viewModelOfSetPassphrasePage;
- (BOOL)isCurrentMnemonicWords;
@end

NS_ASSUME_NONNULL_END
