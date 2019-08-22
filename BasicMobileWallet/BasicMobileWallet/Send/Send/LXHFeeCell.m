// LXHFeeCell.m
// BasicWallet
//
//  Created by lianxianghui on 19-08-22
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHFeeCell.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHFeeCell()
@end

@implementation LXHFeeCell

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
    [self addSubview:self.text];
    [self addSubview:self.selectFeerateButton];
    [self addSubview:self.inputFeeValueButton];
}

- (void)makeConstraints {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.selectFeerateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(55);
        make.right.equalTo(self.inputFeeValueButton.mas_left).offset(-17.09000015258789);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    [self.text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectFeerateButton.mas_centerY);
        make.centerX.equalTo(self.selectFeerateButton.mas_centerX);
    }];
    [self.inputFeeValueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.separator.mas_right).offset(-12.5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(55);
    }];
    [self.text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inputFeeValueButton.mas_centerX);
        make.centerY.equalTo(self.inputFeeValueButton.mas_centerY);
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

- (UILabel *)text {
    if (!_text) {
        _text = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        if (!font) font = [UIFont systemFontOfSize:14];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.3376471) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手续费：40sat/byte （费率）", nil) attributes:textAttributes];
        _text.attributedText = text;
    }
    return _text;
}

- (UIView *)selectFeerateButton {
    if (!_selectFeerateButton) {
        _selectFeerateButton = [[UIView alloc] init];
        _selectFeerateButton.backgroundColor = UIColorFromRGBA(0x009688FF);
        _selectFeerateButton.layer.cornerRadius = 2;
        _selectFeerateButton.alpha = 1;
        [_selectFeerateButton addSubview:self.text1];
    }
    return _selectFeerateButton;
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"选择费率", nil) attributes:textAttributes];
        _text1.attributedText = text;
    }
    return _text1;
}

- (UIView *)inputFeeValueButton {
    if (!_inputFeeValueButton) {
        _inputFeeValueButton = [[UIView alloc] init];
        _inputFeeValueButton.backgroundColor = UIColorFromRGBA(0x009688FF);
        _inputFeeValueButton.layer.cornerRadius = 2;
        _inputFeeValueButton.alpha = 1;
        [_inputFeeValueButton addSubview:self.text2];
    }
    return _inputFeeValueButton;
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手动输入", nil) attributes:textAttributes];
        _text2.attributedText = text;
    }
    return _text2;
}

@end
