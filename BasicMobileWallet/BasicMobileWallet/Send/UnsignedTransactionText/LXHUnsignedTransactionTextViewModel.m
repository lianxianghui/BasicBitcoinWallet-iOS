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

@interface LXHUnsignedTransactionTextViewModel ()
@property (nonatomic) NSDictionary *transactionDictionary;
@end

@implementation LXHUnsignedTransactionTextViewModel

- (instancetype)initWithTransactionDictionary:(NSDictionary *)transactionDictionary {
    self = [super init];
    if (self) {
        _transactionDictionary = transactionDictionary;
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
    return [NSJSONSerialization jsonStringWithObject:_transactionDictionary];
}

- (id)qrCodeAndTextViewModel {
    NSString *jsonString = [self jsonString];
    if (jsonString)
        return [[LXHQRCodeAndTextViewModel alloc] initWithString:jsonString];
    else
        return nil;
}

- (NSDictionary *)signedTransactionDictionary {
    return nil;
}

- (id)signedTransactionTextViewModel {
    NSDictionary *dictionary = [self signedTransactionDictionary];
    LXHSignedTransactionTextViewModel *viewModel = [[LXHSignedTransactionTextViewModel alloc] initWithTransactionDictionary:dictionary];
    return viewModel;
}

@end
