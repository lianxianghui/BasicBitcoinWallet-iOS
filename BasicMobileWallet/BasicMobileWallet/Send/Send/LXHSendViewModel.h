//
//  LXHSendViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface LXHSendViewModel : NSObject

//用来在几个页面之间传递构造交易数据的字典
@property (nonatomic, readonly) NSMutableDictionary *dataForBuildingTransaction;//keys @"selectedUtxos", @"outputs", @"selectedFeeRateItem", @"inputFeeRate"

- (NSArray *)cellDataForListview;
@end

NS_ASSUME_NONNULL_END
