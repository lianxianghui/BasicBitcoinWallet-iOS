// LXHTransactionInfoCell.h
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHTransactionInfoCell : UIView

@property (nonatomic) UIView *separator;
@property (nonatomic) UILabel *comfirmation;
@property (nonatomic) UILabel *type;
@property (nonatomic) UILabel *value;
@property (nonatomic) UILabel *InitializedTime;
@property (nonatomic) UIImageView *disclosureIndicator;

@end
