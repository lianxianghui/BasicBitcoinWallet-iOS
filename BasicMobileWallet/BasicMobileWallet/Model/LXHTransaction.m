//
//  LXHTransaction.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransaction.h"
#import "LXHWallet.h"

@interface LXHTransaction ()
@property (nonatomic, readwrite) NSDictionary *dic;
@property (nonatomic) NSDecimalNumber *sentValueSumFromLocalAddress;
@property (nonatomic) NSDecimalNumber *receivedValueSumFromLocalAddress;
@end

@implementation LXHTransaction

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _dic = dic;
    }
    return self;
}

- (LXHTransactionSendOrReceiveType)sendOrReceiveType {
    NSDecimalNumber *sentValueSumFromLocalAddress = [self sentValueSumFromLocalAddress];
    NSDecimalNumber *receivedValueSumFromLocalAddress = [self receivedValueSumFromLocalAddress];
    if ([sentValueSumFromLocalAddress compare:receivedValueSumFromLocalAddress] == NSOrderedDescending)  {//sent > received is send type
        return LXHTransactionSendOrReceiveTypeSend;
    } else if ([sentValueSumFromLocalAddress compare:receivedValueSumFromLocalAddress] == NSOrderedSame) {
        return LXHTransactionSendOrReceiveTypeNotDefined; //这个时候fee是0 
    } else {
        return LXHTransactionSendOrReceiveTypeReceive;
    }
}

//来自当前钱包地址的输入和，也就是从当前钱包转出去的总值
- (NSDecimalNumber *)sentValueSumFromLocalAddress {
    if (_sentValueSumFromLocalAddress)
        return _sentValueSumFromLocalAddress;
    NSArray *inputs = _dic[@"vin"];
    NSDecimalNumber *sum = [NSDecimalNumber zero];
    NSArray *usedAndCurrentAddresses = [[LXHWallet mainAccount] usedAndCurrentAddresses];
    for (NSDictionary *inputDic in inputs) {
        NSString *inputAddr = inputDic[@"addr"];
        if (![usedAndCurrentAddresses containsObject:inputAddr])
            continue;
        NSString *value = inputDic[@"value"]; 
        if (!value)
            continue;
        value = [NSString stringWithFormat:@"%@", value];
        NSDecimalNumber *decimalValue = [NSDecimalNumber decimalNumberWithString:value];
        if (!sum) 
            sum = decimalValue;
        else
            sum = [sum decimalNumberByAdding:decimalValue];
    }
    _sentValueSumFromLocalAddress = sum;
    return sum;
}

//当前钱包收到的总值
- (NSDecimalNumber *)receivedValueSumFromLocalAddress {
    if (_receivedValueSumFromLocalAddress)
        return _receivedValueSumFromLocalAddress;
    NSArray *outputs = _dic[@"vout"];
    NSDecimalNumber *sum = [NSDecimalNumber zero];
    NSArray *usedAndCurrentAddresses = [[LXHWallet mainAccount] usedAndCurrentAddresses];
    for (NSDictionary *outputDic in outputs) {
        NSString *addr = [outputDic valueForKeyPath:@"scriptPubKey.addresses"][0];
        if (![usedAndCurrentAddresses containsObject:addr])
            continue;
        NSString *value = outputDic[@"value"];
        if (!value)
            continue;
        value = [NSString stringWithFormat:@"%@", value];
        NSDecimalNumber *decimalValue = [NSDecimalNumber decimalNumberWithString:value];
        if (!sum) 
            sum = decimalValue;
        else
            sum = [sum decimalNumberByAdding:decimalValue];
    }
    _receivedValueSumFromLocalAddress = sum;
    return sum;
}

- (NSDecimalNumber *)fees {
    NSDecimalNumber *ret = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", _dic[@"fees"]]];
    return ret;
}

- (NSString *)outAddressAtIndex:(NSInteger)index {
    NSArray *outputs = _dic[@"vout"];
    if (index < outputs.count) {
        NSDictionary *outputDic = outputs[index];
        NSString *addr = [outputDic valueForKeyPath:@"scriptPubKey.addresses"][0];
        return addr;
    }
    return nil;
}

- (NSMutableArray<LXHTransactionInput *> *)inputs {
    if (!_inputs)
        _inputs = [NSMutableArray array];
    return _inputs;
}

- (NSMutableArray<LXHTransactionOutput *> *)outputs {
    if (!_outputs)
        _outputs = [NSMutableArray array];
    return _outputs;
}

@end
