// LXHTextCell.m
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHTextCell.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHTextCell()
@end

@implementation LXHTextCell

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
}

- (void)makeConstraints {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.left.equalTo(self.mas_left).offset(8);
        make.centerY.equalTo(self.mas_centerY);
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"发起时间：2019-05-16  12：34", nil) attributes:textAttributes];
        _text.attributedText = text;
    }
    return _text;
}

@end
