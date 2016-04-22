//
//  JHAddTagViewController.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/21.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHAddTagViewController.h"
#import "JHTagButton.h"
#import "JHTagTextField.h"
#import <SVProgressHUD.h>

@interface JHAddTagViewController () <UITextFieldDelegate>
/**
 *  内容容器
 */
@property(nonatomic, weak)UIView *contentView;
/**
 *  编辑新标签文本控件
 */
@property(nonatomic, weak)UITextField *textField;
/**
 *  添加新标签确定按钮
 */
@property(nonatomic, weak)UIButton *addTagConfirmBtn;
/**
 *  显示的标签 的容器
 */
@property(nonatomic, strong)NSMutableArray<UIButton *> *tags;
@end

@implementation JHAddTagViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    [self setup];
    // navigation设置
    [self setupNavi];
    // 设置可编辑视图容器
    [self setupContentView];
    // textField设置
    [self setupTextField];
    // 同步前一个页面正在显示的标签到当前页面
    [self setupShowingTags];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - GetMethods
- (NSMutableArray<UIButton *> *)tags {
    if (_tags == nil) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (UIButton *)addTagConfirmBtn {
    if (_addTagConfirmBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = JHTagBackColore;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, JHTagMargin, 0, JHTagMargin);
        btn.height = 35;
        btn.width = self.contentView.width;
        btn.y = CGRectGetMaxY(self.textField.frame);
        [btn addTarget:self action:@selector(addTagConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        _addTagConfirmBtn = btn;
    }
    return _addTagConfirmBtn;
}


#pragma mark - PrivateMethods
/**
 *  同步前一个页面正在显示的标签到当前页面
 */
- (void)setupShowingTags {
    for (NSString *showingTitle in self.showingTitles) {
        // 添加前一个页面正显示的标签
        self.textField.text = showingTitle;
        [self addTagConfirmBtnClick];
    }
}

/**
 *  textField设置
 */
- (void)setupTextField {
    JHTagTextField *textField = [[JHTagTextField alloc] init];
    textField.delegate = self;
    // 设置点击删除键回调block
    __weak typeof(self) weakSelf = self;
    textField.deleteWhenHasNoTextCallbackBlock = ^(){
        // 点击删除键时，如果文本为空，则删除上一个标签
        if (!weakSelf.textField.hasText) {
            UIButton *lastTag = [weakSelf.tags lastObject];
            [weakSelf deleteTagBtnClick:lastTag];
        }
    };
//    textField.placeholder = @"多个标签用逗号或者换行隔开";
    [textField sizeToFit];
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    // 注册观察者 监听textField编辑通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeHandle:) name:UITextFieldTextDidChangeNotification object:nil];
}

/**
 *  设置可编辑视图容器
 */
- (void)setupContentView {
    UIView *contentView = [[UIView alloc] init];
    CGFloat viewX = JHTagMargin;
    CGFloat viewY = JHTagMargin + 64;
    CGFloat viewW = self.view.width - 2 * viewX;
    CGFloat viewH = self.view.height - viewY;
    contentView.frame = CGRectMake(viewX, viewY, viewW, viewH);
//    contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

/**
 *  基本设置
 */
- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 *  navigation设置
 */
- (void)setupNavi {
    self.navigationItem.title = @"添加标签";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(accomplishClick)];
    
    // 立即刷新navigationBar状态
    [self.navigationController.navigationBar layoutIfNeeded];
}

#pragma mark - EventHandlers
/**
 *  导航栏取消按钮点击处理
 */
- (void)cancelClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  导航栏完成按钮点击处理
 */
- (void)accomplishClick {
    // 获取当前tags的标题集合
    NSArray<NSString *> *tagTitles = [self.tags valueForKey:@"currentTitle"];
    // 执行回调block
    !self.tagsWillAcommplishCallbackBlock ?  : self.tagsWillAcommplishCallbackBlock(tagTitles);
    // pop回前页面
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  textField编辑通知 处理
 */
- (void)textFieldTextDidChangeHandle:(NSNotification *)noti {
    // 排列标签，textField，添加标签按钮的frame
    [self updateTagsFrame];
    
    // 当文本框还有文本时
    if (self.textField.hasText) {
        NSString *fieldText = self.textField.text;
        // 最后输入的文字
        NSUInteger len = fieldText.length;
        NSString *lastChar = [fieldText substringFromIndex:len-1];
        if (([lastChar isEqualToString:@","] || [lastChar isEqualToString:@"，"]) && len > 1) {
            // 当最后一个文字为逗号时，去掉逗号直接添加标签
            self.textField.text = [fieldText substringToIndex:len-1];
            [self addTagConfirmBtnClick];
            return;
        }
        
        // 同步按钮和textField的内容
        NSString *text = [NSString stringWithFormat:@"添加标签：%@", fieldText];
        [self.addTagConfirmBtn setTitle:text forState:UIControlStateNormal];
        
    }
    
    // 根据标签内容输入框是否有内容判断确定添加按钮的可见度
    self.addTagConfirmBtn.hidden = !self.textField.hasText;
    
    
    
}

/**
 *  tag添加按钮点击处理
 */
- (void)addTagConfirmBtnClick {
    // 当前标签数不能超过5
    if (self.tags.count >= 5) {
        [SVProgressHUD showInfoWithStatus:@"标签数不能超过5个"];
        [SVProgressHUD dismissWithDelay:3];
        return;
    }
    
    // 添加标签
    JHTagButton *tag = [JHTagButton buttonWithType:UIButtonTypeCustom];
    [tag setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
    [tag setTitle:self.textField.text forState:UIControlStateNormal];
    tag.backgroundColor = JHTagBackColore;
    [tag sizeToFit];
    [tag addTarget:self action:@selector(deleteTagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:tag];
    [self.tags addObject:tag];
    
    // 清空textField的文本内容 并 隐藏tag添加按钮
    self.textField.text = nil;
    self.addTagConfirmBtn.hidden = YES;
    
    // 排列标签，textField，添加标签按钮的frame
    [self updateTagsFrame];
}

/**
 *  标签点击处理
 */
- (void)deleteTagBtnClick:(UIButton *)tag {
    // 移除此标签
    [self.tags removeObject:tag];
    [tag removeFromSuperview];
    
    // 排列标签，textField，添加标签按钮的frame
    [UIView animateWithDuration:0.2 animations:^{
        [self updateTagsFrame];
    }];
}

/**
 *  排列标签，textField，添加标签按钮的frame
 */
- (void)updateTagsFrame {
    // 排列标签
    for (NSInteger index=0; index<self.tags.count; index++) {
        UIButton *btn = self.tags[index];
        
        if (index == 0) { // 第一个标签
            btn.x = 0;
            btn.y = 0;
        } else { // 其他标签
            UIButton *preBtn = self.tags[index-1];
            // 判断当前行右侧空间是否足够放置此tag
            CGFloat rightSpace = self.contentView.width - CGRectGetMaxX(preBtn.frame) - JHTagMargin;
            if (rightSpace >= btn.width) { // 足够放置
                // 同行
                btn.x = self.contentView.width - rightSpace;
                btn.y = preBtn.y;
            } else { // 不足够
                // 下一行
                btn.x = 0;
                btn.y = CGRectGetMaxY(preBtn.frame) + JHTagMargin;
            }
        }
    }
    
    // 更新textFieldframe
    [self.textField sizeToFit];
    // 排列textField
    CGFloat rightSpace = self.contentView.width - CGRectGetMaxX([self.tags lastObject].frame) - JHTagMargin;
    if (rightSpace >= self.textField.width) { // 足够放置
        // 同行
        self.textField.x = self.contentView.width - rightSpace;
        self.textField.y = [self.tags lastObject].y;
    } else { // 不足够
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY([self.tags lastObject].frame) + JHTagMargin;
    }
    
    // 排列添加标签按钮
    self.addTagConfirmBtn.x = 0;
    self.addTagConfirmBtn.y = CGRectGetMaxY(self.textField.frame) + JHTagMargin;

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 点击return键的时候，直接添加标签
    if (self.textField.text.length) {
        [self addTagConfirmBtnClick];
    }
    
    return YES;
}
@end
