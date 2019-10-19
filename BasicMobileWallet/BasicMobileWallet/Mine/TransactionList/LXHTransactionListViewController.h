// LXHTransactionListViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LXHTransactionListViewControllerType) {
    LXHTransactionListViewControllerTypeAllTransactions,
    LXHTransactionListViewControllerTypeTransactionByAddress,
};

@interface LXHTransactionListViewController : UIViewController

- (instancetype)initWithData:(NSDictionary *)data;//data has key "type"
@end
