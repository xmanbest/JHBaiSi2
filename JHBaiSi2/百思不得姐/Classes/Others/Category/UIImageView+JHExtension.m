//
//  UIImageView+JHExtension.m
//  百思不得姐
//
//  Created by 李建華 on 16/4/18.
//  Copyright © 2016年 lijianhua. All rights reserved.
//

#import "UIImageView+JHExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (JHExtension)
- (void)setIconImageWithUrlStr:(NSString *)urlStr {
    UIImage *placeholderImage = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholderImage;
    }];
}
@end
