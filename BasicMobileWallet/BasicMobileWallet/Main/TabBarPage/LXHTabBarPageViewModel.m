//
//  LXHTabBarPageViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTabBarPageViewModel.h"
#import "LXHSelectWayOfSendingBitcoinViewModel.h"
#import "LXHOthersViewModel.h"
#import "LXHBalanceViewModel.h"
#import "LXHCurrentReceivingAddressViewModel.h"

@implementation LXHTabBarPageViewModel

- (id)selectWayOfSendingBitcoinViewModel {
    return [[LXHSelectWayOfSendingBitcoinViewModel alloc] init];
}

- (id)currentReceivingAddressViewModel {
    return [[LXHCurrentReceivingAddressViewModel alloc] initWithData:nil];
}

- (id)balanceViewModel {
    return [[LXHBalanceViewModel alloc] init];
}

- (id)othersViewModel {
    return [[LXHOthersViewModel alloc] init];
}

@end
