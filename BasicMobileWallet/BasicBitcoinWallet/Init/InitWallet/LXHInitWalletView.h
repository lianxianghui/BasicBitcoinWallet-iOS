// LXHInitWalletView.h
// BasicWallet
//
//  Created by lianxianghui on 19-12-19
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHInitWalletView : UIView

@property (nonatomic) UIView *bottomButtons;
@property (nonatomic) UIButton *importWatchOnlyWalletButton;
@property (nonatomic) UIButton *restoreWalletButton;
@property (nonatomic) UIButton *createWalletButton;
@property (nonatomic) UILabel *desc3;
@property (nonatomic) UILabel *desc2;
@property (nonatomic) UILabel *desc1;
@property (nonatomic) UIView *customNavigationBar;
@property (nonatomic) UIView *bottomLine;
@property (nonatomic) UILabel *title;
@property (nonatomic) UIButton *leftImageButton;
@property (nonatomic) UILabel *leftText;
@property (nonatomic) UIImageView *leftBarItemImage;
@property (nonatomic) UIActivityIndicatorView *indicatorView;

@end
