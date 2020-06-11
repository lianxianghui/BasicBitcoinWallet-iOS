//
//  LXHSelectFeeRateViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSelectFeeRateViewModel.h"
#import "LXHBitcoinfeesNetworkRequest.h"
#import "NSString+Base.h"
#import "LXHGlobalHeader.h"
#import "LXHFeeRate.h"

@interface LXHSelectFeeRateViewModel()
@property (nonatomic) NSDictionary *feeRateOptionsDic;// keys = @[@"fastestFee", @"halfHourFee", @"hourFee"];
@property (nonatomic) NSDate *feeRateUpdatedTime;
@property (nonatomic, readwrite) NSMutableArray *cellDataListForListView;
@end

@implementation LXHSelectFeeRateViewModel

- (NSMutableArray *)cellDataListForListView {
    if (!_cellDataListForListView) {
        if (_feeRateOptionsDic) {
            _cellDataListForListView = [NSMutableArray array];
            NSArray *keys = @[@"fastestFee", @"halfHourFee", @"hourFee"];
            for (NSString *key in keys) {
                NSNumber *value = _feeRateOptionsDic[key];//数据形式，@"fastestFee":@(30)
                if (!value)
                    continue;
                if (![LXHFeeRate isValidWithFeeRateNumber:value])
                    continue;
                NSString *feeRateTitle = [key firstLetterCapitalized];
                NSString *feeRateValueText = [NSString stringWithFormat:@"%@ sat/byte", value];
                NSMutableDictionary *dic = @{@"feeRate":feeRateValueText, @"isSelectable":@"1", @"title":feeRateTitle, @"circleImage":@"check_circle", @"cellType":@"LXHFeeOptionCell", @"checkedImage":@"checked_circle"}.mutableCopy;
                NSDictionary *feeRateItem = @{key : value};
                if (_selectedFeeRateItem)
                    dic[@"isChecked"] = @([feeRateItem isEqual:_selectedFeeRateItem]);
                dic[@"feeRateItemData"] = feeRateItem;
                [_cellDataListForListView addObject:dic];
            }
        }
    }
    return _cellDataListForListView;
}

- (void)resetCellDataListForListView {
    _cellDataListForListView = nil;
}

- (void)requestFeeRateWithSuccessBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(NSString *errorPrompt))failureBlock {
    __weak __typeof(self)weakSelf = self;
    [[LXHBitcoinfeesNetworkRequest sharedInstance] requestWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        weakSelf.feeRateOptionsDic = resultDic[@"responseData"];
        weakSelf.feeRateUpdatedTime = resultDic[@"responseTime"];
        successBlock();
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        if (resultDic) {
            NSDictionary *cachedResult = resultDic[@"cachedResult"];
            weakSelf.feeRateOptionsDic = cachedResult[@"responseData"];
            weakSelf.feeRateUpdatedTime = cachedResult[@"responseTime"];

            NSError *error = resultDic[@"error"];
            NSString *format = NSLocalizedString(@"由于%@请求费率失败，目前的显示费率有可能是过时的.", nil);
            NSString *errorPrompt = [NSString stringWithFormat:format, error.localizedDescription];
            failureBlock(errorPrompt);
        } else {
            NSError *error = resultDic[@"error"];
            NSString *format = NSLocalizedString(@"由于%@请求费率失败.", nil);
            NSString *errorPrompt = [NSString stringWithFormat:format, error.localizedDescription];
            failureBlock(errorPrompt);
        }
    }];
}

- (void)checkRowAtIndex:(NSInteger)index {//index是row cell的index
    [self setCheckedFlagWithIndex:index];
    self.selectedFeeRateItem = [self currentSelectedFeeRateItemData];
}

- (void)setCheckedFlagWithIndex:(NSInteger)index {
    [_cellDataListForListView enumerateObjectsUsingBlock:^(NSMutableDictionary  * _Nonnull cellData, NSUInteger idx, BOOL * _Nonnull stop) {
        cellData[@"isChecked"] = @(index == idx);
    }];
}

- (id)currentSelectedFeeRateItemData {
    for (NSDictionary *cellData in _cellDataListForListView) {
        if ([cellData[@"isChecked"] isEqual:@(YES)]) {
            return cellData[@"feeRateItemData"];
        }
    }
    return nil;
}

- (NSString *)updateTimeText {
    NSDate *updatedTime = self.feeRateUpdatedTime;
    if (updatedTime) {
        static NSDateFormatter *formatter = nil;
        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = NSLocalizedString(LXHTranactionTimeDateFormat, nil);
        }
        NSString *dateString = [formatter stringFromDate:updatedTime];
        return [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"更新ß时间", nil), dateString];
    } else {
        return @"";
    }
}
@end
