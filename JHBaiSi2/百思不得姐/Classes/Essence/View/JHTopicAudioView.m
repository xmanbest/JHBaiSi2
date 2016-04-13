//
//  JHTopicAudioView.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/13.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHTopicAudioView.h"
#import <UIImageView+WebCache.h>

@interface JHTopicAudioView ()
@property (weak, nonatomic) IBOutlet UIImageView *audioImageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end

@implementation JHTopicAudioView
+ (instancetype)audioView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    // 取消autoresizeing对Frame的干扰
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(JHTopic *)topic {
    _topic = topic;
    
    [self.audioImageView sd_setImageWithURL:[topic.audio.thumbnail firstObject]];
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.audio.playcount];
    NSInteger second = topic.audio.duration;
    NSInteger minute = second / 60;
    second = second % 60;
    self.durationLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

@end
