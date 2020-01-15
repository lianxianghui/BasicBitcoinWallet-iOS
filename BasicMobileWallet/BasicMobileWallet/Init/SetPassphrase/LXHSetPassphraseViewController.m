// LXHSetPassphraseViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSetPassphraseViewController.h"
#import "Masonry.h"
#import "LXHSetPassphraseView.h"
#import "LXHTabBarPageViewController.h"
#import "UILabel+LXHText.h"
#import "UIViewController+LXHAlert.h"
#import "LXHGenerateWalletViewController.h"
#import "LXHSetPassphraseViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSetPassphraseViewController()<UITextFieldDelegate>
@property (nonatomic) LXHSetPassphraseView *contentView;
@property (nonatomic) LXHSetPassphraseViewModel *viewModel;
@end

@implementation LXHSetPassphraseViewController

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
    self.contentView = [[LXHSetPassphraseView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self addActions];
    [self setViewProperties];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.textButton addTarget:self action:@selector(textButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setViewProperties {
    [self.contentView.title updateAttributedTextString:[_viewModel navigationBarTitle]];
    [self.contentView.promot updateAttributedTextString:[_viewModel prompt]];
    self.contentView.inputTextFieldWithPlaceHolder.secureTextEntry = YES;
    self.contentView.inputAgainTextFieldWithPlaceHolder.secureTextEntry = YES;
}

- (void)setDelegates {
    self.contentView.inputTextFieldWithPlaceHolder.delegate = self;
    self.contentView.inputAgainTextFieldWithPlaceHolder.delegate = self;
}

//Actions
- (void)textButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    NSInteger code = [_viewModel checkInputText:self.contentView.inputTextFieldWithPlaceHolder.text inputAgainText:self.contentView.inputAgainTextFieldWithPlaceHolder.text];
//     1 没问题
//    -1 两个输入至少有一个为空
//    -2 两个输入不一致
//    -3 两个输入一致，但输入包含空白字符
    switch (code) {
        case 1:
            [self pushGenerateWalletViewControllerWithPassphrase:self.contentView.inputTextFieldWithPlaceHolder.text];
            break;
        case -1:
            [self showOkAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"请输入密码", nil) handler:nil];
            break;
        case -2:
            [self showOkAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"请确保两次输入的密码一致", nil) handler:nil];
            break;
        case -3:
        {
            LXHWeakSelf
            [self showOkCancelAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"密码含有空白字符，这是您的本意吗，您确定要使用包含空白字符的密码吗？", nil) okHandler:^(UIAlertAction * _Nonnull action) {
                [weakSelf pushGenerateWalletViewControllerWithPassphrase:self.contentView.inputTextFieldWithPlaceHolder.text];
            } cancelHandler:nil];
            break;
        }
        default:
            break;
    }
}

- (void)pushGenerateWalletViewControllerWithPassphrase:(NSString *)passphrase {
    id viewModel = [_viewModel generateWalletViewModelWithPassphrase:passphrase];
    UIViewController *controller = [[LXHGenerateWalletViewController alloc] initWithViewModel:viewModel];
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
