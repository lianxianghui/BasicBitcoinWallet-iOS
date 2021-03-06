// LXHTransactionListView.h
// BasicWallet
//
//  Created by lianxianghui on 19-11-4
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHTransactionListView : UIView

@property (nonatomic) UITableView *listView;
@property (nonatomic) UIView *infomation;
@property (nonatomic) UILabel *promptLabel;
@property (nonatomic) UIView *customNavigationBar;
@property (nonatomic) UIView *bottomLine;
@property (nonatomic) UILabel *title;
@property (nonatomic) UIButton *leftImageButton;
@property (nonatomic) UILabel *leftText;
@property (nonatomic) UIImageView *leftBarItemImage;

@end
