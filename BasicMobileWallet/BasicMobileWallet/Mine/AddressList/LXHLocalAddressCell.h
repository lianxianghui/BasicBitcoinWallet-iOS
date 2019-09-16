// LXHLocalAddressCell.h
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHLocalAddressCell : UIView

@property (nonatomic) UIView *separator;
@property (nonatomic) UIView *receiveAddress;
@property (nonatomic) UILabel *addressText;
@property (nonatomic) UILabel *used;
@property (nonatomic) UILabel *localPath;
@property (nonatomic) UILabel *type;
@property (nonatomic) UIImageView *disclosureIndicator;

@end
