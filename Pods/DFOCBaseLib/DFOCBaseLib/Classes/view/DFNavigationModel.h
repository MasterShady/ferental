//
//  DFNavigationModel.h
//  zuhaowan
//
//  Created by chenhui on 2018/3/22.
//  Copyright © 2018年 chenhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFNavigationModel : NSObject

@property(nonatomic, strong) UIColor *bgColor;//标题背景颜色

@property(nonatomic, copy) NSString *leftBtnTitle;
@property(nonatomic, copy) NSString *leftBtnImage;
@property(nonatomic, strong) UIColor *leftBtnTitleColor;
@property(nonatomic, assign) CGFloat leftBtnFont;
@property(nonatomic, assign) CGSize leftBtnSize;
@property(nonatomic, assign) BOOL showRounded;

@property(nonatomic, copy) NSString *navTitle;
@property(nonatomic, strong) UIColor *navTitleColor;
@property(nonatomic, assign) CGFloat navTitleFont;


@property(nonatomic, copy) NSString *rightBtnTitle;
@property(nonatomic, copy) NSString *rightBtnImage;
@property(nonatomic, strong) UIColor *rightBtnTitleColor;
@property(nonatomic, assign) CGFloat rightBtnFont;
@property(nonatomic, assign) CGSize rightBtnSize;

@property(nonatomic, copy) NSString *rightSecondBtnImage;
@property(nonatomic, copy) NSString *rightFirstBtnImage;
@property(nonatomic, assign) BOOL showFirstSecondRightBtn;
@property(nonatomic, assign) CGSize rightSecondBtnSize;
@property(nonatomic, assign) CGSize rightFirstBtnSize;

@property(nonatomic, assign) BOOL showLeftBtn;
@property(nonatomic, assign) BOOL showRightBtn;

@property(nonatomic, copy) NSString *placehoderStr;
@property(nonatomic, assign) BOOL showLineLabel;//是否限时横线

@end
