//
//  UIViewController+LXHSaveMnemonicAndSeed.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/14.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "UIViewController+LXHSaveMnemonicAndSeed.h"
#import "LXHKeychainStore.h"
#import "UIViewController+LXHAlert.h"
#import "CoreBitcoin.h"
#import "LXHTabBarPageViewController.h"
#import "LXHWallet.h"
#import "LXHWallet+CreateNewOrRestoreExistWallet.h"

@implementation UIViewController (LXHSaveMnemonicAndSeed)

- (void)saveToKeychainWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords mnemonicPassphrase:(nullable NSString *)mnemonicPassphrase {
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    NSData *rootSeed = [mnemonic seed];
    BOOL saveMnemonicResult = [LXHKeychainStore.sharedInstance saveMnemonicCodeWords:mnemonicCodeWords];
    BOOL saveRootSeedResult = [LXHKeychainStore.sharedInstance saveData:rootSeed forKey:kLXHKeychainStoreRootSeed];
    if (saveMnemonicResult && saveRootSeedResult) {
        UIViewController *controller = [[LXHTabBarPageViewController alloc] init];
        [self.navigationController pushViewController:controller animated:NO]; 
    } else {
        [LXHKeychainStore.sharedInstance saveMnemonicCodeWords:nil];
        [LXHKeychainStore.sharedInstance saveData:nil forKey:kLXHKeychainStoreRootSeed];
        [self showOkAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"发生了无法处理的错误，如果方便请联系并告知开发人员", nil) handler:nil];
    }
}

- (void)makeWalletReadyWithWalletCreationType:(LXHWalletCreationType)creationType
                                  mnemonicCodeWords:(NSArray *)mnemonicCodeWords 
                                  mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                  successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                  failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    NSData *rootSeed = [mnemonic seed];
    BOOL saveMnemonicResult = [LXHKeychainStore.sharedInstance saveMnemonicCodeWords:mnemonicCodeWords];
    BOOL saveRootSeedResult = [LXHKeychainStore.sharedInstance saveData:rootSeed forKey:kLXHKeychainStoreRootSeed];
    if (saveMnemonicResult && saveRootSeedResult) {
        if (creationType == LXHWalletCreationTypeCreatingNew) {
            [[LXHWallet sharedInstance] createNewWalletInit];
            successBlock(nil);
        } else {
            //todo show indicatorview
            [[LXHWallet sharedInstance] restoreExistWalletInitWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
               //hide indicatorview
                
            } failureBlock:^(NSDictionary * _Nonnull resultDic) {
                
            }];
        }
    } else {
        
    }
}

@end
