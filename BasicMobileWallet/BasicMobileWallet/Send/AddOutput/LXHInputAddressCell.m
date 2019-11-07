// LXHInputAddressCell.m
// BasicWallet
//
//  Created by lianxianghui on 19-11-7
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
    [self addSubview:self.addressGroup];
}

- (void)makeConstraints {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(0.5);
    }];
    [self.addressGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(3);
        make.top.equalTo(self.mas_top).offset(8);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.warningText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressGroup.mas_centerY);
        make.right.equalTo(self.addressGroup.mas_right).offset(-4);
    }];
    [self.addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.text.mas_right);
        make.centerY.equalTo(self.addressGroup.mas_centerY);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UIView *)addressGroup {
    if (!_addressGroup) {
        _addressGroup = [[UIView alloc] init];
        _addressGroup.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _addressGroup.alpha = 1;
        [_addressGroup addSubview:self.warningText];
        [_addressGroup addSubview:self.addressText];
        [_addressGroup addSubview:self.text];
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
        [textAttributes setObject:@(-0.2894118) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"地址: ", nil) attributes:textAttributes];
        _text.attributedText = text;
    }
    return _text;
}

@end
