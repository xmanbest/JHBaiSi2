//
//  JHTopicVideoView.h
//  百思不得姐
//
//  Created by 李建華 on 16/4/14.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHTopic;

@interface JHTopicVideoView : UIView
@property(nonatomic, strong)JHTopic *topic;

+ (instancetype)videoView;
@end
