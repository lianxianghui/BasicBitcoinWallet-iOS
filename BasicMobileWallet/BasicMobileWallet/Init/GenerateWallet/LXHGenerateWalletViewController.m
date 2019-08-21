// LXHGenerateWalletViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-08-19
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHGenerateWalletViewController.h"
#import "Masonry.h"
#import "LXHGenerateWalletView.h"
#import "LXHTabBarPageViewController.h"
#import "LXHKeychainStore.h"
#import "UIViewController+LXHAlert.h"
#import "CoreBitcoin.h"
#import "LXHWalletDataManager.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHGenerateWalletViewController()

@property (nonatomic) LXHGenerateWalletView *contentView;
@property (nonatomic) LXHWalletGenerationType creationType;
@property (nonatomic) NSArray * mnemonicCodeWords;
@property (nonatomic) NSString *mnemonicPassphrase;
@end

@implementation LXHGenerateWalletViewController

- (instancetype)initWithCreationType:(LXHWalletGenerationType)creationType
                   mnemonicCodeWords:(NSArray *)mnemonicCodeWords
                  mnemonicPassphrase:(NSString *)mnemonicPassphrase {
    self = [super init];
    if (self) {
        self.creationType = creationType;
        self.mnemonicCodeWords = mnemonicCodeWords;
        self.mnemonicPassphrase = mnemonicPassphrase;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHGenerateWalletView alloc] init];
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
    [self.contentView.generateMainnetWalletButton addTarget:self action:@selector(generateMainnetWalletButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.generateTestnet3WalletButton addTarget:self action:@selector(generateTestnet3WalletButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDelegates {
}

//Actions
- (void)generateMainnetWalletButtonClicked:(UIButton *)sender {
    [self generateWalletWithNetType:LXHBitcoinNetworkTypeMainnet];
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

- (void)generateTestnet3WalletButtonClicked:(UIButton *)sender {
    [self generateWalletWithNetType:LXHBitcoinNetworkTypeTestnet];
}

- (void)generateWalletWithNetType:(LXHBitcoinNetworkType)netType {
    if (self.creationType == LXHWalletGenerationTypeGeneratingNew) {
        if ([[LXHWalletDataManager sharedInstance] generateNewWalletDataWithMnemonicCodeWords:_mnemonicCodeWords mnemonicPassphrase:_mnemonicPassphrase netType:netType]) {
             [self pushTabBarViewController];
        } else {
            [self showOkAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"发生了无法处理的错误，如果方便请联系并告知开发人员", nil) handler:nil];
        }
    } else {
        //todo show indicator
        [[LXHWalletDataManager sharedInstance] restoreExistWalletDataWithMnemonicCodeWords:_mnemonicCodeWords mnemonicPassphrase:_mnemonicPassphrase netType:netType successBlock:^(NSDictionary * _Nonnull resultDic) {
            //stop indicator
            
        } failureBlock:^(NSDictionary * _Nonnull resultDic) {
            //stop indicator
        }];
    }
    
}

- (void)pushTabBarViewController {
    UIViewController *controller = [[LXHTabBarPageViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES]; 
}


@end
