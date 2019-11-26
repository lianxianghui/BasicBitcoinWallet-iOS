//
//  LXHInputFeeViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHInputFeeViewModel : NSObject

@property (nonatomic, readonly) NSNumber *inputFeeRateSat;

- (BOOL)setInputFeeRateString:(NSString *)inputFeeRateString errorDesc:(NSString **)errorDesc;
- (NSString *)inputFeeRateString;
@end

NS_ASSUME_NONNULL_END
