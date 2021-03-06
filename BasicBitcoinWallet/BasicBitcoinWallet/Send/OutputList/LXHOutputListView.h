// LXHOutputListView.h
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHOutputListView : UIView

@property (nonatomic) UITableView *listView;
@property (nonatomic) UIView *infomation;
@property (nonatomic) UILabel *text;
@property (nonatomic) UILabel *value;
@property (nonatomic) UIButton *modifyOrderButton;
@property (nonatomic) UIButton *addOutputButton;
@property (nonatomic) UIView *customNavigationBar;
@property (nonatomic) UIView *bottomLine;
@property (nonatomic) UILabel *title;
@property (nonatomic) UIButton *rightTextButton;
@property (nonatomic) UILabel *text1;
@property (nonatomic) UIButton *leftImageButton;
@property (nonatomic) UILabel *leftText;
@property (nonatomic) UIImageView *leftBarItemImage;

@end
