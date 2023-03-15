//
//  AgreeAlertView.h
//  zuhaowan
//
//  Created by mac on 2020/10/9.
//  Copyright © 2020 chenhui. All rights reserved.
//

#import <DFOCBaseLib/BaseContentView.h>

NS_ASSUME_NONNULL_BEGIN

@interface AgreeAlertView : BaseContentView

/** 加载网址 */
@property (nonatomic,copy) NSString *url;

/** 按钮点击事件 */
@property(nonatomic,copy) dispatch_block_t knowBlock;

@end

NS_ASSUME_NONNULL_END
