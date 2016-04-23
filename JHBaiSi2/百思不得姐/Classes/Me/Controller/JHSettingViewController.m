//
//  JHSettingViewController.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/23.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHSettingViewController.h"
#import <SDImageCache.h>

@interface JHSettingViewController ()
@property(assign, nonatomic)NSUInteger diskImageCacheSize;
@end

@implementation JHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = JHGlobalBackColore;
    self.navigationItem.title = @"设置";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 异步加载当前的硬盘图片缓存
        self.diskImageCacheSize = [[SDImageCache sharedImageCache] getSize];
        // 刷新表格
        [self.tableView reloadData];
    });
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
     }
    
    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存（已使用%.2fMB）", self.diskImageCacheSize / 1000.0 / 1000.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 清除缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        // 异步加载当前的硬盘图片缓存
        self.diskImageCacheSize = [[SDImageCache sharedImageCache] getSize];
        // 刷新表格
        [self.tableView reloadData];
    }];
}


@end
