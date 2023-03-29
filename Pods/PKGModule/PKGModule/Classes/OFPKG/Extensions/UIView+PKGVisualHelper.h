//
//  UIView+CornerHelper.h
//  timingapp
//
//  Created by 刘思源 on 2020/9/8.
//  Copyright © 2020 huiian. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PKGVisualHelper)

///边框类型
typedef NS_ENUM(NSInteger, PKGBorderSideType) {
    BorderSideTypeAll    = 0,
    BorderSideTypeTop    = 1 << 0,
    BorderSideTypeBottom = 1 << 1,
    BorderSideTypeLeft   = 1 << 2,
    BorderSideTypeRight  = 1 << 3,
};

@property (nonatomic, assign) UIEdgeInsets pkg_touchAreaInsets;

@property CALayer *pkg_borderLayer;

/**
 单边 & 多边圆角
 */
- (void)pkg_addCornerRectWith:(UIRectCorner)rectCorner radius:(CGFloat)radius;
/**
单边 & 多边 边框
 */
-(void)pkg_addBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth borderType:(PKGBorderSideType)borderType;

//虚线边框
- (CAShapeLayer *)pkg_addDashLineWithColor:(UIColor *)color width:(CGFloat)borderWidth lineDashPattern:(NSArray *)dashPattern cornerRadius:(CGFloat)radius;

//单边& 多变虚线边框
- (void)pkg_addDashLineWithColor:(UIColor *)color width:(CGFloat)borderWidth lineDashPattern:(NSArray *)dashPattern cornerRadius:(CGFloat)radius borderType:(PKGBorderSideType)borderType;



@end

NS_ASSUME_NONNULL_END
