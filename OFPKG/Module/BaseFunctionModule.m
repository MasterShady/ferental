//
//  BaseFunctionModule.m
//  OfflinePackage
//
//  Created by 刘思源 on 2023/2/7.
//

#import "BaseFunctionModule.h"
#import "ferental-Swift.h"
#import "UIViewController+SYAdd.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface BaseFunctionModule ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) void (^imageCallBack)(NSString *base64Image);

@end

@implementation BaseFunctionModule


+(NSString *)moduleName{
    return @"BaseFunction";
}

+ (BOOL)isSingleton{
    return true;
}

- (void)openQRCode:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *responseData))responseCallback{
    lolm_scan_dfvc *vc = [lolm_scan_dfvc new];
    vc.title = nil;
    @WeakObj(vc)
    vc.lolp_qrcodeOutBlock = ^(NSString * _Nullable string) {
        
        responseCallback(@{
            @"result": string
        });
        [vcWeak.navigationController popViewControllerAnimated:true];
    };
    [UIViewController.getCurrentController.navigationController pushViewController:vc animated:YES];
}


- (void)openURLInWebView:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *responseData))responseCallback{
    NSString *urlString = [params[@"url"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURLComponents *components = [NSURLComponents componentsWithURL:[NSURL URLWithString:urlString] resolvingAgainstBaseURL:NO];
    NSArray *queryItems = [components queryItems];
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *queryItem in queryItems) {
        [queryParams setObject:queryItem.value forKey:queryItem.name];
    }
    
    
    BOOL hasTitleBar = queryParams[@"hasTitleBar"] ? [queryParams[@"hasTitleBar"] boolValue] : true;
    NSString *title = queryParams[@"title"];
    BOOL hasStatusBar = queryParams[@"hasStatusBar"] ? [queryParams[@"hasStatusBar"] boolValue] : false;
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURL *targetUrl = nil;
    if (url.scheme){
        targetUrl = url;
    }else{
        //相对路径加载
        targetUrl = [engine.webView.URL URLByAppendingPathComponent:urlString];
    }
    OfflinePackageController *vc = [[OfflinePackageController alloc] initWithUrl:[targetUrl absoluteString]];
    vc.hasTitleBar = hasTitleBar;
    vc.titleFromURL = title;
    vc.hasStatusBar = hasStatusBar;
    [[UIViewController getCurrentController].navigationController pushViewController:vc animated:true];
    
    NSString *evaluateJsCode = params[@"evaluateJsCode"];
    if ([evaluateJsCode isKindOfClass:[NSString class]]){
        @WeakObj(vc)
        vc.didFinishNavigation = ^{
            if (vcWeak){
                [KKJSBridgeJSExecutor evaluateJavaScript:evaluateJsCode inWebView:vcWeak.webView completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"js 执行失败: %@",error);
                    }
                }];
            }
        };
    }
}


- (void)openURLInBrowser:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *responseData))responseCallback{
    NSString *urlString = params[@"url"];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else{
        NSLog(@"不支持的链接 %@",url);
    }
}


- (void)sendMsgToMainWebView:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *responseData))responseCallback{
    //找到栈中的第一个OfflinePackageController的webview
    __block OfflinePackageController *target = nil;
    [UIViewController.getCurrentController.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:OfflinePackageController.class]){
            target = obj;
            *stop = YES;
        }
    }];
    [target.webView.kk_engine dispatchEvent:@"msgFromOpenedWebView" data:params];
}

- (void)goBack:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *responseData))responseCallback{
    //
    WKWebView *webView = engine.webView;
    if ([webView canGoBack]){
        [webView goBack];
    }else{
        [[UIViewController getCurrentController] popOrDismiss];
    }
}


- (void)popSheet:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *responseData))responseCallback{
    //
    NSString *title = [self replaceEmptyStringWithNil:params[@"title"]];
    NSString *message = [self replaceEmptyStringWithNil:params[@"message"]];
    NSArray <NSString*>* items = params[@"items"];
    NSString *cancelTitle = params[@"cancelTitle"];
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *item in items) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            responseCallback(@{
                @"title":item
            });
        }];
        [vc addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        responseCallback(@{
            @"title":cancelTitle
        });
    }];
    [vc addAction:cancel];
    [[UIViewController getCurrentController] presentViewController:vc animated:YES completion:nil];
}


- (void)popAlert:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSDictionary *responseData))responseCallback{
    //
    NSString *title = [self replaceEmptyStringWithNil:params[@"title"]];
    NSString *message = [self replaceEmptyStringWithNil:params[@"message"]];
    NSArray <NSString*>* items = params[@"items"];
    NSString *cancelTitle = params[@"cancelTitle"];
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (NSString *item in items) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            responseCallback(@{
                @"title":item
            });
        }];
        [vc addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        responseCallback(@{
            @"title":cancelTitle
        });
    }];
    [vc addAction:cancel];
    [[UIViewController getCurrentController] presentViewController:vc animated:YES completion:nil];
}

- (void)pickPhoto:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSString *base64Image))responseCallback{
    [AuthChecker checkPhotoLibraryPermissionWithReusltHandler:^(BOOL result) {
        if (result){
            UIImagePickerController *picker = [UIImagePickerController new];
            picker.mediaTypes = @[(NSString *)kUTTypeImage];
            picker.delegate = self;
            [[UIViewController getCurrentController] presentViewController:picker animated:YES completion:nil];
            self.imageCallBack = responseCallback;
        }else{
            [AuthChecker alertGoSettingsWithTitleWithTitle:@"未获得权限访问您的照片" message:@"请在设置选项中允许访问您的照片"];
        }
    }];

    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImagePNGRepresentation(image);
    NSString *base64Data = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *fullBase64String = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",base64Data];
    !_imageCallBack?:_imageCallBack(fullBase64String);
    _imageCallBack = nil;
}


- (void)takePhoto:(KKJSBridgeEngine *)engine params:(NSDictionary *)params responseCallback:(void (^)(NSString *base64Image))responseCallback{
    [AuthChecker checkCameraPermissionWithReusltHandler:^(BOOL result) {
        if(result){
            UIImagePickerController *picker = [UIImagePickerController new];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = @[(NSString *)kUTTypeImage];
            picker.delegate = self;
            [[UIViewController getCurrentController] presentViewController:picker animated:YES completion:nil];
            self.imageCallBack = responseCallback;
        }else{
            [AuthChecker alertGoSettingsWithTitleWithTitle:@"未获得相机权限" message:@"去设置中进行相机授权"];
        }
    }];
    
    

}


- (id)replaceEmptyStringWithNil:(NSString *)string{
    if ([string isKindOfClass:[NSString class]]){
        if (string.length == 0){
            return nil;
        }
    }
    return nil;
}


@end
