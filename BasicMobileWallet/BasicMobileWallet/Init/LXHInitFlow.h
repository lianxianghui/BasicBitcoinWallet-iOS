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

@interface LXHInitFlow : NSObject

//init parameters
@property (nonatomic) NSUInteger mnemonicWordsLength;
@property (nonatomic) NSArray *mnemonicWords;
@property (nonatomic) NSString *MnemonicPassphrase;
@property (nonatomic) LXHBitcoinNetworkType networkType;

+ (LXHInitFlow *)currentFlow;
+ (void)startResettingPINFlow;
+ (void)endFlow;

- (id)checkWalletMnemonicWordsClickNextButtonNavigationInfo;
@end

NS_ASSUME_NONNULL_END
