//
//  LXHSignatureUtils.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSignatureUtils.h"
#import "BlocksKit.h"
#import "LXHWallet.h"

@implementation LXHSignatureUtils

+ (NSArray *)outputBase58AddressesWithBTCOutputs:(NSArray<BTCTransactionOutput *> *)btcOutputs networkType:(LXHBitcoinNetworkType)networkType {
    NSArray *outputBase58Addresses = [btcOutputs bk_map:^id(BTCTransactionOutput *btcOutput) {
        BTCScript *lockingScript = btcOutput.script;
        BTCScriptChunk *chunk;
        BTCAddress *address;
        NSString *addressClassString;
        if (lockingScript.isPayToPublicKeyHashScript) {
             chunk = lockingScript.scriptChunks[2];
            if (networkType == LXHBitcoinNetworkTypeMainnet)
                addressClassString = @"BTCPublicKeyAddress";
            else if (networkType == LXHBitcoinNetworkTypeTestnet)
                addressClassString = @"BTCPublicKeyAddressTestnet";
        } else if (lockingScript.isPayToScriptHashScript) {
            chunk = lockingScript.scriptChunks[1];
            if (networkType == LXHBitcoinNetworkTypeMainnet)
                addressClassString = @"BTCScriptHashAddress";
            else if (networkType == LXHBitcoinNetworkTypeTestnet)
                addressClassString = @"BTCScriptHashAddressTestnet";
        } else {
            return @"unsupported locking script type";
        }
        address = [NSClassFromString(addressClassString) addressWithData:chunk.pushdata];
        return address.string;
    }];
    return outputBase58Addresses;
}

+ (NSArray *)inputBase58AddressesWithUnsignedBTCInputs:(NSArray<BTCTransactionInput *> *)btcInputs networkType:(LXHBitcoinNetworkType)networkType {
    NSArray *ret = [btcInputs bk_map:^id(BTCTransactionInput *input) {
        BTCScript *lockingScript = input.signatureScript;
        if (lockingScript.isPayToPublicKeyHashScript) {
            BTCScriptChunk *chunk = lockingScript.scriptChunks[2];
            BTCAddress *address;
            if (networkType == LXHBitcoinNetworkTypeMainnet)
                address = [BTCPublicKeyAddress addressWithData:chunk.pushdata];
            else if (networkType == LXHBitcoinNetworkTypeTestnet)
                address = [BTCPublicKeyAddressTestnet addressWithData:chunk.pushdata];
            return address.string;
        } else {
            return @"unsupported locking script type";
        }
    }];
    return ret;
}

+ (NSArray *)inputBase58AddressesWithSignedBTCInputs:(NSArray<BTCTransactionInput *> *)btcInputs networkType:(LXHBitcoinNetworkType)networkType {
    NSArray *ret = [btcInputs bk_map:^id(BTCTransactionInput *input) {
        BTCScriptChunk *chunk = input.signatureScript.scriptChunks[1];
        BTCAddress *address;
        NSData *publicKey = chunk.pushdata;
        if (networkType == LXHBitcoinNetworkTypeMainnet) {
            address = [BTCPublicKeyAddress addressWithData:BTCHash160(publicKey)];
        } else if (networkType == LXHBitcoinNetworkTypeTestnet) {
            address = [BTCPublicKeyAddressTestnet addressWithData:BTCHash160(chunk.pushdata)];
        }
        return address.string;
    }];
    return ret;
}

//+ (BTCAddress *)btcAddress

+ (BTCTransaction *)signBTCTransaction:(BTCTransaction *)unsignedBTCTransaction {
    BTCTransaction *transaction = [unsignedBTCTransaction copy];
    NSArray *inputs = transaction.inputs;
    for (uint32_t index = 0; index < inputs.count; index++) {
        BTCTransactionInput *input = inputs[index];
        BTCScript *lockingScript = input.signatureScript;//未签名时input.signatureScript存的是PayToPublicKeyHash的锁定脚本
        NSData *hash = [transaction signatureHashForScript:lockingScript inputIndex:index hashType:BTCSignatureHashTypeAll error:nil];
        if (!hash)
            return nil;
        NSData *publicKeyHash = [lockingScript.scriptChunks[2] pushdata];//第三项是公钥哈希
        if (!publicKeyHash)
            return nil;
        LXHAddress *address = [LXHWallet.mainAccount localAddressWithPublicKeyHash:publicKeyHash];//只从已经生成的范围内查找
        if (!address)
            return nil;
        NSData *signature = [LXHWallet signatureWithNetType:LXHWallet.mainAccount.currentNetworkType path:address.localAddressPath hash:hash];
        NSData *publicKey = [LXHWallet.mainAccount publicKeyWithLocalAddress:address];
        if (!signature || !publicKey)
            return nil;
        BTCScript *unlockingScript = [[BTCScript alloc] init];
        [unlockingScript appendData:signature];
        [unlockingScript appendData:publicKey];
        input.signatureScript = unlockingScript;
    }
    return transaction;
}

@end
