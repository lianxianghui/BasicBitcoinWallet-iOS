// LXHInputMnemonicWordsView.h
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@interface LXHInputMnemonicWordsView : UIView

@property (nonatomic) UITableView *listView;
@property (nonatomic) UITextField *inputTextFieldWithPlaceHolder;
@property (nonatomic) UIView *customNavigationBar;
@property (nonatomic) UIView *bottomLine;
@property (nonatomic) UILabel *title;
@property (nonatomic) UIButton *leftImageButton;
@property (nonatomic) UILabel *leftText;
@property (nonatomic) UIImageView *leftBarItemImage;
@property (nonatomic) UILabel *promot;

@end
