//
//  JHTopicCommentViewController.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/14.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHTopicCommentViewController.h"
#import "JHTopicCell.h"
#import "JHTopicCommentCell.h"
#import "JHTopicComment.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>

static NSString * const JHTopicCommentCellID = @"topicComment";

@interface JHTopicCommentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputToViewBottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *commentTableVIew;
/**
 *  最热评论
 */
@property (strong, nonatomic) NSArray *hotComments;
/**
 *  最新评论
 */
@property (strong, nonatomic) NSMutableArray *lastestComments;
/**
 *  头部视图被删除最热评论模型数据临时仓库
 */
@property (strong, nonatomic) JHTopicComment *headerTopcommentBackup;
/**
 *  纪录最新评论已经加载到的页数
 */
@property (assign, nonatomic) NSInteger lastestCommentsCurrentPage;

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end

@implementation JHTopicCommentViewController

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
    }
    return _sessionManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 基本设置
    [self setup];
    // tableView设置
    [self setupTableView];
    // 添加顶部下拉刷新控件
    [self setupHeadRefresh];
    // 添加底部上拉刷新控件
    [self setupFootRefresh];

    // 获取评论 api
    // http://api.budejie.com/api/api_open.php?a=dataList&appname=baisi_xiaohao&asid=63CB234F-A84B-469E-A741-426F9B739C6C&c=comment&client=iphone&data_id=18043065&device=ios%20device&from=ios&hot=1&jbk=0&mac=&market=&openudid=11b2cfdd928b5fd15c0d37ea09d674a151762b55&page=1&per=50&udid=&ver=4.1
    // http://api.budejie.com/api/api_open.php?a=dataList&appname=baisi_xiaohao&asid=63CB234F-A84B-469E-A741-426F9B739C6C&c=comment&client=iphone&data_id=18043065&device=ios%20device&from=ios&hot=1&jbk=0&lastcid=48790347&mac=&market=&openudid=11b2cfdd928b5fd15c0d37ea09d674a151762b55&page=2&per=50&udid=&ver=4.1
    
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
    // 去掉分割线
    self.commentTableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置tableView顶部缩进
    self.commentTableVIew.contentInset = UIEdgeInsetsMake(64, 0, JHTopicMargin, 0);
    
    // 当有最热评论时，头部不用重复显示，删除此部分的数据模型，并保存删除的数据
    if (self.topic.top_comment) {
        self.headerTopcommentBackup = self.topic.top_comment;
        self.topic.top_comment = nil;
        // 因为cellH != 0 时不会重新计算新值
        [self.topic setValue:@0 forKey:@"cellH"];
    }
    
    // 设置tableViewHeader显示视图(中间间隔一个View可以屏蔽header对cellframe的隐式修改)
    UIView *headerView = [[UIView alloc] init];
    JHTopicCell *cell = [JHTopicCell topicCell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(JHScreenW, self.topic.cellH);
    [headerView addSubview:cell];
    headerView.height = self.topic.cellH;
    self.commentTableVIew.tableHeaderView = headerView;
    
    // 评论tableVIew注册cell
    [self.commentTableVIew registerNib:[UINib nibWithNibName:NSStringFromClass([JHTopicCommentCell class]) bundle:nil] forCellReuseIdentifier:JHTopicCommentCellID];
    
    // cell根据内容自动判定cell高度相关（与xib中的相关约束共同起作用，from iOS8.0）
    self.commentTableVIew.estimatedRowHeight = 44;
    self.commentTableVIew.rowHeight = UITableViewAutomaticDimension;
    
}

/**
 *  添加顶部下拉刷新控件
 */
- (void)setupHeadRefresh {
    // 添加控件
    self.commentTableVIew.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerDownRefresh)];
    // 自动淡化
    self.commentTableVIew.mj_header.automaticallyChangeAlpha = YES;
    // 立即下拉刷新
    [self.commentTableVIew.mj_header beginRefreshing];
}

/**
 *  添加底部上拉刷新控件
 */
- (void)setupFootRefresh {
    // 添加控件
    self.commentTableVIew.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerUpRefresh)];
    // 初始设置为不可见(在上拉和下拉时根据数据判断是否显示)
    self.commentTableVIew.mj_footer.hidden = YES;
}

/**
 *  顶部下拉刷新处理方法
 */
- (void)headerDownRefresh {
    // 防止网络延迟，多请求处理回调block中造成数据模型混乱，需要取消之前延迟的请求
    [self.sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 网络请求评论数据
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php?appname=baisi_xiaohao&asid=63CB234F-A84B-469E-A741-426F9B739C6C&client=iphone&device=ios%20device&from=ios&jbk=0&mac=&market=&openudid=11b2cfdd928b5fd15c0d37ea09d674a151762b55&per=50&udid=&ver=4.1";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    NSInteger page = 1; // 防止读取网络数据失败时，改变当前页数，此处添加中间变量
    params[@"page"] = @(page);
    [self.sessionManager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = (NSDictionary *)responseObject;
//        [dict writeToFile:@"/Users/lijianhua/Desktop/topicComment.plist" atomically:YES];
        // 保存数据到数据模型
        self.hotComments = [JHTopicComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        self.lastestComments = [JHTopicComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 刷新内容tableView
        [self.commentTableVIew reloadData];
        
        // 结束顶部刷新状态
        [self.commentTableVIew.mj_header endRefreshing];
        
        // 根据是否有更多最新评论数据，判断是否显示底部上拉控件
        self.commentTableVIew.mj_footer.hidden = !(self.lastestComments.count < [responseObject[@"total"] integerValue]);
        
        // 保存最新评论当前页数
        self.lastestCommentsCurrentPage = page;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束顶部刷新状态
        [self.commentTableVIew.mj_header endRefreshing];
    }];
}

- (void)footerUpRefresh {
    // 防止网络延迟，多请求处理回调block中造成数据模型混乱，需要取消之前延迟的请求
    [self.sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 网络请求评论数据
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php?appname=baisi_xiaohao&asid=63CB234F-A84B-469E-A741-426F9B739C6C&client=iphone&device=ios%20device&from=ios&jbk=0&mac=&market=&openudid=11b2cfdd928b5fd15c0d37ea09d674a151762b55&page=1&per=50&udid=&ver=4.1";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    // 当前页最后的最新评论的id
    params[@"lastcid"] = [[self.lastestComments lastObject] ID];
    // 下一页
    NSInteger page = self.lastestCommentsCurrentPage + 1;
    params[@"page"] = @(page);
    [self.sessionManager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSDictionary *dict = (NSDictionary *)responseObject;
        //        [dict writeToFile:@"/Users/lijianhua/Desktop/topicComment.plist" atomically:YES];
        // 保存数据到数据模型
        self.hotComments = [JHTopicComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        NSArray *newPageLastestComments = [JHTopicComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.lastestComments addObjectsFromArray:newPageLastestComments];
        // 刷新内容tableView
        [self.commentTableVIew reloadData];
        
        // 结束顶部刷新状态
        [self.commentTableVIew.mj_header endRefreshing];
        
        // 根据是否有更多最新评论数据，判断是否显示底部上拉控件
        self.commentTableVIew.mj_footer.hidden = !(self.lastestComments.count < [responseObject[@"total"] integerValue]);
        
        // 保存最新评论当前页数
        self.lastestCommentsCurrentPage = page;
        
        // 根据是否有更多最新评论数据，判断是否显示底部上拉控件
        self.commentTableVIew.mj_footer.hidden = !(self.lastestComments.count < [responseObject[@"total"] integerValue]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束底部上拉刷新控件刷新状态
        [self.commentTableVIew.mj_footer endRefreshing];
    }];
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

- (void)dealloc {
    // 注销通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 当有最热评论时，头部最热评论被删除的数据需要恢复
    if (self.topic.top_comment) {
        self.topic.top_comment = self.headerTopcommentBackup;
        // 因为cellH != 0 时不会重新计算新值
        [self.topic setValue:@0 forKey:@"cellH"];
    }
    
    // 防止网络延迟时，退出此页面网络请求session中的task依旧回调block，此处需要将延迟的task都取消
//    [self.sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.sessionManager invalidateSessionCancelingTasks:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger hotCount = self.hotComments.count;
    NSInteger lastestCount = self.lastestComments.count;
    
    if (hotCount) return 2; // 有最热评论
    if (lastestCount) return 1; // 只有最新评论
    return 0; // 无最新评论
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) { // 最热评论 或 最新评论
        return hotCount ? self.hotComments.count : self.lastestComments.count;
    } else { // 最新评论
        return self.lastestComments.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger hotCount = self.hotComments.count;
    
    if (section == 0) { // 最热评论 或 最新评论
        return hotCount ? @"最热评论" : @"最新评论";
    } else { // 最新评论
        return @"最新评论";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHTopicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:JHTopicCommentCellID];
    
    JHTopicComment *comment = [self commentFromIndexPath:(NSIndexPath *)indexPath];
    cell.topicComment = comment;
    
    return cell;
}

/**
 *  通过传入cell的indexPath智能返回对应的最热或者最新评论数据模型
 */
- (JHTopicComment *)commentFromIndexPath:(NSIndexPath *)indexPath {
    NSInteger hotCount = self.hotComments.count;
    
    if (indexPath.section == 0) {
        return hotCount ? self.hotComments[indexPath.row] : self.lastestComments[indexPath.row];
    } else {
        return self.lastestComments[indexPath.row];
    }
}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
    // 隐藏MenuController
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIMenuController *menuC = [UIMenuController sharedMenuController];
    
    if (menuC.menuVisible == YES) {
        return;
    }
    
    JHTopicCommentCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
    // 让被选中的cell成为第一响应者
    [selCell becomeFirstResponder];
    
    // 设置menuController
    UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(dingClick:)];
    UIMenuItem *reply = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replyClick:)];
    UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(reportClick:)];
    menuC.menuItems = @[ding, reply, report];
    
    [menuC setMenuVisible:YES animated:YES];
    // 设置menu显示区域
    CGRect menuDisplayRect = selCell.bounds;
    menuDisplayRect.origin.y = menuDisplayRect.size.height * 0.5;
    [menuC setTargetRect:menuDisplayRect inView:selCell];
}

#pragma mark - MenuController点击相关
- (void)dingClick:(UIMenuController *)menuC {
    NSIndexPath *indexPath = [self.commentTableVIew indexPathForSelectedRow];
    JHTopicComment *comment = [self commentFromIndexPath:indexPath];
    JHLog(@"%@", comment.content);
}

- (void)replyClick:(UIMenuController *)menuC {
    NSIndexPath *indexPath = [self.commentTableVIew indexPathForSelectedRow];
    JHTopicComment *comment = [self commentFromIndexPath:indexPath];
    JHLog(@"%@", comment.content);
}

- (void)reportClick:(UIMenuController *)menuC {
    NSIndexPath *indexPath = [self.commentTableVIew indexPathForSelectedRow];
    JHTopicComment *comment = [self commentFromIndexPath:indexPath];
    JHLog(@"%@", comment.content);
}


@end
