//
//  LXHAddressDetailViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/29.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHAddressDetailViewModel.h"
#import "LXHWallet.h"
#import "LXHAddressViewModel.h"
#import "LXHTransactionListByAddressViewModel.h"

@interface LXHAddressDetailViewModel ()
@property (nonatomic) NSDictionary *data;
@property (nonatomic, readwrite) NSMutableArray *cellDataArrayForListview;
@end

@implementation LXHAddressDetailViewModel

- (instancetype)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}


- (NSMutableArray *)cellDataArrayForListview {
    if (!_cellDataArrayForListview) {
        NSMutableArray *cellDataArrayForListview = [NSMutableArray array];
        
        LXHLocalAddressType type = [_data[@"addressType"] integerValue];
        uint32_t index = [_data[@"addressIndex"] unsignedIntValue];
        LXHAccount *account = [LXHWallet mainAccount];
        //cellData, e.g. @{@"title":@"地址Base58 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text":@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE"};
        NSDictionary *addressDetailCellDic = @{@"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell"};
        
        NSMutableDictionary *dic = addressDetailCellDic.mutableCopy;
        dic[@"title"] = NSLocalizedString(@"地址Base58", nil);
        dic[@"text"] = [account addressWithType:type index:index];
        [cellDataArrayForListview addObject:dic];
        
        dic = addressDetailCellDic.mutableCopy;
        dic[@"title"] = NSLocalizedString(@"本地路径", nil);
        dic[@"text"] = [account addressPathWithType:type index:index];
        [cellDataArrayForListview addObject:dic];
        
        dic = addressDetailCellDic.mutableCopy;
        dic[@"title"] = NSLocalizedString(@"使用情况", nil);
        dic[@"text"] = [account isUsedAddressWithType:type index:index] ? NSLocalizedString(@"用过的", nil) : NSLocalizedString(@"未用过的", nil);
        [cellDataArrayForListview addObject:dic];
        
        dic = addressDetailCellDic.mutableCopy;
        dic[@"title"] = NSLocalizedString(@"地址类型", nil);
        dic[@"text"] = @"P2PKH (Pay-to-Public-Key-Hash)";
        [cellDataArrayForListview addObject:dic];
        
        dic = addressDetailCellDic.mutableCopy;
        dic[@"title"] = NSLocalizedString(@"地址用途", nil);
        dic[@"text"] = type == LXHLocalAddressTypeReceiving ? NSLocalizedString(@"接收", nil) : NSLocalizedString(@"找零", nil);
        [cellDataArrayForListview addObject:dic];
        
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyWithSeparatorCell"}.mutableCopy;
        [cellDataArrayForListview addObject:dic];
        dic = @{@"text":NSLocalizedString(@"相关交易", nil), @"isSelectable":@"1", @"cellType":@"LXHAddressDetailTextRightIconCell"}.mutableCopy;
        [cellDataArrayForListview addObject:dic];
        
        if (type == LXHLocalAddressTypeReceiving) { //找零地址不用于接送比特币，所以不显示二维码
            dic = @{@"text":NSLocalizedString(@"地址二维码", nil), @"isSelectable":@"1", @"cellType":@"LXHAddressDetailTextRightIconCell"}.mutableCopy;
            [cellDataArrayForListview addObject:dic];
        }
        
        _cellDataArrayForListview = cellDataArrayForListview;
    }
    return _cellDataArrayForListview;
}


- (void)resetCellDataArrayForListview {
    _cellDataArrayForListview = nil;
}

- (id)transactionListByAddressViewModel {
    LXHLocalAddressType type = [_data[@"addressType"] integerValue];
    uint32_t index = [_data[@"addressIndex"] unsignedIntValue];
    NSString *address = [LXHWallet.mainAccount addressWithType:type index:index];
    LXHTransactionListByAddressViewModel *viewModel = [[LXHTransactionListByAddressViewModel alloc] initWithAddress:address];
    return viewModel;
}

- (id)addressViewModel {
    id viewModel = [[LXHAddressViewModel alloc] initWithData:_data];
    return viewModel;
}

@end
