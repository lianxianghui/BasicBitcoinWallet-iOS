// LXHInputAmountCell.m
// BasicWallet
//
//  Created by lianxianghui on 19-11-7
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHInputAmountCell.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHInputAmountCell()
@end

@implementation LXHInputAmountCell

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
    [self addSubview:self.inputGroup];
    [self addSubview:self.textButton];
}

- (void)makeConstraints {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(0.5);
    }];
    [self.inputGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(3);
        make.right.equalTo(self.inputBTC.mas_right);
        make.height.mas_equalTo(22);
    }];
    [self.inputBTC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputGroup.mas_top);
        make.bottom.equalTo(self.inputGroup.mas_bottom);
        make.right.equalTo(self.BTC.mas_right);
        make.left.equalTo(self.text.mas_right).offset(4);
    }];
    [self.BTC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inputBTC.mas_centerY);
        make.left.equalTo(self.textFieldWithPlaceHolder.mas_right).offset(6);
    }];
    [self.textFieldWithPlaceHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBTC.mas_left);
        make.top.equalTo(self.inputBTC.mas_top);
        make.bottom.equalTo(self.inputBTC.mas_bottom);
        make.width.mas_equalTo(143);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputGroup.mas_left);
        make.centerY.equalTo(self.inputGroup.mas_centerY);
    }];
    [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-8);
        make.width.mas_equalTo(67);
        make.height.mas_equalTo(28);
    }];
    [self.text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textButton.mas_centerY);
        make.centerX.equalTo(self.textButton.mas_centerX);
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

- (UIView *)inputGroup {
    if (!_inputGroup) {
        _inputGroup = [[UIView alloc] init];
        _inputGroup.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _inputGroup.alpha = 1;
        [_inputGroup addSubview:self.inputBTC];
        [_inputGroup addSubview:self.text];
    }
    return _inputGroup;
}

- (UIView *)inputBTC {
    if (!_inputBTC) {
        _inputBTC = [[UIView alloc] init];
        _inputBTC.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _inputBTC.alpha = 1;
        [_inputBTC addSubview:self.BTC];
        [_inputBTC addSubview:self.textFieldWithPlaceHolder];
    }
    return _inputBTC;
}

- (UILabel *)BTC {
    if (!_BTC) {
        _BTC = [[UILabel alloc] init];
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@" BTC", nil) attributes:textAttributes];
        _BTC.attributedText = text;
    }
    return _BTC;
}

- (UITextField *)textFieldWithPlaceHolder {
    if (!_textFieldWithPlaceHolder) {
        _textFieldWithPlaceHolder = [[UITextField alloc] init];
        _textFieldWithPlaceHolder.backgroundColor = UIColorFromRGBA(0xF8F8F8FF);
        _textFieldWithPlaceHolder.layer.cornerRadius = 5;
        _textFieldWithPlaceHolder.layer.borderWidth = 1;
        _textFieldWithPlaceHolder.layer.borderColor = UIColorFromRGBA(0xD8D8D8FF).CGColor;
        _textFieldWithPlaceHolder.alpha = 1;
        UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        if (!font) font = [UIFont systemFontOfSize:14];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x999999FF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.3376471) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"输入数量", nil) attributes:textAttributes];
        _textFieldWithPlaceHolder.attributedPlaceholder = text;
    }
    return _textFieldWithPlaceHolder;
}

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc] init];
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
        [textAttributes setObject:@(-0.3683423) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"数量:", nil) attributes:textAttributes];
        _text.attributedText = text;
    }
    return _text;
}

- (UIButton *)textButton {
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton.backgroundColor = UIColorFromRGBA(0x009688FF);
        _textButton.layer.cornerRadius = 2;
        _textButton.alpha = 1;
        [_textButton addSubview:self.text1];
    }
    return _textButton;
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"输入最大值", nil) attributes:textAttributes];
        _text1.attributedText = text;
    }
    return _text1;
}

@end
