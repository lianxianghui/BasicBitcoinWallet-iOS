// LXHInputMnemonicWordsViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHInputMnemonicWordsViewController.h"
#import "Masonry.h"
#import "LXHInputMnemonicWordsView.h"
#import "LXHWordCell.h"
#import "LXHWalletMnemonicWordsViewController.h"
#import "BTCMnemonic.h"
#import "NSString+Base.h"
#import "UITextField+LXHText.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHInputMnemonicWordsViewController()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic) LXHInputMnemonicWordsView *contentView;
@property (nonatomic) NSArray *currentPromptWords;
@property (nonatomic) NSMutableArray *dataForCells;
@property (nonatomic) NSMutableArray *inputWords;
@end

@implementation LXHInputMnemonicWordsViewController

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
    if (currentInputText.length > 0) {
        NSMutableArray *currentPromptWords = [NSMutableArray array];
        for (NSString *word in [BTCMnemonic englishWordList]) {
            if ([word hasPrefix:currentInputText])
                [currentPromptWords addObject:word];
        }
        self.currentPromptWords = currentPromptWords;
        [self reloadTableview];
    }
}

- (void)clearTextFieldAndPromptWordList {
    self.contentView.inputTextFieldWithPlaceHolder.text = @"";
    self.currentPromptWords = nil;
    [self reloadTableview];
}

- (void)reloadTableview {
    self.dataForCells = nil;
    [self.contentView.listView reloadData];
}

- (void)refreshTextFieldPlaceholder {
    NSString *format = NSLocalizedString(@"请输入第%@个助记词", nil);
    NSString *currentInputPlaceHolder = [NSString stringWithFormat:format, @(self.inputWords.count+1)];
    [self.contentView.inputTextFieldWithPlaceHolder updateAttributedPlaceholderString:currentInputPlaceHolder];
}

//Delegate Methods

- (NSArray *)dataForTableView:(UITableView *)tableView {
    if (!_dataForCells) {
        _dataForCells = [NSMutableArray array];
        if (tableView == self.contentView.listView) {
            for (NSString *word in self.currentPromptWords) {
                NSDictionary *dic = @{@"text":word, @"isSelectable":@"1", @"cellType":@"LXHWordCell"};  
                [_dataForCells addObject:dic];                
            }
        }
    }
    return _dataForCells;
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
            return 33;
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
    if (!self.inputWords)
        self.inputWords = [NSMutableArray array];
    NSString *selectedWord = self.currentPromptWords[indexPath.row];
    [self.inputWords addObject:selectedWord];
    if (self.inputWords.count < 12) {
        [self clearTextFieldAndPromptWordList];
        [self refreshTextFieldPlaceholder];
    } else {
        LXHWalletMnemonicWordsViewController *controller = [[LXHWalletMnemonicWordsViewController alloc] init];
        controller.words = self.inputWords;
        controller.type = LXHWalletMnemonicWordsViewControllerTypeForRestoringExistingWallet;
        [self.navigationController pushViewController:controller animated:YES];
        self.inputWords = nil;
        [self clearTextFieldAndPromptWordList];
        [self refreshTextFieldPlaceholder];
    }
}



@end
