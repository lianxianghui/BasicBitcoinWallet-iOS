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
#import "LXHInputFeeViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHInputFeeViewController()
@property (nonatomic) LXHInputFeeView *contentView;
@property (nonatomic) LXHInputFeeViewModel *viewModel;
@property (nonatomic, copy) dataChangedCallback dataChangedCallback;
@end

@implementation LXHInputFeeViewController

- (instancetype)initWithViewModel:(id)viewModel
              dataChangedCallback:(dataChangedCallback)dataChangedCallback {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
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
    [self setContentViewProperties];
    [self addActions];
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setContentViewProperties {
    self.contentView.textFieldWithPlaceHolder.keyboardType = UIKeyboardTypeNumberPad;
    NSString *feeRateString = [_viewModel inputFeeRateString];
    if (feeRateString)
        [self.contentView.textFieldWithPlaceHolder updateAttributedTextString:feeRateString];
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
    NSString *errorDesc;
    if ([_viewModel setInputFeeRateString:text errorDesc:&errorDesc]) {
        self.dataChangedCallback();
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showOkAlertViewWithMessage:errorDesc handler:nil];
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
