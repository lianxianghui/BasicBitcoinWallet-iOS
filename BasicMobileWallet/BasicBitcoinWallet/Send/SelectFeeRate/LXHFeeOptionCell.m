// LXHFeeOptionCell.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHFeeOptionCell.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHFeeOptionCell()
@end

@implementation LXHFeeOptionCell

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
    [self addSubview:self.feeRate];
    [self addSubview:self.title];
    [self addSubview:self.checkedGroup];
}

- (void)makeConstraints {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [self.feeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.checkedGroup.mas_right).offset(21);
    }];
    [self.checkedGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(29);
        make.left.equalTo(self.mas_left).offset(8);
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

- (UILabel *)feeRate {
    if (!_feeRate) {
        _feeRate = [[UILabel alloc] init];
        _feeRate.numberOfLines = 0;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        if (!font) font = [UIFont systemFontOfSize:13];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.3135294) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"40 sat/byte", nil) attributes:textAttributes];
        _feeRate.attributedText = text;
    }
    return _feeRate;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.numberOfLines = 0;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        if (!font) font = [UIFont systemFontOfSize:13];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2911344) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"FastestFee", nil) attributes:textAttributes];
        _title.attributedText = text;
    }
    return _title;
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
