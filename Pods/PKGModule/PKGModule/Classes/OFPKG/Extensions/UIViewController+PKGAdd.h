//
//  UIViewController+SYAdd.h
//  artapp
//
//  Created by 刘思源 on 17/8/16.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PKGAdd)

@property (nonatomic,strong) void(^pkg_popAction)(void);


/// 获取最高层可视window
+ (UIWindow *)pkg_topmostVisiableWindow;

/* 获取当前的控制器**/
+ (UIViewController *)pkg_getCurrentController;

/* 获取navigationController 池中的上一个controller */
- (UIViewController *)pkg_lastConrollerInNavPool;

- (UIViewController *)pkg_getControllerInNavPoolAheadBy:(NSUInteger)ahead;

/* 检查入口是否为某个类*/
- (BOOL)pkg_checkEntranceWithClsName:(NSString *)clsName;

/* pop 到 navpool 中 类名 为cls 的控制器*/
- (void)pkg_popToViewControllerIdentifiedByClsName:(NSString *)clsName;

/* pop 到 navpool 中 往前第几个控制器 */
- (void)pkg_popToViewControllerAheadBy:(NSInteger)ahead;


/** 跳转到数组中的控制器 数组元素越靠前优先级越高 */
- (void)pkg_popToViewControllerIdentifiedByClsNames:(NSArray *)controllers failed:(void(^)(void))failed;
/** 跳转到数组中的控制器 数组元素越靠前优先级越高 如果找不到控制器 往上跳一层*/
- (void)pkg_popToViewControllerIdentifiedByClsNames:(NSArray *)controllers;

/**
 往上跳,黑名单中的控制器除外
 */
- (void)pkg_popToControllerWithBlackList:(NSArray *)blacklist;

/*不是很严谨*/
- (BOOL)pkg_isPushed;

- (BOOL)pkg_isPrensented;

- (void)pkg_popOrDismiss;

- (void)pkg_pushAndReplace:(UIViewController *)vc;

@end
