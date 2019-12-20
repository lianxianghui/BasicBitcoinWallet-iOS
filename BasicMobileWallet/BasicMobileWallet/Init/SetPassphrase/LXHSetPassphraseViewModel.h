//
//  LXHSetPassphraseViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHWallet.h"

NS_ASSUME_NONNULL_BEGIN


/**
 创建新钱包时的ViewModel
 */
@interface LXHSetPassphraseViewModel : NSObject
@property (nonatomic) NSArray *words;

- (instancetype)initWithWords:(NSArray *)words;

- (NSString *)navigationBarTitle;
- (NSString *)prompt;

/**
 检查输入，返回检查结果code
 1 没问题
 -1 两个输入至少有一个为空
 -2 两个输入不一致
 -3 两个输入一致，但输入包含空白字符
 */
- (NSInteger)checkInputText:(NSString *)inputText inputAgainText:(NSString *)inputAgainText;

- (LXHWalletGenerationType)walletGenerationType;
@end

NS_ASSUME_NONNULL_END
