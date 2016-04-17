//
//  JHTopicCommentCell.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/16.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHTopicCommentCell.h"
#import "JHTopicComment.h"
#import "JHTopicUser.h"
#import <UIImageView+WebCache.h>

@interface JHTopicCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceCommentBtn;
@end

@implementation JHTopicCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTopicComment:(JHTopicComment *)topicComment {
    _topicComment = topicComment;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:topicComment.user.profile_image]];
    self.sexImageView.image = topicComment.user.sex == JHTopicUserSexMale ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.userNameLabel.text = topicComment.user.username;
    self.likeCountLabel.text = topicComment.like_count;
    self.contentLabel.text = topicComment.content;
    
    // 设置音频评论
    if (topicComment.voiceuri.length != 0) { // 存在音频评论
        self.voiceCommentBtn.hidden = NO;
        [self.voiceCommentBtn setTitle:topicComment.voicetime forState:UIControlStateNormal];
    } // 不存在音频评论
    else {
        self.voiceCommentBtn.hidden = YES;
    }
}

@end
