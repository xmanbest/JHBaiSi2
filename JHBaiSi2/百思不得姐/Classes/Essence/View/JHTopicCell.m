//
//  JHTopicCell.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/5.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHTopicCell.h"
#import <UIImageView+WebCache.h>
#import "JHTopicPictureView.h"
#import <DALabeledCircularProgressView.h>
#import "JHTopicAudioView.h"
#import "JHTopicVideoView.h"

@interface JHTopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sinaVImageView;
@property (weak, nonatomic) IBOutlet UILabel *text_Label;

/**
 *  显示图片的视图
 */
@property (weak, nonatomic) JHTopicPictureView *picView;
/**
 *  音频的视图
 */
@property (weak, nonatomic) JHTopicAudioView *audiView;
/**
 *  视频的视图
 */
@property (weak, nonatomic) JHTopicVideoView *videoView;
@end

@implementation JHTopicCell

- (void)awakeFromNib {
    // 设置立体边框背景图
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (JHTopicPictureView *)picView {
    if (!_picView) {
        JHTopicPictureView *picView = [JHTopicPictureView pictureView];
        [self.contentView addSubview:picView];
        
        _picView = picView;
    }
    return _picView;
}

- (JHTopicAudioView *)audiView {
    if (!_audiView) {
        JHTopicAudioView *audioView = [JHTopicAudioView audioView];
        [self.contentView addSubview:audioView];
        
        _audiView = audioView;
    }
    return _audiView;
}

- (JHTopicVideoView *)videoView {
    if (!_videoView) {
        JHTopicVideoView *videoView = [JHTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        
        _videoView = videoView;
    }
    return _videoView;
}

/**
 *  设置cell内部控件显示内容
 */
- (void)setTopic:(JHTopic *)topic {
    _topic = topic;
    
    self.nameLabel.text = topic.u.name;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[topic.u.header firstObject]] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
 
    
    // 设置格式化后的经过时间
    self.timeLabel.text = topic.passtime;
    // 判断是否显示sinaV
    self.sinaVImageView.hidden = !topic.u.is_v;
    
    [self setButton:self.dingBtn count:topic.up placehold:@"顶"];
    [self setButton:self.caiBtn count:topic.down placehold:@"踩"];
    [self setButton:self.shareBtn count:topic.bookmark placehold:@"分享"];
    [self setButton:self.commentBtn count:topic.comment placehold:@"留言"];
    
    // 显示文本内容
    self.text_Label.text = topic.text;
    // 当cell被图片复用时
    if ([topic.type isEqualToString:JHTopicImageKey] || [topic.type isEqualToString:JHTopicGifKey]) {
        // 中部图片视图内部控件设置
        self.picView.topic = topic;
        // 设置图片视图Frame(此frame计算被封装到了数据模型中)
        self.picView.frame = topic.picViewFrame;
    }
    // 当cell被音频复用时
    else if ([topic.type isEqualToString:JHTopicAudioKey]) {
        self.audiView.topic = topic;
        self.audiView.frame = topic.audioViewFrame;
    }
    // 当cell被视频复用时
    else if ([topic.type isEqualToString:JHTopicVideoKey]) {
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoViewFrame;
    }
    // 当cell被段子复用时，应该清除中间控件
    else {
        [self.picView removeFromSuperview];
        [self.audiView removeFromSuperview];
        [self.videoView removeFromSuperview];
        // 中部图片视图内部控件设置
//        self.picView.topic = topic;
        // 设置图片视图Frame(此frame计算被封装到了数据模型中)
//        self.picView.frame = topic.picViewFrame;
    }
    
}

/**
 *  设置底部按钮标题
 */
- (void)setButton:(UIButton *)btn count:(NSString *)count placehold:(NSString *)placehold {
    NSString *title;
    if (count.doubleValue >= 10000) {
        title = [NSString stringWithFormat:@"%.1f万", count.doubleValue / 10000.0];
    }
    else if (count.doubleValue > 0) {
        title = count;
    }
    else {
        title = placehold;
    }
    [btn setTitle:title forState:UIControlStateNormal];
}

/**
 *  修改cell默认frame
 */
- (void)setFrame:(CGRect)frame {
    
//    frame.origin.x = margin;
//    frame.size.width -= 2 * self.x;
    frame.size.height -= JHTopicMargin;
    frame.origin.y += JHTopicMargin;
    
    [super setFrame:frame];
}


@end
