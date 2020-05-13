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
