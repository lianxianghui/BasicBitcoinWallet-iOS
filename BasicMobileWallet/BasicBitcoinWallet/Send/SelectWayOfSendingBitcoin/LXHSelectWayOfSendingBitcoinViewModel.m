//
//  LXHSelectWayOfSendingBitcoinViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSelectWayOfSendingBitcoinViewModel.h"
#import "LXHBuildTransactionViewModelForFixedOutput.h"
#import "LXHBuildTransactionViewModelForFixedInput.h"


@implementation LXHSelectWayOfSendingBitcoinViewModel

- (id)buildTransactionViewModelForFixedOutput {
    LXHBuildTransactionViewModel *viewModel = [LXHBuildTransactionViewModelForFixedOutput new];
    return viewModel;
}

- (id)buildTransactionViewModelForFixedInput {
    LXHBuildTransactionViewModel *viewModel = [LXHBuildTransactionViewModelForFixedInput new];
    return viewModel;
}

@end
