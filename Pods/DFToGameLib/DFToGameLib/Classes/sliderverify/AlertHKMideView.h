//
//  AlertHKMideView.h
//  zuhaowan
//
//  Created by mac on 2021/1/27.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertHKMideView : UIView

/** reload */
@property (nonatomic,copy) NSString *reload;

/** ticket randstr */
@property(nonatomic,copy) void(^tickerAndRandstrBlock) (NSString *ticket, NSString *randstr);

@property(nonatomic,copy) void(^jsonResultBlock) (NSString *);

/** closeBlock */
@property(nonatomic,copy) dispatch_block_t closeBlock;

/** sess */
@property (nonatomic,copy) NSString *sess;

/** sid */
@property (nonatomic,copy) NSString *sid;


- (void)configureLoadUrl:(NSString *)sess sid:(NSString *)sid;

//8.4滑块认证
- (void)configureLoadUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
