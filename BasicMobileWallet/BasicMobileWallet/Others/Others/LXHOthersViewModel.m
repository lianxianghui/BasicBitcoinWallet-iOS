//
//  LXHOthersViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHOthersViewModel.h"
#import "LXHSignatureUtils.h"
#import "NSJSONSerialization+VLBase.h"
#import "LXHSignedTransactionTextViewModel.h"
#import "LXHUnsignedTransactionTextViewModel.h"
#import "LXHTextViewModel.h"
#import "LXHWallet.h"
#import "LXHBitcoinNetwork.h"

@implementation LXHOthersViewModel

- (NSDictionary *)jsonWithScannedText:(NSString *)text {
    NSDictionary *data = [NSJSONSerialization objectWithJsonString:text];
    return data;
}


//检查通过扫描获得的交易数据，如果有问题返回错误字符串，没问题返回nil
//数据格式
//@"dataType" : @"signedTransaction" or @"unsignedTransaction"
//dataForCheckingAddresses = @{@"outputAddresses":outputBase58Addresses, @"network":network};
//@{@"transactionData":transactionData, @"dataForCheckingAddresses":dataForCheckingAddresses};
- (NSString *)checkScannedData:(NSDictionary *)data {
    NSString *dataType = data[@"dataType"];
    if (dataType) {
        if ([dataType isEqualToString:@"unsignedTransaction"] || [dataType isEqualToString:@"signedTransaction"]) {
            //1.检查数据网络类型是否与当前钱包的网络类型一致 2.检查交易输出与校验字段是否一致
            NSString *network = [data valueForKeyPath:@"dataForCheckingAddresses.network"];
            NSString *errorMessage = nil;
            errorMessage = [self checkNetwork:network];
            if (errorMessage)
                return errorMessage;
            errorMessage = [self checkTransactionOutputsWithData:data];
            if (errorMessage)
                return errorMessage;
            BOOL isSignedTransaction = [dataType isEqualToString:@"signedTransaction"];
            errorMessage = [self checkTransactionInputsWithData:data isSignedTransaction:isSignedTransaction];
            return errorMessage;
        } else {
            return nil;
        }
    }
    return nil;
}


//未签名的数据需要签名，签名前需要知道地址对应的私钥。
//如果是离线钱包需要更新CurrentAddressIndex，这样能确定查找私钥的范围（否则如果在所有可能的私钥范围内查找，时间会太长）
//todo 这里有一个问题：如果扫描到的数据来自一个不与当前钱包相对应的只读钱包，这里有可能会把当前地址更新成错误的。（在地址列表里，会显示哪些地址已经使用过，这个错误会带来这个信息不准确）
- (BOOL)needUpdateCurrentAddressIndexDataWithData:(NSDictionary *)data {
    NSString *dataType = data[@"dataType"];
    return [dataType isEqualToString:@"unsignedTransaction"];
}

- (void)updateCurrentAddressIndexData:(NSDictionary *)data
                          successBlock:(nullable void (^)(void))successBlock
                         failureBlock:(nullable void (^)(NSString *errorPrompt))failureBlock {
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        BOOL updated = [self updateCurrentAddressIndexData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (updated)
                successBlock();
            else
                failureBlock(NSLocalizedString(@"传入的地址Index有误", nil));
        }];

    }];
}

//如果data中的currentAddressIndex超出最大值时返回NO
//如果比当前的小，会什么都不做，但目前不算为错误，返回YES。
- (BOOL)updateCurrentAddressIndexData:(NSDictionary *)data {
    NSDictionary *currentAddressIndexData = data[@"currentAddressIndexData"];
    uint32_t currentReceivingAddressIndex = [currentAddressIndexData[@"currentReceivingAddressIndex"] unsignedIntValue];
    uint32_t currentChangeAddressIndex = [currentAddressIndexData[@"currentChangeAddressIndex"] unsignedIntValue];
    LXHAccount *mainAccount = LXHWallet.mainAccount;
    NSError *error = nil;
    BOOL updated = [mainAccount.receiving setCurrentAddressIndex:currentReceivingAddressIndex error:&error];
    if (!updated && error.code == -1)//超出最大值的情况
        return NO;
    updated = [mainAccount.change setCurrentAddressIndex:currentChangeAddressIndex error:&error];
    if (!updated && error.code == -1)//超出最大值的情况
        return NO;
    
    return YES;
}

- (NSString *)checkTransactionOutputsWithData:(NSDictionary *)data {
    NSDictionary *dataForCheckingAddresses = data[@"dataForCheckingAddresses"];
    NSArray *outputAddresses = dataForCheckingAddresses[@"outputAddresses"];
    NSString *network = dataForCheckingAddresses[@"network"];
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

- (NSString *)checkTransactionInputsWithData:(NSDictionary *)data isSignedTransaction:(BOOL)isSignedTransaction {
    NSDictionary *dataForCheckingAddresses = data[@"dataForCheckingAddresses"];
    NSArray *inputAddresses = dataForCheckingAddresses[@"inputAddresses"];
    NSString *network = dataForCheckingAddresses[@"network"];
    LXHBitcoinNetworkType networkType = [LXHBitcoinNetwork networkTypeWithString:network];
    if (networkType == LXHBitcoinNetworkTypeUndefined)
        return NSLocalizedString(@"network数据字段有问题", nil);
    NSDictionary *transactionDictionary = data[@"transactionData"];
    BTCTransaction *transaction = [[BTCTransaction alloc] initWithDictionary:transactionDictionary];
    NSArray *inputAddressesFromTransaction = isSignedTransaction ? [LXHSignatureUtils inputBase58AddressesWithSignedBTCInputs:transaction.inputs networkType:networkType]
    : [LXHSignatureUtils inputBase58AddressesWithUnsignedBTCInputs:transaction.inputs networkType:networkType];
    if (!inputAddresses)
        return NSLocalizedString(@"数据有问题，校验数据中未包含输入地址", nil);
    if (!inputAddressesFromTransaction)
        return NSLocalizedString(@"数据有问题，交易数据中未包含输入地址", nil);
    if (![inputAddressesFromTransaction isEqualToArray:inputAddresses])
        return NSLocalizedString(@"交易输入地址与校验数据中的输入地址不一致", nil);
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
