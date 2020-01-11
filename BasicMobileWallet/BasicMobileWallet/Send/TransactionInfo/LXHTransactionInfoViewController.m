// LXHTransactionInfoViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-11-19
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHTransactionInfoViewController.h"
#import "Masonry.h"
#import "LXHTransactionInfoView.h"
#import "LXHSignedTransactionTextViewController.h"
#import "LXHUnsignedTransactionTextViewController.h"
#import "LXHBuildTransactionViewController.h"
#import "LXHTransactionInfoViewModel.h"
#import "UILabel+LXHText.h"
#import "LXHTransactionDataManager.h"
#import "Toast.h"
#import "UIViewController+LXHBasicMobileWallet.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHTransactionInfoViewController()
@property (nonatomic) LXHTransactionInfoView *contentView;
@property (nonatomic) LXHTransactionInfoViewModel *viewModel;
@end

@implementation LXHTransactionInfoViewController

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
    self.contentView = [[LXHTransactionInfoView alloc] init];
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

- (void)addActions {
    [self.contentView.textButton3 addTarget:self action:@selector(textButton3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.textButton2 addTarget:self action:@selector(textButton2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.textButton1 addTarget:self action:@selector(textButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

- (void)setViewProperties {
    self.contentView.textButton2.enabled = [_viewModel signButtonsEnabled];
    self.contentView.textButton3.enabled = [_viewModel signButtonsEnabled];
    [self.contentView.desc updateAttributedTextString:[_viewModel infoDescription]];
}

//Actions
- (void)textButton3Clicked:(UIButton *)sender {//签名并发送
    LXHWeakSelf
    [self validatePINWithPassedHandler:^{
        [weakSelf.contentView.indicatorView startAnimating];
        [weakSelf.viewModel pushSignedTransactionWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
            [weakSelf.contentView.indicatorView stopAnimating];
            NSString *prompt = NSLocalizedString(@"发送成功.", nil);
            [weakSelf.view makeToast:prompt];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        } failureBlock:^(NSDictionary * _Nonnull resultDic) {
            [weakSelf.contentView.indicatorView stopAnimating];
            NSError *error = resultDic[@"error"];
            NSString *format = NSLocalizedString(@"由于%@发送失败", nil);
            NSString *errorPrompt = [NSString stringWithFormat:format, error.localizedDescription];
            [weakSelf.view makeToast:errorPrompt];
        }];
    }];
}


- (void)textButton2Clicked:(UIButton *)sender {//显示签名过的交易文本
    LXHWeakSelf
    [self validatePINWithPassedHandler:^{
        id viewModel = weakSelf.viewModel.signedTransactionTextViewModel;
        UIViewController *controller = [[LXHSignedTransactionTextViewController alloc] initWithViewModel:viewModel];
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
}


- (void)textButton1Clicked:(UIButton *)sender {//显示未签名的交易文本
    id viewModel = _viewModel.unsignedTransactionTextViewModel;
    UIViewController *controller = [[LXHUnsignedTransactionTextViewController alloc] initWithViewModel:viewModel];
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
