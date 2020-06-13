//
//  LXHValidatePINViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/5/8.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHValidatePINViewModel.h"
#import "LXHWallet.h"
#import "LXHKeychainStore.h"

@implementation LXHValidatePINViewModel

- (BOOL)needShowValidatePINAlert {
    return [LXHWallet hasPIN];
}

- (BOOL)isCurrentPIN:(NSString *)text {
    if (!text)
        return NO;
    return [LXHWallet verifyPIN:text];
}

- (BOOL)walletDataGenerated {
    return [LXHWallet walletDataGenerated];
}

@end
