//
//  OfflinePackageController.h
//  OfflinePackage
//
//  Created by 刘思源 on 2022/11/30.
//

#import <UIKit/UIKit.h>
#import "KKJSBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface OfflinePackageController : UIViewController

@property (nonatomic, strong) KKWebView *webView;

@property (nonatomic, assign) BOOL hasTitleBar;

@property (nonatomic, assign) BOOL hasStatusBar;

@property (nonatomic, strong) NSString *titleFromURL;


@property (nonatomic, strong) void (^didFinishNavigation)(void);

+ (instancetype)controllerWithPackageId:(NSString *)packageId;

- (instancetype)initWithUrl:(NSString *)url;

- (instancetype)initWithPackageId:(NSString *)packageId;


+ (NSString *)decoderUrlEncodeStr: (NSString *) input;

+ (NSString *)urlEncodeStr:(NSString *)input;

- (id <KKJSBridgeModule>)getModuleOfName:(NSString *)moduleName;

+ (void)prepareWebView;


@end

NS_ASSUME_NONNULL_END
