//
//  UIButton+Alignment.m
//  ZHWBuyer
//
//  Created by 毛文豪 on 2017/6/23.
//  Copyright © 2017年 ZuHaoWan. All rights reserved.
//

#import "UIButton+Alignment.h"

@implementation UIButton (Alignment)

- (void)setButtonTitleWithImageAlignment:(UIButtonTitleWithImageAlignment)buttonTitleWithImageAlignment imgTextDistance:(CGFloat)imgTextDistance
{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (buttonTitleWithImageAlignment) {
        case UIButtonTitleWithImageAlignmentUp:
        {
            if (imgTextDistance == 0) {
                //账号详情页收藏按钮
                imageEdgeInsets = UIEdgeInsetsMake(-(labelHeight-imgTextDistance/2.0), 0, 0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(0, -20.0f, -(25.0f), 0);
            }else {
                imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-imgTextDistance/2.0, 0, 0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-imgTextDistance/2.0, 0);
            }
        }
            break;
        case UIButtonTitleWithImageAlignmentLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -imgTextDistance/2.0, 0, imgTextDistance/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, imgTextDistance/2.0, 0, -imgTextDistance/2.0);
        }
            break;
        case UIButtonTitleWithImageAlignmentDown:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-imgTextDistance/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-imgTextDistance/2.0, -imageWith, 0, 0);
        }
            break;
        case UIButtonTitleWithImageAlignmentRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+imgTextDistance/2.0, 0, -labelWidth-imgTextDistance/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-imgTextDistance/2.0, 0, imageWith+imgTextDistance/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
