//
//  UIViewController+SYAdd.m
//  artapp
//
//  Created by 刘思源 on 17/8/16.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "UIViewController+PKGAdd.h"
#import <objc/runtime.h>

@implementation UIViewController (PKGAdd)

void * popActionKey;

-(void (^)(void))pkg_popAction{
    return objc_getAssociatedObject(self, &popActionKey);
}

-(void)setPKG_popAction:(void (^)(void))sy_popAction{
    objc_setAssociatedObject(self, &popActionKey,
                             sy_popAction,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIWindow *)pkg_topmostVisiableWindow{
    __block UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isHidden && obj.windowLevel > window.windowLevel) {
            window = obj;
        }
    }];
    return window;
}


+ (UIViewController*)pkg_topMostControllerFromWindow:(UIWindow *)window
{
    UIViewController *topController = [window rootViewController];
    
    //  Getting topMost ViewController
    while ([topController presentedViewController])    topController = [topController presentedViewController];
    
    //  Returning topMost ViewController
    return topController;
}

+ (UIViewController*)pkg_currentViewControllerFromWindow:(UIWindow *)window{
    UIViewController *currentViewController = [self pkg_topMostControllerFromWindow:window];
    if([currentViewController isKindOfClass:[UITabBarController class]]){
        currentViewController = [(UITabBarController *)currentViewController selectedViewController];
    }
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}


+ (UIViewController *)pkg_getCurrentController{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window == nil) {
        window = [UIApplication sharedApplication].delegate.window;
    }
    
    UIViewController *vc = [self pkg_currentViewControllerFromWindow:window];
    return vc;
}

- (UIViewController *)pkg_getControllerInNavPoolAheadBy:(NSUInteger)ahead{
    if (![self pkg_isPushed]) {
        //如果这个控制器不是被pop出来的
        return nil;
    }
    if (self.navigationController.viewControllers.count <ahead) {
        return nil;
    }
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    UIViewController *controller = self.navigationController.viewControllers[index - ahead];
    return controller;
}

-(UIViewController *)pkg_lastConrollerInNavPool{
    return [self pkg_getControllerInNavPoolAheadBy:1];
}


-(BOOL)pkg_checkEntranceWithClsName:(NSString *)clsName{
    if ([self.pkg_lastConrollerInNavPool isKindOfClass:NSClassFromString(clsName)]) {
        return YES;
    }
    return NO;
}

- (void)pkg_popToViewControllerIdentifiedByClsNames:(NSArray *)controllers{
    [self pkg_popToViewControllerIdentifiedByClsNames:controllers failed:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//跳转到数组中的控制器 数组元素越靠前优先级越高;
- (void)pkg_popToViewControllerIdentifiedByClsNames:(NSArray *)controllers failed:(void(^)(void))failed{
    __block UIViewController *desController;
    [controllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self pkg_getControllerInNavPopByByClsName:obj result:^(UIViewController *des) {
            if (des) {
                desController = des;
                [self.navigationController popToViewController:des animated:YES];
                *stop = YES;
            }
        }];
    }];
    if (!desController) {
        !failed?:failed();
    }
}

- (void)pkg_getControllerInNavPopByByClsName:(NSString *)clsName result:(void(^)(UIViewController *))result{
    __block UIViewController *desController;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:clsName]) {
            desController = obj;
            *stop = YES;
        }
    }];
    result(desController);
}

- (void)pkg_popToControllerWithBlackList:(NSArray *)blacklist{
    //退出当前控制器,如果是上层控制器是黑名单中的 就再向上退一层.
    UINavigationController *nav = self.navigationController;
    UIViewController *root = self;
    if(!nav){
        root = root.parentViewController;
        nav = root.parentViewController.navigationController;
    }
    NSEnumerator *enumerator = [nav.viewControllers reverseObjectEnumerator];
    UIViewController *desVc = nil;
    UIViewController *nextVc = nil;
    while (nextVc = [enumerator nextObject]) {
        __block BOOL inBlackList = NO;
        if (nextVc == self) {
            continue;
        }
        [blacklist enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isEqualToString:NSStringFromClass(nextVc.class)]) {
                inBlackList = YES;
                *stop = YES;
            }
        }];

        if (!inBlackList) {
            desVc = nextVc;
            break;
        }
    }
    if (!desVc) {
        [nav popViewControllerAnimated:YES];
    }else{
        [nav popToViewController:desVc animated:YES];
    }
}


- (void)pkg_popToViewControllerIdentifiedByClsName:(NSString *)clsName{
    __block id target;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(clsName)]) {
            target = obj;
        }
    }];
    if (target) {
        [self.navigationController popToViewController:target animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)pkg_popToViewControllerAheadBy:(NSInteger)ahead{
    UIViewController *vc = [self pkg_getControllerInNavPoolAheadBy:ahead];
    if (vc) {
        [self.navigationController popToViewController:vc animated:YES];
    }else{
        NSLog(@"error: %s",__func__);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)pkg_isPushed{
    return self.navigationController.viewControllers.count >= 2  && [self.navigationController.viewControllers containsObject:self];
}
- (BOOL)pkg_isPrensented{
    return self.presentingViewController? YES:NO;
}

- (void)pkg_popOrDismiss{
    if ([self pkg_isPushed]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)pkg_pushAndReplace:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
    NSMutableArray *VCs = self.navigationController.viewControllers.mutableCopy;
    [VCs removeObject:self];
    self.navigationController.viewControllers = VCs.copy;
}


@end
