// LXHInputDetailView.h
// BasicWallet
//
//  Created by lianxianghui on 19-12-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHInputDetailView : UIView

@property (nonatomic) UITableView *listView;
@property (nonatomic) UIView *customNavigationBar;
@property (nonatomic) UIView *bottomLine;
@property (nonatomic) UILabel *title;
@property (nonatomic) UIButton *leftImageButton;
@property (nonatomic) UILabel *leftText;
@property (nonatomic) UIImageView *leftBarItemImage;
@property (nonatomic) UIActivityIndicatorView *indicatorView;

@end
