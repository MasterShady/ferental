//
//  DFFaceVerifyManager.h
//  zuhaowan
//
//  Created by mac on 2021/9/15.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class DFFaceVerifyItem;

@protocol DFFaceVerifyProtocol <NSObject>

-(void)DFFaceVerifySuccessWithMsg:(id)content;

@property(nonatomic,weak,nullable)UIViewController * viewController;

@end


@interface DFFaceVerifyManager : NSObject

@property(nonatomic,copy)NSString * busnissId;//网易id

@property(nonatomic,weak)id<DFFaceVerifyProtocol> delegate;

@property(nonatomic,strong,readonly)DFFaceVerifyItem * currentItem;

+(instancetype)shareManager;

-(void)verifyTaskWith:(DFFaceVerifyItem *)item withTarget:(nullable id<DFFaceVerifyProtocol>)delegate ;

-(void)push:(UIViewController*)page;

-(void)closeAllPage;

@end


@interface DFFaceVerifyItem : NSObject

@property(nonatomic)NSInteger purpose; //0 大额  1实名  2下单 3预约下单  4登录 5开始游戏

@property(nonatomic,copy)NSString * verify_id;

@property(nonatomic,copy)NSString * rname;

@property(nonatomic,copy)NSString * amount;

@end

NS_ASSUME_NONNULL_END
