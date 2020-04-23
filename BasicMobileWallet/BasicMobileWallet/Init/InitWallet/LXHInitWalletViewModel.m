//
//  LXHInitWalletViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/23.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHInitWalletViewModel.h"
#import "LXHInitFlow.h"
#import "LXHSelectMnemonicWordLengthViewModel.h"

@implementation LXHInitWalletViewModel
- (id)createWalletButtonClicked {
    [LXHInitFlow startCreatingNewWalletFlow];
    return [[LXHSelectMnemonicWordLengthViewModel alloc] init];
}

- (id)restoreWalletButtonClicked {
    [LXHInitFlow startRestoringExistWalletFlow];
    return [[LXHSelectMnemonicWordLengthViewModel alloc] init];
}
@end
