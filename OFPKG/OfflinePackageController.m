//
//  OfflinePackageController.m
//  OfflinePackage
//
//  Created by 刘思源 on 2022/11/30.
//

#import "OfflinePackageController.h"
#import "OfflinePackageURLProtocol.h"
#import <WebKit/WebKit.h>
#import "BaseFunctionModule.h"
#import "ferental-Swift.h"
#import <AFNetworking/AFNetworking.h>
#import <dlfcn.h>

@interface OfflinePackageController ()<WKNavigationDelegate>


@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) KKJSBridgeEngine *jsBridgeEngine;
@property (nonatomic, strong) KKJSBridgeEngine *payBridgeEngine;
@property (nonatomic, strong) KKWebView *payWebView;

@end

@implementation OfflinePackageController

+(void)load{
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        Class cls = NSClassFromString(@"WKBrowsingContextController");
        SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
        [(id)cls performSelector:sel withObject:@"http"];
        [(id)cls performSelector:sel withObject:@"https"];
        [NSURLProtocol registerClass:[OfflinePackageURLProtocol class]];
        [self prepareWebView];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
}


- (instancetype)initWithUrl:(NSString *)url{
    if (self = [super init]) {
        _url = url;
        [self commonInit];
    }
    return self;
}


- (instancetype)init{
    if (self = [super init]){
        _url = [NSString stringWithFormat:@"http://h5.package.zuhaowan"];
        [self commonInit];
    }
    return self;
}


+ (void)prepareWebView{
    [[KKWebViewPool sharedInstance] makeWebViewConfiguration:^(WKWebViewConfiguration * _Nonnull configuration) {
        configuration.preferences.javaScriptEnabled = YES;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        [configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
        [configuration setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
        configuration.applicationNameForUserAgent = [NSString stringWithFormat:@"appId=%@ version=%@ topSafeInsets=%.0f bottomSafeInsets=%.0f",Global.kAppId,Global.df_version,Global.kStatusBarHeight,Global.kBottomSafeInset];
    }];
    [[KKWebViewPool sharedInstance] enqueueWebViewWithClass:KKWebView.class];
    KKJSBridgeConfig.ajaxDelegateManager = (id<KKJSBridgeAjaxDelegateManager>)self;
}

- (void)commonInit{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateNotificationStatus) name:[Global kNotificationStatusChanged] object:nil];
    
    _webView = [[KKWebViewPool sharedInstance] dequeueWebViewWithClass:KKWebView.class webViewHolder:self];
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    _webView.scrollView.bounces = NO;
    _jsBridgeEngine = [KKJSBridgeEngine bridgeForWebView:self.webView];
    _jsBridgeEngine.config.enableAjaxHook = YES;
    _jsBridgeEngine.bridgeReadyCallback = ^(KKJSBridgeEngine * _Nonnull engine) {
//        NSString *event = @"dataReport";
//        NSDictionary *data = @{
//            @"NotificationAvailable": @(Global.notificationAvaliable),
//        };
//        [engine dispatchEvent:event data:data];
    };
    
    [self registerModule];
    [self loadRequest];
}

- (void)registerModule{
    [self.jsBridgeEngine.moduleRegister registerModuleClass:BaseFunctionModule.class withContext:self.webView];
    [self.jsBridgeEngine.moduleRegister registerModuleClass:ToGameModule.class withContext:self];
    [self.jsBridgeEngine.moduleRegister registerModuleClass:FaceVerifyModule.class withContext:self];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = !_hasTitleBar;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self configSubViews];
}

- (void)didUpdateNotificationStatus{
    NSLog(@"%d",Global.notificationAvaliable);
    [self.webView.kk_engine dispatchEvent:@"dataReport" data:@{
        @"NotificationAvailable": @(Global.notificationAvaliable)
    }];
}

- (id <KKJSBridgeModule>)getModuleOfName:(NSString *)moduleName{
    KKJSBridgeModuleMetaClass *metaClass = [self.jsBridgeEngine.moduleRegister getModuleMetaClassByModuleName:moduleName];
    return [self.jsBridgeEngine.moduleRegister generateInstanceFromMetaClass:metaClass];
}

- (void)configSubViews{
    if (self.titleFromURL.length > 0){
        self.title = self.titleFromURL;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    self.webView.frame = [UIScreen mainScreen].bounds;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
//
//    [self.view addSubview:self.payWebView];
//    self.payWebView.frame = CGRectMake(0, 0, 375, 200);

    
    NSMutableArray *constraints = [NSMutableArray array];
    
    if (!self.hasTitleBar && self.hasStatusBar){
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    }else{
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    }
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraints:constraints];
}


- (void)onClickBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 请求
- (void)loadRequest {
    if (!self.url) {
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

- (void)onRefresh{
    [self.webView reload];
}


#pragma mark - KKJSBridgeAjaxDelegateManager

+ (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request callbackDelegate:(NSObject<KKJSBridgeAjaxDelegate> *)callbackDelegate {
    return [[self ajaxSesstionManager] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:httpResponse.URL];
            for (NSHTTPCookie *cookie in cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            }
        }
        // 处理响应数据
        [callbackDelegate JSBridgeAjax:callbackDelegate didReceiveResponse:response];
        if ([responseObject isKindOfClass:NSData.class]) {
            [callbackDelegate JSBridgeAjax:callbackDelegate didReceiveData:responseObject];
        } else if ([responseObject isKindOfClass:NSDictionary.class]) {
            NSData *responseData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            [callbackDelegate JSBridgeAjax:callbackDelegate didReceiveData:responseData];
        } else {
            NSData *responseData = [NSJSONSerialization dataWithJSONObject:@{} options:0 error:nil];
            [callbackDelegate JSBridgeAjax:callbackDelegate didReceiveData:responseData];
        }
        if (responseObject) {
            error = nil;
        }
        [callbackDelegate JSBridgeAjax:callbackDelegate didCompleteWithError:error];
    }];
}


+ (AFHTTPSessionManager *)ajaxSesstionManager {
    static AFHTTPSessionManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        instance.requestSerializer = [AFHTTPRequestSerializer serializer];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return instance;
}


//urlEncode编码
+ (NSString *)urlEncodeStr:(NSString *)input {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *upSign = [input stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return upSign;
}
//urlEncode解码
+ (NSString *)decoderUrlEncodeStr: (NSString *) input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByRemovingPercentEncoding];
}



#pragma mark - WKNavigationDelegate
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = url.absoluteString;
    
    NSLog(@">>> %@",navigationAction.request.URL);
    
    if ([urlString containsString:@"https://__bridge_loaded__"]) {// 防止 WebViewJavascriptBridge 注入
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
   if ( [urlString containsString:@"https://openapi.alipay.com"] && webView == _webView) {
         dispatch_async(dispatch_get_main_queue(), ^{
            NSURL*url = navigationAction.request.URL;
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            request.HTTPMethod = @"GET";
            [request addValue:@"com.dofun.youyizu"forHTTPHeaderField:@"Referer"];
             [self.payWebView loadRequest:request];

         });
         decisionHandler(WKNavigationActionPolicyCancel);
         return;
   }

    if ([navigationAction.request.URL.scheme isEqualToString:@"alipay"]) {
                //  1.以？号来切割字符串
                NSArray *urlBaseArr = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"?"];
                NSString *urlBaseStr = urlBaseArr.firstObject;
                NSString *urlNeedDecode = urlBaseArr.lastObject;
                //  2.将截取以后的Str，做一下URLDecode，方便我们处理数据
                NSMutableString *afterDecodeStr = [NSMutableString stringWithString:[OfflinePackageController decoderUrlEncodeStr:urlNeedDecode]];
                //  3.替换里面的默认Scheme为自己的Scheme
                NSString *afterHandleStr = [afterDecodeStr stringByReplacingOccurrencesOfString:@"alipays" withString:@"com.dofun.youyizu"];
                //  4.然后把处理后的，和最开始切割的做下拼接，就得到了最终的字符串
                NSString *finalStr = [NSString stringWithFormat:@"%@?%@",urlBaseStr, [OfflinePackageController urlEncodeStr:afterHandleStr]];
    
                //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //  判断一下，是否安装了支付宝APP（也就是看看能不能打开这个URL）
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:finalStr]]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalStr]];
                    } else {
                        //未安装支付宝, 自行处理
                        [AutoProgressHUD showAutoHud:@"未安装支付宝"];
                    }
                //});
    
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }

    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面跳转完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (webView == _webView){
        if (!self.titleFromURL){
            self.navigationItem.title = webView.title;
        }
        !self.didFinishNavigation? : self.didFinishNavigation();
        [self didUpdateNotificationStatus];
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    /*
     解决内存过大引起的白屏问题
     */
    [self.webView reload];
}




- (WKWebView*)payWebView{
    if(!_payWebView){
        _payWebView = [[KKWebViewPool sharedInstance] dequeueWebViewWithClass:KKWebView.class webViewHolder:self];
        _payBridgeEngine = [KKJSBridgeEngine bridgeForWebView:self.payWebView];
        _payBridgeEngine.config.enableAjaxHook = YES;
        _payWebView.navigationDelegate = self;
    }
    return _payWebView;
}



@end
