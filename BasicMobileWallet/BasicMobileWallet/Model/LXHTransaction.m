//
//  LXHTransaction.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransaction.h"
#import "LXHWallet.h"
#import "LXHGlobalHeader.h"

@interface LXHTransaction ()
@property (nonatomic) NSDecimalNumber *sentValueSumFromLocalAddress;
@property (nonatomic) NSDecimalNumber *receivedValueSumFromLocalAddress;
@end

@implementation LXHTransaction

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    LXHDecodeObjectStament(blockhash);
    LXHDecodeObjectStament(block);
    LXHDecodeObjectStament(time);
    LXHDecodeObjectStament(confirmations);
    LXHDecodeObjectStament(inputAmount);
    LXHDecodeObjectStament(outputAmount);
    LXHDecodeObjectStament(fees);
    LXHDecodeObjectStament(txid);
    LXHDecodeObjectStament(inputs);
    LXHDecodeObjectStament(outputs);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    LXHEncodeObjectStament(blockhash);
    LXHEncodeObjectStament(block);
    LXHEncodeObjectStament(time);
    LXHEncodeObjectStament(confirmations);
    LXHEncodeObjectStament(inputAmount);
    LXHEncodeObjectStament(outputAmount);
    LXHEncodeObjectStament(fees);
    LXHEncodeObjectStament(txid);
    LXHEncodeObjectStament(inputs);
    LXHEncodeObjectStament(outputs);
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

//由于当前支持P2PKH (Pay To PubKey Hash)地址
//当前交易里来自当前钱包地址的输入和，也就是从当前钱包转出去的总值
- (NSDecimalNumber *)sentValueSumFromLocalAddress {
    if (_sentValueSumFromLocalAddress)
        return _sentValueSumFromLocalAddress;
    NSArray *inputs = self.inputs;
    NSDecimalNumber *sum = [NSDecimalNumber zero];
    NSArray *usedAndCurrentAddresses = [[LXHWallet mainAccount] usedAndCurrentAddresses];
    for (LXHTransactionInput *input in inputs) {
        NSString *address = input.address;
        if (!address) //不应该发生
            continue;
        if (![usedAndCurrentAddresses containsObject:address])
            continue;
        NSString *value = input.value;
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
    NSArray *outputs = self.outputs;
    NSDecimalNumber *sum = [NSDecimalNumber zero];
    NSArray *usedAndCurrentAddresses = [[LXHWallet mainAccount] usedAndCurrentAddresses];
    for (LXHTransactionOutput *output in outputs) {
        NSString *addr = output.address;
        if (!addr)
            continue;
        if (![usedAndCurrentAddresses containsObject:addr])
            continue;
        NSString *value = output.value;
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
