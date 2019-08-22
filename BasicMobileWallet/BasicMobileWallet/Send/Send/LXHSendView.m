// LXHSendView.m
// BasicWallet
//
//  Created by lianxianghui on 19-08-22
//  Copyright © 2019年 lianxianghui. All rights reserved.


#import "LXHSendView.h"
#import "Masonry.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHSendView()
@end

@implementation LXHSendView

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
    [self addSubview:self.listView];
    [self addSubview:self.customNavigationBar];
}

- (void)makeConstraints {
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.customNavigationBar.mas_bottom);
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
}

//Getters
- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listView.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
        _listView.alpha = 1;
        _listView.tableFooterView = [UIView new];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _listView;
}

- (UIView *)customNavigationBar {
    if (!_customNavigationBar) {
        _customNavigationBar = [[UIView alloc] init];
        _customNavigationBar.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
        _customNavigationBar.alpha = 1;
        [_customNavigationBar addSubview:self.bottomLine];
        [_customNavigationBar addSubview:self.title];
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
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"发送", nil) attributes:textAttributes];
        _title.attributedText = text;
    }
    return _title;
}

@end
