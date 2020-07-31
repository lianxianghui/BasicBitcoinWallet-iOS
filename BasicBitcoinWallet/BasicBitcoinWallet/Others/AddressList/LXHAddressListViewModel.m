//
//  LXHAddressListViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/4/30.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHAddressListViewModel.h"
#import "LXHWallet.h"
#import "LXHAddressDetailViewModel.h"
#import "LXHAddress.h"

@interface LXHAddressListViewModel ()
@property (nonatomic, readwrite) NSMutableArray *cellDataArrayForListview;
@end

@implementation LXHAddressListViewModel

- (BOOL)cellDisclosureIndicatorHidden {
    return NO;
}

- (NSArray *)localAddressCellDicArrayWithAddressType:(LXHLocalAddressType)addressType {
    NSMutableArray *ret = [NSMutableArray array];
    LXHAccount *account = LXHWallet.mainAccount;
    NSArray *usedAndCurrentAddresses = [account usedAndCurrentAddressesWithType:addressType];
    NSDictionary *localAddressCellFixedData = @{ @"isSelectable":@"1", @"type":@"P2PKH ", @"cellType":@"LXHLocalAddressCell"};
    //使用过的在前面，当前未用过的在最后一个
    for (NSInteger i = 0; i < usedAndCurrentAddresses.count; i++) {
        NSMutableDictionary *localAddressCellDic = localAddressCellFixedData.mutableCopy;
        localAddressCellDic[@"addressText"] = usedAndCurrentAddresses[i];
        localAddressCellDic[@"used"] = i < [account currentAddressIndexWithType:addressType] ? NSLocalizedString(@"用过的", nil) : NSLocalizedString(@"未用过的", nil);
        localAddressCellDic[@"localPath"] = [account addressPathWithType:addressType index:(uint32_t)i];
        localAddressCellDic[@"type"] = @"P2PKH";
        localAddressCellDic[@"hidden"] = @([self cellDisclosureIndicatorHidden]);
        localAddressCellDic[@"data"] =  @{@"addressType":@(addressType), @"addressIndex":@(i)};
        [ret addObject:localAddressCellDic];
    }
    return ret;
}

- (NSMutableArray *)cellDataArrayForListview {
    if (!_cellDataArrayForListview) {
        NSMutableArray *cellDataArrayForListview = [NSMutableArray array];
        NSDictionary *dic = nil;
        //receiving addresses title
        dic = @{@"title":NSLocalizedString(@"接收地址", nil), @"isSelectable":@"0", @"cellType":@"LXHTitleCell"};
        [cellDataArrayForListview addObject:dic];
        //receiving addresses info cells
        [cellDataArrayForListview addObjectsFromArray:[self localAddressCellDicArrayWithAddressType:LXHLocalAddressTypeReceiving]];
        //change addresses title
        dic = @{@"title":NSLocalizedString(@"找零地址", nil), @"isSelectable":@"0", @"cellType":@"LXHTitleCell"};
        [cellDataArrayForListview addObject:dic];
        //change addresses info cells
        [cellDataArrayForListview addObjectsFromArray:[self localAddressCellDicArrayWithAddressType:LXHLocalAddressTypeChange]];

        _cellDataArrayForListview = cellDataArrayForListview;
    }
    return _cellDataArrayForListview;
}


- (NSDictionary *)clickCellNavigationInfoAtIndex:(NSInteger)index {
    NSDictionary *cellData = _cellDataArrayForListview[index];
    NSMutableDictionary *data = cellData[@"data"];
    LXHAddressDetailViewModel *viewModel = [[LXHAddressDetailViewModel alloc] initWithData:data];
    
    NSString *controllerClassName = @"LXHAddressDetailViewController";
    NSString *navigationType = @"push";
    return @{@"viewModel":viewModel, @"controllerClassName":controllerClassName, @"navigationType":navigationType};
}

- (LXHAddress *)addressAtIndex:(NSInteger)index {
    NSDictionary *cellData = _cellDataArrayForListview[index];
    NSMutableDictionary *data = cellData[@"data"];
    
    LXHAccount *account = [LXHWallet mainAccount];
    LXHLocalAddressType type = [data[@"addressType"] integerValue];
    uint32_t addressIndex = [data[@"addressIndex"] unsignedIntValue];
    LXHAddress *address = [account localAddressWithWithType:type index:addressIndex];
    return address;
}
@end
