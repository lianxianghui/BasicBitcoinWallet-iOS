// LXHSelectWayOfSendingBitcoinViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-11-19
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSelectWayOfSendingBitcoinViewController.h"
#import "Masonry.h"
#import "LXHSelectWayOfSendingBitcoinView.h"
#import "LXHBuildTransactionViewController.h"
#import "LXHSelectWayOfSendingBitcoinViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSelectWayOfSendingBitcoinViewController()
@property (nonatomic) LXHSelectWayOfSendingBitcoinView *contentView;
@property (nonatomic) LXHSelectWayOfSendingBitcoinViewModel *viewModel;
@end

@implementation LXHSelectWayOfSendingBitcoinViewController

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
    self.contentView = [[LXHSelectWayOfSendingBitcoinView alloc] init];
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
    [self.contentView.textButton2 addTarget:self action:@selector(textButton2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.textButton1 addTarget:self action:@selector(textButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDelegates {
}

//Actions
- (void)textButton1Clicked:(UIButton *)sender {
    UIViewController *controller = [[LXHBuildTransactionViewController alloc] initWithViewModel:[_viewModel buildTransactionViewModelForFixedOutput]];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)textButton2Clicked:(UIButton *)sender {
    UIViewController *controller = [[LXHBuildTransactionViewController alloc] initWithViewModel:[_viewModel buildTransactionViewModelForFixedInput]];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}


@end
