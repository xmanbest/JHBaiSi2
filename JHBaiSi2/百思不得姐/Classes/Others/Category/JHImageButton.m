//
//  JHImageButton.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/19.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHImageButton.h"
#import "JHMeSquare.h"
#import <UIButton+WebCache.h>

@implementation JHImageButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.contentMode = UIViewContentModeCenter;
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
        // 去除autorisize
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.y = JHTopicMargin;
    self.imageView.width = 44;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.height = self.height - self.titleLabel.y;
    self.titleLabel.x = 0;
    self.titleLabel.width = self.width;
}

- (void)setMeSquare:(JHMeSquare *)meSquare {
    _meSquare = meSquare;
    
    [self setTitle:[NSString stringWithFormat:@"%@", meSquare.name] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:meSquare.icon] forState:UIControlStateNormal];
    
}
@end
