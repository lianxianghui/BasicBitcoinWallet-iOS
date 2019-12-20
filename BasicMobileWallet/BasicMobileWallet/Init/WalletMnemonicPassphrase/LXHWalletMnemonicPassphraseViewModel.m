//
//  LXHWalletMnemonicPassphraseViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWalletMnemonicPassphraseViewModel.h"
#import "LXHSetPassphraseViewModel.h"

@implementation LXHWalletMnemonicPassphraseViewModel

- (instancetype)initWithWords:(NSArray *)words {
    self = [super init];
    if (self) {
        _words = words;
    }
    return self;
}

- (NSString *)viewClassName {
    return @"LXHWalletMnemonicPassphraseView";
}

- (id)setPassphraseViewModel{
    return [[LXHSetPassphraseViewModel alloc] initWithWords:_words];
}

- (LXHWalletGenerationType)walletGenerationType {
    return LXHWalletGenerationTypeGeneratingNew;
}

@end
