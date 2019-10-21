// LXHSelectInputCell.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHSelectInputCell.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHSelectInputCell()
@end

@implementation LXHSelectInputCell

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
    [self addSubview:self.utxo];
    [self addSubview:self.checkedGroup];
}

- (void)makeConstraints {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [self.utxo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.separator.mas_right).offset(-12);
        make.height.mas_equalTo(50);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.utxo.mas_right);
        make.bottom.equalTo(self.utxo.mas_bottom);
        make.width.mas_equalTo(58);
        make.height.mas_equalTo(30);
    }];
    [self.btcValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.utxo.mas_right);
        make.centerY.equalTo(self.addressText.mas_centerY);
    }];
    [self.addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.utxo.mas_left);
        make.top.equalTo(self.utxo.mas_top);
    }];
    [self.timeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.time.mas_right).offset(2);
        make.centerY.equalTo(self.time.mas_centerY);
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.utxo.mas_left);
        make.centerY.equalTo(self.button.mas_centerY).offset(2);
    }];
    [self.checkedGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(29);
    }];
    [self.circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkedGroup.mas_centerY);
        make.centerX.equalTo(self.checkedGroup.mas_centerX);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    [self.checkedImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.checkedGroup.mas_centerX);
        make.centerY.equalTo(self.checkedGroup.mas_centerY);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(16);
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

- (UIView *)utxo {
    if (!_utxo) {
        _utxo = [[UIView alloc] init];
        _utxo.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _utxo.alpha = 1;
        [_utxo addSubview:self.button];
        [_utxo addSubview:self.btcValue];
        [_utxo addSubview:self.addressText];
        [_utxo addSubview:self.timeValue];
        [_utxo addSubview:self.time];
    }
    return _utxo;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];//Has System Highlighted color
        _button.backgroundColor = UIColorFromRGBA(0x009688FF);
        _button.layer.cornerRadius = 2;
        _button.alpha = 1;
        _button.titleLabel.numberOfLines = 0;
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"查看详情", nil) attributes:textAttributes];
        [_button setAttributedTitle:text forState:UIControlStateNormal];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _button;
}

- (UILabel *)btcValue {
    if (!_btcValue) {
        _btcValue = [[UILabel alloc] init];
        _btcValue.numberOfLines = 0;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (!font) font = [UIFont systemFontOfSize:11];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2652941) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"0.00000004 BTC", nil) attributes:textAttributes];
        _btcValue.attributedText = text;
    }
    return _btcValue;
}

- (UILabel *)addressText {
    if (!_addressText) {
        _addressText = [[UILabel alloc] init];
        _addressText.numberOfLines = 0;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (!font) font = [UIFont systemFontOfSize:11];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2652941) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ", nil) attributes:textAttributes];
        _addressText.attributedText = text;
    }
    return _addressText;
}

- (UILabel *)timeValue {
    if (!_timeValue) {
        _timeValue = [[UILabel alloc] init];
        _timeValue.numberOfLines = 0;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (!font) font = [UIFont systemFontOfSize:11];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2652942) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"2019-09-01 12:36", nil) attributes:textAttributes];
        _timeValue.attributedText = text;
    }
    return _timeValue;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.numberOfLines = 0;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (!font) font = [UIFont systemFontOfSize:11];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2652941) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"交易时间:", nil) attributes:textAttributes];
        _time.attributedText = text;
    }
    return _time;
}

- (UIView *)checkedGroup {
    if (!_checkedGroup) {
        _checkedGroup = [[UIView alloc] init];
        _checkedGroup.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _checkedGroup.alpha = 1;
        [_checkedGroup addSubview:self.circleImage];
        [_checkedGroup addSubview:self.checkedImage];
    }
    return _checkedGroup;
}

- (UIImageView *)circleImage {
    if (!_circleImage) {
        _circleImage = [[UIImageView alloc] init];
        _circleImage.alpha = 1;
        _circleImage.image = [UIImage imageNamed:@"check_circle"];
    }
    return _circleImage;
}

- (UIImageView *)checkedImage {
    if (!_checkedImage) {
        _checkedImage = [[UIImageView alloc] init];
        _checkedImage.alpha = 1;
        _checkedImage.image = [UIImage imageNamed:@"checked_circle"];
    }
    return _checkedImage;
}

@end
