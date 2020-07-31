//
//  LXHCurrentAccountInfoViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHCurrentAccountInfoViewModel.h"
#import "LXHWallet.h"
#import "LXHGlobalHeader.h"
#import "LXHQRCodeAndTextViewModel.h"

@implementation LXHCurrentAccountInfoViewModel

- (NSString *)netTypeText {
    LXHAccount *mainAccount = [LXHWallet mainAccount];
    NSString *text = mainAccount.currentNetworkType == LXHBitcoinNetworkTypeMainnet ? @"Mainnet" : @"Testnet";
    return text;
}

- (NSString *)walletTypeText {
    return [LXHWallet isFullFunctional] ? @"全功能" : @"只读";
}

- (LXHQRCodeAndTextViewModel *)qrCodeAndTextViewModel {
    NSString *xpub = [[LXHWallet mainAccount] extendedPublicKey];
    LXHQRCodeAndTextViewModel *viewModel = [[LXHQRCodeAndTextViewModel alloc] initWithString:xpub];
    viewModel.title = NSLocalizedString(@"扩展公钥(xpub)", nil);
    return viewModel;
}

- (void)searchAndUpdateCurrentAddressIndexWithSuccessBlock:(void (^)(NSString *prompt))successBlock
                                              failureBlock:(void (^)(NSString *errorPrompt))failureBlock {
    [LXHWallet searchAndUpdateCurrentAddressIndexWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        BOOL indexUpdated = [resultDic[@"indexUpdated"] boolValue];
        NSString *prompt = indexUpdated ? NSLocalizedString(@"当前地址已更新", nil) : NSLocalizedString(@"当前地址已经是最新的了", nil);
        successBlock(prompt);
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        NSError *error = resultDic[@"error"];
        NSString *format = NSLocalizedString(@"由于%@搜索地址失败.", nil);
        NSString *errorPrompt = [NSString stringWithFormat:format, error.localizedDescription];
        failureBlock(errorPrompt);
    }];
}
@end
