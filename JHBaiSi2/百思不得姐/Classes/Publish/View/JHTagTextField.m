//
//  JHTagTextField.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/22.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHTagTextField.h"

@implementation JHTagTextField
#pragma mark - overwrite
/**
 *  点击删除按钮时，系统调用的函数
 */
- (void)deleteBackward {
    // 点击删除键回调block
    !self.deleteWhenHasNoTextCallbackBlock ?  : self.deleteWhenHasNoTextCallbackBlock();
    // 父类行为
    [super deleteBackward];
}

@end
