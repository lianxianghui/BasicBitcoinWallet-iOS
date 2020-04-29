// LXHAddressViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-08-22
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHAddressViewController.h"
#import "Masonry.h"
#import "BTCQRCode.h"
#import "UILabel+LXHText.h"
#import "UIViewController+LXHAlert.h"
#import "Toast.h"
#import "LXHAddressViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHAddressViewController()
@property (nonatomic) NSDictionary *data;
@property (nonatomic) LXHAddressViewModel *viewModel;
@end

@implementation LXHAddressViewController

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
    self.contentView = [[LXHAddressView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    [self setContentViewProperties];
    [self addActions];

}

- (void)setContentViewProperties {
    self.contentView.leftImageButton.hidden = [_viewModel leftButtonHidden];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshContentView];
}

- (void)refreshContentView {
    [_viewModel refreshData];
    NSString *address = [_viewModel addressText];
    //地址文本
    [self.contentView.addressText updateAttributedTextString:address];
    //地址二维码
    CGSize imageSize = {198, 198};
    //这里的字符串转成二进制后，如果大于 2,953 bytes, image会为nil。不过这里不会发生。
    UIImage *qrImage = [BTCQRCode imageForString:address size:imageSize scale:1];
    self.contentView.qrImage.image = qrImage;
    //地址路径
    NSString *path = [_viewModel path];
    [self.contentView.addressPath updateAttributedTextString:path];
}

- (void)addActions {
    [self.contentView.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.shareButton addTarget:self action:@selector(shareButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.shareButton addTarget:self action:@selector(shareButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.copyButton addTarget:self action:@selector(copyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.copyButton addTarget:self action:@selector(copyButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.copyButton addTarget:self action:@selector(copyButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

//Actions
- (void)shareButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    NSString *addressText = [_viewModel addressText];
    if (addressText) {
        __weak typeof(self) weakSelf = self;
        NSString *message = NSLocalizedString(@"分享地址到其它应用程序有可能导致泄漏隐私，您确定要分享吗？", nil);
        [self showOkCancelAlertViewWithMessage:message okHandler:^(UIAlertAction * _Nonnull action) {
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[addressText] applicationActivities:nil];
            [weakSelf presentViewController:controller animated:YES completion:nil];
        } cancelHandler:nil];
    }
}

- (void)shareButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)shareButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)copyButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    __weak typeof(self) weakSelf = self;
    NSString *message = NSLocalizedString(@"拷贝到系统剪贴板使得该地址有可能会被其它应用程序读取从而导致泄漏隐私，您确定要拷贝吗？", nil);
    [self showOkCancelAlertViewWithMessage:message okHandler:^(UIAlertAction * _Nonnull action) {
        [UIPasteboard generalPasteboard].string = [weakSelf.viewModel addressText];
        [weakSelf.view makeToast:NSLocalizedString(@"地址已拷贝", nil)];
    } cancelHandler:nil];
}

- (void)copyButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)copyButtonTouchUpOutside:(UIButton *)sender {
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
