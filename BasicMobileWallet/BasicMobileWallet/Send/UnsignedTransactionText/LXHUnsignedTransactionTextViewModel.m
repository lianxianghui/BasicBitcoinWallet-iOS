//
//  LXHUnsignedTransactionTextViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHUnsignedTransactionTextViewModel.h"
#import "NSJSONSerialization+VLBase.h"
#import "LXHQRCodeAndTextViewModel.h"
#import "LXHSignedTransactionTextViewModel.h"
#import "CoreBitcoin.h"
#import "LXHSignatureUtils.h"
#import "LXHWallet.h"

@interface LXHUnsignedTransactionTextViewModel ()
@property (nonatomic) NSDictionary *data;
@end

@implementation LXHUnsignedTransactionTextViewModel

- (instancetype)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}


- (NSString *)text {
    NSString *jsonString = [self jsonString];
    if (jsonString)
        return jsonString;
    else
        return @" ";
}

- (NSString *)jsonString {
    return [NSJSONSerialization jsonStringWithObject:_data];
}

- (nullable id)qrCodeAndTextViewModel {
    NSString *jsonString = [self jsonString];
    if (jsonString) {
        LXHQRCodeAndTextViewModel *viewModel = [[LXHQRCodeAndTextViewModel alloc] initWithString:jsonString];
        viewModel.showText = NO;
        return viewModel;
    } else {
        return nil;
    }
}

- (NSDictionary *)transactionDictionary {
    return _data[@"transactionData"];
}

- (nullable BTCTransaction *)signedTransaction {
    BTCTransaction *unsiginedTransaction = [[BTCTransaction alloc] initWithDictionary:self.transactionDictionary];
    BTCTransaction *signedTransaction = [LXHSignatureUtils signBTCTransaction:unsiginedTransaction];
    return signedTransaction;
}

- (nullable id)signedTransactionTextViewModel {
    BTCTransaction *transaction = [self signedTransaction];
    if (!transaction)
        return nil;
    NSDictionary *transactionData = [transaction dictionary];
    NSArray *outputBase58Addresses = [LXHSignatureUtils outputBase58AddressesWithBTCOutputs:transaction.outputs networkType:LXHWallet.mainAccount.currentNetworkType];
    NSArray *inputBase58Addresses = [LXHSignatureUtils inputBase58AddressesWithSignedBTCInputs:transaction.inputs networkType:LXHWallet.mainAccount.currentNetworkType];
    NSString *network = [_data valueForKeyPath:@"dataForCheckingAddresses.network"];
    NSDictionary *dataForCheckingAddresses = @{@"inputAddresses":inputBase58Addresses, @"outputAddresses":outputBase58Addresses, @"network":network};
    NSDictionary *dictionary = @{@"dataType":@"signedTransaction", @"transactionData":transactionData, @"dataForCheckingAddresses":dataForCheckingAddresses};
    LXHSignedTransactionTextViewModel *viewModel = [[LXHSignedTransactionTextViewModel alloc] initWithData:dictionary];
    return viewModel;
}

- (BOOL)signTransactionButtonEnabled {
    return [LXHWallet isFullFunctional];
}

@end
