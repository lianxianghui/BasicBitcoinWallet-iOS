//
//  LXHOthersViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHOthersViewModel : NSObject

- (NSDictionary *)jsonWithScannedText:(NSString *)text;
- (NSString *)checkScannedData:(NSDictionary *)data;

- (BOOL)needUpdateCurrentAddressIndexDataWithData:(NSDictionary *)data;
- (void)updateCurrentAddressIndexData:(NSDictionary *)data
                         successBlock:(nullable void (^)(void))successBlock
                         failureBlock:(nullable void (^)(NSString *errorPrompt))failureBlock;


- (NSDictionary *)dataForNavigationWithScannedData:(NSDictionary *)data text:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
