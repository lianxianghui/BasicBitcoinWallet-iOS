// LXHWalletMnemonicPassphraseForRestoringViewController.m
// BasicWallet
//
//  Created by lianxianghui on 20-04-24
//  Copyright © 2020年 lianxianghui. All rights reserved.

#import "LXHWalletMnemonicPassphraseForRestoringViewController.h"
#import "Masonry.h"
#import "LXHWalletMnemonicPassphraseForRestoringView.h"
#import "LXHSetPassphraseViewController.h"
#import "LXHGenerateWalletViewController.h"
#import "LXHWalletMnemonicPassphraseForRestoringViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHWalletMnemonicPassphraseForRestoringViewController()
@property (nonatomic) LXHWalletMnemonicPassphraseForRestoringView *contentView;
@property (nonatomic) LXHWalletMnemonicPassphraseForRestoringViewModel *viewModel;
@end

@implementation LXHWalletMnemonicPassphraseForRestoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHWalletMnemonicPassphraseForRestoringView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self addActions];
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.button2 addTarget:self action:@selector(button2TouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.button2 addTarget:self action:@selector(button2TouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.button1 addTarget:self action:@selector(button1TouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.button1 addTarget:self action:@selector(button1TouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
//Actions
- (void)button2Clicked:(UIButton *)sender {
    sender.alpha = 1;
    id viewModel = [_viewModel generateWalletViewModelWithPassphrase:nil];
    UIViewController *controller = [[LXHGenerateWalletViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)button2TouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)button2TouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)button1Clicked:(UIButton *)sender {
    sender.alpha = 1;
    id viewModel = [_viewModel setPassphraseViewModel];
    LXHSetPassphraseViewController *controller = [[LXHSetPassphraseViewController alloc] initWithViewModel:viewModel];
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
