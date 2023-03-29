//
//  URLProtocolHelper.h
//  gerental
//
//  Created by 刘思源 on 2023/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kKKJSBridgeNSURLProtocolKey;

@interface URLProtocolHelper : NSObject

+ (NSURLResponse *)appendRequestIdToResponseHeader:(NSURLResponse *)response;

@end

NS_ASSUME_NONNULL_END
