//
//  DFSuspendURLSchemeHandler.h
//  zuhaowan
//
//  Created by mac on 2021/4/13.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DFSuspendURLSchemeHandler : NSObject<WKURLSchemeHandler>


/** ticket randstr */
@property(nonatomic,copy) void(^handlerTickerAndRandstrBlock) (NSString *ticket, NSString *randstr);

@property(nonatomic,copy) void(^handlerResultBlock) (NSString *);
@end

NS_ASSUME_NONNULL_END
