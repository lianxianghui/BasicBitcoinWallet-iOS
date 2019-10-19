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

@interface LXHTransaction : NSObject <NSCoding>

@property (nonatomic) NSString * blockhash;
@property (nonatomic) NSString *block;
@property (nonatomic) NSString *time;
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
- (NSArray<LXHTransactionOutput *> *)utxos;//Unspent Transaction Outputs
@end

NS_ASSUME_NONNULL_END
