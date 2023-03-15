//
//  UIDevice+Utils.m
//  YWCloudPlayer
//
//  Created by  张恒海 on 2021/5/28.
//  Copyright © 2021 Apple. All rights reserved.
//

#import "UIDevice+Utils.h"

@implementation UIDevice (Utils)

+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation{
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:(int)interfaceOrientation];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

@end
