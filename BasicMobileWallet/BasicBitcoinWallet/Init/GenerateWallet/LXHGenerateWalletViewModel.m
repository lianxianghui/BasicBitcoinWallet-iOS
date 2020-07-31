//
//  LXHGenerateWalletViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/1/14.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHGenerateWalletViewModel.h"
#import "LXHBitcoinNetwork.h"
#import "LXHInitFlow.h"

@interface LXHGenerateWalletViewModel ()
@property (nonatomic) NSArray *mnemonicCodeWords;
@property (nonatomic) NSString *mnemonicPassphrase;
@end

@implementation LXHGenerateWalletViewModel

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase {
    self = [super init];
    if (self) {
        self.mnemonicCodeWords = mnemonicCodeWords;
        self.mnemonicPassphrase = mnemonicPassphrase;
    }
    return self;
}

- (NSDictionary *)clickMainnetNavigationInfo {
    LXHInitFlow *currentFlow = [LXHInitFlow currentFlow];
    return [currentFlow generateWalletViewClickMainnetNavigationInfo];
}

- (NSDictionary *)clickTestnetButtonNavigationInfo {
    LXHInitFlow *currentFlow = [LXHInitFlow currentFlow];
    return [currentFlow generateWalletViewClickTestnetButtonNavigationInfo];
}

@end



