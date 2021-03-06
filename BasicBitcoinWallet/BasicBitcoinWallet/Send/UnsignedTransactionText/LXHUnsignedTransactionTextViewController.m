// LXHUnsignedTransactionTextViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-26
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHUnsignedTransactionTextViewController.h"
#import "Masonry.h"
#import "LXHUnsignedTransactionTextView.h"
#import "LXHSignedTransactionTextViewController.h"
#import "LXHQRCodeAndTextViewController.h"
#import "LXHUnsignedTransactionTextViewModel.h"
#import "UITextView+LXHText.h"
#import "Toast.h"
#import "UIViewController+LXHBasicBitcoinWallet.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHUnsignedTransactionTextViewController()
@property (nonatomic) LXHUnsignedTransactionTextView *contentView;
@property (nonatomic) LXHUnsignedTransactionTextViewModel *viewModel;
@end

@implementation LXHUnsignedTransactionTextViewController

- (instancetype)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHUnsignedTransactionTextView alloc] init];
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

- (void)addActions {
    [self.contentView.textButton2 addTarget:self action:@selector(textButton2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.textButton1 addTarget:self action:@selector(textButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

- (void)setContentViewProperties {
    self.contentView.text.editable = NO;
    [self.contentView.text updateAttributedTextString:[_viewModel text]];
    self.contentView.textButton2.enabled = [_viewModel signTransactionButtonEnabled];
    self.contentView.textButton2.alpha = [_viewModel signTransactionButtonEnabled] ? 1 : 0.5;
}

//Actions
- (void)textButton2Clicked:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self validatePINWithPassedHandler:^{
        id viewModel = [weakSelf.viewModel signedTransactionTextViewModel];
        if (!viewModel) {
            [weakSelf.view makeToast:NSLocalizedString(@"无法签名", nil)];
            return;
        }
        UIViewController *controller = [[LXHSignedTransactionTextViewController alloc] initWithViewModel:viewModel];
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
}


- (void)textButton1Clicked:(UIButton *)sender {
    id viewModel = [_viewModel qrCodeAndTextViewModel];
    if (!viewModel) {
        [self.view makeToast:NSLocalizedString(@"文本无法显示", nil)];
        return;
    }
    UIViewController *controller = [[LXHQRCodeAndTextViewController alloc] initWithViewModel:viewModel];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
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
