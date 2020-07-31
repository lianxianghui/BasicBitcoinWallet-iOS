// LXHSetPassphraseView.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-20
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHSetPassphraseView.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHSetPassphraseView()
@end

@implementation LXHSetPassphraseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0xEFEFF4FF);
        self.alpha = 1;
        [self addSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.view];
    [self addSubview:self.promot];
    [self addSubview:self.customNavigationBar];
}

- (void)makeConstraints {
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(self.textButton.mas_bottom);
        make.top.equalTo(self.promot.mas_bottom).offset(20);
    }];
    [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.inputAgainTextFieldWithPlaceHolder.mas_bottom).offset(25.26000022888184);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(36);
    }];
    [self.inputAgainTextFieldWithPlaceHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTextFieldWithPlaceHolder.mas_left);
        make.right.equalTo(self.inputTextFieldWithPlaceHolder.mas_right);
        make.top.equalTo(self.inputTextFieldWithPlaceHolder.mas_bottom).offset(12.26000022888184);
        make.height.mas_equalTo(35);
    }];
    [self.inputTextFieldWithPlaceHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(35);
    }];
    [self.promot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNavigationBar.mas_bottom).offset(19);
        make.left.equalTo(self.mas_left).offset(19);
        make.right.equalTo(self.mas_right).offset(-19);
    }];
    [self.customNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(45);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customNavigationBar.mas_left);
        make.right.equalTo(self.customNavigationBar.mas_right);
        make.bottom.equalTo(self.customNavigationBar.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.customNavigationBar.mas_centerX);
        make.centerY.equalTo(self.customNavigationBar.mas_centerY);
    }];
    [self.leftImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customNavigationBar.mas_left);
        make.top.equalTo(self.customNavigationBar.mas_top);
        make.bottom.equalTo(self.customNavigationBar.mas_bottom);
        make.width.mas_equalTo(72);
    }];
    [self.leftText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftImageButton.mas_centerY);
        make.left.equalTo(self.leftBarItemImage.mas_right).offset(6);
    }];
    [self.leftBarItemImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageButton.mas_left).offset(5);
        make.centerY.equalTo(self.leftImageButton.mas_centerY);
        make.width.mas_equalTo(12.5);
        make.height.mas_equalTo(21);
    }];
}

//Getters
- (UIView *)view {
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _view.alpha = 1;
        [_view addSubview:self.textButton];
        [_view addSubview:self.inputAgainTextFieldWithPlaceHolder];
        [_view addSubview:self.inputTextFieldWithPlaceHolder];
    }
    return _view;
}

- (UIButton *)textButton {
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeSystem];//Has System Highlighted color
        _textButton.backgroundColor = UIColorFromRGBA(0x009688FF);
        _textButton.layer.cornerRadius = 2;
        _textButton.alpha = 1;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        if (!font) font = [UIFont systemFontOfSize:14];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(0.5) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"确定", nil) attributes:textAttributes];
        [_textButton setAttributedTitle:text forState:UIControlStateNormal];
        _textButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _textButton;
}

- (UITextField *)inputAgainTextFieldWithPlaceHolder {
    if (!_inputAgainTextFieldWithPlaceHolder) {
        _inputAgainTextFieldWithPlaceHolder = [[UITextField alloc] init];
        _inputAgainTextFieldWithPlaceHolder.backgroundColor = UIColorFromRGBA(0xF8F8F8FF);
        _inputAgainTextFieldWithPlaceHolder.layer.cornerRadius = 5;
        _inputAgainTextFieldWithPlaceHolder.layer.borderWidth = 1;
        _inputAgainTextFieldWithPlaceHolder.layer.borderColor = UIColorFromRGBA(0xD8D8D8FF).CGColor;
        _inputAgainTextFieldWithPlaceHolder.alpha = 1;
        UIFont *placeHolderFont = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        if (!placeHolderFont) placeHolderFont = [UIFont systemFontOfSize:14];
        NSMutableParagraphStyle *placeHolderParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        placeHolderParagraphStyle.alignment = NSTextAlignmentNatural;
        placeHolderParagraphStyle.maximumLineHeight = 0;
        placeHolderParagraphStyle.minimumLineHeight = 0;
        placeHolderParagraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *placeHolderTextAttributes = [NSMutableDictionary dictionary];
        [placeHolderTextAttributes setObject:UIColorFromRGBA(0x999999FF) forKey:NSForegroundColorAttributeName];
        [placeHolderTextAttributes setObject:placeHolderFont forKey:NSFontAttributeName];
        [placeHolderTextAttributes setObject:@(-0.3376471) forKey:NSKernAttributeName];
        [placeHolderTextAttributes setObject:placeHolderParagraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *placeHolderText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请再次输入同一密码", nil) attributes:placeHolderTextAttributes];
        _inputAgainTextFieldWithPlaceHolder.attributedPlaceholder = placeHolderText;
    }
    return _inputAgainTextFieldWithPlaceHolder;
}

- (UITextField *)inputTextFieldWithPlaceHolder {
    if (!_inputTextFieldWithPlaceHolder) {
        _inputTextFieldWithPlaceHolder = [[UITextField alloc] init];
        _inputTextFieldWithPlaceHolder.backgroundColor = UIColorFromRGBA(0xF8F8F8FF);
        _inputTextFieldWithPlaceHolder.layer.cornerRadius = 5;
        _inputTextFieldWithPlaceHolder.layer.borderWidth = 1;
        _inputTextFieldWithPlaceHolder.layer.borderColor = UIColorFromRGBA(0xD8D8D8FF).CGColor;
        _inputTextFieldWithPlaceHolder.alpha = 1;
        UIFont *placeHolderFont = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        if (!placeHolderFont) placeHolderFont = [UIFont systemFontOfSize:14];
        NSMutableParagraphStyle *placeHolderParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        placeHolderParagraphStyle.alignment = NSTextAlignmentNatural;
        placeHolderParagraphStyle.maximumLineHeight = 0;
        placeHolderParagraphStyle.minimumLineHeight = 0;
        placeHolderParagraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *placeHolderTextAttributes = [NSMutableDictionary dictionary];
        [placeHolderTextAttributes setObject:UIColorFromRGBA(0x999999FF) forKey:NSForegroundColorAttributeName];
        [placeHolderTextAttributes setObject:placeHolderFont forKey:NSFontAttributeName];
        [placeHolderTextAttributes setObject:@(-0.3376471) forKey:NSKernAttributeName];
        [placeHolderTextAttributes setObject:placeHolderParagraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *placeHolderText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入密码", nil) attributes:placeHolderTextAttributes];
        _inputTextFieldWithPlaceHolder.attributedPlaceholder = placeHolderText;
    }
    return _inputTextFieldWithPlaceHolder;
}

- (UILabel *)promot {
    if (!_promot) {
        _promot = [[UILabel alloc] init];
        NSMutableAttributedString *attributedText = [NSMutableAttributedString new];
        UIFont *font = nil;
        NSMutableParagraphStyle *paragraphStyle = nil;
        NSMutableDictionary *textAttributes = nil;
        NSAttributedString *text = nil;

        font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        if (!font) font = [UIFont systemFontOfSize:18];
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;
        textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.8014479) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请设置密码", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        font = [UIFont fontWithName:@"" size:18];
        if (!font) font = [UIFont systemFontOfSize:18];
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;
        textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.8014479) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@" ", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        _promot.attributedText = attributedText;
    }
    return _promot;
}

- (UIView *)customNavigationBar {
    if (!_customNavigationBar) {
        _customNavigationBar = [[UIView alloc] init];
        _customNavigationBar.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
        _customNavigationBar.alpha = 1;
        [_customNavigationBar addSubview:self.bottomLine];
        [_customNavigationBar addSubview:self.title];
        [_customNavigationBar addSubview:self.leftImageButton];
    }
    return _customNavigationBar;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGBA(0xB2B2B2FF);
        _bottomLine.alpha = 1;
    }
    return _bottomLine;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
        if (!font) font = [UIFont systemFontOfSize:17];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x030303FF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.4099999964237213) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"设置助记词密码", nil) attributes:textAttributes];
        _title.attributedText = text;
    }
    return _title;
}

- (UIButton *)leftImageButton {
    if (!_leftImageButton) {
        _leftImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftImageButton.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _leftImageButton.alpha = 1;
        [_leftImageButton addSubview:self.leftText];
        [_leftImageButton addSubview:self.leftBarItemImage];
    }
    return _leftImageButton;
}

- (UILabel *)leftText {
    if (!_leftText) {
        _leftText = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
        if (!font) font = [UIFont systemFontOfSize:17];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x007AFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.4099999964237213) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"返回", nil) attributes:textAttributes];
        _leftText.attributedText = text;
    }
    return _leftText;
}

- (UIImageView *)leftBarItemImage {
    if (!_leftBarItemImage) {
        _leftBarItemImage = [[UIImageView alloc] init];
        _leftBarItemImage.alpha = 1;
        _leftBarItemImage.image = [UIImage imageNamed:@"back"];
    }
    return _leftBarItemImage;
}

@end
