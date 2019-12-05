//
//  LXHTransactionInfoViewViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionInfoViewViewModel.h"
#import "LXHTransactionOutput.h"

@interface LXHTransactionInfoViewViewModel ()
@property (nonatomic) NSArray<LXHTransactionOutput *> *inputs;
@property (nonatomic) NSArray<LXHTransactionOutput *> *outputs;
@end

@implementation LXHTransactionInfoViewViewModel

- (instancetype)initWithInputs:(NSArray<LXHTransactionOutput *> *)inputs outputs:(NSArray<LXHTransactionOutput *> *)outputs {
    self = [super init];
    if (self) {
        _inputs = inputs;
        _outputs = outputs;
    }
    return self;
}

- (NSString *)infoDescription {
    NSMutableString *ret = [NSMutableString string];
    return ret;
}

- (NSDictionary *)unsignedTransactionDictionary {
    return nil;
}

- (NSDictionary *)signedTransactionDictionary {
    return nil;
}

- (void)pushSignedTransaction {
    
}

@end
