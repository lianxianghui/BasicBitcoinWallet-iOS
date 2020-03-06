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

- (NSDictionary *)clickOKButtonNavigationInfoWithWithPassphrase:(NSString *)passphrase {
    if ([LXHWallet isCurrentMnemonicCodeWords:self.words andMnemonicPassphrase:passphrase]) {
        NSString *controllerClassName = @"LXHSetPinViewController";
        id viewModel = [NSNull null];
        return @{@"controllerClassName":controllerClassName, @"viewModel":viewModel};
    } else {
        return @{@"errorInfo":@"您所输入的助记词或助记词密码有误"};
    }
}

@end
