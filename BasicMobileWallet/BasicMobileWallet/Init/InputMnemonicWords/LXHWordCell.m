// LXHWordCell.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHWordCell.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHWordCell()
@end

@implementation LXHWordCell

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
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
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
        NSMutableAttributedString *attributedText = [NSMutableAttributedString new];
        UIFont *font = nil;
        NSMutableParagraphStyle *paragraphStyle = nil;
        NSMutableDictionary *textAttributes = nil;
        NSAttributedString *text = nil;

        font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        if (!font) font = [UIFont systemFontOfSize:12];
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;
        textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2894118) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"very", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        font = [UIFont fontWithName:@"SFProText-Regular" size:12];
        if (!font) font = [UIFont systemFontOfSize:12];
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;
        textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.2894118) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@" ", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        _text.attributedText = attributedText;
    }
    return _text;
}

@end
