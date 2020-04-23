//
//  LXHInitFlow.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/17.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHInitFlow.h"
#import "LXHInitFlowForCreatingNewWallet.h"
#import "LXHInitFlowForRestoringWallet.h"
#import "LXHInitFlowForResettingPIN.h"

static LXHInitFlow *currentFlow = nil;

@implementation LXHInitFlow

+ (LXHInitFlow *)currentFlow {
    return currentFlow;
}

+ (void)startCreatingNewWalletFlow {
    currentFlow = [LXHInitFlowForCreatingNewWallet sharedInstance];
}

+ (void)startRestoringExistWalletFlow {
    currentFlow = [LXHInitFlowForRestoringWallet sharedInstance];
}

+ (void)startResettingPINFlow {
    currentFlow = [LXHInitFlowForResettingPIN sharedInstance];
}

+ (void)endFlow {
    currentFlow = nil;
}

- (id)checkWalletMnemonicWordsClickNextButtonNavigationInfo {
    return nil;
}

- (NSDictionary *)setPassphraseViewClickOKButtonNavigationInfoWithWithPassphrase:(NSString *)passphrase {
    return nil;
}

- (NSDictionary *)selectMnemonicWordLengthViewClickRowNavigationInfo {
    return nil;
}
@end
