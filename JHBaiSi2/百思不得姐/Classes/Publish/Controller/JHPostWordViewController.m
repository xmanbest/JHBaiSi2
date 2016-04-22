//
//  JHPostWordViewController.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/20.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHPostWordViewController.h"
#import "JHPlaceholderTextView.h"
#import "JHLabelPlaceholderTextView.h"
#import "JHAddTagToolBar.h"
#import "JHAddTagViewController.h"

@interface JHPostWordViewController () <UITextViewDelegate>
@property(nonatomic, weak)JHLabelPlaceholderTextView *textView;
@property(nonatomic, weak)JHAddTagToolBar *toolBar;
@end

@implementation JHPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    [self setup];
    // navigation设置
    [self setupNavi];
    // textView设置
    [self setupTextView];
    // ToolBar设置
    [self setupToolBar];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 自动弹出键盘
    [self.textView becomeFirstResponder];
}

/**
 *  ToolBar设置
 */
- (void)setupToolBar {
    // 添加toolBar
    JHAddTagToolBar *toolBar = [JHAddTagToolBar loadViewFromXib];
    toolBar.y = self.view.height - toolBar.height;
    toolBar.width = self.view.width;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    // toolBar实现addTag按钮点击回调block
    toolBar.addTagBtnDidClickCallbackBlock = ^(UIButton *addTagBtn, NSArray<NSString *> *showingTitles) {
        // push 到 添加标签页面
        JHAddTagViewController *addTagVC = [[JHAddTagViewController alloc] init];
        // 传递正在显示的标题集合
        addTagVC.showingTitles = showingTitles;
        // 实现完成回调
        [addTagVC setTagsWillAcommplishCallbackBlock:^(NSArray<NSString *> *tagTitles) {
            // 显示并排列标签
            [self.toolBar showTagsWithTitles:tagTitles];
        }];
        [self.navigationController pushViewController:addTagVC animated:YES];
    };
    
    // 注册键盘frame改变通知 观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChangeHandle:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  键盘frame改变通知 处理
 */
- (void)keyboardFrameWillChangeHandle:(NSNotification *)noti {
    // UIKeyboardFrameEndUserInfoKey  UIKeyboardAnimationDurationUserInfoKey
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, -(JHScreenH - keyboardFrame.origin.y));
    }];
}

/**
 *  基本设置
 */
- (void)setup {
    self.view.backgroundColor = JHGlobalBackColore;
}

/**
 *  navigation设置
 */
- (void)setupNavi {
    self.navigationItem.title = @"发表文字";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(postClick)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 立即刷新navigationBar状态
    [self.navigationController.navigationBar layoutIfNeeded];
}

/**
 *  textView设置
 */
- (void)setupTextView {
    // 添加自定义带有占位文字的textView
//    JHPlaceholderTextView *textView = [[JHPlaceholderTextView alloc] init];
    JHLabelPlaceholderTextView *textView = [[JHLabelPlaceholderTextView alloc] init];
    textView.delegate = self;
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    self.textView = textView;
    // 设置占位文字
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
}


#pragma mark - EventHandlers
/**
 *  导航栏取消按钮点击处理
 */
- (void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  导航栏发表按钮点击处理
 */
- (void)postClick {
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //  退出键盘
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    // 有文字内容则隐藏占位符
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}
@end
