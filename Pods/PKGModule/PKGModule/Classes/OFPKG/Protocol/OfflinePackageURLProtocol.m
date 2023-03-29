//
//  OfflinePackageURLProtocol.m
//  OfflinePackage
//
//  Created by 刘思源 on 2022/11/29.
//

#import "OfflinePackageURLProtocol.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "URLProtocolHelper.h"
#if __has_include(<PKGModule/PKGModule-Swift.h>)
#import <PKGModule/PKGModule-Swift.h>
#else
#import "PKGModule-Swift.h"
#endif


@interface OfflinePackageURLProtocol ()<NSURLSessionDelegate>

@property (atomic,strong,readwrite) NSURLSessionDataTask *task;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *queue;

@end


static NSString *innerPkgRoot;


@implementation OfflinePackageURLProtocol


+ (void)setPkgRoot:(NSString *)pkgRoot{
    innerPkgRoot = pkgRoot;
}

+ (NSString *)pkgRoot{
    return innerPkgRoot;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    
    NSLog(@"%@",request.URL);
    NSString *scheme = [[request URL] scheme];
    // 判断是否需要进入自定义加载器
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame)
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:kKKJSBridgeNSURLProtocolKey inRequest:request]) {
            return NO;
        }
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    // 执行自定义操作，例如添加统一的请求头等
    return mutableReqeust;
}



- (void)startLoading{
    NSLog(@"%@",self.request.URL);
    NSURLRequest *originRequest = self.request;
    NSMutableURLRequest *mutableReqeust = [originRequest mutableCopy];
    // 标示改request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:kKKJSBridgeNSURLProtocolKey inRequest:mutableReqeust];
    if ([self.request.URL.host containsString:PKGContext.kPkgHostPart]) {
        //本地
        NSString *relativePath;
        if (self.request.URL.pathExtension.length > 0) {
            relativePath = self.request.URL.relativePath;
        }else{
            if([self.request.URL.lastPathComponent isEqualToString:@"/"]){
                relativePath = @"index.html";
            }else{
                relativePath = [NSString stringWithFormat:@"%@.html",self.request.URL.lastPathComponent];
            }
        }
        
        
        NSString *folderRoot = OfflinePackageURLProtocol.pkgRoot;
        NSString *filePath = [@[
            folderRoot,
            relativePath
        ] componentsJoinedByString:@"/"];
        

        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSURLResponse *res = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:[self getMimeTypeWithFilePath:filePath] expectedContentLength:data.length textEncodingName:nil];
        [self.client URLProtocol:self didReceiveResponse:res cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        
    }
    
    else{
        NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session  = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:self.queue];

        if ([self.request isKindOfClass:[NSMutableURLRequest class]]){
            NSMutableURLRequest *realRequest = (NSMutableURLRequest *)self.request;
            NSMutableDictionary *headerFileds = realRequest.allHTTPHeaderFields.mutableCopy;
            //移除Referer和Origin 避免后端风控触发.
            if (![realRequest.URL.absoluteString containsString:@"alipay"]){
                headerFileds[@"Referer"] = [PKGContext kOrigin];
                headerFileds[@"Origin"] = [PKGContext kOrigin];
            }
            realRequest.allHTTPHeaderFields = headerFileds.copy;
            mutableReqeust.allHTTPHeaderFields = headerFileds.copy;
        }

        self.task = [self.session dataTaskWithRequest:mutableReqeust];
        [self.task resume];
    }
}

- (NSString *)getMimeTypeWithFilePath:(NSString *)filePath{
    CFStringRef pathExtension = (__bridge_retained CFStringRef)[filePath pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    CFRelease(pathExtension);
    //The UTI can be converted to a mime type:
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    if (type != NULL)
        CFRelease(type);
    return mimeType;
}



- (void)stopLoading
{
    [self.session invalidateAndCancel];
    self.session = nil;
}




#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil) {
        [self.client URLProtocol:self didFailWithError:error];
    }else
    {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    NSURLResponse *newResponse = [URLProtocolHelper appendRequestIdToResponseHeader:response];
    [self.client URLProtocol:self didReceiveResponse:newResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    completionHandler(proposedResponse);
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                            didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengeUseCredential;
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        //最后调用 completionHandler 继续执行操作
        if (completionHandler) {

            completionHandler(disposition, credential);

        }
}

//TODO: 重定向
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest*    redirectRequest;
    redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:kKKJSBridgeNSURLProtocolKey inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    
    [self.task cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}


#pragma mark - Getter
- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

@end
