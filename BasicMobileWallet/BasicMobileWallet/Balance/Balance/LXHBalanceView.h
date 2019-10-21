// LXHBalanceView.h
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHBalanceView : UIView

@property (nonatomic) UITableView *listView;
@property (nonatomic) UIView *infomation;
@property (nonatomic) UILabel *balance;
@property (nonatomic) UILabel *balanceValue;
@property (nonatomic) UIView *customNavigationBar;
@property (nonatomic) UIView *bottomLine;
@property (nonatomic) UILabel *title;

@end
