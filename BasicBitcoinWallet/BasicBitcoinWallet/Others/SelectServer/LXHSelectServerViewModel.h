//
//  LXHSelectServerViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/9/18.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHSelectServerViewModel : NSObject
- (NSMutableArray *)cellDataListForListView;
- (void)checkRowAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
