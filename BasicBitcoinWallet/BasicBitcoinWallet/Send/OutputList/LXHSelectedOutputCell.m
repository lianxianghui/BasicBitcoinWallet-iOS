// LXHSelectedOutputCell.m
// BasicWallet
//
//  Created by lianxianghui on 19-11-25
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHSelectedOutputCell.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHSelectedOutputCell()
@end

@implementation LXHSelectedOutputCell

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
    [self addSubview:self.group];
    [self addSubview:self.button];
}

- (void)makeConstraints {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [self.group mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.mas_equalTo(40);
    }];
    [self.btcValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.group.mas_right);
        make.top.equalTo(self.group.mas_top);
    }];
    [self.addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.address.mas_centerY);
        make.left.equalTo(self.address.mas_right).offset(2);
    }];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.group.mas_left);
        make.top.equalTo(self.group.mas_top);
    }];
    [self.addressWarningDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.group.mas_left);
        make.bottom.equalTo(self.group.mas_bottom);
    }];
    [self.addressDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.group.mas_left);
        make.bottom.equalTo(self.group.mas_bottom);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-4);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(36);
        make.right.equalTo(self.mas_right).offset(-2);
    }];
    [self.deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.button.mas_centerX);
        make.centerY.equalTo(self.button.mas_centerY);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(13.5);
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

- (UIView *)group {
    if (!_group) {
        _group = [[UIView alloc] init];
        _group.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _group.alpha = 1;
        [_group addSubview:self.btcValue];
        [_group addSubview:self.addressText];
        [_group addSubview:self.address];
        [_group addSubview:self.addressWarningDesc];
        [_group addSubview:self.addressDesc];
    }
    return _group;
}

- (UILabel *)btcValue {
    if (!_btcValue) {
        _btcValue = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        if (!font) font = [UIFont systemFontOfSize:10];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2411765) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"0.00000004 BTC", nil) attributes:textAttributes];
        _btcValue.attributedText = text;
    }
    return _btcValue;
}

- (UILabel *)addressText {
    if (!_addressText) {
        _addressText = [[UILabel alloc] init];
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

- (UILabel *)address {
    if (!_address) {
        _address = [[UILabel alloc] init];
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"地址:", nil) attributes:textAttributes];
        _address.attributedText = text;
    }
    return _address;
}

- (UILabel *)addressWarningDesc {
    if (!_addressWarningDesc) {
        _addressWarningDesc = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (!font) font = [UIFont systemFontOfSize:11];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFE3824FF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2652941) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"用过的本地接收地址", nil) attributes:textAttributes];
        _addressWarningDesc.attributedText = text;
    }
    return _addressWarningDesc;
}

- (UILabel *)addressDesc {
    if (!_addressDesc) {
        _addressDesc = [[UILabel alloc] init];
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"外部地址", nil) attributes:textAttributes];
        _addressDesc.attributedText = text;
    }
    return _addressDesc;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _button.layer.cornerRadius = 2;
        _button.alpha = 1;
        [_button addSubview:self.deleteImage];
    }
    return _button;
}

- (UIImageView *)deleteImage {
    if (!_deleteImage) {
        _deleteImage = [[UIImageView alloc] init];
        _deleteImage.alpha = 1;
        _deleteImage.image = [UIImage imageNamed:@"send_outputlist_delete_image"];
    }
    return _deleteImage;
}

@end
