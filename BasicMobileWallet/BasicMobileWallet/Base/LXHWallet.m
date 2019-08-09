//
//  LXHWallet.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/17.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWallet.h"
#import "CoreBitcoin.h"
#import "LXHPreference.h"

@interface LXHWallet ()
@property (nonatomic) BTCKeychain *masterKeychain;
@property (nonatomic) NSNumber *currentReceivingAddressIndex;
@property (nonatomic) NSNumber *currentChangeAddressIndex;
@property (nonatomic) BTCKeychain *currentReceivingAddressKeychain;
@property (nonatomic) BTCKeychain *currentChangeAddressKeychain;
@end

@implementation LXHWallet

+ (LXHWallet *)sharedInstance { 
    static LXHWallet *sharedInstance = nil;  
    static dispatch_once_t once;  
    dispatch_once(&once, ^{ 
        sharedInstance = [[self alloc] init];  
    });  
    return sharedInstance; 
}

- (BTCKeychain *)masterKeychain {
    if (!_masterKeychain) {
        NSData* seed = BTCDataWithHexCString("000102030405060708090a0b0c0d0e0f");//TODO temp
        _masterKeychain = [[BTCKeychain alloc] initWithSeed:seed];
    }
    return _masterKeychain;
}

- (NSNumber *)currentChangeAddressIndex {
    return [[LXHPreference sharedInstance].mainPreference valueForKey:@"currentChangeAddressIndex"];
}

- (NSNumber *)currentReceivingAddressIndex {
    return [[LXHPreference sharedInstance].mainPreference valueForKey:@"currentReceivingAddressIndex"];
}

//- (BTCKeychain *)currentReceivingAddressKeychain {
//    NSString *
//}

@end
