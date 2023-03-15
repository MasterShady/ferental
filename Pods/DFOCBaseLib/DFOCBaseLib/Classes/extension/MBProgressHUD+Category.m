//
//  MBProgressHUD+Category.m
//  ExiuComponent
//
//  Created by liubin on 15/11/18.
//  Copyright © 2015年 Exiu. All rights reserved.
//

#import "MBProgressHUD+Category.h"

@implementation MBProgressHUD(ExiuCategory)

+(void)ShowHud:(NSString *)str object:(id)object{
    
    Class objectClass = [object class];
    
    UIWindow *displayWindow = nil;
    if ([objectClass isSubclassOfClass:[UIView class]]) {
        __weak UIView * wself = object;
        displayWindow = wself.window;
    }else if ([objectClass isSubclassOfClass:[UIViewController class]]){
        __weak UIViewController * wself = object;
        displayWindow = wself.view.window;
    }else{
        displayWindow = [[UIApplication sharedApplication] keyWindow];
    }
    if (displayWindow == nil) {
        displayWindow = [[UIApplication sharedApplication] keyWindow];
    }

    if (displayWindow) {
        MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:displayWindow animated:YES];
        hud1.mode = MBProgressHUDModeText;
        hud1.removeFromSuperViewOnHide = YES;
        hud1.label.text = str;
        hud1.label.numberOfLines = 0;
        hud1.offset = CGPointMake(hud1.offset.x, -50);
        [hud1 hideAnimated:YES afterDelay:1.5];
    }

}


+(void)ShowDimBackHud:(NSString *)str object:(id)object{
    Class objectClass = [object class];
    
    UIWindow *displayWindow = nil;
    if ([objectClass isSubclassOfClass:[UIView class]]) {
        __weak UIView * wself = object;
        displayWindow = wself.window;
    }else if ([objectClass isSubclassOfClass:[UIViewController class]]){
        __weak UIViewController * wself = object;
        displayWindow = wself.view.window;
    }else{
        displayWindow = [[UIApplication sharedApplication] keyWindow];
    }
    if (displayWindow == nil) {
        displayWindow = [[UIApplication sharedApplication] keyWindow];
    }

    if (displayWindow) {
        MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:displayWindow animated:YES];
        hud1.mode = MBProgressHUDModeText;
        
        hud1.removeFromSuperViewOnHide = YES;
        hud1.label.text = str;
        hud1.offset = CGPointMake(hud1.offset.x, -50);
        [hud1 hideAnimated:YES afterDelay:1.5];
    }

}


+(MBProgressHUD *)ShowHud:(NSString *)str object:(id)object afterDelay:(float)delay{
    
    Class objectClass = [object class];
    
    UIWindow *displayWindow = nil;
    if ([objectClass isSubclassOfClass:[UIView class]]) {
        __weak UIView * wself = object;
        displayWindow = wself.window;
    }else if ([objectClass isSubclassOfClass:[UIViewController class]]){
        __weak UIViewController * wself = object;
        displayWindow = wself.view.window;
    }else{
        displayWindow = [[UIApplication sharedApplication] keyWindow];
    }
    if (displayWindow == nil) {
        displayWindow = [[UIApplication sharedApplication] keyWindow];
    }
    if (displayWindow) {
        MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:displayWindow animated:YES];
        hud1.mode = MBProgressHUDModeText;
        hud1.removeFromSuperViewOnHide = YES;
        hud1.label.text = str;
        hud1.offset = CGPointMake(hud1.offset.x, -50);
        [hud1 hideAnimated:YES afterDelay:1.5];
        return hud1;
    }else{
        return nil;
    }

}

+(void)showHudAtView:(UIView*)view withMessage:(NSString*)message dimBackground:(BOOL)dim afterDelay:(NSInteger)delay{
    UIView *displayWindow = nil;
    if (view) {
        displayWindow = view;
    }
    else{
        displayWindow = [[UIApplication sharedApplication] keyWindow];
    }
    if (displayWindow) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:displayWindow];
        
        hud.offset = CGPointMake(hud.offset.x, -25);
        hud.removeFromSuperViewOnHide = YES;
        if (message&&![message isEqualToString:@""]) {
            hud.label.text = message;
        }
        if (delay != 0) {
            [hud hideAnimated:true afterDelay: delay];
        }
        else{
            [hud hideAnimated:true afterDelay: 12];
        }
        [displayWindow addSubview:hud];
        [hud showAnimated:true];
    }
}
@end
