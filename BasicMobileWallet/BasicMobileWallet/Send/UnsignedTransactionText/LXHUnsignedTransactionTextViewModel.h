//
//  LXHUnsignedTransactionTextViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHUnsignedTransactionTextViewModel : NSObject
//数据格式参考Doc目录下的unsignedTransaction.plist
- (instancetype)initWithData:(NSDictionary *)data;

- (NSString *)text;
- (BOOL)signTransactionButtonEnabled;
- (nullable id)qrCodeAndTextViewModel;
- (nullable id)signedTransactionTextViewModel;
@end

NS_ASSUME_NONNULL_END
