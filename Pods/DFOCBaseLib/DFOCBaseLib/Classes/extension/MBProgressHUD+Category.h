//
//  MBProgressHUD+Category.h
//  ExiuComponent
//
//  Created by liubin on 15/11/18.
//  Copyright © 2015年 Exiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface MBProgressHUD (ExiuCategory)

//生成一个进度框，会将弹框放到window上，并自动消失
+(void)ShowHud:(NSString *)str object:(id)object;

//生成一个带蒙板的进度框，会将弹框放到window上，并自动消失
+(void)ShowDimBackHud:(NSString *)str object:(id)object;

//生成一个进度框，会将弹框放到window上，并在delay时间后自动消失
+(MBProgressHUD *)ShowHud:(NSString *)str object:(id)object afterDelay:(float)delay;


+(void)showHudAtView:(UIView*)view withMessage:(NSString*)message dimBackground:(BOOL)dim afterDelay:(NSInteger)delay;


/* Functions implemented as macros */
#define ExiuShowHudWithOption(view,message,dim,delay)           do {  \
[MBProgressHUD showHudAtView:view withMessage:message dimBackground:dim afterDelay:delay];\
} while(0)

#define ExiuShowHud(view,message)           do {  \
[MBProgressHUD showHudAtView:view withMessage:message dimBackground:NO afterDelay:0];\
} while(0)

#define ExiuHideHud(view)               do {  \
[MBProgressHUD hideAllHUDsForView:view animated:YES];\
} while(0)
@end
