// LXHWalletMnemonicPassphraseView.h
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>


/**
 创建新钱包时的View
 */
@interface LXHWalletMnemonicPassphraseView : UIView {
@protected
    UILabel *_title; //navigation bar title
    UILabel *_text1; //button1 text
    UILabel *_prompt;
}

//以下三个属性的getter方法会在子类中被覆盖
@property (nonatomic) UILabel *title;
@property (nonatomic) UILabel *text1;
@property (nonatomic) UILabel *prompt;

@property (nonatomic) UIButton *button2;
@property (nonatomic) UILabel *text;
@property (nonatomic) UIButton *button1;
@property (nonatomic) UIView *customNavigationBar;
@property (nonatomic) UIButton *leftImageButton;
@property (nonatomic) UILabel *leftText;
@property (nonatomic) UIImageView *leftBarItemImage;
@property (nonatomic) UIView *bottomLine;

@end
