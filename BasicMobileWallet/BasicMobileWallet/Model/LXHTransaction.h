//
//  LXHTransaction.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHTransactionInput.h"
#import "LXHTransactionOutput.h"

typedef NS_ENUM(NSUInteger, LXHTransactionSendOrReceiveType) {
    LXHTransactionSendOrReceiveTypeNotDefined,
    LXHTransactionSendOrReceiveTypeSend,
    LXHTransactionSendOrReceiveTypeReceive,
};


NS_ASSUME_NONNULL_BEGIN

@interface LXHTransaction : NSObject <NSSecureCoding>

@property (nonatomic) NSString * blockhash;
@property (nonatomic) NSString *block;
@property (nonatomic) NSString *firstSeen;//发起时间
@property (nonatomic) NSString *time;//打包进区块的时间
@property (nonatomic) NSString *confirmations;
@property (nonatomic) NSDecimalNumber *inputAmount;
@property (nonatomic) NSDecimalNumber *outputAmount;
@property (nonatomic) NSDecimalNumber *fees;
@property (nonatomic) NSString *txid;
@property (nonatomic) NSMutableArray<LXHTransactionInput *> *inputs;
@property (nonatomic) NSMutableArray<LXHTransactionOutput *> *outputs;

- (LXHTransactionSendOrReceiveType)sendOrReceiveType;
- (NSDecimalNumber *)sentValueSumFromLocalAddress;
- (NSDecimalNumber *)receivedValueSumFromLocalAddress;
- (NSArray<LXHTransactionOutput *> *)myUtxos;//Unspent Transaction Outputs of Local Address of Current Wallet
@end

NS_ASSUME_NONNULL_END
