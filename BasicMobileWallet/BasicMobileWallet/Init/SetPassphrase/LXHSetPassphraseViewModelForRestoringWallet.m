//
//  LXHSetPassphraseViewModelForRestoringWallet.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSetPassphraseViewModelForRestoringWallet.h"

@implementation LXHSetPassphraseViewModelForRestoringWallet

- (NSString *)navigationBarTitle {
    return NSLocalizedString(@"输入助记词密码", nil);
}

- (NSString *)prompt {
    return NSLocalizedString(@"请输入助记词密码", nil);
}

- (LXHWalletGenerationType)walletGenerationType {
    return LXHWalletGenerationTypeRestoringExist;
}

@end
