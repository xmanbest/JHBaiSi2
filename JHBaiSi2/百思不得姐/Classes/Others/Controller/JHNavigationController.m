//
//  JHNavigationController.m
//  百思不得姐
//
//  Created by 李建華 on 16/3/25.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHNavigationController.h"

@implementation JHNavigationController
+ (void)initialize {
    [super initialize];
    // 全局设置UINavigationBar
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self.class]];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];
    
    // 全局设置
    UIBarButtonItem *barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]];
    
    NSMutableDictionary *attrDicNormal = [NSMutableDictionary dictionary];
    attrDicNormal[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    attrDicNormal[NSForegroundColorAttributeName] = [UIColor blackColor];
    [barItem setTitleTextAttributes:attrDicNormal forState:UIControlStateNormal];
    
    NSMutableDictionary *attrDicDisabled = [NSMutableDictionary dictionary];
    attrDicDisabled[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    attrDicDisabled[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [barItem setTitleTextAttributes:attrDicDisabled forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 由于自定义了左侧返回按钮，导致向右拖动左侧边框pop出当前view的功能消失，
    // 此处代码可以回复此功能
    self.interactivePopGestureRecognizer.delegate = nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 设置所有VC的导航栏返回键标题为“返回”, 下面的解决方案无法自定义按钮属性
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    // 不是导航控制器根控制器的情况下
    if (self.viewControllers.count >0) {
        // 自定义返回键
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.frame = CGRectMake(0, 0, 100, self.navigationBar.height);
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        // 导航栏根控制器以外的控制器隐藏tabBarController
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }

    [super pushViewController:viewController animated:animated];
}

-(void)backBtn {
    [self popViewControllerAnimated:YES];
}
@end
