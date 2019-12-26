//
//  LXHTransactionTextViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionTextViewModel.h"
#import "NSJSONSerialization+VLBase.h"
#import "LXHQRCodeAndTextViewModel.h"

@interface LXHTransactionTextViewModelBaseClass ()
@property (nonatomic) NSDictionary *data;
@end

@implementation LXHTransactionTextViewModelBaseClass


- (instancetype)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (NSString *)text {
    NSString *jsonString = [self jsonString];
    if (jsonString)
        return jsonString;
    else
        return @" ";
}

- (NSString *)jsonString {
    return [NSJSONSerialization jsonStringWithObject:_data];
}

- (LXHQRCodeAndTextViewModel *)qrCodeViewModel {
    NSString *jsonString = [self jsonString];
    if (jsonString)
        return [[LXHQRCodeAndTextViewModel alloc] initWithString:jsonString];
    else
        return nil;
}

#pragma mark - for subclass overriding
- (NSString *)navigationBarTitle {
    return nil;
}
- (NSString *)button2Text {
    return nil;
}
- (BOOL)button2NavigationIsAsynchronous {
    return NO;
}
- (NSDictionary *)button2NavigationInfo {
    return nil;
}
- (NSDictionary *)asynchronousbutton2NavigationInfoWithSuccessBlock:(nullable void (^)(id viewModel))successBlock
                                                       failureBlock:(nullable void (^)(NSString *errorPrompt))failureBlock {
    return nil;
}

@end

