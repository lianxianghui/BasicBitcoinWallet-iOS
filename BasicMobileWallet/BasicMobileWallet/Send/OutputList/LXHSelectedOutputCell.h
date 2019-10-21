// LXHSelectedOutputCell.h
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHSelectedOutputCell : UIView

@property (nonatomic) UIView *separator;
@property (nonatomic) UIButton *button;
@property (nonatomic) UIImageView *deleteImage;
@property (nonatomic) UIView *group;
@property (nonatomic) UILabel *btcValue;
@property (nonatomic) UILabel *addressText;
@property (nonatomic) UILabel *address;
@property (nonatomic) UILabel *addressAttributes;

@end
