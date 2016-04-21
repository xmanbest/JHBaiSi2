//
//  JHLabelPlaceholderTextView.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/20.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHLabelPlaceholderTextView.h"

@interface JHLabelPlaceholderTextView ()
@property (weak, nonatomic) UILabel *placeholderLabel;
@end

@implementation JHLabelPlaceholderTextView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置始终可以垂直拖动
        self.alwaysBounceVertical = YES;
        
        self.font = [UIFont systemFontOfSize:15];
        
        // 添加placeholderLabel
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        placeholderLabel.width = JHScreenW - 2 * placeholderLabel.x;
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.font = self.font;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
        // 注册文本内容改变通知 观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChanged) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // 刷新占位符label的frame
    self.placeholderLabel.height = [self.placeholderLabel.text boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size.height;
}

/**
 *  文本内容改变通知 观察者
 */
- (void)textViewTextDidChanged {
    // 有文字内容则隐藏占位符
    self.placeholderLabel.hidden = [self hasText];
}

#pragma mark - SetMethods
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.placeholderLabel.text = placeholder;
    // 刷新占位符label的frame
    [self setNeedsLayout];
}
@end
