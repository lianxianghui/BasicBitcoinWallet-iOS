//
//  ViewController.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXHRootViewController : UINavigationController

@property (nonatomic) BOOL showValidatePINViewControllerIfNeeded;//默认YES

/**
 把当前的LXHRootViewController实例去掉。然后新生成一个实例重新进入。
 重新进入的时候不需要输入PIN，也就是showValidatePINViewControllerIfNeeded会被设为NO
 如果没有钱包数据，就进入欢迎页准备初始化钱包
 如果已经有了钱包数据，就进入TabBar主页
 */
+ (void)reEnter;
@end

