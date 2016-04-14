//
//  JHTopicVideo.h
//  百思不得姐
//
//  Created by 李建華 on 16/4/14.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHTopicVideo : NSObject
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, strong)NSArray *video;
@property(nonatomic, strong)NSArray *download;
@property(nonatomic, strong)NSArray *thumbnail;
@property(nonatomic, assign)NSInteger duration;
@property(nonatomic, assign)NSInteger playcount;
@end
