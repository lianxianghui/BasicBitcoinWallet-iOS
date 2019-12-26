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
        if (lockingScript.isPayToPublicKeyHashScript) {
            BTCScriptChunk *chunk = btcOutput.script.scriptChunks[2];
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
    return outputBase58Addresses;
}

+ (BTCTransaction *)signBTCTransaction:(BTCTransaction *)unsignedBTCTransaction {
    BTCTransaction *transaction = [unsignedBTCTransaction copy];
    __block BOOL hasError = NO;
    [transaction.inputs enumerateObjectsUsingBlock:^(BTCTransactionInput *input, NSUInteger idx, BOOL * _Nonnull stop) {
        uint32_t index = (uint32_t)idx;
        BTCScript *lockingScript = input.signatureScript;//未签名时input.signatureScript存的是PayToPublicKeyHash的锁定脚本
        NSData *publicKeyHash = [lockingScript.scriptChunks[2] pushdata];//第三项是公钥哈希
        NSData *hash = [transaction signatureHashForScript:lockingScript inputIndex:index hashType:BTCSignatureHashTypeAll error:nil];
        if (hash) {
            LXHAddress *address = [LXHWallet.mainAccount localAddressWithPublicKeyHash:publicKeyHash];
            NSData *signature = [LXHWallet signatureWithNetType:LXHWallet.mainAccount.currentNetworkType path:address.localAddressPath hash:hash];
            NSData *publicKey = [LXHWallet.mainAccount publicKeyWithLocalAddress:address];
            //                NSData *publicKeyHash = BTCHash160(publicKey);
            //                NSAssert([publicKeyHash isEqual:[lockingScript.scriptChunks[2] pushdata]], @"锁定脚本的第三项是公钥哈希");
            BTCScript *unlockingScript = [[BTCScript alloc] init];
            [unlockingScript appendData:signature];
            [unlockingScript appendData:publicKey];
            BTCTransactionInput *input = transaction.inputs[idx];
            input.signatureScript = unlockingScript;
        } else {
            hasError = YES;
            *stop = YES;
        }
    }];
    if (hasError)
        return nil;
    return transaction;
}

@end
