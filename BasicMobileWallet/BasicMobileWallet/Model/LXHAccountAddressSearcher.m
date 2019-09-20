//
//  LXHAccountAddressSearcher.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAccountAddressSearcher.h"
#import "LXHNetworkRequest.h"
#import "NSJSONSerialization+VLBase.h"
#import "CoreBitcoin.h"
#import "LXHTransactionDataManager.h"

@interface LXHAccountAddressSearcher ()
@property (nonatomic) LXHAccount *account;
@end

@implementation LXHAccountAddressSearcher

- (instancetype)initWithAccount:(LXHAccount *)account {
    self = [super init];
    if (self) {
        _account = account;
    }
    return self;
}

- (void)searchWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
                  failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSMutableArray *allTransactions = [NSMutableArray array];
    [self searchFirstUnusedReceivingAddressesGapFromIndex:0 allTransactions:allTransactions successBlock:^(NSDictionary *resultDic) {
        NSNumber *FirstUnusedReceivingAddressesGapStartIndex = resultDic[@"FirstUnusedReceivingAddressesGapStartIndex"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"currentUnusedReceivingAddressIndex"] = FirstUnusedReceivingAddressesGapStartIndex;
        //allTransactions是搜索UnusedReceivingAddressesGap过程中从网络获取的
        //因为找零肯定都是从接收地址发出去的，所以包含找零地址的交易肯定都在allTransactions中
        //这里直接使用allTransactions获取下一个找零地址
        dic[@"currentUnusedChangeAddressIndex"] = @([self currentUnusedChangeAddressIndexWithAllTransactions:allTransactions]);
        dic[@"allTransactions"] = allTransactions;
        successBlock(dic);
    } failureBlock:^(NSDictionary *resultDic) {
        failureBlock(resultDic);
    }];
}

/**
 找到当前账户的第一个未使用的ReceivingAddressGap, gap limit为20
 具体逻辑参考https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki#Account_discovery
 异步+递归的实现稍微有点复杂
 返回值有两个：1.通过successBlock返回第一个未使用ReceivingAddressGap的起始index 2.通过一开始传入的allTransactions NSMutableArray累积从网络获取的交易数据
 */
- (void)searchFirstUnusedReceivingAddressesGapFromIndex:(NSUInteger)fromIndex
                         allTransactions:(NSMutableArray *)allTransactions
                            successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                            failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    uint32_t gapLimit = 20;
    NSArray *addressesForRequesting = [_account.receivingLevel addressesFromIndex:(uint32_t)fromIndex count:gapLimit];
    //异步请求，通过successBlock传回事务数据
    [LXHTransactionDataManager requestTransactionsWithNetworkType:_account.currentNetworkType addresses:addressesForRequesting successBlock:^(NSDictionary *resultDic) {
        NSArray *transactions = resultDic[@"items"];
        if (transactions.count == 0) { //未找到新的交易，说明当前的20个地址都未用过，所以就是要找的Gap
            successBlock(@{@"FirstUnusedReceivingAddressesGapStartIndex":@(fromIndex)});
        } else {
            [allTransactions addObjectsFromArray:transactions];
            //查找从哪里开始进行下一次搜索
            NSSet *allInAddressesSet = [self inAddressesWithTransactions:transactions];//所有可能的接收地址
            //总共20个请求地址。现在从后往前查，找到第一个用过的地址index，然后以这个index+1为fromIndex递归调用
            for (NSInteger i = addressesForRequesting.count-1; i >= 0; i--) {
                NSString *address = addressesForRequesting[i];
                if ([allInAddressesSet containsObject:address]) {//找到第一个使用过的地址
                    NSUInteger nextFromIndex = fromIndex + i + 1;
                    [self searchFirstUnusedReceivingAddressesGapFromIndex:nextFromIndex allTransactions:allTransactions successBlock:successBlock failureBlock:failureBlock];
                    return;
                }
            }
            NSAssert(YES, @"");//不应该到这里，因为如果有交易返回，说明在地址中肯定有用过的，所以一定能走到上面"找到第一个used地址"那里
            failureBlock(@{@"error":@"logic error"});
        }
    } failureBlock:^(NSDictionary *resultDic) {
        failureBlock(resultDic);
    }];
}

- (NSMutableSet *)inAddressesWithTransactions:(NSArray *)transactions {
    NSMutableSet *ret = [NSMutableSet set];
    for (NSDictionary *dic in transactions) {
        NSArray *vins = dic[@"vin"];
        for (NSDictionary *vin in vins) {
            if (vin[@"addr"])
                [ret addObject:vin[@"addr"]];
        }
    }
    return ret;
}

- (NSMutableSet *)outAddressesWithTransactions:(NSArray *)transactions {
    NSMutableSet *ret = [NSMutableSet set];
    for (NSDictionary *dic in transactions) {
        NSArray *vouts = dic[@"vout"];
        for (NSDictionary *vout in vouts) {
            NSString *address = vout[@"scriptPubKey"][@"addresses"][0];//TODO check
            if (address)
                [ret addObject:address];
        }
    }
    return ret;
}

- (NSInteger)currentUnusedChangeAddressIndexWithAllTransactions:(NSArray *)allTransactions {
    NSSet *allOutAddressSet = [self outAddressesWithTransactions:allTransactions];
    NSInteger maxPossibleUsedChangeAddressCount = allOutAddressSet.count; //找零地址肯定在allOutAddressSet里面，所以最大不会超过allOutAddressSet的数量
    for (NSInteger i = maxPossibleUsedChangeAddressCount-1; i >= 0; i--) { //找到倒数第一个用过的，也就是最后一个用过的，加一就得到下一个准备使用的找零地址
        NSString *changeAddress = [_account.changeLevel addressStringWithIndex:(uint32_t)i];
        if ([allOutAddressSet containsObject:changeAddress])
            return i+1;
    }
    return 0;//没有使用过找零地址
}
@end
