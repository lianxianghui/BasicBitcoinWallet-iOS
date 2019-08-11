//
//  LXHKeychainStore.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/13.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHKeychainStore.h"
#import "BTCData.h"


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

- (void)savePin:(NSString *)pin {
    //为了防止keychain中的pin被读取（比如有人越狱了设备)，存储hmac过的pin
    NSString *key = @"serefddetggg"; //TODO 随便写的，用你自己的代替
    NSMutableData* hmac = BTCHMACSHA512([key dataUsingEncoding:NSASCIIStringEncoding], [pin dataUsingEncoding:NSASCIIStringEncoding]);
    [LXHKeychainStore.sharedInstence.store setData:hmac forKey:kLXHKeychainStorePIN];
}

- (void)saveMnemonic:(NSArray *)mnemonic {
    
}

@end
