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

+ (instancetype)sharedInstance {
    static LXHCurrentReceivingAddressViewController *instance = nil;
    static dispatch_once_t tokon;
    dispatch_once(&tokon, ^{
        instance = [[LXHCurrentReceivingAddressViewController alloc] init];
    });
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshViewWithCurrentReceivingAddress];
}

- (void)refreshViewWithCurrentReceivingAddress {
    NSDictionary *data = @{@"addressType":@(LXHAddressTypeReceiving), @"addressIndex":@([LXHWallet.mainAccount currentReceivingAddressIndex])};
    [self refreshViewWithData:data];
} 

@end
