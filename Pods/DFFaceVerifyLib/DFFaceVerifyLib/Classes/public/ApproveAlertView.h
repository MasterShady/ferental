//
//  ApproveAlertView.h
//  zuhaowan
//
//  Created by mac on 2020/9/15.
//  Copyright © 2020 chenhui. All rights reserved.
//

@import DFOCBaseLib;

NS_ASSUME_NONNULL_BEGIN

@interface ApproveAlertView : BaseContentView

/** 按钮点击事件 */
@property(nonatomic, copy) void(^btnActionBlock) (NSInteger type);


/** 信息 */
@property (nonatomic,strong) UILabel *msg_label;
@end

NS_ASSUME_NONNULL_END
