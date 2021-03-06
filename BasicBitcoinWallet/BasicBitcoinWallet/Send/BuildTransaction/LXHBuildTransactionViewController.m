// LXHBuildTransactionViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-11-19
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHBuildTransactionViewController.h"
#import "Masonry.h"
#import "LXHBuildTransactionView.h"
#import "LXHInputFeeViewController.h"
#import "LXHSelectInputViewController.h"
#import "LXHOutputListViewController.h"
#import "LXHSelectFeeRateViewController.h"
#import "LXHTransactionInfoViewController.h"
#import "LXHTitleCell1.h"
#import "LXHSelectionCell.h"
#import "LXHInputOutputCell.h"
#import "LXHTitleCell2.h"
#import "LXHFeeCell.h"
#import "LXHBuildTransactionViewModel.h"
#import "LXHGlobalHeader.h"
#import "UIViewController+LXHAlert.h"
#import "UILabel+LXHText.h"
#import "Toast.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHBuildTransactionViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHBuildTransactionView *contentView;
@property (nonatomic) LXHBuildTransactionViewModel *viewModel;
@property (nonatomic) NSArray *cellDataListForListView;
@end

@implementation LXHBuildTransactionViewController

- (instancetype)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHBuildTransactionView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self setContentViewProperties];
    [self addActions];
    [self setDelegates];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshListView];
    [self showPromptIfNeeded];
}

- (void)showPromptIfNeeded {
    NSInteger statusCode = [_viewModel currentStatusCode];
    switch (statusCode) {
        case -1://实际手续费过多，有可能造成浪费的情况。
        {
            if ([_viewModel hasChangeOutput])
                return;
            NSString *prompt = NSLocalizedString(@"是否添加找零?", nil);
            LXHWeakSelf
            [self showYesNoAlertViewWithMessage:prompt yesHandler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.viewModel addChangeOutputAtRandomPosition];
                [weakSelf refreshListView];
            } noHandler:^(UIAlertAction * _Nonnull action) {
                
            }];
        }
        default:
            break;
    }
}

- (void)setContentViewProperties {
    [self.contentView.title updateAttributedTextString:[_viewModel navigationBarTitle]];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.rightTextButton addTarget:self action:@selector(rightTextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDelegates {
    self.contentView.listView.dataSource = self;
    self.contentView.listView.delegate = self;
}

//Actions
- (void)leftImageButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftImageButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)leftImageButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)rightTextButtonClicked:(UIButton *)sender {
    NSInteger code = [_viewModel currentStatusCode];
    switch (code) {
        case 0:
        case 1:
            [self pushLXHTransactionInfoViewController];
            break;
        case -1:
        {
            LXHWeakSelf
            NSString *note = [weakSelf.viewModel hasChangeOutput] ? NSLocalizedString(@"您可以通过修改或重新添加找零的方式进行调整", nil) :
            NSLocalizedString(@"您可以通过添加找零的方式进行调整", nil);
            NSString *promptFomat = NSLocalizedString(@"实际手续费大于根据费率估算的手续费，有可能造成浪费，您确定要进入下一步吗？(%@)", nil);
            NSString *prompt = [NSString stringWithFormat:promptFomat, note];
            [self showOkCancelAlertViewWithMessage:prompt okHandler:^(UIAlertAction * _Nonnull action) {
                [weakSelf pushLXHTransactionInfoViewController];
            } cancelHandler:^(UIAlertAction * _Nonnull action) {
                
            }];
            break;
        }
        case -2:
        {
            LXHWeakSelf
            NSString *prompt = NSLocalizedString(@"实际手续费小于根据费率估算的手续费，有可能影响到账时间，您确定要进入下一步吗？", nil);
            [self showOkCancelAlertViewWithMessage:prompt okHandler:^(UIAlertAction * _Nonnull action) {
                [weakSelf pushLXHTransactionInfoViewController];
            } cancelHandler:^(UIAlertAction * _Nonnull action) {
                
            }];
            break;
        }
        case -3:
        {
            NSString *prompt = NSLocalizedString(@"输入无法满足输出", nil);
            [self showOkAlertViewWithMessage:prompt handler:nil];
            break;
        }
        case -4:
        {
            NSString *prompt = NSLocalizedString(@"输入、输出或费率未正确选择或填写", nil);
            [self showOkAlertViewWithMessage:prompt handler:nil];
            break;
        }
        default:
        {
            NSString *prompt = NSLocalizedString(@"出现未知错误", nil);
            [self showOkAlertViewWithMessage:prompt handler:nil];
            break;
            
        }
            break;
    }
}

- (void)pushLXHTransactionInfoViewController {
    id viewModel = [_viewModel transactionInfoViewModel];
    UIViewController *controller = [[LXHTransactionInfoViewController alloc] initWithViewModel:viewModel];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


//Actions
- (void)LXHFeeCellInputFeeValueButtonClicked:(UIButton *)sender {
    LXHWeakSelf
    id viewModel = _viewModel.inputFeeViewModel;
    UIViewController *controller = [[LXHInputFeeViewController alloc] initWithViewModel:viewModel dataChangedCallback:^{
        [weakSelf.viewModel resetSelectFeeRateViewModel];//把LXHSelectFeeRateViewController数据置空
    }];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)LXHFeeCellSelectFeerateButtonClicked:(UIButton *)sender {
    LXHWeakSelf
    id viewModel = _viewModel.selectFeeRateViewModel;
    UIViewController *controller = [[LXHSelectFeeRateViewController alloc] initWithViewModel:viewModel dataChangedCallback:^{
        [weakSelf.viewModel resetInputFeeViewModel]; //把LXHInputFeeViewController数据置空
    }];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)refreshListView {
    _cellDataListForListView = nil;
    [self.contentView.listView reloadData];
}

//Delegate Methods
- (NSArray *)cellDataListForTableView:(UITableView *)tableView {
    if (tableView == self.contentView.listView) {
        if (!_cellDataListForListView) {
            _cellDataListForListView = [_viewModel cellDataForListview];
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
    if ([cellType isEqualToString:@"LXHTitleCell1"])
        return 100;
    if ([cellType isEqualToString:@"LXHSelectionCell"])
        return 101;
    if ([cellType isEqualToString:@"LXHInputOutputCell"])
        return 102;
    if ([cellType isEqualToString:@"LXHTitleCell2"])
        return 103;
    if ([cellType isEqualToString:@"LXHFeeCell"])
        return 104;
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
    if ([cellType isEqualToString:@"LXHTitleCell1"]) {
        LXHTitleCell1 *cellView = (LXHTitleCell1 *)view;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
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
    if ([cellType isEqualToString:@"LXHTitleCell2"]) {
        LXHTitleCell2 *cellView = (LXHTitleCell2 *)view;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
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
        if ([cellType isEqualToString:@"LXHTitleCell1"])
            return 38;
        if ([cellType isEqualToString:@"LXHSelectionCell"])
            return 50;
        if ([cellType isEqualToString:@"LXHInputOutputCell"])
            return 50;
        if ([cellType isEqualToString:@"LXHTitleCell2"])
            return 38;
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
        NSDictionary *data = [self cellDataForTableView:tableView atIndexPath:indexPath];
        NSString *cellId = data[@"id"];
        if (!cellId)
            return;
        if ([cellId isEqualToString:@"selectInput"]) {
            NSString *prompt = [_viewModel clickSelectInputPrompt];
            if (prompt) {
                [self showOkAlertViewWithMessage:prompt handler:nil];
                return;
            }
            id viewModel = [_viewModel selectInputViewModel];
            UIViewController *controller = [[LXHSelectInputViewController alloc] initWithViewModel:viewModel];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        } else if ([cellId isEqualToString:@"selectOutput"]) {
            NSString *prompt = [_viewModel clickSelectOutputPrompt];
            if (prompt) {
                [self showOkAlertViewWithMessage:prompt handler:nil];
                return;
            }
            id viewModel = _viewModel.outputListViewModel;
            UIViewController *controller = [[LXHOutputListViewController alloc] initWithViewModel:viewModel];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
