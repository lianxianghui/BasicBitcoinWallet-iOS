//
//  LXHOthersViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHOthersViewModel.h"
#import "LXHTransactionListViewModel.h"
#import "LXHSignatureUtils.h"
#import "NSJSONSerialization+VLBase.h"
#import "LXHSignedTransactionTextViewModel.h"
#import "LXHUnsignedTransactionTextViewModel.h"
#import "LXHTextViewModel.h"

@implementation LXHOthersViewModel

- (id)transactionListViewModel {
    return [[LXHTransactionListViewModel alloc] init];
}

- (id)addressListViewModel {
    return nil;
}

- (id)settingViewModel {
    return nil;
}

//数据格式
//NSDictionary *dataForCheckingOutputAddresses = @{@"outputAddresses":outputBase58Addresses, @"network":network};
//return @{@"transactionData":transactionData, @"dataForCheckingOutputAddresses":dataForCheckingOutputAddresses};
- (NSString *)checkScannedText:(NSString *)text {
    NSDictionary *json = [NSJSONSerialization objectWithJsonString:text];
    NSString *dataType = json[@"dataType"];
    if (dataType) {
        if ([dataType isEqualToString:@"unsignedTransaction"] || [dataType isEqualToString:@"signedTransaction"]) {
            NSDictionary *dataForCheckingOutputAddresses = json[@"dataForCheckingOutputAddresses"];
            NSArray *outputAddresses = dataForCheckingOutputAddresses[@"outputAddresses"];
            NSString *network = dataForCheckingOutputAddresses[@"network"];
            LXHBitcoinNetworkType networkType;
            if ([network isEqualToString:@"mainnet"])
                networkType = LXHBitcoinNetworkTypeMainnet;
            else if ([network isEqualToString:@"testnet"])
                networkType = LXHBitcoinNetworkTypeTestnet;
            else
                return NSLocalizedString(@"network数据字段有问题", nil);
            NSDictionary *transactionDictionary = json[@"transactionData"];
            BTCTransaction *transaction = [[BTCTransaction alloc] initWithDictionary:transactionDictionary];
            NSArray *outputAddressesFromTransaction = [LXHSignatureUtils outputBase58AddressesWithBTCOutputs:transaction.outputs networkType:networkType];
            if (!outputAddresses)
                return NSLocalizedString(@"数据有问题，校验数据中未包含输出地址", nil);
            if (!outputAddressesFromTransaction)
                return NSLocalizedString(@"数据有问题，交易数据中未包含输出地址", nil);
            if (![outputAddressesFromTransaction isEqualToArray:outputAddresses])
                return NSLocalizedString(@"交易输出地址与校验数据中的输出地址不一致", nil);
            return nil;
        } else {
            return nil;
        }
    }
    return nil;
}

- (NSDictionary *)dataForNavigationWithScannedText:(NSString *)text {
    NSDictionary *json = [NSJSONSerialization objectWithJsonString:text];
    NSString *dataType = json[@"dataType"];
    NSString *controllerClassName;
    id viewModel;
    if (dataType) {
        if ([dataType isEqualToString:@"unsignedTransaction"]) {
            controllerClassName = @"LXHUnsignedTransactionTextViewController";
            viewModel = [[LXHUnsignedTransactionTextViewModel alloc] initWithData:json];
        } else if ([dataType isEqualToString:@"signedTransaction"]) {
            controllerClassName = @"LXHSignedTransactionTextViewController";
            viewModel = [[LXHSignedTransactionTextViewModel alloc] initWithData:json];
        } else {
            return nil;
        }
    } else {
        controllerClassName = @"LXHTextViewController";
        viewModel = [[LXHTextViewModel alloc] initWithText:text];
    }
    return @{@"controllerClassName":controllerClassName, @"viewModel":viewModel};
}

@end
