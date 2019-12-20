//
//  LXHTransactionListViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHTransaction;
@interface LXHTransactionListViewModel : NSObject {
    @protected
    NSMutableArray *_dataForCells;
}

- (NSString *)updatedTimeText;
- (NSMutableArray *)dataForCells;
- (void)resetDataForCells;

- (void)addObserverForUpdatedTransactinListWithCallback:(void (^)(void))updatedCallback;
- (void)removeObserverForUpdatedTransactinList;

- (void)updateTransactionListDataWithSuccessBlock:(nullable void (^)(void))successBlock
                       failureBlock:(nullable void (^)(NSString *errorPrompt))failureBlock;



#pragma mark - for overriding
- (NSArray<LXHTransaction *> *)transactionList;//默认实现是全部交易，子类可以根据需要重新实现
@end

NS_ASSUME_NONNULL_END
