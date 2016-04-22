//
//  JHAddTagViewController.h
//  百思不得姐
//
//  Created by 李建華 on 16/4/21.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHAddTagViewController : UIViewController
/**
 *  点击完成按钮回调block
 */
@property(nonatomic, copy)void(^tagsWillAcommplishCallbackBlock)(NSArray<NSString *> *tagTitles);
/**
 *  前一个页面正在显示的标签的标题集合
 */
@property(nonatomic, strong)NSArray<NSString *> *showingTitles;
@end
