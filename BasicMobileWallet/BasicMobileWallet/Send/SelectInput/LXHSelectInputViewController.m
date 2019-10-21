// LXHSelectInputViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSelectInputViewController.h"
#import "Masonry.h"
#import "LXHSelectInputView.h"
#import "LXHOutputDetailViewController.h"
#import "LXHTopLineCell.h"
#import "LXHSelectInputCell.h"
#import "LXHTransactionDataManager.h"
#import "UILabel+LXHText.h"
#import "BlocksKit.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSelectInputViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHSelectInputView *contentView;
@property (nonatomic) NSMutableArray *cellDataListForListView;
@property (nonatomic) NSString *observerToken;
@end

@implementation LXHSelectInputViewController

- (void)dealloc
{
    if (_observerToken)
        [[LXHTransactionDataManager sharedInstance] bk_removeObserversWithIdentifier:_observerToken];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHSelectInputView alloc] init];
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
    [self.contentView.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.rightTextButton addTarget:self action:@selector(rightTextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.rightTextButton addTarget:self action:@selector(rightTextButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.rightTextButton addTarget:self action:@selector(rightTextButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
    self.contentView.listView.dataSource = self;
    self.contentView.listView.delegate = self;
}

- (void)setViewProperties {
    NSString *balanceValueText = [NSString stringWithFormat:@"%@ BTC", [[LXHTransactionDataManager sharedInstance] balance]];
    [self.contentView.value updateAttributedTextString:balanceValueText];

}

- (void)addObservers {
    //观察transactionList, 有变化时刷新列表
    __weak __typeof(self)weakSelf = self;
    _observerToken =  [[LXHTransactionDataManager sharedInstance] bk_addObserverForKeyPath:@"transactionList" task:^(id target) {
        [weakSelf reloadListView];
    }];
}

- (void)reloadListView {
    self.cellDataListForListView = nil;
    [self.contentView.listView reloadData];
}

//Actions
- (void)buttonClicked:(UIButton *)sender {
}


- (void)rightTextButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightTextButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)rightTextButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

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

- (void)LXHSelectInputCellButtonClicked:(UIButton *)sender {
    NSUInteger index = (NSUInteger)sender.tag;
    if (index >= self.cellDataListForListView.count)
        return;
    NSDictionary *cellData = self.cellDataListForListView[index];
    LXHTransactionOutput *output = cellData[@"data"];
    if (!output)
        return;
    UIViewController *controller = [[LXHOutputDetailViewController alloc] initWithOutput:output];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}

//按value从大到小排序
- (NSMutableArray<LXHTransactionOutput *> *)utxos {
    NSMutableArray<LXHTransactionOutput *> *ret = [[LXHTransactionDataManager sharedInstance] utxosOfAllTransactions];
    [ret sortUsingComparator:^NSComparisonResult(LXHTransactionOutput *  _Nonnull obj1, LXHTransactionOutput *  _Nonnull obj2) {
        return -[obj1.value compare:obj2.value];
    }];
    return ret;
}

//Delegate Methods
- (NSArray *)dataForTableView:(UITableView *)tableView {
    if (tableView == self.contentView.listView) {
        if (!_cellDataListForListView) {
            _cellDataListForListView = [NSMutableArray array];
            NSDictionary *dic = nil;
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHTopLineCell"};
            [_cellDataListForListView addObject:dic];
            for (LXHTransactionOutput *utxo in [self utxos]) {
                NSString *valueText = [NSString stringWithFormat:@"%@ BTC", utxo.value];
                
                static NSDateFormatter *formatter = nil;
                if (!formatter) {
                    formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = NSLocalizedString(LXHTranactionTimeDateFormat, nil);
                }
                LXHTransaction *transaction = [[LXHTransactionDataManager sharedInstance] transactionByTxid:utxo.txid];
                NSInteger time = [transaction.time integerValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                NSString *transactionTime = [formatter stringFromDate:date];
                NSMutableDictionary *dic = @{@"circleImage":@"check_circle",
                                             @"cellType":@"LXHSelectInputCell",
                                             @"time": NSLocalizedString(@"交易时间:", nil),
                                             @"btcValue":@"0.00000004 BTC",
                                             @"addressText":@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ",
                                             @"checkedImage":@"checked_circle", @"isSelectable":@"1",
                                             @"timeValue":@"2019-09-01 12:36"}.mutableCopy;
                dic[@"btcValue"] = valueText;
                dic[@"addressText"] = utxo.address ?: @"";
                dic[@"timeValue"] = transactionTime;
                dic[@"data"] = utxo;
                [_cellDataListForListView addObject:dic];
            }
        }
        return _cellDataListForListView;
    } else {
        return nil;
    }
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
    if ([cellType isEqualToString:@"LXHTopLineCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHSelectInputCell"])
        return 101;
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
    if ([cellType isEqualToString:@"LXHTopLineCell"]) {
        LXHTopLineCell *cellView = (LXHTopLineCell *)view;
    }
    if ([cellType isEqualToString:@"LXHSelectInputCell"]) {
        LXHSelectInputCell *cellView = (LXHSelectInputCell *)view;
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
        NSString *timeValue = [dataForRow valueForKey:@"timeValue"];
        if (!timeValue)
            timeValue = @"";
        NSMutableAttributedString *timeValueAttributedString = [cellView.timeValue.attributedText mutableCopy];
        [timeValueAttributedString.mutableString setString:timeValue];
        cellView.timeValue.attributedText = timeValueAttributedString;
        NSString *time = [dataForRow valueForKey:@"time"];
        if (!time)
            time = @"";
        NSMutableAttributedString *timeAttributedString = [cellView.time.attributedText mutableCopy];
        [timeAttributedString.mutableString setString:time];
        cellView.time.attributedText = timeAttributedString;
        NSString *circleImageImageName = [dataForRow valueForKey:@"circleImage"];
        if (circleImageImageName)
            cellView.circleImage.image = [UIImage imageNamed:circleImageImageName];
        NSString *checkedImageImageName = [dataForRow valueForKey:@"checkedImage"];
        if (checkedImageImageName)
            cellView.checkedImage.image = [UIImage imageNamed:checkedImageImageName];
        cellView.button.tag = indexPath.row;
        [cellView.button addTarget:self action:@selector(LXHSelectInputCellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHTopLineCell"])
            return 0.5;
        if ([cellType isEqualToString:@"LXHSelectInputCell"])
            return 80;
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
            }
            break;
        default:
            break;
    }
}

@end
