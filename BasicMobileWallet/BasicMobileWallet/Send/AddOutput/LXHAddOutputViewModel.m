//
//  LXHAddOutputViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddOutputViewModel.h"
#import "LXHTransactionOutput.h"
#import "LXHAddress+LXHAccount.h"
#import "NSString+Base.h"
#import "BTCAddress.h"
#import "LXHWallet.h"
#import "LXHAmount.h"
#import "NSDecimalNumber+LXHBTCSatConverter.h"
#import "LXHAddress+LXHAccount.h"

@interface LXHAddOutputViewModel ()
@property (nonatomic, readwrite) NSMutableArray *cellDataArrayForListView;
@property (nonatomic) NSString *tempText;
@end

@implementation LXHAddOutputViewModel
@synthesize output = _output;

- (void)setTempText:(NSString *)tempText {
    _tempText = tempText;
}

- (void)setTempTextToValueString {
    [self setTempText:[self valueString]];
}

- (NSString *)naviBarTitle {
    return _isEditing ? NSLocalizedString(@"编辑输出", nil) : NSLocalizedString(@"添加输出", nil);
}

- (NSMutableArray *)cellDataArrayForListView {
    if (!_cellDataArrayForListView) {
        _cellDataArrayForListView = [NSMutableArray array];
        NSDictionary *dic = @{@"isSelectable":@"0", @"cellType":@"LXHTopLineCell"};
        [_cellDataArrayForListView addObject:dic];
        
        NSString *text, *warningText, *addressText;
        if (self.output.address) {
            text = NSLocalizedString(@"地址: ", nil);
            addressText = self.output.address.base58String ?: @" ";
        } else {
            text = NSLocalizedString(@"地址: 点击添加", nil);
            addressText = @" ";
        }
        warningText = [self warningText];
        dic = @{@"text":text, @"warningText":warningText, @"isSelectable":@"1", @"cellType":@"LXHInputAddressCell", @"addressText":addressText};
        [_cellDataArrayForListView addObject:dic];
        
        NSString *maxValueString = _maxValue ? [NSString stringWithFormat:NSLocalizedString(@"可输入最大值: %@", nil), _maxValue] : @" ";
        BOOL maxValueHidden = (_maxValue == nil);
        BOOL maxValueButtonHidden = (_maxValue == nil);
        NSString *textFieldText = self.tempText ?: @"";
        dic = @{@"maxValue":maxValueString,
                @"text1":@"数量:",
                @"isSelectable":@"0",
                @"text":@"输入最大值",
                @"cellType":@"LXHInputAmountCell",
                @"BTC":@" BTC",
                @"textFieldText":textFieldText,
                @"maxValueHidden":@(maxValueHidden),
                @"textButtonHidden":@(maxValueButtonHidden),
                };
        [_cellDataArrayForListView addObject:dic];
    }
    return _cellDataArrayForListView;
}

- (NSString *)warningText {
    if (self.output.address.isLocalAddress) {
        NSString *format = NSLocalizedString(@"%@本地%@地址", nil); //例如 "用过的本地找零地址"
        NSString *string1 = self.output.address.localAddressUsed ? NSLocalizedString(@"用过的", nil) : @"";
        NSString *string2 = self.output.address.localAddressType == LXHLocalAddressTypeChange ? NSLocalizedString(@"找零", nil) : NSLocalizedString(@"接收", nil);
        NSString *text = [NSString stringWithFormat:format, string1, string2];
        return text;
    } else
        return @" ";
}

- (void)resetCellDataArrayForListView {
    _cellDataArrayForListView = nil;
}

- (BOOL)setBase58Address:(NSString *)address {
    NSString *validAddress = [LXHAddress validAddress:address];
    if (validAddress) {
        self.output.address = [LXHAddress addressWithBase58String:validAddress];
        return YES;
    } else {
        return NO;
    }
}

- (void)setAddress:(LXHAddress *)address {
    self.output.address = address;
}

- (BOOL)hasAddress {
    return (self.output.address.base58String != nil);
}

- (NSString *)valueString {
    if (self.output.valueBTC)
        return [NSString stringWithFormat:@"%@", self.output.valueBTC];
    else
        return @"";
}

- (BOOL)setValueString:(NSString *)valueString {
    if ([self valueIsValid:valueString]) {
        self.output.valueBTC = [valueString decimalValue];
        [self resetCellDataArrayForListView];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)valueIsValid:(NSString *)valueString {
    NSDecimalNumber *decimalNumber = [valueString decimalValue];
    if (!decimalNumber)
        return NO;
    LXHBTCAmount valueInSat = [NSDecimalNumber amountSatValueWithBTCValue:decimalNumber];
    if (![LXHAmount isValidWithValue:valueInSat])
        return NO;
    if (valueInSat == 0)
        return NO;
    if (_maxValue) {
        LXHBTCAmount maxValueInSat = [NSDecimalNumber amountSatValueWithBTCValue:_maxValue];
        return valueInSat <= maxValueInSat;
    } else {
        return YES;
    }
}

- (void)setOutput:(LXHTransactionOutput *)output {
    _output = output;
}

- (LXHTransactionOutput *)output {
    if (!_output)
        _output = [LXHTransactionOutput new];
    return _output;
}

- (BOOL)isChangeOutput {
    if (self.output.address.isLocalAddress)
        return self.output.address.localAddressType == LXHLocalAddressTypeChange;
    return NO;
}

@end
