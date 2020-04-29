//
//  LXHSettingViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2020/4/29.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHSettingViewModel : NSObject

@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListview;

- (void)resetCellDataArrayForListview;

- (id)showWalletMnemonicWordsViewModel;

- (NSString *)alertMessageForResettingWallet;

- (void)clearWalletData;
- (void)clearPIN;
@end

NS_ASSUME_NONNULL_END
