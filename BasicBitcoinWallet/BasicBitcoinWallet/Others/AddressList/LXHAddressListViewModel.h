//
//  LXHAddressListViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/4/30.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class LXHAddress;

//地址列表页面，点击某个会进入地址详情
@interface LXHAddressListViewModel : NSObject

@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListview;
- (LXHAddress *)addressAtIndex:(NSInteger)index;

//for overriding
- (BOOL)cellDisclosureIndicatorHidden;//右边的图标是否显示
- (NSDictionary *)clickCellNavigationInfoAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
