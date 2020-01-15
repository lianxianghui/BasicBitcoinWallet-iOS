//
//  LXHSearchAddressesAndGenerateWalletViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/1/15.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHSearchAddressesAndGenerateWalletViewModel.h"
#import "LXHTabBarPageViewModel.h"
#import "LXHWallet.h"

@interface LXHSearchAddressesAndGenerateWalletViewModel ()
@property (nonatomic) NSArray *mnemonicCodeWords;
@property (nonatomic) NSString *mnemonicPassphrase;
@property (nonatomic) LXHBitcoinNetworkType networkType;
@end

@implementation LXHSearchAddressesAndGenerateWalletViewModel

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
                              networkType:(LXHBitcoinNetworkType)networkType {
    self = [super init];
    if (self) {
        self.mnemonicCodeWords = mnemonicCodeWords;
        self.mnemonicPassphrase = mnemonicPassphrase;
        self.networkType = networkType;
    }
    return self;
}

- (void)searchUsedAddressesAndGenerateExistWalletDataWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                                  failureBlock:(void (^)(NSString *errorPrompt))failureBlock {
    [LXHWallet restoreExistWalletDataWithMnemonicCodeWords:_mnemonicCodeWords mnemonicPassphrase:_mnemonicPassphrase netType:_networkType successBlock:^(NSDictionary * _Nonnull resultDic) {
        successBlock(nil);
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        NSError *error = resultDic[@"error"];
        NSString *format = NSLocalizedString(@"由于%@搜索地址失败，请稍后重试.", nil);
        NSString *errorPrompt = [NSString stringWithFormat:format, error.localizedDescription];
        failureBlock(errorPrompt);
    }];
}

- (BOOL)generateExistWalletData {
    if ([LXHWallet generateWalletDataWithMnemonicCodeWords:_mnemonicCodeWords mnemonicPassphrase:_mnemonicPassphrase netType:_networkType]) {
        return YES;
    } else {
        return NO;
    }
}


@end
