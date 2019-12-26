// LXHQRCodeAndTextViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-17
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHQRCodeAndTextViewController.h"
#import "Masonry.h"
#import "LXHQRCodeAndTextView.h"
#import "LXHQRCodeAndTextViewModel.h"
#import "UILabel+LXHText.h"
#import "UIViewController+LXHAlert.h"
#import "Toast.h"
#import "LXHGlobalHeader.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHQRCodeAndTextViewController()
@property (nonatomic) LXHQRCodeAndTextView *contentView;
@property (nonatomic) LXHQRCodeAndTextViewModel *viewModel;
@end

@implementation LXHQRCodeAndTextViewController

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
    self.contentView = [[LXHQRCodeAndTextView alloc] init];
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
    [self.contentView.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.copyButton addTarget:self action:@selector(copyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

- (void)setViewProperties {
    [self.contentView.title updateAttributedTextString:[_viewModel title]];
    UIImage *image = [_viewModel image];
    if (!image)
        [self.view makeToast:NSLocalizedString(@"文本长度已超过最大限制，无法生成二维码", nil)];
    else
        self.contentView.qrImage.image = image;
    if ([_viewModel showText]) {
        self.contentView.text.hidden = NO;
        [self.contentView.text updateAttributedTextString:[_viewModel text]];
    } else {
        self.contentView.text.hidden = YES;
    }
    self.contentView.copyButton.hidden = ![_viewModel showCopyButton];
    self.contentView.shareButton.hidden = ![_viewModel showShareButton];
}

//Actions
- (void)shareButtonClicked:(UIButton *)sender {
    if ([_viewModel showShareButton]) {
        NSString *text = [_viewModel text];
        if (text) {
            LXHWeakSelf
            NSString *message = NSLocalizedString(@"分享文本到其它应用程序有可能导致泄漏隐私，您确定要分享吗？", nil);
            [self showOkCancelAlertViewWithMessage:message okHandler:^(UIAlertAction * _Nonnull action) {
                UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text] applicationActivities:nil];
                [weakSelf presentViewController:controller animated:YES completion:nil];
            } cancelHandler:nil];
        }
    }
}

- (void)copyButtonClicked:(UIButton *)sender {
    if ([_viewModel showCopyButton]) {
        NSString *text = [_viewModel text];
        if (text) {
            LXHWeakSelf
            NSString *message = NSLocalizedString(@"拷贝文本到系统剪贴板使得该文本有可能会被其它应用程序读取从而导致泄漏隐私，您确定要拷贝吗？", nil);
            [self showOkCancelAlertViewWithMessage:message okHandler:^(UIAlertAction * _Nonnull action) {
                [UIPasteboard generalPasteboard].string = text;
                [weakSelf.view makeToast:NSLocalizedString(@"文本已拷贝", nil)];
            } cancelHandler:nil];
        }
    }
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
