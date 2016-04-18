//
//  UIImage+JHExtension.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/18.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "UIImage+JHExtension.h"

@implementation UIImage (JHExtension)
- (UIImage *)circleImage {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获取当前绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 画圆
    CGRect circleRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, circleRect);
    // 剪切成圆形画布
    CGContextClip(context);
    // 在圆形画布上绘图
    [self drawInRect:circleRect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
