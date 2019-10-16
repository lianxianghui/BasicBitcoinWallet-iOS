//
//  LXHTransaction.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LXHTransactionSendOrReceiveType) {
    LXHTransactionSendOrReceiveTypeNotDefined,
    LXHTransactionSendOrReceiveTypeSend,
    LXHTransactionSendOrReceiveTypeReceive,
};

NS_ASSUME_NONNULL_BEGIN

@interface LXHTransaction : NSObject

- (instancetype)initWithDic:(NSDictionary *)dic;
 
- (LXHTransactionSendOrReceiveType)sendOrReceiveType;
//来自当前钱包地址的输入和，也就是从当前钱包转出去的总值
- (NSDecimalNumber *)sentValueSumFromLocalAddress;
//当前钱包收到的总值
- (NSDecimalNumber *)receivedValueSumFromLocalAddress;

- (NSDecimalNumber *)fees;

- (NSString *)outAddressAtIndex:(NSInteger)index;

@property (nonatomic, readonly) NSDictionary *dic;

//其它属性可以直接从dic里读
@property (nonatomic) NSString * blockhash;// = 00000000020b45260487556b38924f222c36837d4f0f4b5556b35a0a1ca26583;
@property (nonatomic) NSString *blockheight;// = 1576427;
@property (nonatomic) NSString *blocktime;// = 1567157500;
@property (nonatomic) NSString *confirmations;// = 717;
//@property (nonatomic) NSString *fees = "0.0003";
//locktime = 0;
//size = 191;
//time = 1567157500;
@property (nonatomic) NSString *txid;// = 71e8a069e7ce8985c3e260cdb0bde4d50d0294c42704b102f3b1ac5db0f9d2b9;
//valueIn = "0.03";
//valueOut = "0.0297";
//version = 1;
@end

NS_ASSUME_NONNULL_END
