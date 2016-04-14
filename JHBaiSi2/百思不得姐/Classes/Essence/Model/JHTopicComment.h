//
//  JHTopicComment.h
//  百思不得姐
//
//  Created by 李建華 on 16/4/14.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHTopicUser;

@interface JHTopicComment : NSObject

/*
"data_id":"17979407",
"status":"0",
"id":"48720005",
"content":"1楼是狗",
"ctime":"2016-04-14 08:57:45",
"precid":"0",
"preuid":"0",
"like_count":"1",
"voiceuri":"",
"voicetime":"0",
"user":Object{...},
"precmt":[

]
 */
@property(copy, nonatomic) NSString *data_id;
@property(copy, nonatomic) NSString *status;
@property(copy, nonatomic) NSString *ID;
@property(copy, nonatomic) NSString *content;
@property(copy, nonatomic) NSString *ctime;
@property(copy, nonatomic) NSString *precid;
@property(copy, nonatomic) NSString *preuid;
@property(copy, nonatomic) NSString *like_count;
@property(copy, nonatomic) NSString *voiceuri;
@property(copy, nonatomic) NSString *voicetime;
@property(strong, nonatomic) JHTopicUser *user;
@property(strong, nonatomic) JHTopicUser *u;
@end
