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
        NSString *valueText = _input.value ? [NSString stringWithFormat:@"%@ BTC", _input.value] : @" ";
        dic = @{@"title":@"输入数量 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": valueText};
        [_dataForCells addObject:dic];
        dic = @{@"content":@"30440220517dab8b1b6244ec166294cebf56d5d80db8933c14b3117445e556b152d729f202207725fa725a54bef4b30d6ccce0a5454c75c55d2570825738d2a5c1de38e7e5db01 030ab23e8385a0d49cdc7a333755e5c448a144d7d1b2193e01c90f7bbc124f9ccc", @"isSelectable":@"1", @"title":@"解锁脚本", @"cellType":@"LXHUnLockingScriptCell"};
        [_dataForCells addObject:dic];
        dic = @{@"title":@"序列号 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text":@"4294967295"};
        [_dataForCells addObject:dic];
        dic = @{@"text":@"71e8a069e7ce8985c3e260cdb0bde4d50d0294c42704b102f3b1ac5db0f9d2b9 ", @"isSelectable":@"1", @"title":@"引用交易ID ", @"cellType":@"LXHTwoColumnTextCell"};
        [_dataForCells addObject:dic];
        dic = @{@"title":@"输出索引 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text":@"0"};
        [_dataForCells addObject:dic];
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyWithSeparatorCell"};
        [_dataForCells addObject:dic];
        dic = @{@"text":@"引用交易", @"isSelectable":@"1", @"cellType":@"LXHOutputDetailTextRightIconCell"};
        [_dataForCells addObject:dic];
    }
    return _dataForCells;
}

@end

