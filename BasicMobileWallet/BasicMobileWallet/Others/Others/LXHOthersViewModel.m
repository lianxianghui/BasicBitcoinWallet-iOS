//
//  LXHOthersViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHOthersViewModel.h"
#import "LXHTransactionListViewModel.h"

@implementation LXHOthersViewModel

- (id)transactionListViewModel {
    return [[LXHTransactionListViewModel alloc] init];
}

- (id)addressListViewModel {
    return nil;
}

- (id)settingViewModel {
    return nil;
}

@end
