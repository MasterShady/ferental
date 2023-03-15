//
//  URLProtocolHelper.m
//  gerental
//
//  Created by 刘思源 on 2023/3/2.
//

#import "URLProtocolHelper.h"
#import <dlfcn.h>

@implementation URLProtocolHelper

typedef CFHTTPMessageRef (*KKJSBridgeURLResponseGetHTTPResponse)(CFURLRef response);

static NSString * const kKKJSBridgeRequestId = @"KKJSBridge-RequestId";
static NSString * const kKKJSBridgeAjaxRequestHeaderAC = @"Access-Control-Request-Headers";
static NSString * const kKKJSBridgeAjaxResponseHeaderAC = @"Access-Control-Allow-Headers";
NSString * const kKKJSBridgeNSURLProtocolKey = @"kKKJSBridgeNSURLProtocolKey";

+ (NSURLResponse *)appendRequestIdToResponseHeader:(NSURLResponse *)response{
    if ([response isKindOfClass:NSHTTPURLResponse.class]) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        NSMutableDictionary *headers = [res.allHeaderFields mutableCopy];
        if (!headers) {
            headers = [NSMutableDictionary dictionary];
        }
        
        NSMutableString *string = [headers[kKKJSBridgeAjaxResponseHeaderAC] mutableCopy];
        if (string) {
            [string appendFormat:@",%@", kKKJSBridgeRequestId];
        } else {
            string = [kKKJSBridgeRequestId mutableCopy];
        }
        headers[kKKJSBridgeAjaxResponseHeaderAC] = [string copy];
        headers[@"Access-Control-Allow-Credentials"] = @"true";
        headers[@"Access-Control-Allow-Origin"] = @"*";
        headers[@"Access-Control-Allow-Methods"] = @"OPTIONS,GET,POST,PUT,DELETE";
        
        NSHTTPURLResponse *updateRes = [[NSHTTPURLResponse alloc] initWithURL:res.URL statusCode:res.statusCode HTTPVersion:[self getHttpVersionFromResponse:res] headerFields:[headers copy]];
        response = updateRes;
    }
    
    return response;
}

+ (NSString *)getHttpVersionFromResponse:(NSURLResponse *)response {
    NSString *version;
    // 获取CFURLResponseGetHTTPResponse的函数实现
    NSString *funName = @"CFURLResponseGetHTTPResponse";
    KKJSBridgeURLResponseGetHTTPResponse originURLResponseGetHTTPResponse = dlsym(RTLD_DEFAULT, [funName UTF8String]);

    SEL theSelector = NSSelectorFromString(@"_CFURLResponse");
    if ([response respondsToSelector:theSelector] &&
        NULL != originURLResponseGetHTTPResponse) {
        // 获取NSURLResponse的_CFURLResponse
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        CFTypeRef cfResponse = CFBridgingRetain([response performSelector:theSelector]);
        #pragma clang diagnostic pop
        
        if (NULL != cfResponse) {
            // 将CFURLResponseRef转化为CFHTTPMessageRef
            CFHTTPMessageRef message = originURLResponseGetHTTPResponse(cfResponse);
            // 获取http协议版本
            CFStringRef cfVersion = CFHTTPMessageCopyVersion(message);
            if (NULL != cfVersion) {
                version = (__bridge NSString *)cfVersion;
                CFRelease(cfVersion);
            }
            CFRelease(cfResponse);
        }
    }

    // 获取失败的话则设置一个默认值
    if (nil == version || ![version isKindOfClass:NSString.class] || version.length == 0) {
        version = @"HTTP/1.1";
    }

    return version;
}


@end
