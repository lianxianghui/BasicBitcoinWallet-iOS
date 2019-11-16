//
//  LXHSendViewControllerHelper.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/11.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSendViewControllerHelper.h"
#import "LXHTransactionOutput.h"

@interface LXHSendViewControllerHelper ()
//keys @"selectedUtxos", @"outputs", @"selectedFeeRateItem",@"inputFeeRate"
@property (nonatomic) NSDictionary *dataForBuildingTransaction;
@end

@implementation LXHSendViewControllerHelper

- (instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _dataForBuildingTransaction = data;
    }
    return self;
}

- (NSArray<LXHTransactionOutput *> *)inputs { //utxos
    return _dataForBuildingTransaction[@"selectedUtxos"];
}

- (NSArray<LXHTransactionOutput *> *)outputs {
    return _dataForBuildingTransaction[@"outputs"];
}

- (NSUInteger)inputCount {
    NSUInteger inputCount = [self inputs].count;
    if (inputCount == 0)
        inputCount = 1;//至少得有一个输入
    return inputCount;
}

- (NSUInteger)outputCount {
    NSInteger outputCount = [self outputs].count;
    if (outputCount == 0)
        outputCount = 1;//至少得有一个输出
    return outputCount;
}

//继续  构造交易的过程。
//两种发送方式

- (NSInteger)estimatedFeeInSat {
    return 0;
}
//
//- (NSInteger)maxOutputsAmountExceptEstimatedFeeInSat {
//    return 0;
//}

@end
