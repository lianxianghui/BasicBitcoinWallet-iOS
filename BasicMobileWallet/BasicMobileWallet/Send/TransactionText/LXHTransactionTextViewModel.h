//
//  LXHTransactionTextViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHQRCodeAndTextViewModel;

@protocol LXHTransactionTextViewModel <NSObject>

- (instancetype)initWithData:(NSDictionary *)data;
- (NSString *)text;
- (nullable LXHQRCodeAndTextViewModel *)qrCodeViewModel;

- (NSString *)navigationBarTitle;
- (NSString *)button2Text;
- (BOOL)button2NavigationIsAsynchronous;
- (NSDictionary *)button2NavigationInfo;
@end

@interface LXHTransactionTextViewModelBaseClass : NSObject<LXHTransactionTextViewModel>

@end

NS_ASSUME_NONNULL_END
