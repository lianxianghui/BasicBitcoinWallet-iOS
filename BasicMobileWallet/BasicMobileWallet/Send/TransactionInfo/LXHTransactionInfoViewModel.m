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
#import "LXHSignedTransactionTextViewModel.h"
#import "LXHUnsignedTransactionTextViewModel.h"
#import "LXHWallet.h"
#import "LXHTransactionDataRequest.h"
#import "LXHSignatureUtils.h"

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

//按以下格式生成字符串
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

- (NSDictionary *)dataWithBTCTransaction:(BTCTransaction *)transaction isSignedTransaction:(BOOL)isSignedTransaction {
    NSDictionary *transactionData = [transaction dictionary];
    NSArray *outputBase58Addresses = [LXHSignatureUtils outputBase58AddressesWithBTCOutputs:transaction.outputs networkType:LXHWallet.mainAccount.currentNetworkType];
    NSArray *inputBase58Addresses;
    if (isSignedTransaction)
        inputBase58Addresses = [LXHSignatureUtils inputBase58AddressesWithSignedBTCInputs:transaction.inputs networkType:LXHWallet.mainAccount.currentNetworkType];
    else
        inputBase58Addresses = [LXHSignatureUtils inputBase58AddressesWithUnsignedBTCInputs:transaction.inputs networkType:LXHWallet.mainAccount.currentNetworkType];
    NSString *network = [LXHBitcoinNetwork networkStringWithType:LXHWallet.mainAccount.currentNetworkType];
    NSDictionary *dataForCheckingAddresses = @{@"inputAddresses":inputBase58Addresses, @"outputAddresses":outputBase58Addresses, @"network":network};
    return @{@"transactionData":transactionData, @"dataForCheckingAddresses":dataForCheckingAddresses};
}

- (NSDictionary *)currentAddressIndexData {
    LXHAccount *mainAccount = [LXHWallet mainAccount];
    NSDictionary *currentAddressIndexData =
    @{@"currentReceivingAddressIndex":@(mainAccount.receiving.currentAddressIndex),
      @"currentChangeAddressIndex":@(mainAccount.change.currentAddressIndex)};
    return currentAddressIndexData;
}

- (NSDictionary *)unsignedTransactionData {
    NSMutableDictionary *dictionary = [self dataWithBTCTransaction:self.unsignedBTCTransaction isSignedTransaction:NO].mutableCopy;
    dictionary[@"dataType"] = @"unsignedTransaction";
    dictionary[@"currentAddressIndexData"] = [self currentAddressIndexData];
    return dictionary;
}

- (NSMutableDictionary *)signedTransactionData {
    NSMutableDictionary *dictionary = [self dataWithBTCTransaction:self.signedBTCTransaction isSignedTransaction:YES].mutableCopy;
    dictionary[@"dataType"] = @"signedTransaction";
    return dictionary;
}

- (BTCTransaction *)signedBTCTransaction {
    if (!_signedBTCTransaction) {
        _signedBTCTransaction = [LXHSignatureUtils signBTCTransaction:self.unsignedBTCTransaction];
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
            BTCScript *lockingScript = [[BTCScript alloc] initWithHex:utxo.lockingScriptHex];
            input.signatureScript = lockingScript;//临时的，put the output script here so the signer knows which key to use.
            [transaction addInput:input];
        }];
        [_outputs enumerateObjectsUsingBlock:^(LXHTransactionOutput * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BTCAddress *address = [BTCAddress addressWithString:obj.address.base58String];
            NSDecimalNumber *valueInSat = [obj.valueBTC decimalNumberByMultiplyingByPowerOf10:8];
            BTCAmount value = BTCAmountFromDecimalNumber(valueInSat);
            BTCTransactionOutput *output = [[BTCTransactionOutput alloc] initWithValue:value address:address];
            [transaction addOutput:output];
        }];
        _unsignedBTCTransaction = transaction;
    }
    return _unsignedBTCTransaction;
}

- (id)unsignedTransactionTextViewModel {
    LXHUnsignedTransactionTextViewModel *viewModel = [[LXHUnsignedTransactionTextViewModel alloc] initWithData:[self unsignedTransactionData]];
    return viewModel;
}
- (id)signedTransactionTextViewModel {
    LXHSignedTransactionTextViewModel *viewModel = [[LXHSignedTransactionTextViewModel alloc] initWithData:[self signedTransactionData]];
    return viewModel;
}

- (void)pushSignedTransactionWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                                 failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    
//    NSLog(@"正在发送的签名交易：%@", [self.signedBTCTransaction dictionary]);
    [LXHTransactionDataRequest pushTransactionsWithHex:self.signedBTCTransaction.hex successBlock:successBlock failureBlock:failureBlock];
}

- (BOOL)signatureButtonsEnabled {
    return [LXHWallet isFullFunctional];
}

@end
