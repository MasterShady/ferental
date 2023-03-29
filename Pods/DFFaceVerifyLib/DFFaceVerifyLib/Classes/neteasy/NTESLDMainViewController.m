//
//  NTESLDMainViewController.m
//  NTESLiveDetectPublicDemo
//
//  Created by Ke Xu on 2019/10/11.
//  Copyright © 2019 Ke Xu. All rights reserved.
//

#import "NTESLDMainViewController.h"
#import <NTESLiveDetect/NTESLiveDetect.h>
#import "NTESLiveDetectView.h"
#import "LDDemoDefines.h"
#import "NTESTimeoutToastView.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "DFFaceVerifyManager.h"
#import "DFNavigationBar.h"
#import "DFNavigationModel.h"

#import "ApproveAlertView.h"
#import <Masonry/Masonry.h>
#import "DFFileUtil.h"
static NSOperationQueue *_queue;

@interface NTESLDMainViewController () <NTESLiveDetectViewDelegate, NTESTimeoutToastViewDelegate>

@property (nonatomic, strong) NTESLiveDetectView *mainView;

@property (nonatomic, strong) NTESLiveDetectManager *detector;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) DFNavigationModel *navModel;
@property (nonatomic, strong) DFNavigationBar *navBar;



/** 弹出视图 */
@property (nonatomic,strong) ApproveAlertView *alertView;
/**
 屏幕亮度值
 */
@property (nonatomic, assign) CGFloat value;

@end

@implementation NTESLDMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self df_CustomeSubClassNav];
    [self replyLoading];
     
}
- (void)df_CustomeSubClassNav {
    self.navModel = [DFNavigationModel new];
    self.navModel.showLineLabel = YES;
    self.navModel.leftBtnImage = @"left_back";
    self.navModel.leftBtnSize = CGSizeMake(32.0f, 32.0f);
    self.navBar = [[DFNavigationBar alloc] initWithBackModel:self.navModel];
    [self.view addSubview:self.navBar];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.navBar.leftBtn setImage:[DFFileUtil imageWithName:@"left_back" withBundleName:DFPublicSourceBundle] forState:UIControlStateNormal];
    
    @WeakObj(self);
    
    DFFaceVerifyItem * item = [DFFaceVerifyManager shareManager].currentItem;
    self.navBar.leftActionBlock = ^{
       
        [selfWeak.view addSubview:selfWeak.alertView];
        [selfWeak.alertView setBtnActionBlock:^(NSInteger type) {
            
            if (type == 1) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                if (item.purpose == 4) {
                    
                    [NSNOTIFICATIONCENTER postNotificationName:@"DF_NOTIFICATION_LOGINFACE_IGNORE" object:nil userInfo:@{@"type":@(2)}];
                }
            }
                
                
            
        }];

    };
    
   
}

- (ApproveAlertView *)alertView {
    if (!_alertView) {
        _alertView = [ApproveAlertView new];
        _alertView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _alertView.backgroundColor = [UIColor clearColor];
    }
    return _alertView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIScreen mainScreen] setBrightness:self.value];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.detector stopLiveDetect];
     if (self.mainView.timer) {
         [self.mainView.timer invalidate];
     }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    
}

- (void)__initDetectorView {
    self.view.backgroundColor = UIColor.whiteColor;
    self.mainView = [[NTESLiveDetectView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT + StatueHeight);
    }];
    self.mainView.LDViewDelegate = self;
    
}

- (void)__initDetector {
    self.detector = [[NTESLiveDetectManager alloc] initWithImageView:self.mainView.cameraImage withDetectSensit:NTESSensitNormal];
    [self startLiveDetect];
//
    CGFloat brightness = [UIScreen mainScreen].brightness;
    self.value = brightness;
//    [self compareCurrentBrightness:brightness];
    [UIScreen mainScreen].brightness = 0.8;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDetectStatusChange:) name:@"NTESLDNotificationStatusChange" object:nil];
    // 监控app进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDefaultBrightness:) name:UIScreenBrightnessDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}
//
-(void)willResignActive {
    [UIScreen mainScreen].brightness = self.value;
}

- (void)didBecomeActive {
    [UIScreen mainScreen].brightness = 0.8;
}

- (void)saveDefaultBrightness:(NSNotification *)notification {
    CGFloat brightness = [UIScreen mainScreen].brightness;
    [self compareCurrentBrightness:brightness];

}

- (void)compareCurrentBrightness:(CGFloat)brightness {
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",brightness]];
     NSDecimalNumberHandler *numHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
     NSString *str1 = [[num1 decimalNumberByRoundingAccordingToBehavior:numHandler] stringValue];
     if (![str1 isEqualToString:@"0.8"]) {
       self.value = [UIScreen mainScreen].brightness;
     } else {
         
     }
}

- (void)startLiveDetect {
    [self.mainView.activityIndicator startAnimating];
    [self.detector setTimeoutInterval:20];
    NSString *version = [self.detector getSDKVersion];
    NSLog(@"=======%@",version);
    __weak __typeof(self)weakSelf = self;
    [self.detector startLiveDetectWithBusinessID:[DFFaceVerifyManager shareManager].busnissId actionsHandler:^(NSDictionary * _Nonnull params) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.mainView.activityIndicator stopAnimating];
            NSString *actions = [params objectForKey:@"actions"];
            if (actions && actions.length != 0) {
                
                [weakSelf.mainView showActionTips:actions];
                NSLog(@"动作序列：%@", actions);
            } else {
                [weakSelf showToastWithQuickPassMsg:@"返回动作序列为空"];
            }
        });
    } checkingHandler:^{
        weakSelf.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        weakSelf.hud.mode = MBProgressHUDModeAnnularDeterminate;
        weakSelf.hud.label.text = @"图片正在进行云端检测。。。";
        [weakSelf.hud showAnimated:YES];
    } completionHandler:^(NTESLDStatus status, NSDictionary * _Nullable params) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.params = params;
            [weakSelf showToastWithLiveDetectStatus:status];
        });
    }];
}

-  (void)applicationEnterBackground {
    [self stopLiveDetect];
}

- (void)stopLiveDetect {
    [self.detector stopLiveDetect];
}

- (void)liveDetectStatusChange:(NSNotification *)infoNotification {
//    NSDictionary *infoDict = [infoNotification.userInfo objectForKey:@"info"];
    [self.mainView changeTipStatus:infoNotification.userInfo];
}

- (void)showToastWithLiveDetectStatus:(NTESLDStatus)status {
    [self.hud hideAnimated:YES];
    NSString *msg = @"";
   
    NSString *token;
    if ([self.params isKindOfClass:[NSDictionary class]]) {
        token = [self.params objectForKey:@"token"];
    }
    
    switch (status) {
        case NTESLDCheckPass:
        {
          //成功
            [self uploadWithToken:token];
        }
            break;
        case NTESLDCheckNotPass:
            //未通过
            
            break;
        case NTESLDOperationTimeout:
        {
            msg = @"动作检测超时\n请在规定时间内完成动作";
            NTESTimeoutToastView *toastView = [[NTESTimeoutToastView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            toastView.delegate = self;
            [toastView show];
        }
            break;
        case NTESLDGetConfTimeout:
            
            break;
        case NTESLDOnlineCheckTimeout:
           
            break;
        case NTESLDOnlineUploadFailure:
           
            break;
        case NTESLDNonGateway:
          
            break;
        case NTESLDSDKError:
           
            break;
        case NTESLDCameraNotAvailable:
            [self showcamaraAlertView];
            
            break;
        default:
            
            break;
    }
    if (status == NTESLDGetConfTimeout || status == NTESLDNonGateway ||status == NTESLDCameraNotAvailable) {
        [self showToastWithQuickPassMsg:msg];
    }
}

- (void)showToastWithQuickPassMsg:(NSString *)msg {
    
    if (msg.length == 0) {
        
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeAnnularDeterminate;
        self.hud.label.text = msg;
        [self.hud showAnimated:YES];
    });
}

- (void)dealloc {
    NSLog(@"-----dealloc");
}

-(void)showcamaraAlertView{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iphone的“设置-刀锋互娱”选项中，允许使用相机权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"知道啦");
        }];
        UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        }];
        [alert addAction:action];
        [alert addAction:action2];
        UIViewController* fatherViewController = weakSelf.presentingViewController;
        if (fatherViewController != nil) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                [fatherViewController presentViewController:alert animated:YES completion:nil];
            }];
        }else{
            [weakSelf presentViewController:alert animated:true completion:nil];
        }
       
    });
}

#pragma mark - view delegate
- (void)backBarButtonPressed {
   
    
    [[DFFaceVerifyManager shareManager] closeAllPage];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//
//
//        DFFaceVerifyItem * item = [DFFaceVerifyManager shareManager].currentItem;
//
//        if (item.purpose == 4) {
//
//            [NSNOTIFICATIONCENTER postNotificationName:@"DF_NOTIFICATION_LOGINFACE_IGNORE" object:nil userInfo:@{@"type":@(2)}];
//        }
//    });
}

#pragma mark - NTESTimeoutToastViewDelegate
- (void)retryButtonDidTipped:(UIButton *)sender {
    [self replyLoading];
}

- (void)replyLoading {
    [self stopLiveDetect];
    if (self.mainView) {
        [self.mainView removeFromSuperview];
    }
    self.mainView = nil;
    self.detector = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self __initDetectorView];
    [self __initDetector];
}

- (void)backHomePageButtonDidTipped:(UIButton *)sender {
    
    
    
    [self backBarButtonPressed];
}



#pragma mark - **************** 上传图片 ****************
- (void)uploadWithToken:(NSString *)token {

    DFFaceVerifyItem * item = [DFFaceVerifyManager shareManager].currentItem;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DF_NOTIFICATION_PUBLIC_FACE_SUCCESS" object:nil userInfo:@{@"token":token,@"item":item}];
    
    
//    [[DFFaceVerifyManager shareManager] closeAllPage];
    
}





@end

