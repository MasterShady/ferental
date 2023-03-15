//
//  OC_Const.h
//  DoFunNew
//
//  Created by mac on 2021/11/8.
//

#ifndef OC_Const_h
#define OC_Const_h


//屏幕的宽度(不包含状态栏)
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define APPLICATION_WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define APPLICATION_HEIGHT [UIScreen mainScreen].applicationFrame.size.height
//系统版本
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
//屏幕尺寸（全部屏幕）
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define BASE_HEIGHT_SCALE (SCREEN_HEIGHT / 667.0f)
#define BASE_WIDTH_SCALE (SCREEN_WIDTH / 375.0f)

#define NAVBASE_HEIGHT 44.0
#define LEFT_MARGIN 15.0
#define RIGHT_MARGIN 15.0

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define TabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 83:49) // 适配iPhone x 底栏高度
#define TabbarStateHeight ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 34:0) // 适配iPhone x 底部状态栏高度


#define StatueHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAV_HEIGHT CGRectGetHeight(self.navigationController.navigationBar.frame)
#define KEY_WINDOW  [[UIApplication sharedApplication].delegate window]

//比例缩放
#define SCALE_WIDTH(value) (value * BASE_WIDTH_SCALE)
#define SCALE_HEIGHT(value) (BASE_WIDTH_SCALE == 1 ? value : value * BASE_HEIGHT_SCALE)

// 设置常规字体大小
#define DFFontWithSize(size) [UIFont systemFontOfSize:size]
/*

 颜色
 */
#define _RGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)/1.0f]
//16进制颜色
#define OX_COLOR(A) [UIColor colorWithHex:A]
/*
 弱引用
 */
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ShowHud(str)           do {  \
[MBProgressHUD ShowHud:str object:self];\
} while(0)

//url
#define DF_URL(_str_) [NSURL URLWithString:_str_]
///图片
#define DF_IMG(_name_) [UIImage imageNamed:_name_]
///加载Bundle图片
#define DF_RIMG(_name_) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_name_ ofType:nil]]

#define NSNOTIFICATIONCENTER  [NSNotificationCenter defaultCenter]

#define NETEASY_FACE_ID @"eb9a910f5019499786c3cd6011a94dcf"

#endif /* OC_Const_h */

#import <UIKit/UIKit.h>

#import "UIColor+Hex.h"

typedef NS_ENUM(NSInteger, FONT_TYPE){
    FONT_TYPE_REGULAR,  //常规
    FONT_TYPE_MEDIUM,   //粗体
    FONT_TYPE_LIGHT,    //细体
    FONT_TYPE_DISPLAY,
    FONT_TYPE_BOLD,     //加粗
    FONT_RM_MEDIUM      //HI,
};

typedef enum {
    UIButtonTitleWithImageAlignmentUp = 0,  // image is up, title is down
    UIButtonTitleWithImageAlignmentLeft,    // image is left, title is right
    UIButtonTitleWithImageAlignmentDown,    // image is down, title is up
    UIButtonTitleWithImageAlignmentRight    // image is right, title is left
} UIButtonTitleWithImageAlignment;

/*
 比例计算高度(宽度)
 */
extern CGFloat SCALE_WIDTHS(CGFloat value);
extern CGFloat SCALE_HEIGTHS(CGFloat value);
extern UIFont* DFFont(CGFloat size, FONT_TYPE tp);
