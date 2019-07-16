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
#import "BTCMnemonic.h"
#import "BTCData.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHWalletMnemonicWordsOneByOneViewController()
@property NSArray *words;
@property (nonatomic) LXHWalletMnemonicWordsOneByOneView *contentView;
@property (nonatomic) NSUInteger currentWordIndex;
@end

@implementation LXHWalletMnemonicWordsOneByOneViewController

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
    
    [self generateRandomMnemonicWords];
    self.currentWordIndex = 0;
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

- (void)generateRandomMnemonicWords {
    //todo 助记词Entropy用BTCRandomDataWithLength生成是否具有足够的随机性
    NSUInteger entropyBitCount = self.wordLength * 32/3;
    NSUInteger entropyByteCount = entropyBitCount / 8;
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithEntropy:BTCRandomDataWithLength(entropyByteCount) password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    self.words = mnemonic.words;
}


- (void)showCurrentWord {
    if (self.currentWordIndex < self.words.count) {
        NSString *word = self.words[self.currentWordIndex];
        [self.contentView.word updateAttributedTextString:word];
        
        NSString *currentNumberFormat = NSLocalizedString(@"%@个单词中的第%@个", nil);
        NSString *currentNumber = [NSString stringWithFormat:currentNumberFormat, @(self.words.count), @(self.currentWordIndex+1)];
        [self.contentView.number updateAttributedTextString:currentNumber];
    }
}

- (void)setPreAndNextButtonsProperties {
    //pre button enabled
    self.contentView.textButton1.enabled = (self.currentWordIndex != 0);
    self.contentView.textButton1.alpha = self.contentView.textButton1.enabled ? 1 : 0.5;
    //button2 text
    NSString *text = self.currentWordIndex == self.words.count-1 ? NSLocalizedString(@"完成", nil) : NSLocalizedString(@"后一个", nil);
    [self.contentView.textButton2 updateAttributedTitleString:text forState:UIControlStateNormal];
}

- (void)refreshContentView {
    [self showCurrentWord];
    [self setPreAndNextButtonsProperties];
}

//Actions
- (void)textButton2Clicked:(UIButton *)sender {
    if (self.currentWordIndex == self.words.count-1) {
        LXHWalletMnemonicWordsViewController *controller = [[LXHWalletMnemonicWordsViewController alloc] init];
        controller.words = self.words;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        self.currentWordIndex++;
        [self refreshContentView];
    }
}


- (void)textButton1Clicked:(UIButton *)sender {
    self.currentWordIndex--;
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
