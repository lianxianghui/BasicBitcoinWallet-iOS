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


- (void)setViewData {
    NSString *address = [[LXHWallet mainAccount] currentReceivingAddress];
    [self.contentView.addressText updateAttributedTextString:address];
    
    CGSize imageSize = self.contentView.qrImage.bounds.size;
    UIImage *qrImage = [BTCQRCode imageForString:address size:imageSize scale:1];
    self.contentView.qrImage.image = qrImage;
    
    NSString *path = [[LXHWallet mainAccount] currentReceivingAddressPath];
    [self.contentView.addressPath updateAttributedTextString:path];
    
}


@end
