//
//  BaseContentView.m
//  zuhaowan
//
//  Created by chenhui on 2018/3/23.
//  Copyright © 2018年 chenhui. All rights reserved.
//

#import "BaseContentView.h"
#import "OC_Const.h"
@implementation BaseContentView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = OX_COLOR(0xffffff);
        [self configureContentView];
    }
    return self;
}


- (void)configureContentView
{
    
}

@end
