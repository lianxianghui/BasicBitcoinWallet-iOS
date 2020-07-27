//
//  LXHInputDetailViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHInputDetailViewModel.h"
#import "LXHTransactionInput.h"
#import "LXHTransactionDataManager.h"
#import "LXHTransactionDataRequest.h"
#import "LXHTransactionDetailViewModel.h"
#import "LXHOutputDetailViewModel.h"

@interface LXHInputDetailViewModel ()
@property (nonatomic) LXHTransactionInput *input;
@property (nonatomic, readwrite) NSMutableArray *dataForCells;
@end

@implementation LXHInputDetailViewModel

- (instancetype)initWithInput:(LXHTransactionInput *)input {
    self = [super init];
    if (self) {
        _input = input;
    }
    return self;
}

- (NSArray *)dataForCells {
    if (!_dataForCells) {
        _dataForCells = [NSMutableArray array];
        NSDictionary *dic = nil;
        dic = @{@"title":@"地址Base58 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": _input.address.base58String ?: @" "};
        [_dataForCells addObject:dic];
        
        NSString *text = _input.valueBTC ? [NSString stringWithFormat:@"%@ BTC", _input.valueBTC] : @" ";
        dic = @{@"title":@"输入数量 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": text};
        [_dataForCells addObject:dic];
        
        //显示解锁脚本或隔离见证
        //todo 目前cell高度固定，有可能显示不下，改成自适应高度的
        BOOL isSegwit = (_input.scriptType == LXHLockingScriptTypeP2WPKH || _input.scriptType == LXHLockingScriptTypeP2WSH);
        if (isSegwit) {
            NSString *segwit = [_input.witness componentsJoinedByString:@","];
            dic = @{@"content":segwit ?: @" ", @"isSelectable":@"1", @"title":@"隔离见证", @"cellType":@"LXHUnLockingScriptCell"};
        } else {
            dic = @{@"content":_input.unlockingScript ?: @" ", @"isSelectable":@"1", @"title":@"解锁脚本", @"cellType":@"LXHUnLockingScriptCell"};
        }
        [_dataForCells addObject:dic];
        
        dic = @{@"title":@"脚本类型 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": [LXHOutputDetailViewModel scriptTypeTextWithLockingScriptType:_input.scriptType]};
        [_dataForCells addObject:dic];
        
        dic = @{@"title":@"序列号 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text":[@(_input.sequence) description]};
        [_dataForCells addObject:dic];
        
        dic = @{@"text":_input.txid ?: @" ", @"isSelectable":@"1", @"title":@"引用交易ID ", @"cellType":@"LXHTwoColumnTextCell"};
        [_dataForCells addObject:dic];
        
        dic = @{@"title":@"输出索引 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text":[@(_input.vout) description]};
        [_dataForCells addObject:dic];
        
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyWithSeparatorCell"};
        [_dataForCells addObject:dic];
        
        dic = @{@"text":@"引用交易", @"isSelectable":@"1", @"cellType":@"LXHOutputDetailTextRightIconCell", @"cellId":@(0)};
        [_dataForCells addObject:dic];
    }
    return _dataForCells;
}

- (id)transactionDetailViewModel {
    LXHTransaction *transaction = [[LXHTransactionDataManager sharedInstance] transactionByTxid:_input.txid];
    if (transaction) {
        LXHTransactionDetailViewModel *viewModel = [[LXHTransactionDetailViewModel alloc] initWithTransaction:transaction];
        return viewModel;
    } else {
        return nil;
    }
}

- (void)asynchronousTransactionDetailViewModelWithSuccessBlock:(nullable void (^)(id viewModel))successBlock
                                                  failureBlock:(nullable void (^)(NSString *errorPrompt))failureBlock {
    [LXHTransactionDataRequest requestTransactionsWithTxid:_input.txid successBlock:^(NSDictionary * _Nonnull resultDic) {
        LXHTransaction *transaction = resultDic[@"transaction"];
        LXHTransactionDetailViewModel *viewModel = nil;
        if (transaction)
            viewModel = [[LXHTransactionDetailViewModel alloc] initWithTransaction:transaction];
        successBlock(viewModel);
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        NSError *error = resultDic[@"error"];
        NSString *format = NSLocalizedString(@"请求交易失败:%@", nil);
        NSString *errorPrompt = [NSString stringWithFormat:format, error.localizedDescription];
        failureBlock(errorPrompt);
    }];
}

@end

