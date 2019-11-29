//
//  LXHOutputListViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHOutputListViewModel.h"
#import "LXHTransactionOutput.h"
#import "LXHAddOutputViewModel.h"
#import "BlocksKit.h"
#import "BTCData.h"

@interface LXHOutputListViewModel ()
@property (nonatomic) NSMutableArray<LXHAddOutputViewModel *> *outputViewModels;
@property (nonatomic, readwrite) NSMutableArray *cellDataArrayForListview;//生成自outputViewModels
@end

@implementation LXHOutputListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _outputViewModels = [NSMutableArray array];
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
    if (!_cellDataArrayForListview) { //缓存，不至于每次调用都生成
        NSMutableArray *cellDataArrayForListView = [NSMutableArray array];
        NSDictionary *dic = nil;
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHTopLineCell"};
        [cellDataArrayForListView addObject:dic];
        for (NSInteger i = 0; i < self.outputViewModels.count; i++) {
            LXHTransactionOutput *output = self.outputViewModels[i].output;
            NSMutableDictionary *dic = @{@"cellType":@"LXHSelectedOutputCell", @"deleteImage":@"send_outputlist_delete_image", @"address":@"地址:", @"isSelectable":@"1"}.mutableCopy;
            
            NSString *valueText = [NSString stringWithFormat:@"%@ BTC", output.value];
            dic[@"btcValue"] = valueText;
            
            dic[@"addressText"] = output.address ?: @"";
            dic[@"addressWarningDesc"] = [self addressWarningDescAtIndex:i];
            dic[@"addressWarningDescHidden"] = @([self addressWarningDescHiddenAtIndex:i]);
            dic[@"addressDesc"] =  NSLocalizedString(@"外部地址", nil);
            dic[@"model"] = output;
            dic[@"index"] = @(i);
            [cellDataArrayForListView addObject:dic];
        }
        _cellDataArrayForListview = cellDataArrayForListView;
    }
    return _cellDataArrayForListview;
}

- (NSString *)addressWarningDescAtIndex:(NSInteger)index {
    return [_outputViewModels[index] warningText];
}

- (BOOL)addressWarningDescHiddenAtIndex:(NSInteger)index {
    return (_outputViewModels[index].localAddress == nil);
}

- (void)moveRowAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex {//传入的是cell的index
    [self.cellDataArrayForListview exchangeObjectAtIndex:sourceIndex withObjectAtIndex:destinationIndex];//cell Data
    [_outputViewModels exchangeObjectAtIndex:[self outputIndexForRowIndex:sourceIndex] withObjectAtIndex:[self outputIndexForRowIndex:destinationIndex]]; //对应的cell Data的来源
}

- (NSInteger)outputIndexForRowIndex:(NSInteger)rowIndex {
    NSDictionary *cellData = _cellDataArrayForListview[rowIndex];
    NSNumber *index = cellData[@"index"];
    return index.integerValue;
}

- (void)deleteRowAtIndex:(NSInteger)index { //传入的是cell的index
    NSInteger outputIndex = [self outputIndexForRowIndex:index];
    [self.cellDataArrayForListview removeObjectAtIndex:index]; //cell Data
    [_outputViewModels removeObjectAtIndex:outputIndex]; //对应的cell Data的来源
}

- (LXHAddOutputViewModel *)getNewOutputViewModel {
    return [[LXHAddOutputViewModel alloc] init];
}

- (NSArray<LXHAddOutputViewModel *> *)outputViewModels {
    return _outputViewModels;
}

- (void)addOutputViewModel:(LXHAddOutputViewModel *)model {
    [_outputViewModels addObject:model];
}

- (void)addNewChangeOutputAtRandomPositionWithOutput:(LXHTransactionOutput *)output {
    if (!output)
        return;
    LXHAddOutputViewModel *viewModel = [self getNewOutputViewModel];
    [viewModel setOutput:output];
    NSUInteger randomPosition = [self randomPosition];
    [_outputViewModels insertObject:viewModel atIndex:randomPosition];
}

- (NSUInteger)randomPosition {
    NSUInteger randomInt;
    NSData *randomData = BTCRandomDataWithLength(sizeof(randomInt));
    [randomData getBytes:&randomInt length:sizeof(randomInt)];
    NSUInteger allPostionCount = [self outputCount] + 1;
    return randomInt % (allPostionCount + 1);
}

- (void)deleteOutputViewModelAtIndex:(NSInteger)index {
    [_outputViewModels removeObjectAtIndex:index];
}

- (NSArray *)outputs {
    NSArray *outputs = [self.outputViewModels bk_map:^id(LXHAddOutputViewModel *viewModel) {
        return viewModel.output;
    }];
    return outputs;
}

- (NSInteger)outputCount {
    return _outputViewModels.count;
}

- (BOOL)hasChangeOutput {
    return [self.outputViewModels bk_any:^BOOL(LXHAddOutputViewModel *viewModel) {
        return [viewModel isChangeOutput];
    }];
}
@end
