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
#import "LXHWallet.h"
#import "LXHBitcoinNetwork.h"

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

- (NSDictionary *)jsonWithScannedText:(NSString *)text {
    NSDictionary *data = [NSJSONSerialization objectWithJsonString:text];
    return data;
}

//数据格式
//NSDictionary *dataForCheckingOutputAddresses = @{@"outputAddresses":outputBase58Addresses, @"network":network};
//return @{@"transactionData":transactionData, @"dataForCheckingOutputAddresses":dataForCheckingOutputAddresses};
- (NSString *)checkScannedData:(NSDictionary *)data {
    NSString *dataType = data[@"dataType"];
    if (dataType) {
        if ([dataType isEqualToString:@"unsignedTransaction"] || [dataType isEqualToString:@"signedTransaction"]) {
            //检查交易: 1.检查网络类型 2.检查交易输出与校验字段是否一致
            NSString *network = [data valueForKeyPath:@"dataForCheckingOutputAddresses.network"];
            NSString *errorMessage = nil;
            errorMessage = [self checkNetwork:network];
            if (errorMessage)
                return errorMessage;
            errorMessage = [self checkTransactionOutputsWithData:data];
            return errorMessage;
        } else {
            return nil;
        }
    }
    return nil;
}

- (BOOL)needUpdateCurrentAddressIndexDataWithData:(NSDictionary *)data {
    NSString *dataType = data[@"dataType"];
    return [dataType isEqualToString:@"unsignedTransaction"];
}

//- (BOOL)needAsynchronousUpdateCurrentAddressIndexData:(NSDictionary *)data {
//
//}

- (void)updateCurrentAddressIndexData:(NSDictionary *)data
                          successBlock:(nullable void (^)(void))successBlock
                         failureBlock:(nullable void (^)(NSString *errorPrompt))failureBlock {
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [self updateCurrentAddressIndexData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            successBlock();
        }];
    }];
}

- (void)updateCurrentAddressIndexData:(NSDictionary *)data {
    NSDictionary *currentAddressIndexData = data[@"currentAddressIndexData"];
    uint32_t currentReceivingAddressIndex = [currentAddressIndexData[kLXHKeychainStoreCurrentReceivingAddressIndex] unsignedIntValue];
    uint32_t currentChangeAddressIndex = [currentAddressIndexData[kLXHKeychainStoreCurrentChangeAddressIndex] unsignedIntValue];
    LXHAccount *mainAccount = LXHWallet.mainAccount;
    [mainAccount.receiving setCurrentAddressIndex:currentReceivingAddressIndex];
    [mainAccount.change setCurrentAddressIndex:currentChangeAddressIndex];
}

- (NSString *)checkTransactionOutputsWithData:(NSDictionary *)data {
    NSDictionary *dataForCheckingOutputAddresses = data[@"dataForCheckingOutputAddresses"];
    NSArray *outputAddresses = dataForCheckingOutputAddresses[@"outputAddresses"];
    NSString *network = dataForCheckingOutputAddresses[@"network"];
    LXHBitcoinNetworkType networkType = [LXHBitcoinNetwork networkTypeWithString:network];
    if (networkType == LXHBitcoinNetworkTypeUndefined)
        return NSLocalizedString(@"network数据字段有问题", nil);
    NSDictionary *transactionDictionary = data[@"transactionData"];
    BTCTransaction *transaction = [[BTCTransaction alloc] initWithDictionary:transactionDictionary];
    NSArray *outputAddressesFromTransaction = [LXHSignatureUtils outputBase58AddressesWithBTCOutputs:transaction.outputs networkType:networkType];
    if (!outputAddresses)
        return NSLocalizedString(@"数据有问题，校验数据中未包含输出地址", nil);
    if (!outputAddressesFromTransaction)
        return NSLocalizedString(@"数据有问题，交易数据中未包含输出地址", nil);
    if (![outputAddressesFromTransaction isEqualToArray:outputAddresses])
        return NSLocalizedString(@"交易输出地址与校验数据中的输出地址不一致", nil);
    return nil;
}

- (NSString *)checkNetwork:(NSString *)network {
    NSString *currentAccountNetwork = [LXHBitcoinNetwork networkStringWithType:LXHWallet.mainAccount.currentNetworkType];
    if (![network isEqualToString:currentAccountNetwork]) {
        NSString *format = NSLocalizedString(@"交易的网络为%@，当前帐号比特币网络类型为%@，二者不一致", nil);
        return [NSString stringWithFormat:format, network, currentAccountNetwork];
    }
    return nil;
}

- (NSDictionary *)dataForNavigationWithScannedData:(NSDictionary *)data text:(NSString *)text {
    NSDictionary *json = data;
    NSString *dataType = json[@"dataType"];
    NSString *controllerClassName;
    id viewModel;
    if (dataType) {
        if ([dataType isEqualToString:@"unsignedTransaction"]) {
            controllerClassName = @"LXHUnsignedTransactionTextViewController";
            LXHUnsignedTransactionTextViewModel *unsignedTransactionTextViewModel = [[LXHUnsignedTransactionTextViewModel alloc] initWithData:json];
            viewModel = unsignedTransactionTextViewModel;
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
