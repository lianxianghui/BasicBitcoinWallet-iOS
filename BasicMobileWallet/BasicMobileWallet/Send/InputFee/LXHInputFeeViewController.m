// LXHInputFeeViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHInputFeeViewController.h"
#import "Masonry.h"
#import "LXHInputFeeView.h"
#import "UIViewController+LXHAlert.h"
#import "UITextField+LXHText.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHInputFeeViewController()
@property (nonatomic) LXHInputFeeView *contentView;
@property (nonatomic) NSMutableDictionary *data;
@property (nonatomic, copy) dataChangedCallback dataChangedCallback;
@end

@implementation LXHInputFeeViewController

- (instancetype)initWithData:(NSMutableDictionary *)data
         dataChangedCallback:(dataChangedCallback)dataChangedCallback {
    self = [super init];
    if (self) {
        _data = data;
        _dataChangedCallback = dataChangedCallback;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHInputFeeView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self setViewProperties];
    [self addActions];
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setViewProperties {
    self.contentView.textFieldWithPlaceHolder.keyboardType = UIKeyboardTypeNumberPad;
    if (self.data[@"inputFeeRate"]) {
        NSString *feeRateString = [NSString stringWithFormat:@"%@", self.data[@"inputFeeRate"]];
        [self.contentView.textFieldWithPlaceHolder updateAttributedTextString:feeRateString];
    }
}

- (void)addActions {
    [self.contentView.rightTextButton addTarget:self action:@selector(rightTextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.rightTextButton addTarget:self action:@selector(rightTextButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.rightTextButton addTarget:self action:@selector(rightTextButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
- (void)rightTextButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    
    NSString *text = self.contentView.textFieldWithPlaceHolder.text;
    BOOL inputFeeRateIsValid = [self isIntegerWithString:text];
    if (inputFeeRateIsValid) {
        NSNumber *feeRate = @(text.integerValue);
        self.data[@"inputFeeRate"] = feeRate;
        self.dataChangedCallback();
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showOkAlertViewWithMessage:NSLocalizedString(@"请输入有效形式的费率(非负整数)", nil) handler:nil];
    }
}

- (BOOL)isIntegerWithString:(NSString*)string {
    NSScanner* scanner = [NSScanner scannerWithString:string];
    return [scanner scanInt:nil] && [scanner isAtEnd];
}

- (void)rightTextButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)rightTextButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)leftImageButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftImageButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)leftImageButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

@end
