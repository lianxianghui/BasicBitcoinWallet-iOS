// LXHInputOutputCell.h
// BasicWallet
//
//  Created by lianxianghui on 19-08-22
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHInputOutputCell : UIView

@property (nonatomic) UIView *separator;
@property (nonatomic) UILabel *btcValue;
@property (nonatomic) UIView *receiveAddress;
@property (nonatomic) UILabel *addressText;
@property (nonatomic) UILabel *text;

@end