// LXHInitWalletView.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHInitWalletView.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHInitWalletView()
@end

@implementation LXHInitWalletView

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
    [self addSubview:self.bottomButtons];
    [self addSubview:self.desc2];
    [self addSubview:self.desc1];
    [self addSubview:self.customNavigationBar];
}

- (void)makeConstraints {
    [self.bottomButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(162);
        make.right.equalTo(self.mas_right);
    }];
    [self.restoreWalletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(46);
        make.left.equalTo(self.bottomButtons.mas_left).offset(19);
        make.right.equalTo(self.bottomButtons.mas_right).offset(-19);
        make.bottom.equalTo(self.bottomButtons.mas_bottom).offset(-16);
    }];
    [self.createWalletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.restoreWalletButton.mas_top).offset(-11);
        make.left.equalTo(self.restoreWalletButton.mas_left);
        make.right.equalTo(self.restoreWalletButton.mas_right);
        make.height.mas_equalTo(46);
    }];
    [self.desc2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desc1.mas_bottom).offset(8);
        make.left.equalTo(self.desc1.mas_left);
        make.right.equalTo(self.desc1.mas_right);
    }];
    [self.desc1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(19);
        make.right.equalTo(self.mas_right).offset(-19);
        make.top.equalTo(self.customNavigationBar.mas_bottom).offset(19);
    }];
    [self.customNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(45);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customNavigationBar.mas_left);
        make.right.equalTo(self.customNavigationBar.mas_right);
        make.bottom.equalTo(self.customNavigationBar.mas_bottom);
        make.height.mas_equalTo(0.5099999904632568);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.customNavigationBar.mas_centerX);
        make.centerY.equalTo(self.customNavigationBar.mas_centerY);
    }];
    [self.leftImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customNavigationBar.mas_left);
        make.top.equalTo(self.customNavigationBar.mas_top);
        make.bottom.equalTo(self.customNavigationBar.mas_bottom);
        make.width.mas_equalTo(72);
    }];
    [self.leftText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftImageButton.mas_centerY);
        make.left.equalTo(self.leftBarItemImage.mas_right).offset(6);
    }];
    [self.leftBarItemImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageButton.mas_left).offset(5);
        make.centerY.equalTo(self.leftImageButton.mas_centerY);
        make.width.mas_equalTo(12.5);
        make.height.mas_equalTo(25);
    }];
}

//Getters
- (UIView *)bottomButtons {
    if (!_bottomButtons) {
        _bottomButtons = [[UIView alloc] init];
        _bottomButtons.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _bottomButtons.alpha = 1;
        [_bottomButtons addSubview:self.restoreWalletButton];
        [_bottomButtons addSubview:self.createWalletButton];
    }
    return _bottomButtons;
}

- (UIButton *)restoreWalletButton {
    if (!_restoreWalletButton) {
        _restoreWalletButton = [UIButton buttonWithType:UIButtonTypeSystem];//Has System Highlighted color
        _restoreWalletButton.backgroundColor = UIColorFromRGBA(0x009688FF);
        _restoreWalletButton.alpha = 1;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        if (!font) font = [UIFont systemFontOfSize:18];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.449999988079071) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"恢复钱包", nil) attributes:textAttributes];
        [_restoreWalletButton setAttributedTitle:text forState:UIControlStateNormal];
        _restoreWalletButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _restoreWalletButton;
}

- (UIButton *)createWalletButton {
    if (!_createWalletButton) {
        _createWalletButton = [UIButton buttonWithType:UIButtonTypeSystem];//Has System Highlighted color
        _createWalletButton.backgroundColor = UIColorFromRGBA(0x009688FF);
        _createWalletButton.alpha = 1;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        if (!font) font = [UIFont systemFontOfSize:18];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0xFFFFFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.449999988079071) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"创建钱包", nil) attributes:textAttributes];
        [_createWalletButton setAttributedTitle:text forState:UIControlStateNormal];
        _createWalletButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _createWalletButton;
}

- (UILabel *)desc2 {
    if (!_desc2) {
        _desc2 = [[UILabel alloc] init];
        _desc2.numberOfLines = 0;
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
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"恢复钱包：\n", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        if (!font) font = [UIFont systemFontOfSize:14];
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
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"如果您之前拥有一个符合BIP-44标准的HD钱包，可以用您之前记录的助记词序列和助记词密码来恢复该钱包。\n\n", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        _desc2.attributedText = attributedText;
    }
    return _desc2;
}

- (UILabel *)desc1 {
    if (!_desc1) {
        _desc1 = [[UILabel alloc] init];
        _desc1.numberOfLines = 0;
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
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"创建钱包：\n", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        if (!font) font = [UIFont systemFontOfSize:14];
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
        text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"会按着BIP-44的标准为您生成一个新的HD钱包（分层确定性钱包），在生成的过程中会显示12个英文单词的助记词序列，您也可以选择性地设置一个助记词密码。有了助记词序列和助记词密码，你可以在未来重新生成私钥。由于拥有私钥就等于拥有了您的比特币，所以请务必记住助记码和密码并保存好。\n\n", nil) attributes:textAttributes];
        [attributedText appendAttributedString:text];

        _desc1.attributedText = attributedText;
    }
    return _desc1;
}

- (UIView *)customNavigationBar {
    if (!_customNavigationBar) {
        _customNavigationBar = [[UIView alloc] init];
        _customNavigationBar.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
        _customNavigationBar.alpha = 1;
        [_customNavigationBar addSubview:self.bottomLine];
        [_customNavigationBar addSubview:self.title];
        [_customNavigationBar addSubview:self.leftImageButton];
    }
    return _customNavigationBar;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGBA(0xB2B2B2FF);
        _bottomLine.alpha = 1;
    }
    return _bottomLine;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
        if (!font) font = [UIFont systemFontOfSize:17];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x030303FF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.4099999964237213) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"初始化钱包", nil) attributes:textAttributes];
        _title.attributedText = text;
    }
    return _title;
}

- (UIButton *)leftImageButton {
    if (!_leftImageButton) {
        _leftImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftImageButton.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _leftImageButton.alpha = 1;
        [_leftImageButton addSubview:self.leftText];
        [_leftImageButton addSubview:self.leftBarItemImage];
    }
    return _leftImageButton;
}

- (UILabel *)leftText {
    if (!_leftText) {
        _leftText = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
        if (!font) font = [UIFont systemFontOfSize:17];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentNatural;
        paragraphStyle.maximumLineHeight = 0;
        paragraphStyle.minimumLineHeight = 0;
        paragraphStyle.paragraphSpacing = 0;

        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:UIColorFromRGBA(0x007AFFFF) forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:font forKey:NSFontAttributeName];
        [textAttributes setObject:@(-0.4099999964237213) forKey:NSKernAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"返回", nil) attributes:textAttributes];
        _leftText.attributedText = text;
    }
    return _leftText;
}

- (UIImageView *)leftBarItemImage {
    if (!_leftBarItemImage) {
        _leftBarItemImage = [[UIImageView alloc] init];
        _leftBarItemImage.alpha = 1;
        _leftBarItemImage.image = [UIImage imageNamed:@"back"];
    }
    return _leftBarItemImage;
}

@end
