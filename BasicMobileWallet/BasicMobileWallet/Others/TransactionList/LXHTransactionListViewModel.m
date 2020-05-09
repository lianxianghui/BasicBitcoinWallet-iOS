//
//  LXHTransactionListViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionListViewModel.h"
#import "LXHTransactionDataManager.h"
#import "LXHTransaction.h"
#import "BlocksKit.h"
#import "LXHTransactionDetailViewModel.h"
#import "NSDecimalNumber+Convenience.h"

@interface LXHTransactionListViewModel ()
@property (nonatomic) NSString *observerToken;
@end

@implementation LXHTransactionListViewModel

- (NSArray<LXHTransaction *> *)transactionList {
    return [LXHTransactionDataManager sharedInstance].transactionList;
}

- (NSString *)updatedTimeText {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = NSLocalizedString(LXHTranactionTimeDateFormat, nil);
    }
    NSDate *updatedTime = [LXHTransactionDataManager sharedInstance].dataUpdatedTime;
    if (updatedTime) {
        NSString *dateString = [formatter stringFromDate:updatedTime];
        return [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"更新时间", nil), dateString];
    } else {
        return @"";
    }
}

- (NSMutableArray *)dataForCells {
    if (!_dataForCells) {
        _dataForCells = [NSMutableArray array];
        NSArray *transactionList = [self transactionList];
        for (LXHTransaction *transaction in transactionList) {
            //                NSDictionary *dic = @{@"value":@"0.00000001BTC", @"isSelectable":@"1", @"confirmation":@"确认数：2", @"InitializedTime":@"发起时间：2019-05-16  12：34", @"cellType":@"LXHTransactionInfoCell", @"type":@"交易类型：发送"};
            
            NSMutableDictionary *dic = @{@"isSelectable":@"1", @"cellType":@"LXHTransactionInfoCell"}.mutableCopy;
            
            id confirmation = transaction.confirmations;
            if (confirmation)
                dic[@"confirmation"] = [NSString stringWithFormat: @"%@:%@", NSLocalizedString(@"确认数", nil), confirmation];
            else
                dic[@"confirmation"] = @"";
            static NSDateFormatter *formatter = nil;
            if (!formatter) {
                formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = NSLocalizedString(LXHTranactionTimeDateFormat, nil);
            }
            NSInteger firstSeen = [transaction.firstSeen integerValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:firstSeen];
            NSString *dateString = [formatter stringFromDate:date];
            dic[@"InitializedTime"] = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"发起时间", nil), dateString];
            
            LXHTransactionSendOrReceiveType sendType = [transaction sendOrReceiveType];
            NSString *typeString = nil;
            NSDecimalNumber *receivedValueSum = [transaction receivedValueSumFromLocalAddress];
            NSDecimalNumber *sendValueSum = [transaction sentValueSumFromLocalAddress];
            NSDecimalNumber *value =  [receivedValueSum decimalNumberBySubtracting:sendValueSum];
            if (sendType == LXHTransactionSendOrReceiveTypeSend) {
                typeString = @"发送";
            } else if (sendType == LXHTransactionSendOrReceiveTypeReceive) {
                typeString = @"接收";
            } else { //应该不会发生
                typeString = @"未知";
            }
            typeString = NSLocalizedString(typeString, nil);
            dic[@"type"] = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"交易类型", nil), typeString];
            //正数前面加'+'
            NSString *valueString = value.description;
            if ([value greaterThanZero])
                valueString = [@"+" stringByAppendingString:valueString];
            dic[@"value"] = [NSString stringWithFormat:@"%@ BTC", valueString];
            dic[@"model"] = transaction;
            [_dataForCells addObject:dic];
        }
    }
    return _dataForCells;
}

- (void)resetDataForCells {
    _dataForCells = nil;
}

- (void)addObserverForUpdatedTransactinListWithCallback:(void (^)(void))updatedCallback {
    _observerToken =  [[LXHTransactionDataManager sharedInstance] bk_addObserverForKeyPath:@"transactionList" task:^(id target) {
        updatedCallback();
    }];
}

- (void)removeObserverForUpdatedTransactinList {
    if (_observerToken)
        [[LXHTransactionDataManager sharedInstance] bk_removeObserversWithIdentifier:_observerToken];
}

- (void)updateTransactionListDataWithSuccessBlock:(nullable void (^)(void))successBlock
                                     failureBlock:(nullable void (^)(NSString *errorPrompt))failureBlock {
    [[LXHTransactionDataManager sharedInstance] requestDataWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        successBlock();
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        NSError *error = resultDic[@"error"];
        NSString *format = NSLocalizedString(@"刷新失败:%@", nil);
        NSString *errorPrompt = [NSString stringWithFormat:format, error.localizedDescription];
        failureBlock(errorPrompt);
    }];
}

- (id)transactionDetailViewModelAtIndex:(NSInteger)index {
    NSDictionary *cellData = self.dataForCells[index];
    LXHTransaction *transaction = cellData[@"model"];
    if (!transaction)
        return nil;
    id viewModel = [[LXHTransactionDetailViewModel alloc] initWithTransaction:transaction];
    return viewModel;
}


@end
