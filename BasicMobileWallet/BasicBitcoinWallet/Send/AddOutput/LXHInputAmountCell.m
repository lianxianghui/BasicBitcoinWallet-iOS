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
    [self addSubview:self.inputBTC];
    [self addSubview:self.textButton];
    [self addSubview:self.text1];
}

- (void)makeConstraints {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.inputBTC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(180);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.text1.mas_right).offset(6);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
    }];
    [self.BTC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textFieldWithPlaceHolder.mas_right).offset(6);
        make.centerY.equalTo(self.textFieldWithPlaceHolder.mas_centerY);
    }];
    [self.maxValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBTC.mas_left).offset(2);
        make.top.equalTo(self.textFieldWithPlaceHolder.mas_bottom).offset(3);
    }];
    [self.textFieldWithPlaceHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBTC.mas_left);
        make.width.mas_equalTo(143);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(self.inputBTC.mas_centerY).offset(-1);
    }];
    [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.width.mas_equalTo(67);
        make.height.mas_equalTo(28);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textButton.mas_centerY);
        make.centerX.equalTo(self.textButton.mas_centerX);
    }];
    [self.text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(6);
        make.centerY.equalTo(self.mas_centerY).offset(-1);
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

- (UIView *)inputBTC {
    if (!_inputBTC) {
        _inputBTC = [[UIView alloc] init];
        _inputBTC.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _inputBTC.alpha = 1;
        [_inputBTC addSubview:self.BTC];
        [_inputBTC addSubview:self.maxValue];
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

- (UILabel *)maxValue {
    if (!_maxValue) {
        _maxValue = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
        if (!font) font = [UIFont systemFontOfSize:9];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.400724) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"可输入最大值: 0.00000001 ", nil) attributes:textAttributes];
        _maxValue.attributedText = text;
    }
    return _maxValue;
}

- (UITextField *)textFieldWithPlaceHolder {
    if (!_textFieldWithPlaceHolder) {
        _textFieldWithPlaceHolder = [[UITextField alloc] init];
        _textFieldWithPlaceHolder.backgroundColor = UIColorFromRGBA(0xF8F8F8FF);
        _textFieldWithPlaceHolder.layer.cornerRadius = 5;
        _textFieldWithPlaceHolder.layer.borderWidth = 1;
        _textFieldWithPlaceHolder.layer.borderColor = UIColorFromRGBA(0xD8D8D8FF).CGColor;
        _textFieldWithPlaceHolder.alpha = 1;
        UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"", nil) attributes:textAttributes];
	    _textFieldWithPlaceHolder.attributedText = text;
        UIFont *placeHolderFont = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
        if (!placeHolderFont) placeHolderFont = [UIFont systemFontOfSize:12];
        NSMutableParagraphStyle *placeHolderParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        placeHolderParagraphStyle.alignment = NSTextAlignmentNatural;
        placeHolderParagraphStyle.maximumLineHeight = 0;
        placeHolderParagraphStyle.minimumLineHeight = 0;
        placeHolderParagraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *placeHolderTextAttributes = [NSMutableDictionary dictionary];
        [placeHolderTextAttributes setObject:UIColorFromRGBA(0x999999FF) forKey:NSForegroundColorAttributeName];
        [placeHolderTextAttributes setObject:font forKey:NSFontAttributeName];
        [placeHolderTextAttributes setObject:@(-0.2894118) forKey:NSKernAttributeName];
        [placeHolderTextAttributes setObject:placeHolderParagraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *placeHolderText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入数量", nil) attributes:placeHolderTextAttributes];
        _textFieldWithPlaceHolder.attributedPlaceholder = placeHolderText;
    }
    return _textFieldWithPlaceHolder;
}

- (UIButton *)textButton {
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton.backgroundColor = UIColorFromRGBA(0x009688FF);
        _textButton.layer.cornerRadius = 2;
        _textButton.alpha = 1;
        [_textButton addSubview:self.text];
    }
    return _textButton;
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"输入最大值", nil) attributes:textAttributes];
        _text.attributedText = text;
    }
    return _text;
}

- (UILabel *)text1 {
    if (!_text1) {
        _text1 = [[UILabel alloc] init];
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
        _text1.attributedText = text;
    }
    return _text1;
}

@end
