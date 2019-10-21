// LXHSelectInputCell.h
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHSelectInputCell : UIView

@property (nonatomic) UIView *separator;
@property (nonatomic) UIView *utxo;
@property (nonatomic) UIButton *button;
@property (nonatomic) UILabel *btcValue;
@property (nonatomic) UILabel *addressText;
@property (nonatomic) UILabel *timeValue;
@property (nonatomic) UILabel *time;
@property (nonatomic) UIView *checkedGroup;
@property (nonatomic) UIImageView *circleImage;
@property (nonatomic) UIImageView *checkedImage;

@end
