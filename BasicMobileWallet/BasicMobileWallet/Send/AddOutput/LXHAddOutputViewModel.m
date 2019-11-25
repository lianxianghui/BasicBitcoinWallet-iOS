//
//  LXHAddOutputViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddOutputViewModel.h"
#import "LXHTransactionOutput.h"
#import "LXHLocalAddress.h"
#import "NSString+Base.h"
#import "BTCAddress.h"

@interface LXHAddOutputViewModel ()
@property (nonatomic, readwrite) LXHTransactionOutput *output;
@property (nonatomic, readwrite) NSMutableArray *cellDataArrayForListView;
@end

@implementation LXHAddOutputViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _output = [[LXHTransactionOutput alloc] init];
    }
    return self;
}

- (NSString *)naviBarTitle {
    return _isEditing ? NSLocalizedString(@"编辑输出", nil) : NSLocalizedString(@"添加输出", nil);
}

- (NSMutableArray *)cellDataArrayForListView {
    if (!_cellDataArrayForListView) {
        _cellDataArrayForListView = [NSMutableArray array];
        NSDictionary *dic = nil;
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHTopLineCell"};
        [_cellDataArrayForListView addObject:dic];
        
        NSString *text, *warningText, *addressText;
        if (_output.address) {
            text = NSLocalizedString(@"地址: ", nil);
            addressText = self.output.address ?: @" ";
        } else {
            text = NSLocalizedString(@"地址: 点击添加", nil);
            addressText = @" ";
        }
        warningText = [self warningText];
        dic = @{@"text":text, @"warningText":warningText, @"isSelectable":@"1", @"cellType":@"LXHInputAddressCell", @"addressText":addressText};
        [_cellDataArrayForListView addObject:dic];
        
        dic = @{@"maxValue":@"可输入最大值: 0.00000001 ", @"text1":@"数量:", @"isSelectable":@"0", @"text":@"输入最大值", @"cellType":@"LXHInputAmountCell", @"BTC":@" BTC", @"textFieldText":[self valueString]};
        [_cellDataArrayForListView addObject:dic];
    }
    return _cellDataArrayForListView;
}

- (NSString *)warningText {
    if (_localAddress) {
        NSString *format = NSLocalizedString(@"%@本地%@地址", nil); //例如 "用过的本地找零地址"
        NSString *string1 = _localAddress.used ? NSLocalizedString(@"用过的", nil) : @"";
        NSString *string2 = _localAddress.type == LXHAddressTypeChange ? NSLocalizedString(@"找零", nil) : NSLocalizedString(@"接收", nil);
        NSString *text = [NSString stringWithFormat:format, string1, string2];
        return text;
    } else
        return @" ";
}

- (void)resetCellDataArrayForListView {
    _cellDataArrayForListView = nil;
}

- (BOOL)setAddress:(NSString *)address {
    NSString *validAddress = [LXHAddOutputViewModel validAddress:address];
    if (validAddress) {
        _output.address = validAddress;
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)valueString {
    if (_output.value)
        return [NSString stringWithFormat:@"%@", _output.value];
    else
        return @"";
}

- (BOOL)setValueString:(NSString *)valueString {
    //todo check
    BOOL valueIsValid = YES;
    if (valueIsValid) {
        _output.value = [[NSDecimalNumber alloc] initWithString:valueString];
        [self resetCellDataArrayForListView];
        return YES;
    } else {
        return NO;
    }
}

/**
 返回有效的地址，如果无效返回nil
 */
+ (NSString *)validAddress:(NSString *)address { //todo 放到一个公共的地方，比如AddressUtil
    address = [address stringByTrimmingWhiteSpace];
    address = [address stringByReplacingOccurrencesOfString:@"bitcoin:" withString:@""];
    if ([BTCAddress addressWithString:address]) //有效
        return address;
    else
        return nil;
}

- (void)setLocalAddress:(LXHLocalAddress *)localAddress {
    _localAddress = localAddress;
    _output.address = localAddress.addressString;
}

@end
