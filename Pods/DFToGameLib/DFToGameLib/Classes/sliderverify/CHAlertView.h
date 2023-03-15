//
//  CHAlertView.h
//  zuhaowan
//
//  Created by chenhui on 2018/12/3.
//  Copyright © 2018 chenhui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHAlertView : UIView

- (id)initWithMiddleView:(UIView *)middleView;

@property(nonatomic, assign) BOOL noAnimation;//弹出时是否需要动画

/**
 *  与系统弹框一样，调用该方法进行展示
 */
-(void)show;

/**
 *  调用该方法隐藏该实例对象
 */
-(void)dismiss;

@end

NS_ASSUME_NONNULL_END
