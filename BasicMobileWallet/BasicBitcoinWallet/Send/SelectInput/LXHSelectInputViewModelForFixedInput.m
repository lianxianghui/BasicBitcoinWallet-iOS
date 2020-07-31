//
//  LXHSelectInputViewModelForFixedInput.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/11/29.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSelectInputViewModelForFixedInput.h"
#import "LXHTransactionOutput.h"

@implementation LXHSelectInputViewModelForFixedInput

- (NSString *)infoText {
    NSDecimalNumber *seletedInputValueSum = [LXHTransactionOutput valueSumOfOutputs:self.selectedUtxos];
    NSString *format = NSLocalizedString(@"所选总值为 %@BTC", nil);
    return [NSString stringWithFormat:format, seletedInputValueSum];
}

@end
