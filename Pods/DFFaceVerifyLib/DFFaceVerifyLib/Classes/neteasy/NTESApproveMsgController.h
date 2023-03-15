//
//  NTESApproveMsgController.h
//  zuhaowan
//
//  Created by mac on 2021/9/23.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DFOCBaseLib/DFBaseController.h>
NS_ASSUME_NONNULL_BEGIN

@interface NTESApproveMsgController : DFBaseController


// 人脸用途
@property(nonatomic) NSInteger purpose; //0 大额  1实名  2下单 3预约下单  4登录 5开始游戏

@end

NS_ASSUME_NONNULL_END
