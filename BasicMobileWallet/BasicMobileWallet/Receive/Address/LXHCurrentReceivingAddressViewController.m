//
//  LXHCurrentReceivingAddressViewController.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/22.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHCurrentReceivingAddressViewController.h"
#import "BTCQRCode.h"
#import "LXHWallet.h"
#import "UILabel+LXHText.h"

@interface LXHCurrentReceivingAddressViewController ()

@end

@implementation LXHCurrentReceivingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.leftImageButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshViewWithCurrentReceivingAddress];//每次显示时都刷新
}

- (void)refreshViewWithCurrentReceivingAddress {
    NSDictionary *data = @{@"addressType":@(LXHLocalAddressTypeReceiving), @"addressIndex":@(LXHWallet.mainAccount.receiving.currentAddressIndex)};
    [self refreshViewWithData:data];
} 

@end
