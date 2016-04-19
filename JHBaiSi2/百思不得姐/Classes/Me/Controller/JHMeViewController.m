//
//  JHMeViewController.m
//  百思不得姐
//
//  Created by 李建華 on 16/3/24.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHMeViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "JHMeTag.h"
#import "JHMeSquare.h"
#import "JHMeSimpleCell.h"
#import "JHMeButtonCell.h"
#import "JHMeImageButtonCell.h"

static NSString * const JHMeSimpleCellID = @"JHMeSimpleCellID";
static NSString * const JHMeButtonCellID = @"JHMeButtonCellID";
static NSString * const JHMeImageButtonCellID = @"JHMeImageButtonCellID";
// http://api.budejie.com/api/api_open.php?a=square&appname=baisi_xiaohao&asid=63CB234F-A84B-469E-A741-426F9B739C6C&c=topic&client=iphone&device=ios%20device&from=ios&jbk=0&mac=&market=&openudid=11b2cfdd928b5fd15c0d37ea09d674a151762b55&sex=m&udid=&ver=4.1

@interface JHMeViewController ()
@property(nonatomic, strong)NSArray *meTags;
@property(nonatomic, strong)NSArray *meSquares;
@end

@implementation JHMeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    [self setup];
    // 导航栏设置
    [self setupNavi];
    // tableView设置
    [self setupTableView];
    
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php?a=square&appname=baisi_xiaohao&asid=63CB234F-A84B-469E-A741-426F9B739C6C&c=topic&client=iphone&device=ios%20device&from=ios&jbk=0&mac=&market=&openudid=11b2cfdd928b5fd15c0d37ea09d674a151762b55&sex=m&udid=&ver=4.1";
    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [((NSDictionary *)responseObject) writeToFile:@"/Users/lijianhua/Desktop/me.plist" atomically:YES];
        // 填充数据模型
        self.meTags = [JHMeTag mj_objectArrayWithKeyValuesArray:responseObject[@"tag_list"]];
        self.meSquares = [JHMeSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
        // 刷新tableView
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/**
 *  基本设置
 */
- (void)setup {
    // 设置背景色
    self.tableView.backgroundColor = JHGlobalBackColore;
    // 去除autorisize
    self.tableView.autoresizingMask = UIViewAutoresizingNone;
    
}
/**
 *  导航栏设置
 */
- (void)setupNavi {
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    // 设置导航栏按钮
    UIBarButtonItem *settingBtn = self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highlightImage:@"mine-setting-icon-click" target:self action:@selector(settingClick:)];
    UIBarButtonItem *moonBtn = self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highlightImage:@"mine-moon-icon-click" target:self action:@selector(moonClick:)];
    
    self.navigationItem.rightBarButtonItems = @[
                                                settingBtn,
                                                moonBtn
                                                ];
}
/**
 *  tableView设置
 */
- (void)setupTableView {
    // 注册cell
    [self.tableView registerClass:[JHMeSimpleCell class] forCellReuseIdentifier:JHMeSimpleCellID];
    [self.tableView registerClass:[JHMeButtonCell class] forCellReuseIdentifier:JHMeButtonCellID];
    [self.tableView registerClass:[JHMeImageButtonCell class] forCellReuseIdentifier:JHMeImageButtonCellID];
    // 更改sectionHeader,Footer高度，减少组间间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = JHTopicMargin;
    // 设置整体顶部inset
    self.tableView.contentInset = UIEdgeInsetsMake(JHTopicMargin - 35, 0, 0, 0);
    
}

- (void)settingClick:(UIButton *)btn {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)moonClick:(UIButton *)btn {
    JHLog(@"moonClick");
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:JHMeSimpleCellID];
        BOOL isFirst = indexPath.section == 0;
        cell.textLabel.text = isFirst ? @"登录/注册" : @"离线下载";
        cell.imageView.image = isFirst ? [UIImage imageNamed:@"setup-head-default"] : nil;
    }
    else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:JHMeButtonCellID];
        ((JHMeButtonCell *)cell).meTags = self.meTags;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:JHMeImageButtonCellID];
        ((JHMeImageButtonCell *)cell).meSquares = self.meSquares;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        NSInteger totalRow = (self.meSquares.count + JHMeImageButtonMaxCol -1) / JHMeImageButtonMaxCol;
        return totalRow * JHMeImageButtonH;
    }
    return 44;
}
@end
