//
//  LXHValidatePINViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2020/5/8.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHValidatePINViewModel : NSObject

- (BOOL)needShowValidatePINAlert;
- (BOOL)isCurrentPIN:(NSString *)text;
- (BOOL)walletDataGenerated;
@end

NS_ASSUME_NONNULL_END
