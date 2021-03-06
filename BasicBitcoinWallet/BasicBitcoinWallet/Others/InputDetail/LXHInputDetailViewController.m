// LXHInputDetailViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHInputDetailViewController.h"
#import "Masonry.h"
#import "LXHInputDetailView.h"
#import "LXHTransactionDetailViewController.h"
#import "LXHAddressDetailCell.h"
#import "LXHUnLockingScriptCell.h"
#import "LXHTwoColumnTextCell.h"
#import "LXHEmptyWithSeparatorCell.h"
#import "LXHOutputDetailTextRightIconCell.h"
#import "LXHInputDetailViewModel.h"
#import "Toast.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHInputDetailViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHInputDetailView *contentView;
@property (nonatomic) LXHInputDetailViewModel *viewModel;
@end

@implementation LXHInputDetailViewController

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
    self.contentView = [[LXHInputDetailView alloc] init];
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
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
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

//Delegate Methods
- (NSArray *)dataForTableView:(UITableView *)tableView {
    return _viewModel.dataForCells;
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
    if ([cellType isEqualToString:@"LXHAddressDetailCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHUnLockingScriptCell"])
        return 101;
    if ([cellType isEqualToString:@"LXHTwoColumnTextCell"])
        return 102;
    if ([cellType isEqualToString:@"LXHEmptyWithSeparatorCell"])
        return 103;
    if ([cellType isEqualToString:@"LXHOutputDetailTextRightIconCell"])
        return 104;
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
    if ([cellType isEqualToString:@"LXHAddressDetailCell"]) {
        LXHAddressDetailCell *cellView = (LXHAddressDetailCell *)view;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
    }
    if ([cellType isEqualToString:@"LXHUnLockingScriptCell"]) {
        LXHUnLockingScriptCell *cellView = (LXHUnLockingScriptCell *)view;
        NSString *content = [dataForRow valueForKey:@"content"];
        if (!content)
            content = @"";
        NSMutableAttributedString *contentAttributedString = [cellView.content.attributedText mutableCopy];
        [contentAttributedString.mutableString setString:content];
        cellView.content.attributedText = contentAttributedString;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
    }
    if ([cellType isEqualToString:@"LXHTwoColumnTextCell"]) {
        LXHTwoColumnTextCell *cellView = (LXHTwoColumnTextCell *)view;
        NSString *content = [dataForRow valueForKey:@"text"];
        if (!content)
            content = @"";
        NSMutableAttributedString *contentAttributedString = [cellView.text.attributedText mutableCopy];
        [contentAttributedString.mutableString setString:content];
        cellView.text.attributedText = contentAttributedString;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
    }
    if ([cellType isEqualToString:@"LXHOutputDetailTextRightIconCell"]) {
        LXHOutputDetailTextRightIconCell *cellView = (LXHOutputDetailTextRightIconCell *)view;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHAddressDetailCell"])
            return 47;
        if ([cellType isEqualToString:@"LXHUnLockingScriptCell"])
            return 100;
        if ([cellType isEqualToString:@"LXHTwoColumnTextCell"])
            return 60;
        if ([cellType isEqualToString:@"LXHEmptyWithSeparatorCell"])
            return 18;
        if ([cellType isEqualToString:@"LXHOutputDetailTextRightIconCell"])
            return 47;
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
    NSDictionary *cellData = [self cellDataForTableView:tableView atIndexPath:indexPath];
    NSNumber *cellId = cellData[@"cellId"];
    if (!cellId)
        return;
    switch(cellId.integerValue) {
        case 0:
            {
                //先从本地获取，如果没有就请求
                id viewModel = [_viewModel transactionDetailViewModel];
                if (viewModel) {
                    [self pushTransactionDetailViewControllerWithViewModel:viewModel];
                } else {
                    __weak __typeof(self)weakSelf = self;
                    [self.contentView.indicatorView startAnimating];
                    [_viewModel asynchronousTransactionDetailViewModelWithSuccessBlock:^(id  _Nonnull viewModel) {
                        [self.contentView.indicatorView stopAnimating];
                        if (viewModel) {
                            [weakSelf pushTransactionDetailViewControllerWithViewModel:viewModel];
                        }
                    } failureBlock:^(NSString * _Nonnull errorPrompt) {
                        [self.contentView.indicatorView stopAnimating];
                        [weakSelf.view makeToast:errorPrompt];
                    }];
                }
            }
            break;
        default:
            break;
    }
}

- (void)pushTransactionDetailViewControllerWithViewModel:(id)viewModel {
    UIViewController *controller = [[LXHTransactionDetailViewController alloc] initWithViewModel:viewModel];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
