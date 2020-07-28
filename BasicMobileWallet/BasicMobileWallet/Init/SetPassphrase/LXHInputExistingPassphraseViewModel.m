//
//  LXHInputExistingPassphraseViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/7/28.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHInputExistingPassphraseViewModel.h"

@implementation LXHInputExistingPassphraseViewModel

- (NSString *)navigationBarTitle {
    return NSLocalizedString(@"输入助记词密码", nil);
}

- (NSString *)prompt {
    return NSLocalizedString(@"请输入助记词密码", nil);
}

@end
