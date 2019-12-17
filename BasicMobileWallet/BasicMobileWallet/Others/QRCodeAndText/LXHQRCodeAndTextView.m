// LXHQRCodeAndTextView.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-17
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHQRCodeAndTextView.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHQRCodeAndTextView()
@end

@implementation LXHQRCodeAndTextView

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
    [self addSubview:self.shareButton];
    [self addSubview:self.copyButton];
    [self addSubview:self.text2];
    [self addSubview:self.qrImage];
    [self addSubview:self.customNavigationBar];
}

- (void)makeConstraints {
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(34);
        make.top.equalTo(self.copyButton.mas_bottom).offset(18);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareButton.mas_centerX);
        make.centerY.equalTo(self.shareButton.mas_centerY);
    }];
    [self.copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(34);
        make.top.equalTo(self.text2.mas_bottom).offset(12);
    }];
    [self.text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.copyButton.mas_centerX);
        make.centerY.equalTo(self.copyButton.mas_centerY);
    }];
    [self.text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrImage.mas_bottom).offset(30);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.height.mas_equalTo(80);
    }];
    [self.qrImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.customNavigationBar.mas_bottom).offset(30);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(250);
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
        make.height.mas_equalTo(0.5099999904632568);
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
- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.backgroundColor = UIColorFromRGBA(0x009688FF);
        _shareButton.layer.cornerRadius = 2;
        _shareButton.alpha = 1;
        [_shareButton addSubview:self.text];
    }
    return _shareButton;
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        if (!font) font = [UIFont systemFontOfSize:13];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(0.4642857) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"分享", nil) attributes:textAttributes];
        _text.attributedText = text;
    }
    return _text;
}

- (UIButton *)copyButton {
    if (!_copyButton) {
        _copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _copyButton.backgroundColor = UIColorFromRGBA(0x009688FF);
        _copyButton.layer.cornerRadius = 2;
        _copyButton.alpha = 1;
        [_copyButton addSubview:self.text1];
    }
    return _copyButton;
}

- (UILabel *)text1 {
    if (!_text1) {
        _text1 = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        if (!font) font = [UIFont systemFontOfSize:13];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(0.4642857) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"拷贝", nil) attributes:textAttributes];
        _text1.attributedText = text;
    }
    return _text1;
}

- (UILabel *)text2 {
    if (!_text2) {
        _text2 = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        if (!font) font = [UIFont systemFontOfSize:15];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.4220588) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"mouVCdfedfdfdfefefefefefefefefdsfdldefdeddddfe", nil) attributes:textAttributes];
        _text2.attributedText = text;
    }
    return _text2;
}

- (UIImageView *)qrImage {
    if (!_qrImage) {
        _qrImage = [[UIImageView alloc] init];
        _qrImage.alpha = 1;
        _qrImage.image = [UIImage imageNamed:@"others_qrcodeandtext_qr_image"];
    }
    return _qrImage;
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Title", nil) attributes:textAttributes];
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
