//
//  JHTagButton.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/22.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHTagButton.h"

@implementation JHTagButton
#pragma mark - OverWrite
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    // 更新frame
    [self sizeToFit];
}

- (void)sizeToFit {
    [super sizeToFit];
    
    self.width += 3 * JHTagMargin;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.x = JHTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + JHTagMargin;
}
@end
