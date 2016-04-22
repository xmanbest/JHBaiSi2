//
//  JHAddTagToolBar.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/21.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHAddTagToolBar.h"

@interface JHAddTagToolBar ()
@property (weak, nonatomic) IBOutlet UIView *tagsView;
/**
 *  添加标签按钮
 */
@property (weak, nonatomic) UIButton *addBtn;
/**
 *  显示的标签容器
 */
@property (strong, nonatomic) NSMutableArray<UILabel *> *tagLbls;
@end

@implementation JHAddTagToolBar

- (void)awakeFromNib {
    // toolBar 中添加添加tag按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addBtn.size = addBtn.currentImage.size;
    addBtn.x = JHTopicMargin;
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tagsView addSubview:addBtn];
    self.addBtn = addBtn;
}

- (NSMutableArray<UILabel *> *)tagLbls {
    if (_tagLbls == nil) {
        _tagLbls = [NSMutableArray array];
    }
    return _tagLbls;
}

/**
 *  添加tag按钮点击处理
 */
- (void)addBtnClick:(UIButton *)btn {
    // 获取正在显示的tag标题集合
    NSArray<NSString *> *showingTitles = [self.tagLbls valueForKey:@"text"];
    // 调用回调block，push到addTag页面
    !self.addTagBtnDidClickCallbackBlock ? : self.addTagBtnDidClickCallbackBlock(btn, showingTitles);
}

/**
 *  显示完成的tags，并排列
 */
- (void)showTagsWithTitles:(NSArray<NSString *> *)tagTitles {
    // 如果没有tag需要显示，直接退出
    if (tagTitles.count == 0) return;
    
    // 清空之前的标签 并 清空tagLbl容器
    [self.tagLbls makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLbls removeAllObjects];
    
    for (NSInteger index=0; index<tagTitles.count; index++) {
        NSString *title = tagTitles[index];
        // 显示标签
        UILabel *tagLab = [[UILabel alloc] init];
        tagLab.text = title;
        tagLab.textAlignment = NSTextAlignmentCenter;
        tagLab.backgroundColor = JHTagBackColore;
        tagLab.textColor = [UIColor whiteColor];
        [tagLab sizeToFit];
        tagLab.width += 2 * JHTagMargin;
        [self.tagsView addSubview:tagLab];
        [self.tagLbls addObject:tagLab];
    
        // 标签排列Frame
        if (index == 0) { // 第一个标签
            tagLab.x = 0;
            tagLab.y = 0;
        } else { // 其他标签
            UILabel *preLbl = self.tagLbls[index-1];
            // 判断当前行右侧空间是否足够放置此tag
            CGFloat rightSpace = self.tagsView.width - CGRectGetMaxX(preLbl.frame) - JHTagMargin;
            if (rightSpace >= tagLab.width) { // 足够放置
                // 同行
                tagLab.x = self.tagsView.width - rightSpace;
                tagLab.y = preLbl.y;
            } else { // 不足够
                // 下一行
                tagLab.x = 0;
                tagLab.y = CGRectGetMaxY(preLbl.frame) + JHTagMargin;
            }
        }
    
    }
    
    // 添加标签按钮更新Frame
    CGFloat rightSpace = self.tagsView.width - CGRectGetMaxX([self.tagLbls lastObject].frame) - JHTagMargin;
    if (rightSpace >= self.addBtn.width) { // 足够放置
        // 同行
        self.addBtn.x = self.tagsView.width - rightSpace;
        self.addBtn.y = [self.tagLbls lastObject].y;
    } else { // 不足够
        self.addBtn.x = 0;
        self.addBtn.y = CGRectGetMaxY([self.tagLbls lastObject].frame) + JHTagMargin;
    }

}

@end
