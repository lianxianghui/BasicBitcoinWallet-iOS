//
//  LXHSettingViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/29.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHSettingViewModel.h"
#import "LXHWallet.h"
#import "LXHTransactionDataManager.h"
#import "LXHKeychainStore.h"

@interface LXHSettingViewModel ()
@property (nonatomic, readwrite) NSMutableArray *cellDataArrayForListview;
@end

@implementation LXHSettingViewModel

- (NSMutableArray *)cellDataArrayForListview {
    if (!_cellDataArrayForListview) {
        NSMutableArray *cellDataArrayForListview = [NSMutableArray array];
        NSDictionary *dic = nil;
        dic = @{@"text":@"重置钱包", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(0)};
        [cellDataArrayForListview addObject:dic];
        
        NSString *text = [LXHWallet hasPIN] ? NSLocalizedString(@"修改PIN码", nil) : NSLocalizedString(@"设置PIN码", nil);
        dic = @{@"text":text, @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(1)};
        [cellDataArrayForListview addObject:dic];
        if ([LXHWallet hasPIN]) {
            dic = @{@"text":@"清除PIN码", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(2)};
            [cellDataArrayForListview addObject:dic];
        }
        if (![LXHWallet isWatchOnly]) {//只读钱包没有助记词
            dic = @{@"text":@"钱包助记词", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(3)};
            [cellDataArrayForListview addObject:dic];
        }
        dic = @{@"text":@"账户信息", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(4)};
        [cellDataArrayForListview addObject:dic];
        
        _cellDataArrayForListview = cellDataArrayForListview;
    }
    return _cellDataArrayForListview;
}


- (void)resetCellDataArrayForListview {
    _cellDataArrayForListview = nil;
}

- (NSString *)alertMessageForResettingWallet {
    NSString *message = [LXHWallet isWatchOnly] ? NSLocalizedString(@"重置将会清除本地的钱包数据与PIN码，您确定现在要重置吗？", nil) : NSLocalizedString(@"重要：重置将会清除本地的钱包数据与PIN码，请务必保证已经备份了钱包助记词，否则会导致比特币丢失。您确定现在要重置吗？", nil);
    return message;
}

- (void)clearWalletData {
    [LXHWallet clearAccount];
    [LXHWallet clearPIN];
    [[LXHTransactionDataManager sharedInstance] clearCachedData];
}

- (void)clearPIN {
    [LXHWallet clearPIN];
}
@end
