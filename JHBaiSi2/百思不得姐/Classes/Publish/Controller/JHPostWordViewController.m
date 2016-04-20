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

@interface JHPostWordViewController () <UITextViewDelegate>
@property(nonatomic, weak)JHLabelPlaceholderTextView *textView;
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

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    // 有文字内容则隐藏占位符
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}
@end
