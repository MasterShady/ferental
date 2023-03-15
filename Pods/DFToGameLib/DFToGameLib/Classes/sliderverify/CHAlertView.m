//
//  CHAlertView.m
//  zuhaowan
//
//  Created by chenhui on 2018/12/3.
//  Copyright © 2018 chenhui. All rights reserved.
//

#import "CHAlertView.h"
#define middleViewHight 80
@interface CHAlertView ()
{
    UIView *_containerView;
    UIView *_middleContainerView;
    UIView *_middleView;
}

@end

@implementation CHAlertView

- (id)initWithMiddleView:(UIView *)middleView
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        _middleView = middleView;
        [self _setUpFrame];
    }
    return self;
}

- (void)_setUpFrame
{
    self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
    float alertWidth = 0.74 * [UIScreen mainScreen].bounds.size.width;
    if (_middleView) {
        alertWidth = _middleView.bounds.size.width;
    }
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertWidth, 300)];
    _middleContainerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, alertWidth, middleViewHight)];
    if (_middleView != nil) {
        CGRect rect1 = _middleView.frame;
        rect1.origin.x = 0;
        rect1.origin.y = 0;
        _middleContainerView.frame = rect1;
        rect1.origin.y = 0;
        rect1.origin.x = 0;
        _middleView.frame = rect1;
        [_middleContainerView addSubview:_middleView];
        [_containerView addSubview:_middleContainerView];
    }
    float height = 0;
    if (_middleContainerView) {
        height += _middleContainerView.bounds.size.height;
    }
    if (_middleContainerView) {
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:_middleContainerView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = _middleContainerView.bounds;
        maskLayer1.path = maskPath1.CGPath;
        _middleContainerView.layer.mask = maskLayer1;
        _middleContainerView.clipsToBounds = YES;
    }
    CGRect containerRect = _containerView.frame;
    containerRect.size.height = 0;
    if (_middleContainerView) {
        containerRect.size.height += _middleContainerView.frame.size.height;
    }
    _containerView.frame = containerRect;
    _containerView.center = self.center;
    [self addSubview:_containerView];
}

- (void)setNoAnimation:(BOOL)noAnimation
{
    _noAnimation = noAnimation;
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (!self.noAnimation) {
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = 0.4;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_containerView.layer addAnimation:popAnimation forKey:nil];
    }
}

-(void)dismiss{

    if (self && self.superview) {
        [self removeFromSuperview];
    }
}

@end
