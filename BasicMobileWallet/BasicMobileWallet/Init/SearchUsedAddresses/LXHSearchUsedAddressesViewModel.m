//
//  LXHSearchUsedAddressesViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/1/14.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHSearchUsedAddressesViewModel.h"
#import "LXHBitcoinNetwork.h"
#import "LXHTabBarPageViewModel.h"
#import "LXHWallet.h"

@interface LXHSearchUsedAddressesViewModel ()
@property (nonatomic) NSArray *mnemonicCodeWords;
@property (nonatomic) NSString *mnemonicPassphrase;
@property (nonatomic) LXHBitcoinNetworkType networkType;
@end

@implementation LXHSearchUsedAddressesViewModel

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
                              networkType:(LXHBitcoinNetworkType)networkType
{
    self = [super init];
    if (self) {
        self.mnemonicCodeWords = mnemonicCodeWords;
        self.mnemonicPassphrase = mnemonicPassphrase;
        self.networkType = networkType;
    }
    return self;
}

- (void)restoreExistWalletDataWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                                              failureBlock:(void (^)(NSString *errorPrompt))failureBlock {
    [LXHWallet restoreExistWalletDataWithMnemonicCodeWords:_mnemonicCodeWords mnemonicPassphrase:_mnemonicPassphrase netType:_networkType successBlock:^(NSDictionary * _Nonnull resultDic) {
        
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        NSError *error = resultDic[@"error"];
        NSString *format = NSLocalizedString(@"由于%@搜索地址失败.", nil);
        NSString *errorPrompt = [NSString stringWithFormat:format, error.localizedDescription];
        failureBlock(errorPrompt);
    }];
}

@end
