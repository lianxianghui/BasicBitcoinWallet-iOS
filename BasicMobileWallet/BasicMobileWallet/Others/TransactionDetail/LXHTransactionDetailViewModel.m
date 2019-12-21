//
//  LXHTransactionDetailViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionDetailViewModel.h"
#import "LXHTransaction.h"
#import "LXHGlobalHeader.h"
#import "LXHOutputDetailViewModel.h"
#import "LXHInputDetailViewModel.h"

@interface LXHTransactionDetailViewModel ()
@property (nonatomic) LXHTransaction *transaction;
@property (nonatomic) NSMutableArray *dataForCells;
@end

@implementation LXHTransactionDetailViewModel

- (instancetype)initWithTransaction:(LXHTransaction *)transaction {
    self = [super init];
    if (self) {
        _transaction = transaction;
    }
    return self;
}

- (NSMutableArray *)dataForCells {
    if (!_dataForCells) {
        NSMutableArray *dataForCells = [NSMutableArray array];
        //txid
        NSMutableDictionary *dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTransactionCell", @"title":@"交易ID: "}.mutableCopy;
        LXHTransaction *transaction = _transaction;
        dataForCell[@"content"] = transaction.txid;
        [dataForCells addObject:dataForCell];
        
        NSDictionary *lxhTextCellDataDic = @{@"isSelectable":@"1", @"cellType":@"LXHTextCell"};
        //type
        dataForCell = lxhTextCellDataDic.mutableCopy;
        LXHTransactionSendOrReceiveType sendType = [_transaction sendOrReceiveType];
        NSString *typeString = nil;
        if (sendType == LXHTransactionSendOrReceiveTypeSend) {
            typeString = @"发送";
        } else if (sendType == LXHTransactionSendOrReceiveTypeReceive) {
            typeString = @"接收";
        } else {
            typeString = @"";
        }
        typeString = NSLocalizedString(typeString, nil);
        dataForCell[@"text"] = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"交易类型", nil), typeString];
        [dataForCells addObject:dataForCell];
        
        //交易发起时间
        dataForCell = lxhTextCellDataDic.mutableCopy;
        static NSDateFormatter *formatter = nil;
        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = NSLocalizedString(LXHTranactionTimeDateFormat, nil);
        }
        
        NSInteger firstSeen = [transaction.firstSeen integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:firstSeen];
        NSString *dateString = [formatter stringFromDate:date];
        dataForCell[@"text"] = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"发起时间", nil), dateString];
        [dataForCells addObject:dataForCell];
        
        //打包时间
        dataForCell = lxhTextCellDataDic.mutableCopy;
        NSInteger time = [transaction.time integerValue];
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time];
        NSString *dateString1 = transaction.time ? [formatter stringFromDate:date1] : NSLocalizedString(@"尚未打包进区块", nil);
        dataForCell[@"text"] = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"打包时间", nil), dateString1];
        [dataForCells addObject:dataForCell];
        
        //confirmations
        dataForCell = lxhTextCellDataDic.mutableCopy;
        id confirmation = transaction.confirmations;
        dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"确认数", nil), confirmation];
        [dataForCells addObject:dataForCell];
        
        //block
        dataForCell = lxhTextCellDataDic.mutableCopy;
        NSString *block = transaction.block ?: NSLocalizedString(@"尚未打包进区块", nil);
        dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"区块", nil), block];
        [dataForCells addObject:dataForCell];
        //valueIn
        dataForCell = lxhTextCellDataDic.mutableCopy;
        dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@ BTC", NSLocalizedString(@"输入数量", nil), transaction.inputAmount];
        [dataForCells addObject:dataForCell];
        //valueOut
        dataForCell = lxhTextCellDataDic.mutableCopy;
        dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@ BTC", NSLocalizedString(@"输出数量", nil), transaction.outputAmount];
        [dataForCells addObject:dataForCell];
        
        //fees
        dataForCell = lxhTextCellDataDic.mutableCopy;
        dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@ BTC", NSLocalizedString(@"手续费", nil), _transaction.fees];
        [dataForCells addObject:dataForCell];
        
        dataForCell = lxhTextCellDataDic.mutableCopy;
        NSString *isCoinbase = _transaction.coinbase ? @"是" : @"否";
        isCoinbase = NSLocalizedString(isCoinbase, nil);
        dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"币基交易", nil), isCoinbase];
        [dataForCells addObject:dataForCell];
        
        //in title
        dataForCell = @{@"isSelectable":@"0", @"cellType":@"LXHTitleCell"}.mutableCopy;
        dataForCell[@"title"] = NSLocalizedString(@"输入", nil);
        [dataForCells addObject:dataForCell];
        //vin
        for (NSInteger i = 0; i < [_transaction.inputs count]; i++) {
            LXHTransactionInput *input = [_transaction.inputs objectAtIndex:i];
            dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTransDetailLeftRightTextCell"}.mutableCopy;
            dataForCell[@"text1"] = [NSString stringWithFormat:@"%ld. %@", i+1, input.address];
            dataForCell[@"text2"] = [NSString stringWithFormat:@"%@ BTC", input.value];
            dataForCell[@"data"] = input;
            [dataForCells addObject:dataForCell];
        }
        
        //out title
        dataForCell = @{@"isSelectable":@"0", @"cellType":@"LXHTitleCell"}.mutableCopy;
        dataForCell[@"title"] = NSLocalizedString(@"输出", nil);
        [dataForCells addObject:dataForCell];
        
        //vout
        for (NSInteger i = 0; i < [_transaction.outputs count]; i++) {
            LXHTransactionOutput *output = [_transaction.outputs objectAtIndex:i];
            dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTransDetailLeftRightTextCell"}.mutableCopy;
            dataForCell[@"text1"] = [NSString stringWithFormat:@"%ld. %@", i+1, output.address];
            dataForCell[@"text2"] = [NSString stringWithFormat:@"%@ BTC", output.value];
            dataForCell[@"data"] = output;
            [dataForCells addObject:dataForCell];
        }
        _dataForCells = dataForCells;
    }
    return _dataForCells;
}

- (NSDictionary *)controllerInfoAtIndex:(NSInteger)index {
    id dataForRow = self.dataForCells[index];
    id data = [dataForRow valueForKey:@"data"];
    NSString *controllerClassName;
    id viewModel;
    if ([data isKindOfClass:[LXHTransactionInput class]]) {
        LXHTransactionInput *input = (LXHTransactionInput *)data;
        controllerClassName = @"LXHInputDetailViewController";
        viewModel = [[LXHInputDetailViewModel alloc] initWithInput:input];
    } else if ([data isKindOfClass:[LXHTransactionOutput class]]) {
        LXHTransactionOutput *output = (LXHTransactionOutput *)data;
        controllerClassName = @"LXHOutputDetailViewController";
        viewModel = [[LXHOutputDetailViewModel alloc] initWithOutput:output];
    } else {
        return nil;
    }
    return @{@"controllerClassName":controllerClassName, @"viewModel":viewModel};
}

@end

