//
//  JHPlaceholderTextView.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/20.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHPlaceholderTextView.h"

@implementation JHPlaceholderTextView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:15];
        
        // 注册文本内容改变通知 观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChanged) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

/**
 *  文本内容改变通知 观察者
 */
- (void)textViewTextDidChanged {
    // 立即重绘layer
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // 如果有文字内容，则本次重绘不绘制占位文字
    if ([self hasText]) return;
    
    // rect = {{0, -64}, {414, 736}}，需要更改
    rect.origin.x = 4;
    rect.origin.y = 7;
    rect.size.width -= 2 * rect.origin.x;
    
    // 绘制占位文字
    NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
    attrDic[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    attrDic[NSFontAttributeName] = self.font;
    [self.placeholder drawInRect:rect withAttributes:attrDic];
}


@end
