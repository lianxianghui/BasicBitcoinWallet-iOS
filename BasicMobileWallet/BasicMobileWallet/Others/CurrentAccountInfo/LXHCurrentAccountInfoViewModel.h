//
//  LXHCurrentAccountInfoViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHQRCodeAndTextViewModel;
@interface LXHCurrentAccountInfoViewModel : NSObject

- (NSString *)netTypeText;
- (NSString *)isWatchOnlyText;
- (LXHQRCodeAndTextViewModel *)qrCodeAndTextViewModel;
@end

NS_ASSUME_NONNULL_END
