//
//  JHMeSimpleCell.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/19.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHMeSimpleCell.h"

@interface JHMeSimpleCell ()

@end

@implementation JHMeSimpleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // 设置背景图
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageView.image) { // 如果是第一个cell需要做特殊处理
        self.imageView.x = JHTopicMargin;
        self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + JHTopicMargin;
    }
}
@end
