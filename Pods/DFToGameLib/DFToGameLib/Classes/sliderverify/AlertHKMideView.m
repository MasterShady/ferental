//
//  AlertHKMideView.m
//  zuhaowan
//
//  Created by mac on 2021/1/27.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import "AlertHKMideView.h"
#import <WebKit/WebKit.h>
#import "DFSuspendURLSchemeHandler.h"
#import <JavaScriptCore/JavaScriptCore.h>

//屏幕尺寸（全部屏幕）
//#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//#define BASE_HEIGHT_SCALE (SCREEN_HEIGHT / 667.0f)
//#define BASE_WIDTH_SCALE (SCREEN_WIDTH / 375.0f)
///*
// 比例计算高度(宽度)
// */
//CGFloat SCALE_WIDTHS(CGFloat value)
//{
//    return value * BASE_WIDTH_SCALE;
//}
//
//CGFloat SCALE_HEIGTHS(CGFloat value)
//{
//    return value * BASE_WIDTH_SCALE;
//   // return BASE_WIDTH_SCALE == 1 ? value : value * BASE_HEIGHT_SCALE;
//}

@interface AlertHKMideView ()<UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate>

/** wkwebview */
@property (nonatomic,strong) WKWebView *webView;


/** closeBtn */
@property (nonatomic,strong) UIButton *closeBtn;

@end

@implementation AlertHKMideView

- (void)closeBtnAction {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)setReload:(NSString *)reload {
    _reload = reload;
    
    [self.webView reload];
}

- (void)configureLoadUrl:(NSString *)sess sid:(NSString *)sid {
    
    NSString *first_str = @"https://t.captcha.qq.com/cap_union_new_show?aid=716027609&protocol=https&accver=1&showtype=popup&ua=TW96aWxsYS81LjAgKExpbnV4OyBBbmRyb2lkIDYuMDsgTmV4dXMgNSBCdWlsZC9NUkE1OE4pIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS84Ni4wLjQyNDAuNzUgTW9iaWxlIFNhZmFyaS81MzcuMzY%3D&noheader=0&fb=1&enableDarkMode=0";

    NSString *sid_str = [NSString stringWithFormat:@"&sid=%@", sid];
    
    NSString *second_str = @"&fpinfo=fpsig%3Dundefined&grayscale=1&clientype=1&subsid=2";
    
   NSString *sess_str = [NSString stringWithFormat:@"&sess=%@&fwidth=0&forcestyle=undefined&wxLang=&tcScale=1&uid=&cap_cd=&rnd=812385&TCapIframeLoadTime=undefined&prehandleLoadTime=68&createIframeStart=%@", sess, [self getNowTimeTimestamp3]];
//    NSString *sess_str = @"";

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", first_str, sid_str, second_str, sess_str]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0.0]];
    
    
}


- (NSString *)getNowTimeTimestamp3
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970] * 1000];
    return timeSp;
}

- (void)configureLoadUrl:(NSString *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0.0]];
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    
    [self configureContentView];
    
    return self;
}
- (void)configureContentView {
    
    // UI代理
    self.webView.UIDelegate = self;
    // 导航代理
    self.webView.navigationDelegate = self;
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    //创建网页配置对象
    [self addSubview:self.webView];
    
    CGFloat Kwidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat Kheight = UIScreen.mainScreen.bounds.size.height;
    
    self.webView.frame = CGRectMake((Kwidth - 300)/2, (Kheight - 300)/2, 300, 300);
    
//    NSLayoutConstraint * web_height = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:SCALE_WIDTHS(300)];
//    NSLayoutConstraint * web_width = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:SCALE_WIDTHS(300)];
//
//    NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
//    NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
//
//    [NSLayoutConstraint activateConstraints:@[web_height,web_width,centerY,centerX]];
    
//    [self.webView addConstraints:];
    
    [self addSubview:self.closeBtn];
    
    self.closeBtn.frame = CGRectMake(Kwidth/2 - 25 , CGRectGetMaxY(self.webView.frame) + 20, 50, 50);
    
//    NSLayoutConstraint * btn_height = [NSLayoutConstraint constraintWithItem:self.closeBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:SCALE_WIDTHS(50)];
//    NSLayoutConstraint * btn_width = [NSLayoutConstraint constraintWithItem:self.closeBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:SCALE_WIDTHS(50)];
//
//    NSLayoutConstraint * btn_top = [NSLayoutConstraint constraintWithItem:self.closeBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.webView attribute:NSLayoutAttributeBottom multiplier:1 constant:SCALE_HEIGTHS(35.0)];
//    NSLayoutConstraint * btn_cenY = [NSLayoutConstraint constraintWithItem:self.closeBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.webView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
//    [NSLayoutConstraint activateConstraints:@[btn_top,btn_width,btn_height,btn_cenY]];
//    [self.closeBtn addConstraints:@[btn_top,btn_width,btn_height,btn_cenY]];
    

    
}

#pragma mark -- WKUIDelegate

// 显示一个按钮。点击后调用completionHandler回调
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//
//    if (message.length != 0 && [message containsString:@"###"]) {
//        NSArray *arr = [message componentsSeparatedByString:@"###"];
//        if (self.tickerAndRandstrBlock) {
//            self.tickerAndRandstrBlock(arr[1], arr[0]);
//        }
//    }
//
//    completionHandler();
//
//}


// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
 // 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
 
}
 // 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
 // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSLog(@"userAgent :%@", result);
    }];
}
 //提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
 
}
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
}
 // 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
 
    decisionHandler(WKNavigationActionPolicyAllow);
}
 
 // 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (WKWebView *)webView {
    if (!_webView) {
        
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        DFSuspendURLSchemeHandler *handler = [DFSuspendURLSchemeHandler new];
        
        //支持https和http的方法1  这个需要去hook +[WKwebview handlesURLScheme]的方法,可以去看WKWebView+Custome类的实现
        if (@available(iOS 11.0, *)) {
            [config setURLSchemeHandler:handler forURLScheme:@"https"];
        } else {
            // Fallback on earlier versions
        }
        if (@available(iOS 11.0, *)) {
            [config setURLSchemeHandler:handler forURLScheme:@"http"];
        } else {
            // Fallback on earlier versions
        }
        
        //拦截请求回调的参数
        __weak typeof(self) weakSelf = self;
        handler.handlerTickerAndRandstrBlock = ^(NSString * _Nonnull ticket, NSString * _Nonnull randstr) {
            
            [weakSelf mainThreadCallBack:^{
                
                if (weakSelf.tickerAndRandstrBlock) {
                    weakSelf.tickerAndRandstrBlock(ticket, randstr);
                }
            }];
        };
        
        handler.handlerResultBlock = ^(NSString * _Nonnull result) {
            
            [weakSelf mainThreadCallBack:^{
                
                if (weakSelf.jsonResultBlock) {
                    
                    weakSelf.jsonResultBlock(result);
                };
            }];
        };
        

        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
//        _webView.customUserAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Mobile/15E148 Safari/604.1";
        _webView.backgroundColor = [UIColor redColor];
    }
    return _webView;
}

-(void)mainThreadCallBack:(void(^)(void))block{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        block();
    });
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.adjustsImageWhenHighlighted = NO;
        [_closeBtn setImage:[UIImage imageNamed:@"sw_paypsd_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
