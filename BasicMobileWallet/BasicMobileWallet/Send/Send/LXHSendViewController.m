// LXHSendViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSendViewController.h"
#import "Masonry.h"
#import "LXHSendView.h"
#import "LXHInputFeeViewController.h"
#import "LXHSelectInputViewController.h"
#import "LXHOutputListViewController.h"
#import "LXHSelectFeeRateViewController.h"
#import "LXHEmptyCell.h"
#import "LXHSelectionCell.h"
#import "LXHInputOutputCell.h"
#import "LXHFeeCell.h"
#import "LXHTransactionInput.h"
#import "LXHTransactionOutput.h"
#import "LXHGlobalHeader.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSendViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHSendView *contentView;
@property (nonatomic) NSMutableArray *cellDataListForListView;
//下面几个是用来在几个页面之间传递数据的字典
//@property (nonatomic) NSMutableDictionary *inputDataDic; //@"selectedUtxos"
//@property (nonatomic) NSMutableDictionary *outputDataDic; //@"outputs"
//@property (nonatomic) NSMutableDictionary *selectFeeRateData;//key selectedFeeRateItem value is like {@"fastestFee", @(30)}
//@property (nonatomic) NSMutableDictionary *inputFeeRateData;//key @"feeRate" value 是整数 单位是sat/byte
@property (nonatomic) NSMutableDictionary *dataForBuildingTransaction;
@end

@implementation LXHSendViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataForBuildingTransaction = [NSMutableDictionary dictionary];
//        _inputDataDic = [NSMutableDictionary dictionary];
//        _outputDataDic = [NSMutableDictionary dictionary];
//        _selectFeeRateData = [NSMutableDictionary dictionary];
//        _inputFeeRateData = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHSendView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self addActions];
    [self setDelegates];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshListView];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
}

- (void)setDelegates {
    self.contentView.listView.dataSource = self;
    self.contentView.listView.delegate = self;
}

//Actions
- (void)LXHFeeCellInputFeeValueButtonClicked:(UIButton *)sender {
    LXHWeakSelf
    UIViewController *controller = [[LXHInputFeeViewController alloc] initWithData:_dataForBuildingTransaction dataChangedCallback:^{
        weakSelf.dataForBuildingTransaction[@"selectFeeRateDataItem"] = nil; //把LXHSelectFeeRateViewController数据置空
    }];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}

- (void)LXHFeeCellSelectFeerateButtonClicked:(UIButton *)sender {
    LXHWeakSelf
    UIViewController *controller = [[LXHSelectFeeRateViewController alloc] initWithData:_dataForBuildingTransaction dataChangedCallback:^{
        weakSelf.dataForBuildingTransaction[@"inputFeeRate"] = nil;
    }];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}

- (void)refreshListView {
    _cellDataListForListView = nil;
    [self.contentView.listView reloadData];
}

- (NSNumber *)feeRateValue {
    NSNumber *feeRateValue = nil;
    if (_dataForBuildingTransaction[@"inputFeeRate"])
        feeRateValue = _dataForBuildingTransaction[@"inputFeeRate"];
    else if (_dataForBuildingTransaction[@"selectedFeeRateItem"]) {
        NSDictionary *selectedFeeRateItem = _dataForBuildingTransaction[@"selectedFeeRateItem"];
        feeRateValue = selectedFeeRateItem.allValues[0];
    } else {
        feeRateValue = nil;
    }
    return feeRateValue;
}

//Delegate Methods
- (NSArray *)cellDataListForTableView:(UITableView *)tableView {
    if (tableView == self.contentView.listView) {
        if (!_cellDataListForListView) {
            _cellDataListForListView = [NSMutableArray array];
            NSDictionary *dic = nil;
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
            [_cellDataListForListView addObject:dic];
            dic = @{@"isSelectable":@"1", @"disclosureIndicator":@"disclosure_indicator", @"cellType":@"LXHSelectionCell", @"text":@"选择输入"};
            [_cellDataListForListView addObject:dic];
            NSArray *selectedUtxos = _dataForBuildingTransaction[@"selectedUtxos"];
            for (NSUInteger i = 0 ; i < selectedUtxos.count; i++) {
                LXHTransactionOutput *utxo = selectedUtxos[i];
                NSMutableDictionary *mutableDic =  @{@"isSelectable":@"1", @"cellType":@"LXHInputOutputCell"}.mutableCopy;
                mutableDic[@"addressText"] = utxo.address;
                mutableDic[@"text"] = [NSString stringWithFormat:@"%ld.", i+1];
                mutableDic[@"btcValue"] = [NSString stringWithFormat:@"%@ BTC", utxo.value];
                [_cellDataListForListView addObject:mutableDic];
            }
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
            [_cellDataListForListView addObject:dic];
            //fee rate text
            NSNumber *feeRateValue = [self feeRateValue];
            NSString *feeRateText = nil;
            if (feeRateValue) {
                NSString *feeRateTextFormat = NSLocalizedString(@"手续费率: %@ sat/byte", nil);
                feeRateText = [NSString stringWithFormat:feeRateTextFormat, feeRateValue];
            } else {
                feeRateText = NSLocalizedString(@"请选择或者输入手续费率", nil);
            }
            dic = @{@"text":feeRateText, @"isSelectable":@"0", @"cellType":@"LXHFeeCell"};
            [_cellDataListForListView addObject:dic];
            
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
            [_cellDataListForListView addObject:dic];
            dic = @{@"isSelectable":@"1", @"disclosureIndicator":@"disclosure_indicator", @"cellType":@"LXHSelectionCell", @"text":@"选择输出"};
            [_cellDataListForListView addObject:dic];
            NSArray *outputs = _dataForBuildingTransaction[@"outputs"];
            for (NSUInteger i = 0 ; i < outputs.count; i++) {
                LXHTransactionOutput *output = outputs[i];
                NSMutableDictionary *mutableDic =  @{@"isSelectable":@"1", @"cellType":@"LXHInputOutputCell"}.mutableCopy;
                mutableDic[@"addressText"] = output.address;
                mutableDic[@"text"] = [NSString stringWithFormat:@"%ld.", i+1];
                mutableDic[@"btcValue"] = [NSString stringWithFormat:@"%@ BTC", output.value];
                [_cellDataListForListView addObject:mutableDic];
            }
        }
        return _cellDataListForListView;
    }
    return nil;
}

- (id)cellDataForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataForTableView = [self cellDataListForTableView:tableView];
    if (indexPath.row < dataForTableView.count)
        return [dataForTableView objectAtIndex:indexPath.row];
    else
        return nil;
}


- (NSString *)tableView:(UITableView *)tableView cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentView.listView) {
        NSArray *data = [self cellDataListForTableView:tableView];
        if (indexPath.row < data.count) {
            NSDictionary *cellData = [data objectAtIndex:indexPath.row];
            return [cellData valueForKey:@"cellType"];
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView viewTagAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if ([cellType isEqualToString:@"LXHEmptyCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHSelectionCell"])
        return 101;
    if ([cellType isEqualToString:@"LXHInputOutputCell"])
        return 102;
    if ([cellType isEqualToString:@"LXHFeeCell"])
        return 103;
    return -1;
}

- (NSString *)tableView:(UITableView *)tableView cellContentViewClassStingAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    NSString *classString = cellType;
    return classString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self cellDataListForTableView:tableView].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
    NSInteger tag = [self tableView:tableView viewTagAtIndexPath:indexPath];
    id dataForRow = [self cellDataForTableView:tableView atIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
        NSString *viewClass = [self tableView:tableView cellContentViewClassStingAtIndexPath:indexPath];
        UIView *view = [[NSClassFromString(viewClass) alloc] init];
        view.tag = tag;
        [cell.contentView addSubview:view];
        //if view.backgroudColor is clearColor, need to set backgroundColor of contentView and cell.
        //cell.contentView.backgroundColor = view.backgroundColor;
        //cell.backgroundColor = view.backgroundColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        NSString *isSelectable = [dataForRow valueForKey:@"isSelectable"];
        if ([isSelectable isEqualToString:@"0"])
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *view = [cell.contentView viewWithTag:tag];
    if ([cellType isEqualToString:@"LXHSelectionCell"]) {
        LXHSelectionCell *cellView = (LXHSelectionCell *)view;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
        NSString *disclosureIndicatorImageName = [dataForRow valueForKey:@"disclosureIndicator"];
        if (disclosureIndicatorImageName)
            cellView.disclosureIndicator.image = [UIImage imageNamed:disclosureIndicatorImageName];
    }
    if ([cellType isEqualToString:@"LXHInputOutputCell"]) {
        LXHInputOutputCell *cellView = (LXHInputOutputCell *)view;
        NSString *btcValue = [dataForRow valueForKey:@"btcValue"];
        if (!btcValue)
            btcValue = @"";
        NSMutableAttributedString *btcValueAttributedString = [cellView.btcValue.attributedText mutableCopy];
        [btcValueAttributedString.mutableString setString:btcValue];
        cellView.btcValue.attributedText = btcValueAttributedString;
        NSString *addressText = [dataForRow valueForKey:@"addressText"];
        if (!addressText)
            addressText = @"";
        NSMutableAttributedString *addressTextAttributedString = [cellView.addressText.attributedText mutableCopy];
        [addressTextAttributedString.mutableString setString:addressText];
        cellView.addressText.attributedText = addressTextAttributedString;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
    }
    if ([cellType isEqualToString:@"LXHFeeCell"]) {
        LXHFeeCell *cellView = (LXHFeeCell *)view;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
        cellView.inputFeeValueButton.tag = indexPath.row;
        [cellView.inputFeeValueButton addTarget:self action:@selector(LXHFeeCellInputFeeValueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cellView.selectFeerateButton.tag = indexPath.row;
        [cellView.selectFeerateButton addTarget:self action:@selector(LXHFeeCellSelectFeerateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHEmptyCell"])
            return 18;
        if ([cellType isEqualToString:@"LXHSelectionCell"])
            return 50;
        if ([cellType isEqualToString:@"LXHInputOutputCell"])
            return 50;
        if ([cellType isEqualToString:@"LXHFeeCell"])
            return 50;
    }
    return 0;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id dataForRow = [self cellDataForTableView:tableView atIndexPath:indexPath];
    NSString *isSelectable = [dataForRow valueForKey:@"isSelectable"];
    if ([isSelectable isEqualToString:@"0"])
        return nil;
    else
        return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *type = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if ([type isEqualToString:@"LXHSelectionCell"]) {
        if (indexPath.row == 1) {
            UIViewController *controller = [[LXHSelectInputViewController alloc] initWithData:_dataForBuildingTransaction];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            UIViewController *controller = [[LXHOutputListViewController alloc] initWithData:_dataForBuildingTransaction];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
