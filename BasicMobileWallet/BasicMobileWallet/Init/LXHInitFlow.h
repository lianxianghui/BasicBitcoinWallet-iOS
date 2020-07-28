//
//  LXHInitFlow.h
//  BasicMobileWallet
//
//  Created by lian on 2020/4/17.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHBitcoinNetwork.h"

NS_ASSUME_NONNULL_BEGIN


/**
 从“初始化钱包”页面，可以开始创建新钱包、也可以恢复已有钱包。接下来的流程从开始到结束会经过多个页面。
 接下来的流程（从SelectMnemonicWordLength页开始）所经过的页面有的是完全不一样，而有的是页面功能基本一样，只是跳转逻辑不一样（比如"助记词数量"页点击列表项接下来会进入不同的页面)。
 后来又加入了重置PIN码的功能，也会从SelectMnemonicWordLength页开始走输入助记词重置PIN码的流程
 下面这个类 把这些页面跳转逻辑不一样的地方抽象成统一的接口，用子类来具体实现。
 */
@interface LXHInitFlow : NSObject

@property (nonatomic) NSUInteger mnemonicWordsLength;
@property (nonatomic) NSArray *mnemonicWords;
@property (nonatomic) NSString *mnemonicPassphrase;

+ (LXHInitFlow *)currentFlow;
+ (void)startCreatingNewWalletFlow;
+ (void)startRestoringExistWalletFlow;
+ (void)startResettingPINFlow;
+ (void)endFlow;

//SelectMnemonicWordLengthView
- (NSDictionary *)selectMnemonicWordLengthViewClickRowNavigationInfo;
//CheckWalletMnemonicWordsView
- (NSDictionary *)checkWalletMnemonicWordsClickNextButtonNavigationInfo;
//SetPassphraseView
- (NSDictionary *)setPassphraseViewClickOKButtonNavigationInfoWithWithPassphrase:(NSString *)passphrase;
//GenerateWalletView
- (NSDictionary *)generateWalletViewClickMainnetNavigationInfo;
- (NSDictionary *)generateWalletViewClickTestnetButtonNavigationInfo;
@end

NS_ASSUME_NONNULL_END
