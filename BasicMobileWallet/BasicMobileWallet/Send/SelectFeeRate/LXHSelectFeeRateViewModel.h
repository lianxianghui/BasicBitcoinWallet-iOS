//
//  LXHSelectFeeRateViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHSelectFeeRateViewModel : NSObject

@property (nonatomic, readonly) NSMutableArray *cellDataListForListView;
@property (nonatomic) NSDictionary *selectedFeeRateItem;

- (void)requestFeeRateWithSuccessBlock:(void (^)(void))successBlock
                          failureBlock:(void (^)(NSString *errorPrompt))failureBlock;

- (void)checkRowAtIndex:(NSInteger)index;//index是row cell的index

- (NSString *)updateTimeText;

- (void)resetCellDataListForListView;
@end

NS_ASSUME_NONNULL_END
