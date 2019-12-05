//
//  LXHTransactionTextViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHTransactionTextViewModel : NSObject

- (instancetype)initWithData:(NSDictionary *)data;

- (NSString *)text;
@end

NS_ASSUME_NONNULL_END
