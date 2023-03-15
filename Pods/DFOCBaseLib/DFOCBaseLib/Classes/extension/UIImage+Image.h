//
//  UIImage+Image.h
//  zuhaowan
//
//  Created by chenhui on 2018/3/21.
//  Copyright © 2018年 chenhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
/**
 *  根据颜色生成一张图片
 *  param color 提供的颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/*
 获取视频第一帧
 */
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size;


- (UIImage *)imagesWithColor:(UIColor *)color;

@end
