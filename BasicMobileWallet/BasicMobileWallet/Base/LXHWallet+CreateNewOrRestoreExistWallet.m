//
//  LXHWallet+CreateNewOrRestoreExistWallet.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWallet+CreateNewOrRestoreExistWallet.h"
#import "LXHKeychainStore.h"
#import "LXHWallet+NetworkRequest.h"

@implementation LXHWallet (CreateNewOrRestoreExistWallet)

- (void)createNewWalletInit {
    [[LXHKeychainStore sharedInstance].store setString:@"0" forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    [[LXHKeychainStore sharedInstance].store setString:@"0" forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
}

- (void)restoreExistWalletInitWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                  failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    [self findLastUsedReceivingAddressIndexWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *lastUsedReceivingAddressIndex = resultDic[@"lastUsedReceivingAddressIndex"];
        NSString *currentReceivingAddressIndex = [NSString stringWithFormat:@"%ld", lastUsedReceivingAddressIndex.integerValue+1];
        [[LXHKeychainStore sharedInstance].store setString:currentReceivingAddressIndex forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
        
        [self requestAllTransactionsWithLastUsedReceivingAddressIndex:lastUsedReceivingAddressIndex.integerValue successBlock:^(NSDictionary * _Nonnull resultDic) {
            NSArray *transactions = resultDic[@"transactions"];
            NSInteger lastUsedChangeIndex = [self lastUsedChangeAddressIndexWithAllTransactions:transactions];
            NSString *currentChangeAddressIndex = [NSString stringWithFormat:@"%ld", lastUsedChangeIndex+1];
            [[LXHKeychainStore sharedInstance].store setString:currentChangeAddressIndex forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
            successBlock(resultDic);//带上所有事务数据
        } failureBlock:^(NSDictionary * _Nonnull resultDic) {
            failureBlock(nil);
        }];
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(nil);
    }];
    
    
}
@end
