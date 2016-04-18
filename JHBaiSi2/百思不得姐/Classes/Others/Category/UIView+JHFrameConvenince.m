//
//  UIView+JHFrameConvenince.m
//  百思不得姐
//
//  Created by 李建華 on 16/3/24.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "UIView+JHFrameConvenince.h"

@implementation UIView (JHFrameConvenince)
-(CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

/**
 *  判断是否正在被主窗口范围显示
 */
- (BOOL)isShowingInKeyWindow {
    // 判断子视图是否是scrollView
    BOOL isScrollView = [self isKindOfClass:[UIScrollView class]];
    // 判断子视图是否 可见 且 不透明
    BOOL isVisible = self.hidden == NO && self.alpha > 0.01;
    // 判断子视图是否 在主窗体的层次结构中 且 在主窗体的坐标系下是否与主窗体有交集(显示在主窗体范围下)
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect subViewFrameInKeyWindow = [self.superview convertRect:self.frame toView:keyWindow];
    BOOL isInKeyWindow = self.window == keyWindow && CGRectIntersectsRect(subViewFrameInKeyWindow, keyWindow.frame);
    
    return isScrollView && isVisible && isInKeyWindow;
}
@end
