//
//  LXHTextViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHTextViewModel : NSObject
@property (nonatomic, readonly) NSString *text;

- (instancetype)initWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
