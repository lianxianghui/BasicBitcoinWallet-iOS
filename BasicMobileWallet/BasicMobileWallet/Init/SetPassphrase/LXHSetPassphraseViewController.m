// LXHSetPassphraseViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSetPassphraseViewController.h"
#import "Masonry.h"
#import "LXHSetPassphraseView.h"
#import "LXHTabBarPageViewController.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSetPassphraseViewController()

@property (nonatomic) LXHSetPassphraseView *contentView;

@end

@implementation LXHSetPassphraseViewController

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
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.textButton addTarget:self action:@selector(textButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.textButton addTarget:self action:@selector(textButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.textButton addTarget:self action:@selector(textButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
- (void)textButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    UIViewController *controller = [[LXHTabBarPageViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO]; 
}

- (void)textButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)textButtonTouchUpOutside:(UIButton *)sender {
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
