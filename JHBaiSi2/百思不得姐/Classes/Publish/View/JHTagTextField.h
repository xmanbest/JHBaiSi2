//
//  JHTagTextField.h
//  百思不得姐
//
//  Created by 李建華 on 16/4/22.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTagTextField : UITextField
/**
 *  点击删除键回调block
 */
@property (nonatomic, copy)void(^deleteWhenHasNoTextCallbackBlock)();
@end
