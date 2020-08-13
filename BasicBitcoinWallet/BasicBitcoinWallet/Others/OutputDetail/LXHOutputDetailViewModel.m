//
//  LXHOutputDetailViewModel.m
//  BasicBitcoinWallet
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
        _showGotoTransactionCell = YES;
    }
    return self;
}

- (NSMutableArray *)dataForCells {
    if (!_dataForCells) {
        _dataForCells = [NSMutableArray array];
        NSDictionary *dic = nil;
        dic = @{@"title":@"地址Base58 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": _model.address.base58String ?: @""};
        [_dataForCells addObject:dic];
        NSString *valueText = _model.valueBTC ? [NSString stringWithFormat:@"%@ BTC", _model.valueBTC] : @"";
        dic = @{@"title":@"输出数量 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": valueText};
        [_dataForCells addObject:dic];
        dic = @{@"content":_model.lockingScript ?: @"", @"isSelectable":@"1", @"title":@"锁定脚本", @"cellType":@"LXHLockingScriptCell"};
        [_dataForCells addObject:dic];
        if (_model.scriptType != LXHLockingScriptTypeUnknown) {
            dic = @{@"title":@"脚本类型 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": [self scriptTypeText]};
            [_dataForCells addObject:dic];
        }
        dic = @{@"title":@"使用情况", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell",
                @"text": [_model isUnspent] ? @"未花费" : @"已花费"};
        [_dataForCells addObject:dic];
        if (_showGotoTransactionCell) {
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyWithSeparatorCell"};
            [_dataForCells addObject:dic];
            dic = @{@"text":@"所在交易", @"isSelectable":@"1", @"cellType":@"LXHOutputDetailTextRightIconCell", @"cellId":@"tx"};
            [_dataForCells addObject:dic];
        }
    }
    return _dataForCells;
}

+ (NSString *)scriptTypeTextWithLockingScriptType:(LXHLockingScriptType)lockingScriptType {
    switch (lockingScriptType) {
        case LXHLockingScriptTypeUnSupported:
            return NSLocalizedString(@"尚不支持", nil);
            break;
        case LXHLockingScriptTypeP2PKH:
            return NSLocalizedString(@"Pay-to-Public-Key-Hash (P2PKH)", nil);
            break;
        case LXHLockingScriptTypeP2SH:
            return NSLocalizedString(@"Pay-to-Script-Hash (P2SH)", nil);
            break;
        case LXHLockingScriptTypeP2WPKH:
            return NSLocalizedString(@"Pay-to-Witness-Public-Key-Hash (P2WPKH)", nil);
            break;
        case LXHLockingScriptTypeP2WSH:
            return NSLocalizedString(@"Pay-to-Witness-Script-Hash (P2WSH)", nil);
            break;
        case LXHLockingScriptTypeNullData:
            return NSLocalizedString(@"Null Data", nil);
            break;
        case LXHLockingScriptTypeMultisig:
            return NSLocalizedString(@"Multi-signature", nil);
            break;
        default:
            return NSLocalizedString(@"尚不支持", nil);
            break;
    }
}

- (NSString *)scriptTypeText {
    return [LXHOutputDetailViewModel scriptTypeTextWithLockingScriptType:_model.scriptType];
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

