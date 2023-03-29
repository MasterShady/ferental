//
//  UIButton+SYImagePosition.m
//
//  Created by liusiyuan on 16/1/15.
//  Copyright © 2016年 liusiyuan. All rights reserved.
//

#import "UIButton+PKGImagePosition.h"
//#import <WXApi.h>

@implementation UIButton (PKGImagePosition)

- (void)pkg_setImagePosition:(PKGImagePosition)postion spacing:(CGFloat)spacing{
    [self pkg_setImagePosition:postion maxTitleLayoutW:HUGE spacing:spacing];
}

- (void)pkg_setImagePosition:(PKGImagePosition)postion maxTitleLayoutW:(CGFloat)maxLayoutW spacing:(CGFloat)spacing{
    [self setTitle:self.currentTitle forState:self.state];
    [self setImage:self.currentImage forState:self.state];

    //[WXApi class];
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
        
    CGFloat labelWidth = 0;
    CGFloat labelHeight = 0;
    
    labelWidth = [self.titleLabel.text boundingRectWithSize:CGSizeMake(maxLayoutW, HUGE) options: 0 attributes:@{
        NSFontAttributeName : self.titleLabel.font,
    } context:nil].size.width;

    labelHeight = [self.titleLabel.attributedText size].height;
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    CGFloat tempWidth = MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + spacing - tempHeight;
    
    switch (postion) {
        case PKGImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case PKGImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case PKGImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
            
        case PKGImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
        
        case PKGImagePositionReset:
            self.imageEdgeInsets = UIEdgeInsetsZero;
            self.titleEdgeInsets = UIEdgeInsetsZero;
            self.contentEdgeInsets = UIEdgeInsetsZero;
            break;
            
        default:
            break;
    }
    
}

- (void)pkg_resetPostion{
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.contentEdgeInsets = UIEdgeInsetsZero;
}


@end
