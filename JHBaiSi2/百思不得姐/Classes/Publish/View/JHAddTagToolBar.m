//
//  JHAddTagToolBar.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/21.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHAddTagToolBar.h"

@interface JHAddTagToolBar ()

@end

@implementation JHAddTagToolBar

- (void)awakeFromNib {
    // toolBar 中添加添加tag按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addBtn.size = addBtn.currentImage.size;
    addBtn.x = JHTopicMargin;
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
}

/**
 *  添加tag按钮点击处理
 */
- (void)addBtnClick:(UIButton *)btn {
    // 调用回调block，push到addTag页面
    !self.addTagBtnDidClickCallbackBlock ? : self.addTagBtnDidClickCallbackBlock(self, btn);
}

@end
