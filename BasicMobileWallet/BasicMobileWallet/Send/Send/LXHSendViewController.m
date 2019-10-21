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

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSendViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHSendView *contentView;

@end

@implementation LXHSendViewController

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
    UIViewController *controller = [[LXHInputFeeViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}


- (void)LXHFeeCellSelectFeerateButtonClicked:(UIButton *)sender {
    UIViewController *controller = [[LXHSelectFeeRateViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}


//Delegate Methods
- (NSArray *)dataForTableView:(UITableView *)tableView {
    static NSMutableArray *dataForCells = nil;
    if (!dataForCells) {
        dataForCells = [NSMutableArray array];
        if (tableView == self.contentView.listView) {
            NSDictionary *dic = nil;
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
            [dataForCells addObject:dic];
            dic = @{@"isSelectable":@"1", @"disclosureIndicator":@"disclosure_indicator", @"cellType":@"LXHSelectionCell", @"text":@"选择输入"};
            [dataForCells addObject:dic];
            dic = @{@"addressText":@"mqo7674J9Q7hpfPB6qFoYufMdoNjEsRZHx ", @"text":@"1. ", @"isSelectable":@"1", @"btcValue":@"0.00000323 BTC", @"cellType":@"LXHInputOutputCell"};
            [dataForCells addObject:dic];
            dic = @{@"addressText":@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ", @"text":@"2.", @"isSelectable":@"1", @"btcValue":@"0.00000323 BTC", @"cellType":@"LXHInputOutputCell"};
            [dataForCells addObject:dic];
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
            [dataForCells addObject:dic];
            dic = @{@"text":@"手续费：40sat/byte （费率）", @"isSelectable":@"0", @"cellType":@"LXHFeeCell"};
            [dataForCells addObject:dic];
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
            [dataForCells addObject:dic];
            dic = @{@"isSelectable":@"1", @"disclosureIndicator":@"disclosure_indicator", @"cellType":@"LXHSelectionCell", @"text":@"选择输出"};
            [dataForCells addObject:dic];
            dic = @{@"addressText":@"mqo7674J9Q7hpfPB6qFoYufMdoNjEsRZHx ", @"text":@"1. ", @"isSelectable":@"1", @"btcValue":@"0.00003023 BTC", @"cellType":@"LXHInputOutputCell"};
            [dataForCells addObject:dic];
            dic = @{@"addressText":@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ", @"text":@"2.", @"isSelectable":@"1", @"btcValue":@"0.00000023 BTC", @"cellType":@"LXHInputOutputCell"};
            [dataForCells addObject:dic];
        }
    }
    return dataForCells;
}

- (id)cellDataForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataForTableView = [self dataForTableView:tableView];
    if (indexPath.row < dataForTableView.count)
        return [dataForTableView objectAtIndex:indexPath.row];
    else
        return nil;
}


- (NSString *)tableView:(UITableView *)tableView cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentView.listView) {
        NSArray *data = [self dataForTableView:tableView];
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
    return [self dataForTableView:tableView].count;
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
    if ([cellType isEqualToString:@"LXHEmptyCell"]) {
        LXHEmptyCell *cellView = (LXHEmptyCell *)view;
    }
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
            return 49.99999999999997;
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
    switch(indexPath.row) {
        case 0:
            {
            }
            break;
        case 1:
            {
            UIViewController *controller = [[LXHSelectInputViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        case 2:
            {
            }
            break;
        case 3:
            {
            }
            break;
        case 4:
            {
            }
            break;
        case 5:
            {
            }
            break;
        case 6:
            {
            }
            break;
        case 7:
            {
            UIViewController *controller = [[LXHOutputListViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        case 8:
            {
            }
            break;
        case 9:
            {
            }
            break;
        default:
            break;
    }
}

@end
