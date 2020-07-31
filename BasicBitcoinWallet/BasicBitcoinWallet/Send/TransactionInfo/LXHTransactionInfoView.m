// LXHTransactionInfoView.m
// BasicWallet
//
//  Created by lianxianghui on 19-11-19
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHTransactionInfoView.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHTransactionInfoView()
@end

@implementation LXHTransactionInfoView

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
    [self addSubview:self.bottomButtons];
    [self addSubview:self.desc];
    [self addSubview:self.infoTitle];
    [self addSubview:self.customNavigationBar];
    [self addSubview:self.indicatorView];
}

- (void)makeConstraints {
    [self.bottomButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.customNavigationBar.mas_left);
        make.right.equalTo(self.customNavigationBar.mas_right);
        make.height.mas_equalTo(162);
    }];
    [self.textButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomButtons.mas_left).offset(19);
        make.bottom.equalTo(self.bottomButtons.mas_bottom).offset(-16);
        make.right.equalTo(self.bottomButtons.mas_right).offset(-19);
        make.height.mas_equalTo(46);
    }];
    [self.textButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textButton3.mas_left);
        make.right.equalTo(self.textButton3.mas_right);
        make.bottom.equalTo(self.textButton3.mas_top).offset(-10);
        make.height.mas_equalTo(46);
    }];
    [self.textButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(46);
        make.bottom.equalTo(self.textButton2.mas_top).offset(-10);
        make.left.equalTo(self.textButton3.mas_left);
        make.right.equalTo(self.textButton3.mas_right);
    }];
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoTitle.mas_left);
        make.right.equalTo(self.infoTitle.mas_right).offset(-10);
        make.top.equalTo(self.infoTitle.mas_bottom).offset(12);
    }];
    [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.customNavigationBar.mas_bottom).offset(19);
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
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
}

//Getters
- (UIView *)bottomButtons {
    if (!_bottomButtons) {
        _bottomButtons = [[UIView alloc] init];
        _bottomButtons.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _bottomButtons.alpha = 1;
        [_bottomButtons addSubview:self.textButton3];
        [_bottomButtons addSubview:self.textButton2];
        [_bottomButtons addSubview:self.textButton1];
    }
    return _bottomButtons;
}

- (UIButton *)textButton3 {
    if (!_textButton3) {
        _textButton3 = [UIButton buttonWithType:UIButtonTypeSystem];//Has System Highlighted color
        _textButton3.backgroundColor = UIColorFromRGBA(0x009688FF);
        _textButton3.alpha = 1;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        if (!font) font = [UIFont systemFontOfSize:18];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.449999988079071) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"签名并发送", nil) attributes:textAttributes];
        [_textButton3 setAttributedTitle:text forState:UIControlStateNormal];
        _textButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _textButton3;
}

- (UIButton *)textButton2 {
    if (!_textButton2) {
        _textButton2 = [UIButton buttonWithType:UIButtonTypeSystem];//Has System Highlighted color
        _textButton2.backgroundColor = UIColorFromRGBA(0x009688FF);
        _textButton2.layer.cornerRadius = 2;
        _textButton2.alpha = 1;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        if (!font) font = [UIFont systemFontOfSize:18];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.449999988079071) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"查看签名交易文本", nil) attributes:textAttributes];
        [_textButton2 setAttributedTitle:text forState:UIControlStateNormal];
        _textButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _textButton2;
}

- (UIButton *)textButton1 {
    if (!_textButton1) {
        _textButton1 = [UIButton buttonWithType:UIButtonTypeSystem];//Has System Highlighted color
        _textButton1.backgroundColor = UIColorFromRGBA(0x009688FF);
        _textButton1.layer.cornerRadius = 2;
        _textButton1.alpha = 1;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        if (!font) font = [UIFont systemFontOfSize:18];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.449999988079071) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"查看未签名交易文本", nil) attributes:textAttributes];
        [_textButton1 setAttributedTitle:text forState:UIControlStateNormal];
        _textButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _textButton1;
}

- (UILabel *)desc {
    if (!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.numberOfLines = 0;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        if (!font) font = [UIFont systemFontOfSize:14];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.801448) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"输入：两个输入，共0.01BTC\n输出：两个输出（包含一个找零），共0.00986BTC\n交易费：0.00014BTC\n", nil) attributes:textAttributes];
        _desc.attributedText = text;
    }
    return _desc;
}

- (UILabel *)infoTitle {
    if (!_infoTitle) {
        _infoTitle = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        if (!font) font = [UIFont systemFontOfSize:16];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.8014479) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"交易汇总信息：", nil) attributes:textAttributes];
        _infoTitle.attributedText = text;
    }
    return _infoTitle;
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"交易信息", nil) attributes:textAttributes];
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

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

@end
