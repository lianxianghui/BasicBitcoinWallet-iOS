//
//  LXHAddressViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2020/4/29.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHAddressViewModel : NSObject
@property (nonatomic) NSDictionary *data;

- (instancetype)initWithData:(NSDictionary *)data;

- (BOOL)leftButtonHidden;
- (void)refreshData;
- (NSString *)addressText;
- (NSString *)path;
@end

NS_ASSUME_NONNULL_END
