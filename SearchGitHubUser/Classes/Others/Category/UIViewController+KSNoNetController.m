//
//  UIViewController+KSNoNetController.m
//  Test
//
//  Created by KS on 15/11/25.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import "UIViewController+KSNoNetController.h"
#import "UIColor+Expanded.h"


@implementation UIViewController (KSNoNetController)

- (void)showNonetWork
{
    NoNetView* view = [NoNetView sharednoNetWorkView];
    view.delegate = self;
    [self.view addSubview:view.noNetWorkView];
}
- (void)hiddenNonetWork
{
    NoNetView* view = [NoNetView sharednoNetWorkView];
    [view.noNetWorkView removeFromSuperview];
}
- (void)reloadNetworkDataSource:(id)sender
{
    if ([self respondsToSelector:@selector(reloadRequest)]) {
        [self performSelector:@selector(reloadRequest)];
    }
}
- (void)reloadRequest
{
    NSLog(@"必须由网络控制器(%@)重写这个方法(%@)，才可以使用再次刷新网络",NSStringFromClass([self class]),NSStringFromSelector(@selector(reloadRequest)));
}


@end

@implementation NoNetView


+ (NoNetView *)sharednoNetWorkView {
    
    static NoNetView *noNetView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noNetView = [[NoNetView alloc]init];
    });
    
    return noNetView;
}

/**
 *  没有网路提示框
 *
 *  @return 无网络View
 */
- (UIView *) noNetWorkView
{
    if(_noNetWorkView)
    {
        return _noNetWorkView;
    }
    
    _noNetWorkView = ({
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.image = [UIImage imageNamed:@"noNetWork"];
        [view addSubview:imageview];
        
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.centerY.equalTo(view.mas_centerY).with.offset(-60);
        }];
        
        UILabel *alertLab = ({
        
            UILabel *label = [[UILabel alloc]init];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"网络不给力，请稍后再试吧~";
            label.textColor = [UIColor colorWithString:@"0x5a5a5a"];
            label;
        });
        
        [view addSubview:alertLab];
        [alertLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.top.mas_equalTo(imageview.mas_bottom).with.offset(20);
        }];
        
        UIButton *refreshBut = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"再试一次" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(reloadNetworkDataSource:) forControlEvents:UIControlEventTouchDown];
        
            button;
        });
        
        [view addSubview:refreshBut];
        [refreshBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.top.mas_equalTo(alertLab.mas_bottom).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(200, 40));
        }];
        view;
    });

    return _noNetWorkView;
}

- (void)reloadNetworkDataSource:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadNetworkDataSource:)]) {
        [self.delegate performSelector:@selector(reloadNetworkDataSource:) withObject:sender];
    }
}

@end



