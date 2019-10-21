// LXHInputAddressCell.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHInputAddressCell.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHInputAddressCell()
@end

@implementation LXHInputAddressCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0xFFFFFFFF);
        self.alpha = 1;
        [self addSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.separator];
    [self addSubview:self.textButton1];
    [self addSubview:self.textButton2];
    [self addSubview:self.textButton3];
    [self addSubview:self.addressGroup];
}

- (void)makeConstraints {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(0.5);
    }];
    [self.textButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(32);
        make.right.equalTo(self.textButton2.mas_left).offset(-8);
        make.height.mas_equalTo(28);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textButton1.mas_centerY);
        make.centerX.equalTo(self.textButton1.mas_centerX);
    }];
    [self.textButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.textButton3.mas_left).offset(-8);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(28);
    }];
    [self.text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textButton2.mas_centerX);
        make.centerY.equalTo(self.textButton2.mas_centerY);
    }];
    [self.textButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-6);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(28);
    }];
    [self.text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textButton3.mas_centerX);
        make.centerY.equalTo(self.textButton3.mas_centerY);
    }];
    [self.addressGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(3);
        make.height.mas_equalTo(33);
        make.right.equalTo(self.addressText.mas_right);
    }];
    [self.warningText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressText.mas_left);
        make.top.equalTo(self.addressText.mas_bottom).offset(6);
    }];
    [self.addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressGroup.mas_top);
        make.left.equalTo(self.text3.mas_right);
    }];
    [self.text3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressGroup.mas_left);
        make.centerY.equalTo(self.addressGroup.mas_centerY);
    }];
}

//Getters
- (UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = UIColorFromRGBA(0xC8C7CCFF);
        _separator.alpha = 1;
    }
    return _separator;
}

- (UIButton *)textButton1 {
    if (!_textButton1) {
        _textButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton1.backgroundColor = UIColorFromRGBA(0x009688FF);
        _textButton1.layer.cornerRadius = 2;
        _textButton1.alpha = 1;
        [_textButton1 addSubview:self.text];
    }
    return _textButton1;
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        if (!font) font = [UIFont systemFontOfSize:11];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(0.3928571) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"粘贴", nil) attributes:textAttributes];
        _text.attributedText = text;
    }
    return _text;
}

- (UIButton *)textButton2 {
    if (!_textButton2) {
        _textButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton2.backgroundColor = UIColorFromRGBA(0x009688FF);
        _textButton2.layer.cornerRadius = 2;
        _textButton2.alpha = 1;
        [_textButton2 addSubview:self.text1];
    }
    return _textButton2;
}

- (UILabel *)text1 {
    if (!_text1) {
        _text1 = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        if (!font) font = [UIFont systemFontOfSize:11];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(0.3928571) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"扫描", nil) attributes:textAttributes];
        _text1.attributedText = text;
    }
    return _text1;
}

- (UIButton *)textButton3 {
    if (!_textButton3) {
        _textButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton3.backgroundColor = UIColorFromRGBA(0x009688FF);
        _textButton3.layer.cornerRadius = 2;
        _textButton3.alpha = 1;
        [_textButton3 addSubview:self.text2];
    }
    return _textButton3;
}

- (UILabel *)text2 {
    if (!_text2) {
        _text2 = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        if (!font) font = [UIFont systemFontOfSize:11];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(0.3928571) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"选择", nil) attributes:textAttributes];
        _text2.attributedText = text;
    }
    return _text2;
}

- (UIView *)addressGroup {
    if (!_addressGroup) {
        _addressGroup = [[UIView alloc] init];
        _addressGroup.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _addressGroup.alpha = 1;
        [_addressGroup addSubview:self.warningText];
        [_addressGroup addSubview:self.addressText];
        [_addressGroup addSubview:self.text3];
    }
    return _addressGroup;
}

- (UILabel *)warningText {
    if (!_warningText) {
        _warningText = [[UILabel alloc] init];
        NSMutableAttributedString *attributedText = [NSMutableAttributedString new];
        UIFont *font = nil;
        NSMutableParagraphStyle *paragraphStyle = nil;
        NSMutableDictionary *textAttributes = nil;
        NSAttributedString *text = nil;

        font = [UIFont fontWithName:@"PingFangSC-Regular" size:10.5];
        if (!font) font = [UIFont systemFontOfSize:10.5];
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;
        textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFE3824FF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.4675113) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"用过的本地找零地址", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        font = [UIFont fontWithName:@"" size:10.5];
        if (!font) font = [UIFont systemFontOfSize:10.5];
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;
        textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFE3824FF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.4908869) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@" ", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        _warningText.attributedText = attributedText;
    }
    return _warningText;
}

- (UILabel *)addressText {
    if (!_addressText) {
        _addressText = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:10.5];
        if (!font) font = [UIFont systemFontOfSize:10.5];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2279117) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ", nil) attributes:textAttributes];
        _addressText.attributedText = text;
    }
    return _addressText;
}

- (UILabel *)text3 {
    if (!_text3) {
        _text3 = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        if (!font) font = [UIFont systemFontOfSize:12];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2894118) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"地址: ", nil) attributes:textAttributes];
        _text3.attributedText = text;
    }
    return _text3;
}

@end
