//
//  LXHSearchUsedAddressesViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2020/1/14.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHSearchUsedAddressesViewModel : NSObject


- (void)searchAndUpdateCurrentAddressIndexWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                                              failureBlock:(void (^)(NSString *errorPrompt))failureBlock;
@end

NS_ASSUME_NONNULL_END
