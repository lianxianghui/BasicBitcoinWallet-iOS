// LXHInputPINToEnterAppView.m
// BasicWallet
//
//  Created by lianxianghui on 20-01-11
//  Copyright © 2020年 lianxianghui. All rights reserved.


#import "LXHInputPINToEnterAppView.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHInputPINToEnterAppView()
@end

@implementation LXHInputPINToEnterAppView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0xEFEFF4FF);
        self.alpha = 1;
        [self addSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.inputPinTextField];
    [self addSubview:self.promot];
}

- (void)makeConstraints {
    [self.inputPinTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.centerX.equalTo(self.promot.mas_centerX);
        make.width.mas_equalTo(300);
        make.top.equalTo(self.promot.mas_bottom).offset(30);
    }];
    [self.promot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(80);
    }];
}

//Getters
- (UITextField *)inputPinTextField {
    if (!_inputPinTextField) {
        _inputPinTextField = [[UITextField alloc] init];
        _inputPinTextField.backgroundColor = UIColorFromRGBA(0xF8F8F8FF);
        _inputPinTextField.layer.cornerRadius = 5;
        _inputPinTextField.layer.borderWidth = 1;
        _inputPinTextField.layer.borderColor = UIColorFromRGBA(0xD8D8D8FF).CGColor;
        _inputPinTextField.alpha = 1;
    }
    return _inputPinTextField;
}

- (UILabel *)promot {
    if (!_promot) {
        _promot = [[UILabel alloc] init];
        NSMutableAttributedString *attributedText = [NSMutableAttributedString new];
        UIFont *font = nil;
        NSMutableParagraphStyle *paragraphStyle = nil;
        NSMutableDictionary *textAttributes = nil;
        NSAttributedString *text = nil;

        font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        if (!font) font = [UIFont systemFontOfSize:18];
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;
        textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.8014479) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入六位数字PIN码", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        if (!font) font = [UIFont systemFontOfSize:18];
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;
        textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x5281DFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.8014479) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@" ", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        _promot.attributedText = attributedText;
    }
    return _promot;
}

@end
