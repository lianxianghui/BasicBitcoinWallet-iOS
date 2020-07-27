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
#import "BlocksKit.h"

@interface LXHTransaction ()
@property (nonatomic) NSDecimalNumber *sentValueSumFromLocalAddress;
@property (nonatomic) NSDecimalNumber *receivedValueSumFromLocalAddress;
@end

@implementation LXHTransaction

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
//    LXHDecodeObjectOfStringClassStament(blockhash);
    LXHDecodeObjectOfStringClassStament(block);
    LXHDecodeObjectOfStringClassStament(firstSeen);
    LXHDecodeObjectOfStringClassStament(time);
    LXHDecodeObjectOfStringClassStament(confirmations);
    LXHDecodeObjectOfDecimalNumberClassStament(inputAmount);
    LXHDecodeObjectOfDecimalNumberClassStament(outputAmount);
    LXHDecodeObjectOfDecimalNumberClassStament(fees);
    LXHDecodeObjectOfStringClassStament(txid);
    LXHDecodeBOOLTypeStament(coinbase);
    LXHDecodeObjectOfMutableArrayClassStament(inputs);
    LXHDecodeObjectOfMutableArrayClassStament(outputs);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
//    LXHEncodeObjectStament(blockhash);
    LXHEncodeObjectStament(block);
    LXHEncodeObjectStament(firstSeen);
    LXHEncodeObjectStament(time);
    LXHEncodeObjectStament(confirmations);
    LXHEncodeObjectStament(inputAmount);
    LXHEncodeObjectStament(outputAmount);
    LXHEncodeObjectStament(fees);
    LXHEncodeObjectStament(txid);
    LXHEncodeBOOLStament(coinbase);
    LXHEncodeObjectStament(inputs);
    LXHEncodeObjectStament(outputs);
}

//- (BOOL)isEqual:(id)object {
//    if (object == self)
//        return YES;
//    if (![object isMemberOfClass:[LXHTransaction class]])
//        return NO;
//    LXHTransaction *transaction = (LXHTransaction *)object;
//    return [self.txid isEqualToString:transaction.txid];
//}

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
    NSArray *usedAndCurrentAddresses = [[LXHWallet mainAccount] usedAndCurrentAddresses];
    //用Reduce累加
    _sentValueSumFromLocalAddress = [self.inputs bk_reduce:[NSDecimalNumber zero] withBlock:^id(NSDecimalNumber *sum, LXHTransactionInput *input) {
        NSString *address = input.address.base58String;
        if (!address) //不应该发生
            return sum;
        if (![usedAndCurrentAddresses containsObject:address])
            return sum;
        NSDecimalNumber *value = input.valueBTC;
        if (!value)
            return sum;
        sum = [sum decimalNumberByAdding:value];
        return sum;
    }];
    return _sentValueSumFromLocalAddress;
}

//当前钱包收到的总值
- (NSDecimalNumber *)receivedValueSumFromLocalAddress {
    if (_receivedValueSumFromLocalAddress)
        return _receivedValueSumFromLocalAddress;
    NSArray *usedAndCurrentAddresses = [[LXHWallet mainAccount] usedAndCurrentAddresses];
    //用Reduce累加
    _receivedValueSumFromLocalAddress = [self.outputs bk_reduce:[NSDecimalNumber zero] withBlock:^id(NSDecimalNumber *sum, LXHTransactionOutput *output) {
        NSString *address = output.address.base58String;
        if (!address) //不应该发生
            return sum;
        if (![usedAndCurrentAddresses containsObject:address])
            return sum;
        NSDecimalNumber *value = output.valueBTC;
        if (!value)
            return sum;
        sum = [sum decimalNumberByAdding:value];
        return sum;
    }];
    return _receivedValueSumFromLocalAddress;
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

- (NSArray<LXHTransactionOutput *> *)myUtxos {
    NSArray *usedAndCurrentAddresses = [[LXHWallet mainAccount] usedAndCurrentAddresses];
    NSSet *usedAndCurrentAddressesSet = [NSSet setWithArray:usedAndCurrentAddresses];
    return [self.outputs bk_select:^BOOL(LXHTransactionOutput *obj) {
        return [usedAndCurrentAddressesSet containsObject:obj.address.base58String] && [obj isUnspent];
    }];
}

@end
