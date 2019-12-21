//
//  LXHInputDetailViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHInputDetailViewModel.h"
#import "LXHTransactionInput.h"

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

//dic = @{@"title":@"地址Base58 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": _model.address.base58String ?: @""};
//[_dataForCells addObject:dic];
//NSString *valueText = _model.value ? [NSString stringWithFormat:@"%@ BTC", _model.value] : @"";
//dic = @{@"title":@"输入数量 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": valueText};

- (NSArray *)dataForCells {
    if (!_dataForCells) {
        _dataForCells = [NSMutableArray array];
        NSDictionary *dic = nil;
        dic = @{@"title":@"地址Base58 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": _input.address.base58String ?: @" "};
        [_dataForCells addObject:dic];
        
        NSString *text = _input.value ? [NSString stringWithFormat:@"%@ BTC", _input.value] : @" ";
        dic = @{@"title":@"输入数量 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": text};
        [_dataForCells addObject:dic];
        
        dic = @{@"content":_input.unlockingScript ?: @" ", @"isSelectable":@"1", @"title":@"解锁脚本", @"cellType":@"LXHUnLockingScriptCell"};
        [_dataForCells addObject:dic];
        
        dic = @{@"title":@"序列号 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text":[@(_input.sequence) description]};
        [_dataForCells addObject:dic];
        
        dic = @{@"text":_input.txid ?: @" ", @"isSelectable":@"1", @"title":@"引用交易ID ", @"cellType":@"LXHTwoColumnTextCell"};
        [_dataForCells addObject:dic];
        
        dic = @{@"title":@"输出索引 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text":[@(_input.vout) description]};
        [_dataForCells addObject:dic];
        
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyWithSeparatorCell"};
        [_dataForCells addObject:dic];
        
        dic = @{@"text":@"引用交易", @"isSelectable":@"1", @"cellType":@"LXHOutputDetailTextRightIconCell"};
        [_dataForCells addObject:dic];
    }
    return _dataForCells;
}

@end

