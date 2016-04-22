//
//  JHAddTagToolBar.h
//  百思不得姐
//
//  Created by 李建華 on 16/4/21.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHAddTagToolBar : UIView
/**
 *  添加标签按钮点击后，执行的block
 */
@property(copy, nonatomic)void(^addTagBtnDidClickCallbackBlock)(UIButton *addTagBtn, NSArray<NSString *> *showingTagTitles);

/**
 *  显示完成的tags，并排列
 */
- (void)showTagsWithTitles:(NSArray<NSString *> *)tagTitles;
@end
