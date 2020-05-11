//
//  LXHSignedTransactionTextViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSignedTransactionTextViewModel.h"
#import "NSJSONSerialization+VLBase.h"
#import "LXHQRCodeAndTextViewModel.h"
#import "LXHTransactionDataRequest.h"
#import "CoreBitcoin.h"

@interface LXHSignedTransactionTextViewModel ()
@property (nonatomic) NSDictionary *data;
@property (nonatomic) BTCTransaction *signedBTCTransaction;
@property (nonatomic) NSDictionary *signedTransactionDictionary;
@end

@implementation LXHSignedTransactionTextViewModel

- (instancetype)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;
        _signedTransactionDictionary = _data[@"transactionData"];
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

- (id)qrCodeAndTextViewModel {
    NSString *jsonString = [self jsonString];
    if (jsonString) {
        LXHQRCodeAndTextViewModel *viewModel = [[LXHQRCodeAndTextViewModel alloc] initWithString:jsonString];
        viewModel.showText = NO;
        return viewModel;
    } else {
        return nil;
    }
}

- (BTCTransaction *)signedBTCTransaction {
    if (!_signedBTCTransaction)
        _signedBTCTransaction = [[BTCTransaction alloc] initWithDictionary:_signedTransactionDictionary];
    return _signedBTCTransaction;
}

- (void)pushSignedTransactionWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                                 failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    
//    NSLog(@"正在发送的签名交易：%@", [self.signedBTCTransaction dictionary]);
    [LXHTransactionDataRequest pushTransactionsWithHex:self.signedBTCTransaction.hex successBlock:successBlock failureBlock:failureBlock];
}
@end
