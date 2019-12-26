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

@interface LXHSignedTransactionTextViewModel ()
@property (nonatomic) NSDictionary *transactionDictionary;
@end

@implementation LXHSignedTransactionTextViewModel

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

- (void)pushSignedTransactionWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                                 failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    
}

@end
