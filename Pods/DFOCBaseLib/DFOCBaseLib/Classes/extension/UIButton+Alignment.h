//
//  UIButton+Alignment.h
//  ZHWBuyer
//
//  Created by 毛文豪 on 2017/6/23.
//  Copyright © 2017年 ZuHaoWan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OC_Const.h"
@interface UIButton (Alignment)

- (void)setButtonTitleWithImageAlignment:(UIButtonTitleWithImageAlignment)buttonTitleWithImageAlignment imgTextDistance:(CGFloat)imgTextDistance;

////图片 文字间距
//@property (nonatomic) CGFloat imgTextDistance;  // distance between image and title, default is 5
//@property (nonatomic) UIButtonTitleWithImageAlignment buttonTitleWithImageAlignment;  // need to set a value when used
//
//- (UIButtonTitleWithImageAlignment)buttonTitleWithImageAlignment;
//- (void)setButtonTitleWithImageAlignment:(UIButtonTitleWithImageAlignment)buttonTitleWithImageAlignment;


@end
