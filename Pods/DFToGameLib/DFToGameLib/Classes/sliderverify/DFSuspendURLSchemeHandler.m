//
//  DFSuspendURLSchemeHandler.m
//  zuhaowan
//
//  Created by mac on 2021/4/13.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import "DFSuspendURLSchemeHandler.h"


@interface DFSuspendURLSchemeHandler ()

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSMutableDictionary * schemaTaskMap;


@end

@implementation DFSuspendURLSchemeHandler


-(NSMutableDictionary *)schemaTaskMap {
    
    if (!_schemaTaskMap) {
        
        _schemaTaskMap = @{}.mutableCopy;
    }
    
    return  _schemaTaskMap;
}

//这里拦截到URLScheme为customScheme的请求后，根据自己的需求,返回结果，并返回给WKWebView显示
- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask{
    NSMutableURLRequest *request = urlSchemeTask.request.mutableCopy;
    NSString *urlStr = [NSString stringWithFormat:@"%@", request.URL];
    NSLog(@"当前拦截的url ============ %@", urlStr);
    //如果是我们替对方去处理请求的时候
    self.schemaTaskMap[urlSchemeTask.description] = @(1) ;
    NSURLSession * session = NSURLSession.sharedSession;
//    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0" forHTTPHeaderField:@"User-Agent"];
    
   NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
       if ([self.schemaTaskMap[urlSchemeTask.description] intValue] == 0) {
           
           return;
       }
        if ([urlStr containsString:@"https://t.captcha.qq.com/cap_union_new_verify"]) {
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"大佬大佬实力坑爹请求结果str ===== =====%@", jsonString);
            
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
            NSLog(@"当前得到的ticket =====%@ randstr=====%@", dic[@"ticket"], dic[@"randstr"]);
            
            if (self.handlerTickerAndRandstrBlock) {
                self.handlerTickerAndRandstrBlock(dic[@"ticket"], dic[@"randstr"]);
            }
            
            if (self.handlerResultBlock) {
                
                self.handlerResultBlock(jsonString);
            }
        }
        
        [urlSchemeTask didReceiveResponse:response];
        [urlSchemeTask didReceiveData:responseObject];
        [urlSchemeTask didFinish];
        
        }];
    
    [task resume];
    
    
    
    
//
//    if (!manager) {
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
//        //这个acceptableContentTypes类型自己补充,demo不写太多
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/html", nil];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    }
//
//    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//
//
//    }];
//
//    [task resume];
    
}




- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask{
    
    self.schemaTaskMap[urlSchemeTask.description] = @(0) ;
}

@end
