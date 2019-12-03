//
//  LXHTransactionInputOutputCommon.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/15.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionInputOutputCommon.h"
#import "BlocksKit.h"
#import "LXHAddress.h"

@implementation LXHTransactionInputOutputCommon

- (LXHAddress *)address {
    if (!_address)
        _address = [LXHAddress new];
    return _address;
}

+ (NSDecimalNumber *)valueSumOfInputsOrOutputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputsOrOutputs {
    if (inputsOrOutputs.count == 0)
        return [NSDecimalNumber zero];
    else
        return [inputsOrOutputs bk_reduce:[NSDecimalNumber zero] withBlock:^id(NSDecimalNumber *sum, LXHTransactionInputOutputCommon *inputOrOutput) {
            return [sum decimalNumberByAdding:inputOrOutput.value];
        }];
}

@end
