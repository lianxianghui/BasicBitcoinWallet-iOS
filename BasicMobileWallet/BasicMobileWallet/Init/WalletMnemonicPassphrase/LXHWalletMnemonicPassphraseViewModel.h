//
//  LXHWalletMnemonicPassphraseViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHWalletMnemonicPassphraseViewModel : NSObject

@property (nonatomic) NSArray *words;

- (instancetype)initWithWords:(NSArray *)words;
- (NSString *)viewClassName;
- (id)setPassphraseViewModel;
- (LXHWalletGenerationType)walletGenerationType;
@end

NS_ASSUME_NONNULL_END
