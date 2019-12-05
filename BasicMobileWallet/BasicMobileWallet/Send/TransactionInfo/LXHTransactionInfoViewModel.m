//
//  LXHTransactionInfoViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionInfoViewModel.h"
#import "LXHTransactionOutput.h"
#import "BlocksKit.h"
#import "LXHAddress.h"
#import "CoreBitcoin.h"
#import "LXHTransactionTextViewModel.h"

@interface LXHTransactionInfoViewModel ()
@property (nonatomic) NSArray<LXHTransactionOutput *> *inputs;
@property (nonatomic) NSArray<LXHTransactionOutput *> *outputs;
@property (nonatomic) BTCTransaction *unsignedBTCTransaction;
@property (nonatomic) BTCTransaction *signedBTCTransaction;
@end

@implementation LXHTransactionInfoViewModel

- (instancetype)initWithInputs:(NSArray<LXHTransactionOutput *> *)inputs outputs:(NSArray<LXHTransactionOutput *> *)outputs {
    self = [super init];
    if (self) {
        _inputs = inputs;
        _outputs = outputs;
    }
    return self;
}

//输入：两个输入，共0.01BTC
//输出：两个输出（包含一个找零），共0.00986BTC
//交易手续费：0.00014BTC
- (NSString *)infoDescription {
    NSMutableString *info = [NSMutableString string];
    //输入
    NSDecimalNumber *inputValueSum = [LXHTransactionOutput valueSumOfOutputs:_inputs];//"inputs" is array of UTXO
    [info appendFormat:NSLocalizedString(@"输入：%ld个输入，共%@BTC\n", nil), _inputs.count, inputValueSum];
    //输出
    NSDecimalNumber *outputValueSum = [LXHTransactionOutput valueSumOfOutputs:_outputs];
    NSArray *changeOutputs = [_outputs bk_select:^BOOL(LXHTransactionOutput *obj) {
        if (obj.address.isLocalAddress)
            return obj.address.localAddressType == LXHLocalAddressTypeChange;
        return NO;
    }];
    NSString *changeInfo = changeOutputs.count > 0 ? [NSString stringWithFormat:NSLocalizedString(@"（包含%ld个找零）", nil), changeOutputs.count] : @"";
    [info appendFormat:NSLocalizedString(@"输出：%ld个输出%@，共%@BTC\n", nil), _outputs.count, changeInfo, outputValueSum];
    //手续费
    NSDecimalNumber *fee = [inputValueSum decimalNumberBySubtracting:outputValueSum];
    [info appendFormat:NSLocalizedString(@"交易手续费：%@BTC\n", nil), fee];
    return info;
}

- (NSDictionary *)unsignedTransactionDictionary {
    return [self.unsignedBTCTransaction dictionary];
}

- (NSDictionary *)signedTransactionDictionary {
    return [self.signedBTCTransaction dictionary];
}

- (BTCTransaction *)signedBTCTransaction {
    if (_signedBTCTransaction) {
        _signedBTCTransaction = self.unsignedBTCTransaction;
        //todo sign
    }
    return _signedBTCTransaction;
}

- (BTCTransaction *)unsignedBTCTransaction {
    if (!_unsignedBTCTransaction) {
        BTCTransaction *transaction = [[BTCTransaction alloc] init];
        [_inputs enumerateObjectsUsingBlock:^(LXHTransactionOutput * _Nonnull utxo, NSUInteger idx, BOOL * _Nonnull stop) {
            BTCTransactionInput *input = [[BTCTransactionInput alloc] init];
            input.previousTransactionID = utxo.txid;
            input.previousIndex = (uint32_t)utxo.index;
            [transaction addInput:input];
        }];
        [_outputs enumerateObjectsUsingBlock:^(LXHTransactionOutput * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BTCAddress *address = [BTCAddress addressWithString:obj.address.base58String];
            NSDecimalNumber *valueInSat = [obj.value decimalNumberByMultiplyingByPowerOf10:8];
            BTCAmount value = BTCAmountFromDecimalNumber(valueInSat);
            BTCTransactionOutput *output = [[BTCTransactionOutput alloc] initWithValue:value address:address];
            [transaction addOutput:output];
        }];
        _unsignedBTCTransaction = transaction;
    }
    return _unsignedBTCTransaction;
}

- (LXHTransactionTextViewModel *)unsignedTransactionTextViewModel {
    LXHTransactionTextViewModel *viewModel = [[LXHTransactionTextViewModel alloc] initWithData:[self unsignedTransactionDictionary]];
    return viewModel;
}
- (LXHTransactionTextViewModel *)signedTransactionTextViewModel {
    LXHTransactionTextViewModel *viewModel = [[LXHTransactionTextViewModel alloc] initWithData:[self unsignedTransactionDictionary]];
    return viewModel;
}

- (void)pushSignedTransaction {
    //todo self.signedBTCTransaction.hex
}

@end
