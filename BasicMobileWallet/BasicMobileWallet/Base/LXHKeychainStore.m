//
//  LXHKeychainStore.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/13.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHKeychainStore.h"


@interface LXHKeychainStore ()
@end

static NSString *const kKeychainStoreServiceKey = @"org.lianxianghui.keychain.store.basic.wallet";

@implementation LXHKeychainStore

+ (instancetype)sharedInstence {
    static LXHKeychainStore *instance = nil;
    static dispatch_once_t tokon;
    dispatch_once(&tokon, ^{
        instance = [[LXHKeychainStore alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _store = [UICKeyChainStore keyChainStoreWithService:kKeychainStoreServiceKey];
    }
    return self;
}

@end
