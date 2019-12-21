//
//  LXHOutputDetailViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHOutputDetailViewModel.h"
#import "LXHTransactionOutput.h"
#import "LXHTransactionDataManager.h"
#import "LXHTransactionDetailViewModel.h"

@interface LXHOutputDetailViewModel ()
@property (nonatomic) LXHTransactionOutput *model;
@property (nonatomic) NSMutableArray *dataForCells;
@end

@implementation LXHOutputDetailViewModel

- (instancetype)initWithOutput:(LXHTransactionOutput *)output
{
    self = [super init];
    if (self) {
        _model = output;
    }
    return self;
}

- (NSMutableArray *)dataForCells {
    if (!_dataForCells) {
        _dataForCells = [NSMutableArray array];
        NSDictionary *dic = nil;
        dic = @{@"title":@"地址Base58 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": _model.address.base58String ?: @""};
        [_dataForCells addObject:dic];
        NSString *valueText = _model.value ? [NSString stringWithFormat:@"%@ BTC", _model.value] : @"";
        dic = @{@"title":@"输出数量 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": valueText};
        [_dataForCells addObject:dic];
        dic = @{@"content":_model.lockingScript ?: @"", @"isSelectable":@"1", @"title":@"锁定脚本", @"cellType":@"LXHLockingScriptCell"};
        [_dataForCells addObject:dic];
        dic = @{@"title":@"脚本类型 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": [self scriptTypeText]};
        [_dataForCells addObject:dic];
        dic = @{@"title":@"使用情况", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell",
                @"text": [_model isUnspent] ? @"未花费" : @"已花费"};
        [_dataForCells addObject:dic];
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyWithSeparatorCell"};
        [_dataForCells addObject:dic];
        dic = @{@"text":@"所在交易", @"isSelectable":@"1", @"cellType":@"LXHOutputDetailTextRightIconCell"};
        [_dataForCells addObject:dic];
    }
    return _dataForCells;
}

- (NSString *)scriptTypeText {
    switch (_model.scriptType) {
        case LXHLockingScriptTypeUnSupported:
            return NSLocalizedString(@"无法识别", nil);
            break;
        case LXHLockingScriptTypeP2PKH:
            return NSLocalizedString(@"P2PKH (Pay-to-Public-Key-Hash)", nil);
            break;
        case LXHLockingScriptTypeP2SH:
            return NSLocalizedString(@"Pay-to-Script-Hash (P2SH)", nil);
            break;
        default:
            return NSLocalizedString(@"无法识别", nil);
            break;
    }
}

- (id)transactionDetailViewModel {
    if (!_model.txid)
        return nil;
    LXHTransaction *transaction = [[LXHTransactionDataManager sharedInstance] transactionByTxid:_model.txid];
    if (!transaction)
        return nil;
    id viewModel = [[LXHTransactionDetailViewModel alloc] initWithTransaction:transaction];
    return viewModel;
}

@end