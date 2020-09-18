//
//  LXHSelectServerViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/9/18.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHSelectServerViewModel.h"
#import "LXHWallet.h"
#import "LXHBitcoinNetwork.h"

@interface LXHSelectServerViewModel ()
@property (nonatomic) NSMutableArray *cellDataListForListView;
@property (nonatomic) NSMutableDictionary *serverDataDic;
@end

@implementation LXHSelectServerViewModel

- (NSMutableArray *)cellDataListForListView {
    if (!_cellDataListForListView) {
        _cellDataListForListView = [NSMutableArray array];
        NSString *currentNetworkString = [LXHBitcoinNetwork networkStringWithType:LXHWallet.mainAccount.currentNetworkType];
        NSArray *currentNetworkItems = [LXHWallet serverDataDic][currentNetworkString];
        NSDictionary *checkedServerItem = [LXHWallet selectedServerInfo];
        for (NSDictionary *item in currentNetworkItems) {
            NSMutableDictionary *dic = @{@"isSelectable":@"1", @"circleImage":@"check_circle", @"cellType":@"LXHCheckTextCell", @"checkedImage":@"checked_circle"}.mutableCopy;
            dic[@"title"]  = item[@"title"];
            dic[@"data"] = item;
            if ([item isEqualToDictionary:checkedServerItem])
                dic[@"checked"] = @(YES);
            [_cellDataListForListView addObject:dic];
        }
    }
    return _cellDataListForListView;
}

- (void)saveSelectedServerInfoWithIndex:(NSUInteger)index {
    NSDictionary *item = self.cellDataListForListView[index][@"data"];
    if (item)
        [LXHWallet saveSelectedServerInfo:item];
}

@end
