//
//  LXHAddressDetailViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2020/4/29.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHAddressDetailViewModel : NSObject

@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListview;

- (instancetype)initWithData:(NSDictionary *)data;

- (id)transactionListByAddressViewModel;
- (id)addressViewModel;
@end

NS_ASSUME_NONNULL_END
