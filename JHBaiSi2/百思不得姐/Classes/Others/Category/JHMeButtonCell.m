//
//  JHMeButtonCell.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/19.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "JHMeButtonCell.h"
#import "JHMeTag.h"

@implementation JHMeButtonCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置背景图
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    }
    return self;
}

- (void)setMeTags:(NSArray *)meTags {
    _meTags = meTags;
    
    NSUInteger btnCount = meTags.count;
    CGFloat btnW = JHScreenW / btnCount;
    NSUInteger index = 0;
    for (JHMeTag *tag in meTags) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"#%@#", tag.theme_name] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(index * btnW, 0, btnW, self.height);
        
        [self.contentView addSubview:btn];
        index ++;
    }
}
@end
