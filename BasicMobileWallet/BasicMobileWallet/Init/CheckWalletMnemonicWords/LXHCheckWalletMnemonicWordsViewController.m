// LXHWalletMnemonicWordsViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHCheckWalletMnemonicWordsViewController.h"
#import "Masonry.h"
#import "LXHCheckWalletMnemonicWordsView.h"
#import "LXHWalletMnemonicPassphraseViewController.h"
#import "UILabel+LXHText.h"
#import "LXHCheckWalletMnemonicWordsViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHCheckWalletMnemonicWordsViewController()

@property (nonatomic) LXHCheckWalletMnemonicWordsView *contentView;
@property (nonatomic) LXHCheckWalletMnemonicWordsViewModel *viewModel;//有可能是LXHWalletMnemonicWordsViewModel的子类
@end

@implementation LXHCheckWalletMnemonicWordsViewController

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
    self.contentView = [[LXHCheckWalletMnemonicWordsView alloc] init];
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
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setContentViewProperties {
    [self.contentView.text updateAttributedTextString:[_viewModel mnemonicWordsText]];
}

//Actions
- (void)button1Clicked:(UIButton *)sender {
    NSDictionary *navigationInfo = [_viewModel clickNextButtonNavigationInfo];
    NSString *controllerClassName = navigationInfo[@"controllerClassName"];
    id viewModel = navigationInfo[@"viewModel"];
    UIViewController *controller = [[NSClassFromString(controllerClassName) alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)button1TouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)button1TouchUpOutside:(UIButton *)sender {
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
