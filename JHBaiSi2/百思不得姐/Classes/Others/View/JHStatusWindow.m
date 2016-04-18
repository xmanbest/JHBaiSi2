//
//  JHStatusWindow.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/17.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHStatusWindow.h"
/**
 *  单例对象
 */
static UIWindow *statusWindow_ = nil;

@implementation JHStatusWindow
+ (void)initialize {
    // 初始化代码
    statusWindow_ = [[UIWindow alloc] init];
    statusWindow_.frame = CGRectMake(0, 0, JHScreenW, 20);
    statusWindow_.windowLevel = UIWindowLevelAlert;
    [statusWindow_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle)]];
    statusWindow_.backgroundColor = [UIColor clearColor];
    
    // 抑制报错添加的代码
    statusWindow_.rootViewController = [[UIViewController alloc] init];
}

/**
 *  状态栏点击处理方法
 *  当前显示的视图如果有scrollView，使其回滚到顶部
 */
+ (void)tapHandle {
    // 递归找到当前显示视图的所有scrollView，使其回滚顶部
    [self setOnDisplayScrollViewOffsetTopInView:[UIApplication sharedApplication].keyWindow];
}
/**
 *  递归找到当前显示视图的所有scrollView，使其回滚顶部
 */
+ (void)setOnDisplayScrollViewOffsetTopInView:(UIView *)supview {
    for (UIView *subview in supview.subviews) {
        // 1.判断是否正在被主窗口范围显示，进行回滚
        if (subview.showingInKeyWindow) {
            UIScrollView *scroll = ((UIScrollView *)subview);
            CGPoint offset = scroll.contentOffset;
            offset.y = -scroll.contentInset.top;
            scroll.contentOffset = offset;
        }
        
        // 2.继续递归子视图
        [self setOnDisplayScrollViewOffsetTopInView:subview];
    }
}

#pragma mark - 接口实现
+ (void)show {
    statusWindow_.hidden = NO;
}

+ (void)hide {
    statusWindow_.hidden = YES;
}
@end
