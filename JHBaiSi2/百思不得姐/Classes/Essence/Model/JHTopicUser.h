//
//  JHUser.h
//  百思不得姐
//
//  Created by 李建華 on 16/4/2.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString * const JHTopicUserSexMale;
UIKIT_EXTERN NSString * const JHTopicUserSexFemale;

@interface JHTopicUser : NSObject
/*
"id":"15229286",
"username":"不善言辞美男子",
"sex":"m",
"profile_image":"http://tp3.sinaimg.cn/5386061854/50/5711780989/1",
"weibo_uid":"5386061854",
"qq_uid":"",
"qzone_uid":"",
"is_vip":false,
"personal_page":"http://m.weibo.com/u/5386061854"
*/

/**
 *  头像图片url
 */
@property(nonatomic, strong)NSArray *header;
@property(nonatomic, assign)BOOL is_v;
@property(nonatomic, assign)BOOL is_vip;
/**
 *  用户名字
 */
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *uid;

//------------------------------------------
@property(nonatomic, copy)NSString *username;
@property(nonatomic, copy)NSString *sex;
@property(nonatomic, copy)NSString *profile_image;
@property(nonatomic, copy)NSString *weibo_uid;
@property(nonatomic, copy)NSString *qq_uid;
@property(nonatomic, copy)NSString *qzone_uid;
@property(nonatomic, copy)NSString *personal_page;
@end
