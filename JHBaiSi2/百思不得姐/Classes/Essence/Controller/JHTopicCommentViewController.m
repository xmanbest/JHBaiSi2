//
//  JHTopicCommentViewController.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/14.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHTopicCommentViewController.h"
#import "JHTopicCell.h"

@interface JHTopicCommentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputToViewBottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *commentTableVIew;

@end

@implementation JHTopicCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 基本设置
    [self setup];
    // tableView设置
    [self setupTableView];
    

    
    // 获取评论 api
    // http://api.budejie.com/api/api_open.php?a=dataList&appname=baisi_xiaohao&asid=63CB234F-A84B-469E-A741-426F9B739C6C&c=comment&client=iphone&data_id=18041737&device=ios%20device&from=ios&hot=1&jbk=0&mac=&market=&openudid=11b2cfdd928b5fd15c0d37ea09d674a151762b55&page=1&per=50&udid=&ver=4.1
    
    // 获取点赞用户list api
    // http://api.budejie.com/api/api_open.php?a=praise&appname=baisi_xiaohao&asid=63CB234F-A84B-469E-A741-426F9B739C6C&c=comment&client=iphone&device=ios%20device&from=ios&id=17979407&jbk=0&mac=&market=&maxtime=0&openudid=11b2cfdd928b5fd15c0d37ea09d674a151762b55&per=5&sex=m&udid=&ver=4.1
}

/**
 *  基本设置
 */
- (void)setup {
    self.navigationItem.title = @"评论";
    
    // 设置背景色
    self.commentTableVIew.backgroundColor = JHGlobalBackColore;
    
    // 注册键盘通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  tableView设置
 */
- (void)setupTableView {
    // 设置tableView顶部缩进
    self.commentTableVIew.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    // 设置tableViewHeader显示视图(中间间隔一个View可以屏蔽header对cellframe的隐式修改)
    UIView *headerView = [[UIView alloc] init];
    
    JHTopicCell *cell = [JHTopicCell topicCell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(JHScreenW, self.topic.cellH);
    [headerView addSubview:cell];
    
    headerView.height = self.topic.cellH;
    self.commentTableVIew.tableHeaderView = headerView;
}


/**
 *  键盘Frame变化通知处理方法
 */
- (void)keyboardWillChangeFrame:(NSNotification *)noti {
    // 获取应变动高度
    self.inputToViewBottomSpace.constant = JHScreenH - [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    // 获取动画时长
    CGFloat animateDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 执行动画
    [UIView animateWithDuration:animateDuration animations:^{
        // 立即刷新自控件布局
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc
{
    // 注销通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.text = [NSString stringWithFormat:@"row:%zd", indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%zd", section];
}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
