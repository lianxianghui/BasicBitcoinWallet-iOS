// LXHLocalAddressCell.m
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHLocalAddressCell.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHLocalAddressCell()
@end

@implementation LXHLocalAddressCell

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
    [self addSubview:self.receiveAddress];
    [self addSubview:self.disclosureIndicator];
}

- (void)makeConstraints {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
    }];
    [self.receiveAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(8);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.mas_right).offset(-30);
    }];
    [self.addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiveAddress.mas_top).offset(6);
        make.left.equalTo(self.receiveAddress.mas_left);
    }];
    [self.used mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.type.mas_centerY);
        make.left.equalTo(self.type.mas_right).offset(5);
    }];
    [self.localPath mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressText.mas_centerY);
        make.right.equalTo(self.receiveAddress.mas_right);
    }];
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.receiveAddress.mas_bottom).offset(-8);
        make.left.equalTo(self.addressText.mas_left);
    }];
    [self.disclosureIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13);
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

- (UIView *)receiveAddress {
    if (!_receiveAddress) {
        _receiveAddress = [[UIView alloc] init];
        _receiveAddress.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _receiveAddress.alpha = 1;
        [_receiveAddress addSubview:self.addressText];
        [_receiveAddress addSubview:self.used];
        [_receiveAddress addSubview:self.localPath];
        [_receiveAddress addSubview:self.type];
    }
    return _receiveAddress;
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE", nil) attributes:textAttributes];
        _addressText.attributedText = text;
    }
    return _addressText;
}

- (UILabel *)used {
    if (!_used) {
        _used = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (!font) font = [UIFont systemFontOfSize:11];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x4A90E2FF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2652941) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"未用过的 ", nil) attributes:textAttributes];
        _used.attributedText = text;
    }
    return _used;
}

- (UILabel *)localPath {
    if (!_localPath) {
        _localPath = [[UILabel alloc] init];
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"m/44’/1’/0/1/1 ", nil) attributes:textAttributes];
        _localPath.attributedText = text;
    }
    return _localPath;
}

- (UILabel *)type {
    if (!_type) {
        _type = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        if (!font) font = [UIFont systemFontOfSize:10];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2411765) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"P2PKH ", nil) attributes:textAttributes];
        _type.attributedText = text;
    }
    return _type;
}

- (UIImageView *)disclosureIndicator {
    if (!_disclosureIndicator) {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.alpha = 1;
        _disclosureIndicator.image = [UIImage imageNamed:@"mine_addresslist_disclosure_indicator"];
    }
    return _disclosureIndicator;
}

@end
