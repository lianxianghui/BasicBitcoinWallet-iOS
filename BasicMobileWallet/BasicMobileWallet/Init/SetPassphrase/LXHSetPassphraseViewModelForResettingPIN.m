//
//  LXHSetPassphraseViewModelForResettingPIN.m
//  BasicMobileWallet
//
//  Created by lian on 2020/3/6.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHSetPassphraseViewModelForResettingPIN.h"
#import "LXHWallet.h"

@implementation LXHSetPassphraseViewModelForResettingPIN

- (NSString *)navigationBarTitle {
    return NSLocalizedString(@"输入助记词密码", nil);
}

- (NSString *)prompt {
    return NSLocalizedString(@"请输入助记词密码", nil);
}

@end
