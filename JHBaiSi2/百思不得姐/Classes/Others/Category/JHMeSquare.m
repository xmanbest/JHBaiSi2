//
//  JHMeSquare.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/19.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHMeSquare.h"
#import <MJExtension.h>

@interface JHMeSquare ()

@end

@implementation JHMeSquare
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end
