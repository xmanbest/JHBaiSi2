//
//  JHWebViewController.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/19.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHWebViewController.h"
#import <NJKWebViewProgress.h>

@interface JHWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *WebContentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/**
 *  检查webView下载进度的代理
 */
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;

@end

@implementation JHWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.WebContentView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    // 使用第三方监听webView加载情况并修改进度条进度（虚拟）
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.WebContentView.delegate = self.progressProxy;
    __weak typeof(self) weakSelf = self;
    self.progressProxy.progressBlock = ^(float progress){
        weakSelf.progressView.progress = progress;
        // 隐藏进度条
        weakSelf.progressView.hidden = progress == 1.0;
    };
    // 确保被占用的WebView delegate 在此处被传递回本控制器
    self.progressProxy.webViewProxyDelegate = self;
    
    // webView开始加载url
    [self.WebContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (IBAction)goBack:(id)sender {
    [self.WebContentView goBack];
}
- (IBAction)goForward:(id)sender {
    [self.WebContentView goForward];
}
- (IBAction)refresh:(id)sender {
    [self.WebContentView reload];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 控制goback goforward按钮的可用性
    self.goBackBtn.enabled = webView.canGoBack;
    self.goForwardBtn.enabled = webView.canGoForward;
}

@end
