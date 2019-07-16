// LXHWalletMnemonicPassphraseForRestoringView.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-16
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHWalletMnemonicPassphraseForRestoringView.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHWalletMnemonicPassphraseForRestoringView()
@end

@implementation LXHWalletMnemonicPassphraseForRestoringView

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
    [self addSubview:self.button2];
    [self addSubview:self.button1];
    [self addSubview:self.promot];
    [self addSubview:self.customNavigationBar];
}

- (void)makeConstraints {
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button1.mas_right).offset(20);
        make.top.equalTo(self.button1.mas_top);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(36);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.button2.mas_centerX);
        make.centerY.equalTo(self.button2.mas_centerY);
    }];
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promot.mas_bottom).offset(27);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(93);
        make.left.equalTo(self.promot.mas_left);
    }];
    [self.text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.button1.mas_centerX);
        make.centerY.equalTo(self.button1.mas_centerY);
    }];
    [self.promot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-19);
        make.left.equalTo(self.mas_left).offset(19);
        make.top.equalTo(self.customNavigationBar.mas_bottom).offset(19);
    }];
    [self.customNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(45);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.customNavigationBar.mas_centerY);
        make.centerX.equalTo(self.customNavigationBar.mas_centerX);
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
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(13);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customNavigationBar.mas_left);
        make.right.equalTo(self.customNavigationBar.mas_right);
        make.bottom.equalTo(self.customNavigationBar.mas_bottom);
        make.height.mas_equalTo(0.5099999904632568);
    }];
}

//Getters
- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.backgroundColor = UIColorFromRGBA(0x009688FF);
        _button2.layer.cornerRadius = 2;
        _button2.alpha = 1;
        [_button2 addSubview:self.text];
    }
    return _button2;
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc] init];
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"略过", nil) attributes:textAttributes];
        _text.attributedText = text;
    }
    return _text;
}

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.backgroundColor = UIColorFromRGBA(0x009688FF);
        _button1.layer.cornerRadius = 2;
        _button1.alpha = 1;
        [_button1 addSubview:self.text1];
    }
    return _button1;
}

- (UILabel *)text1 {
    if (!_text1) {
        _text1 = [[UILabel alloc] init];
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"输入", nil) attributes:textAttributes];
        _text1.attributedText = text;
    }
    return _text1;
}

- (UILabel *)promot {
    if (!_promot) {
        _promot = [[UILabel alloc] init];
        _promot.numberOfLines = 0;
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
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入密码", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        font = [UIFont fontWithName:@"SFProText-Regular" size:18];
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
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"\n", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        if (!font) font = [UIFont systemFontOfSize:14];
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
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"您可以选择设置或者略过这一步骤。如果您为正在恢复的钱包设置过助记词密码，请点击输入按钮。如果您未设置过，请点击略过按钮。此密码与", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        font = [UIFont fontWithName:@"SFProText-Regular" size:14];
        if (!font) font = [UIFont systemFontOfSize:14];
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
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"PIN", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        if (!font) font = [UIFont systemFontOfSize:14];
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
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"码不同，如果输错不会导致原有的比特币丢失，但会导致无法恢复使用原有的比特币。如果您不完全理解此密码的用途，请更多了解相关知识并清楚后再选择输入或者略过。", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        _promot.attributedText = attributedText;
    }
    return _promot;
}

- (UIView *)customNavigationBar {
    if (!_customNavigationBar) {
        _customNavigationBar = [[UIView alloc] init];
        _customNavigationBar.backgroundColor = UIColorFromRGBA(0xFAFAFAE5);
        _customNavigationBar.alpha = 1;
        [_customNavigationBar addSubview:self.title];
        [_customNavigationBar addSubview:self.leftImageButton];
        [_customNavigationBar addSubview:self.bottomLine];
    }
    return _customNavigationBar;
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"输入助记词密码", nil) attributes:textAttributes];
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
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        if (!font) font = [UIFont systemFontOfSize:16];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentRight;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x0076FFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.3858823) forKey:NSKernAttributeName];
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

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGBA(0xB2B2B2FF);
        _bottomLine.alpha = 1;
    }
    return _bottomLine;
}

@end
