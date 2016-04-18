//
//  UIView+JHFrameConvenince.h
//  百思不得姐
//
//  Created by 李建華 on 16/3/24.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JHFrameConvenince)
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, assign)CGFloat x;
@property(nonatomic, assign)CGFloat y;
@property(nonatomic, assign)CGSize size;
@property(nonatomic, assign)CGPoint origin;
@property(nonatomic, assign)CGFloat centerX;
@property(nonatomic, assign)CGFloat centerY;

/**
 *  判断是否正在被主窗口范围显示
 */
@property(nonatomic, assign, readonly, getter=isShowingInKeyWindow)BOOL showingInKeyWindow;
@end
