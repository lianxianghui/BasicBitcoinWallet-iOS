// LXHSelectInputCell.h
// BasicWallet
//
//  Created by lianxianghui on 20-05-13
//  Copyright © 2020年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHSelectInputCell : UIView

@property (nonatomic) UIView *separator;
@property (nonatomic) UIView *utxo;
@property (nonatomic) UIButton *button;
@property (nonatomic) UILabel *btcValue;
@property (nonatomic) UILabel *btcValueForWarning;
@property (nonatomic) UILabel *addressText;
@property (nonatomic) UILabel *timeValue;
@property (nonatomic) UILabel *time;
@property (nonatomic) UIView *checkedGroup;
@property (nonatomic) UIImageView *circleImage;
@property (nonatomic) UIImageView *checkedImage;

@end
