// LXHSignedTransactionTextViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-26
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSignedTransactionTextViewController.h"
#import "Masonry.h"
#import "LXHSignedTransactionTextView.h"
#import "LXHQRCodeAndTextViewController.h"
#import "LXHSignedTransactionTextViewModel.h"
#import "Toast.h"
#import "UITextView+LXHText.h"
#import "UIViewController+LXHAlert.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSignedTransactionTextViewController()
@property (nonatomic) LXHSignedTransactionTextView *contentView;
@property (nonatomic) LXHSignedTransactionTextViewModel *viewModel;
@end

@implementation LXHSignedTransactionTextViewController

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
    self.contentView = [[LXHSignedTransactionTextView alloc] init];
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
}

//Actions
- (void)textButton2Clicked:(UIButton *)sender {
    [self.contentView.indicatorView startAnimating];
    __weak typeof(self) weakSelf = self;
    [_viewModel pushSignedTransactionWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        [self.contentView.indicatorView stopAnimating];
        NSInteger code = [resultDic[@"code"] integerValue];
        if (code == 0) {
            NSString *prompt = NSLocalizedString(@"发送成功.", nil);
            [weakSelf.view makeToast:prompt];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        } else if (code == 1) { //发送交易成功，但更新交易数据失败
            [self showOkAlertViewWithMessage:NSLocalizedString(@"发送成功，请稍后刷新余额或交易列表以更新到最新数据", nil) handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        [self.contentView.indicatorView stopAnimating];
        NSError *error = resultDic[@"error"];
        NSString *format = NSLocalizedString(@"由于%@发送失败", nil);
        NSString *errorPrompt = [NSString stringWithFormat:format, error.localizedDescription];
        [weakSelf.view makeToast:errorPrompt];
    }];
}


- (void)textButton1Clicked:(UIButton *)sender {
    id viewModel = [_viewModel qrCodeAndTextViewModel];
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
