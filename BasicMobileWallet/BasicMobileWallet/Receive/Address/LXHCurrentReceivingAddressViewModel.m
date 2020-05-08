//
//  LXHCurrentReceivingAddressViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/29.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHCurrentReceivingAddressViewModel.h"
#import "LXHWallet.h"

@implementation LXHCurrentReceivingAddressViewModel

- (NSString *)navigationBarTitle {
    return @"接收地址";
}

- (BOOL)leftButtonHidden {
    return YES;
}

- (void)refreshData {
    NSDictionary *data = @{@"addressType":@(LXHLocalAddressTypeReceiving), @"addressIndex":@(LXHWallet.mainAccount.receiving.currentAddressIndex)};
    self.data = data;
}

@end
