// LXHSelectedOutputCell.h
// BasicWallet
//
//  Created by lianxianghui on 19-11-25
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHSelectedOutputCell : UIView

@property (nonatomic) UIView *separator;
@property (nonatomic) UIView *group;
@property (nonatomic) UILabel *btcValue;
@property (nonatomic) UILabel *addressText;
@property (nonatomic) UILabel *address;
@property (nonatomic) UILabel *addressWarningDesc;
@property (nonatomic) UILabel *addressDesc;
@property (nonatomic) UIButton *button;
@property (nonatomic) UIImageView *deleteImage;

@end
