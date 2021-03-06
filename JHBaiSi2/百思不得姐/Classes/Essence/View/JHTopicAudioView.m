//
//  JHTopicAudioView.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/13.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHTopicAudioView.h"
#import <UIImageView+WebCache.h>
#import "JHShowBigPicViewController.h"

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
    // 设置图片点击手势识别
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)]];
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

/**
 *  图片点击手势响应方法
 */
- (void)imageViewClick {
    // 模态视图显示放大图片
    JHShowBigPicViewController *vc = [[JHShowBigPicViewController alloc] init];
    vc.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}
@end
