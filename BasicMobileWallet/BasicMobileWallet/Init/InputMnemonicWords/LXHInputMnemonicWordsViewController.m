// LXHInputMnemonicWordsViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHInputMnemonicWordsViewController.h"
#import "Masonry.h"
#import "LXHInputMnemonicWordsView.h"
#import "LXHWordCell.h"
#import "LXHCheckWalletMnemonicWordsViewController.h"
#import "UITextField+LXHText.h"
#import "LXHInputMnemonicWordsViewModel.h"
#import "NSString+Base.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHInputMnemonicWordsViewController()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic) LXHInputMnemonicWordsView *contentView;
@property (nonatomic) LXHInputMnemonicWordsViewModel *viewModel;
@end

@implementation LXHInputMnemonicWordsViewController

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
    self.contentView = [[LXHInputMnemonicWordsView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self setSubviewProperties];
    [self addActions];
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSubviewProperties {
    self.contentView.inputTextFieldWithPlaceHolder.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.contentView.inputTextFieldWithPlaceHolder.autocorrectionType = UITextAutocorrectionTypeNo;//For Security Consideration
}

- (void)addActions {
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.inputTextFieldWithPlaceHolder addTarget:self action:@selector(inputTextFieldWithPlaceHolderChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setDelegates {
    self.contentView.listView.dataSource = self;
    self.contentView.listView.delegate = self;
    self.contentView.inputTextFieldWithPlaceHolder.delegate = self;
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

- (void)inputTextFieldWithPlaceHolderChanged:(UITextField *)sender {
    NSString *text = sender.text;
    NSString *currentInputText = [text stringByTrimmingWhiteSpace];
    if ([_viewModel refreshCellDataArrayForListViewByCurrentInputText:currentInputText])
        [self.contentView.listView reloadData];
}

- (void)clearTextFieldAndPromptWordList {
    self.contentView.inputTextFieldWithPlaceHolder.text = @"";
    [self reloadTableview];
}

- (void)reloadTableview {
    [_viewModel resetCellDataArrayForListView];
    [self.contentView.listView reloadData];
}

- (void)refreshTextFieldPlaceholder {
    NSString *currentInputPlaceHolder = [_viewModel currentInputPlaceHolder];
    [self.contentView.inputTextFieldWithPlaceHolder updateAttributedPlaceholderString:currentInputPlaceHolder];
}

//Delegate Methods

- (NSArray *)dataForTableView:(UITableView *)tableView {
    if (tableView == self.contentView.listView)
        return [_viewModel cellDataArrayForListView];
    else
        return [NSArray array];
}

- (id)cellDataForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataForTableView = [self dataForTableView:tableView];
    if (indexPath.row < dataForTableView.count) 
        return dataForTableView[indexPath.row];
    else
        return nil;
}


- (NSString *)tableView:(UITableView *)tableView cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentView.listView) {
        NSArray *data = [self dataForTableView:tableView];
        if (indexPath.row < data.count) {
            NSDictionary *cellData = data[indexPath.row];
            return cellData[@"cellType"];
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView viewTagAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if ([cellType isEqualToString:@"LXHWordCell"])
        return 100;
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
        UIView *view = [NSClassFromString(viewClass) new];
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
    if ([cellType isEqualToString:@"LXHWordCell"]) {
        LXHWordCell *cellView = (LXHWordCell *)view;
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
        if ([cellType isEqualToString:@"LXHWordCell"])
            return 40;
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
    [_viewModel selectWordAtIndex:indexPath.row];
    if ([_viewModel selectWordsUnfinshed]) {
        [self clearTextFieldAndPromptWordList];
        [self refreshTextFieldPlaceholder];
    } else {
        id viewModel = [_viewModel checkWalletMnemonicWordsViewModel];
        LXHCheckWalletMnemonicWordsViewController *controller = [[LXHCheckWalletMnemonicWordsViewController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:controller animated:YES];
        _viewModel.inputWords = nil;
        [self clearTextFieldAndPromptWordList];
        [self refreshTextFieldPlaceholder];
    }
}

@end
