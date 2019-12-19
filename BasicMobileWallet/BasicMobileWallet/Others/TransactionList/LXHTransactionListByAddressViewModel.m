//
//  LXHTransactionListByAddressViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionListByAddressViewModel.h"
#import "LXHTransactionDataManager.h"

@interface LXHTransactionListByAddressViewModel ()
@property (nonatomic) NSString *address;
@end

@implementation LXHTransactionListByAddressViewModel

- (instancetype)initWithAddress:(NSString *)address {
    self = [super init];
    if (self) {
        _address = address;
    }
    return self;
}

- (NSArray<LXHTransaction *> *)transactionList {
    if (!_address)
        return nil;
    else
        return [[LXHTransactionDataManager sharedInstance] transactionListByAddress:_address];
}


@end
