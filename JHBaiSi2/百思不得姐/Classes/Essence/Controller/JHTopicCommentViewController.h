//
//  JHTopicCommentViewController.h
//  百思不得姐
//
//  Created by 李建華 on 16/4/14.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHTopic;

@interface JHTopicCommentViewController : UIViewController
/**
 *  头部视图数据模型
 */
@property(strong, nonatomic) JHTopic *topic;
@end
