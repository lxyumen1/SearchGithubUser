//
//  UIViewController+KSNoNetController.h
//  Test
//
//  Created by KS on 15/11/25.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoNetView;

@protocol KSNoNetViewDelegate  <NSObject>

- (void)reloadNetworkDataSource:(id)sender;

@end

@interface UIViewController (KSNoNetController)<KSNoNetViewDelegate>

/**
 *  为控制器扩展方法，刷新网络时候执行，建议必须实现
 */
- (void)reloadRequest;

/**
 *  显示没有网络
 */
- (void)showNonetWork;

/**
 *  隐藏没有网络
 */
- (void)hiddenNonetWork;

@end



@interface  NoNetView: UIView

/**
 *  由代理控制器去执行刷新网络
 */
@property (nonatomic, strong) id<KSNoNetViewDelegate>delegate;

@property(nonatomic,retain)UIView *noNetWorkView;

/**
 *  初始化方法,可以自定义,
 *
 *  @return KSNotNetView
 */
+ (NoNetView *)sharednoNetWorkView;

@end