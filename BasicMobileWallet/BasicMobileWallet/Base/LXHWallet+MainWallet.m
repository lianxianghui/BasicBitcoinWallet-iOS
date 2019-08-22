//
//  LXHWallet+MainWallet.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/22.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWallet+MainWallet.h"
#import "LXHWalletDataManager.h"

@implementation LXHWallet (MainWallet)

+ (LXHWallet *)mainWallet {
    static LXHWallet *sharedInstance = nil;  
    static dispatch_once_t once;  
    dispatch_once(&once, ^{ 
        sharedInstance = [[LXHWalletDataManager sharedInstance] createWallet];
    });  
    return sharedInstance;
}

@end
