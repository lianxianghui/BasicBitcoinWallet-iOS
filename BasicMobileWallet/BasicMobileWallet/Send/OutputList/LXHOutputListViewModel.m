//
//  LXHOutputListViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHOutputListViewModel.h"
#import "LXHTransactionOutput.h"

@interface LXHOutputListViewModel ()
@property (nonatomic, readwrite) NSMutableArray *outputs;
@property (nonatomic, readwrite) NSMutableArray *cellDataArrayForListview;
@end

@implementation LXHOutputListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _outputs = nil;
    }
    return self;
}

- (NSString *)headerInfoTitle {
    return @"输出总值";
}

- (NSString *)headerInfoText {
    return @"0.0000002BTC";
}

- (void)resetCellDataArrayForListview {
    _cellDataArrayForListview = nil;
}

- (NSMutableArray *)cellDataArrayForListview {
    if (!_cellDataArrayForListview) {
        NSMutableArray *cellDataArrayForListView = [NSMutableArray array];
//        dic = @{@"cellType":@"LXHSelectedOutputCell", @"deleteImage":@"send_outputlist_delete_image", @"address":@"地址:", @"btcValue":@"0.00000004 BTC", @"addressText":@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ", @"isSelectable":@"1", @"addressAttributes":@"外部地址"};
//        [dataForCells addObject:dic];
//        dic = @{@"cellType":@"LXHSelectedOutputCell", @"deleteImage":@"send_outputlist_delete_image", @"address":@"地址:", @"btcValue":@"0.00000004 BTC", @"addressText":@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ", @"isSelectable":@"1", @"addressAttributes":@"用过的本地接收地址"};
//        [dataForCells addObject:dic];
        //构造cellDataArray
        NSDictionary *dic = nil;
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHTopLineCell"};
        [cellDataArrayForListView addObject:dic];
        for (NSInteger i = 0; i < _outputs.count; i++) {
            LXHTransactionOutput *output = _outputs[i];
            NSMutableDictionary *dic = @{@"cellType":@"LXHSelectedOutputCell", @"deleteImage":@"send_outputlist_delete_image", @"address":@"地址:", @"isSelectable":@"1"}.mutableCopy;
            
            NSString *valueText = [NSString stringWithFormat:@"%@ BTC", output.value];
            dic[@"btcValue"] = valueText;
            
            dic[@"addressText"] = output.address ?: @"";
            dic[@"addressAttributes"] = [self addressAttributesAtIndex:i];
            dic[@"model"] = output;
            dic[@"index"] = @(i);
            [cellDataArrayForListView addObject:dic];
        }
        _cellDataArrayForListview = cellDataArrayForListView;
    }
    return _cellDataArrayForListview;
}

- (NSString *)addressAttributesAtIndex:(NSInteger)index {//todo 颜色
    return @"用过的本地接收地址";
}

- (void)moveRowAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex {
    [self.cellDataArrayForListview exchangeObjectAtIndex:sourceIndex withObjectAtIndex:destinationIndex];
    [self.outputs exchangeObjectAtIndex:sourceIndex withObjectAtIndex:destinationIndex];
}

- (void)deleteRowAtIndex:(NSInteger)index {
    [self.cellDataArrayForListview removeObjectAtIndex:index];
    [self.outputs removeObjectAtIndex:index];
}

@end
