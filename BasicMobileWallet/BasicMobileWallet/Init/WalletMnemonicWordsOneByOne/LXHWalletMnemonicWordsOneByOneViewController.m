// LXHWalletMnemonicWordsOneByOneViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHWalletMnemonicWordsOneByOneViewController.h"
#import "Masonry.h"
#import "LXHWalletMnemonicWordsOneByOneView.h"
#import "LXHWalletMnemonicWordsViewController.h"
#import "UILabel+LXHText.h"
#import "UIButton+LXHText.h"
#import "LXHWalletMnemonicWordsOneByOneViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHWalletMnemonicWordsOneByOneViewController()
@property (nonatomic) LXHWalletMnemonicWordsOneByOneView *contentView;
@property (nonatomic) LXHWalletMnemonicWordsOneByOneViewModel *viewModel;
@end

@implementation LXHWalletMnemonicWordsOneByOneViewController

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
    self.contentView = [[LXHWalletMnemonicWordsOneByOneView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self addActions];
    [self refreshContentView];
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

- (void)showCurrentWord {
    NSString *word = [_viewModel currentWord];
    if (word)
        [self.contentView.word updateAttributedTextString:word];
    [self.contentView.number updateAttributedTextString:[_viewModel currentNumberPrompt]];
}

- (void)setPreAndNextButtonsProperties {
    //pre button enabled
    self.contentView.textButton1.enabled = [_viewModel button1Enabled];
    self.contentView.textButton1.alpha = self.contentView.textButton1.enabled ? 1 : 0.5;
    //button2 text
    [self.contentView.textButton2 updateAttributedTitleString:[_viewModel button2Text] forState:UIControlStateNormal];
}

- (void)refreshContentView {
    [self showCurrentWord];
    [self setPreAndNextButtonsProperties];
}

//Actions
- (void)textButton2Clicked:(UIButton *)sender {
    if ([_viewModel isLastWord]) {
        LXHWalletMnemonicWordsViewController *controller = [[LXHWalletMnemonicWordsViewController alloc] init];
        controller.words = _viewModel.words;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [_viewModel nextWord];
        [self refreshContentView];
    }
}


- (void)textButton1Clicked:(UIButton *)sender {
    [_viewModel previousWord];
    [self refreshContentView];
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
