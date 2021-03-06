//
//  AppDelegate.m
//  百思不得姐
//
//  Created by 李建華 on 16/3/24.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "AppDelegate.h"
#import "JHTabBarController.h"
#import "JHOneTimeLaunchView.h"
#import "JHStatusWindow.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [[UIScreen mainScreen] bounds];
    
    JHTabBarController *tabBarC = [[JHTabBarController alloc] init];
    tabBarC.delegate = self;
    self.window.rootViewController = tabBarC;
    
    [self.window makeKeyAndVisible];
    
    // 当前版本为第一次打开时，显示提示视图
    [JHOneTimeLaunchView show];
    
    
    return YES;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // 发送tabbarItem被点击通知
    [[NSNotificationCenter defaultCenter] postNotificationName:JHTabBarDidSelectNotification object:nil userInfo:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    /**
     添加自定义顶部statusBar（带有回滚顶部功能），会让各个控制器的statusBar不显示，所以需要配置Info.plist禁用控制器statusBar
     View controller-based status bar appearance ＝ NO
     */
    [JHStatusWindow show];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
