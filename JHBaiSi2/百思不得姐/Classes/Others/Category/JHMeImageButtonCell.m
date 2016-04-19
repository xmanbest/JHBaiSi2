//
//  JHMeImageButtonCell.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/19.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHMeImageButtonCell.h"
#import "JHMeSquare.h"
#import "JHImageButton.h"
#import "JHWebViewController.h"

@implementation JHMeImageButtonCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置背景图
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
        // 去除autorisize
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (void)setMeSquares:(NSArray *)meSquares {
    _meSquares = meSquares;
    
    NSUInteger maxCol = JHMeImageButtonMaxCol;
    CGFloat btnW = JHScreenW / maxCol;
    CGFloat btnH = JHMeImageButtonH;
    for (NSInteger index = 0; index < meSquares.count; index ++) {
        JHImageButton *btn = [JHImageButton buttonWithType:UIButtonTypeCustom];
        btn.meSquare = meSquares[index];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger col = index % maxCol;
        NSInteger row = index / maxCol;
        CGFloat btnX = col * btnW;
        CGFloat btnY = row * btnH;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [self.contentView addSubview:btn];
    }
}

- (void)btnClick:(JHImageButton *)btn {
    if (![btn.meSquare.url hasPrefix:@"http"]) return;
    
    // 点击打开对应网页
    JHWebViewController *webVC = [[JHWebViewController alloc] init];
    webVC.url = btn.meSquare.url;
    
    UITabBarController *tabBarC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *naviC = (UINavigationController *)tabBarC.selectedViewController;
    [naviC pushViewController:webVC animated:YES];
}
@end
