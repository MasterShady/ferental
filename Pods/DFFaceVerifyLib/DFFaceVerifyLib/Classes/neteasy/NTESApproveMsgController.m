//
//  NTESApproveMsgController.m
//  zuhaowan
//
//  Created by mac on 2021/9/23.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import "NTESApproveMsgController.h"

#import "ApproveAlertView.h"
#import "AgreeAlertView.h"

#import "NTESLDMainViewController.h"
#import "DFFaceVerifyManager.h"
#import <Masonry/Masonry.h>
#import <DFOCBaseLib/OC_Const.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "DFFileUtil.h"
@interface NTESApproveMsgController ()
/** 提示标题 */
@property (nonatomic,strong) UILabel *title_label;

/** 用户信息 */
@property (nonatomic,strong) UILabel *user_info_label;

/** 图片 */
@property (nonatomic,strong) UIImageView *msg_imageview;

/** 提示信息 */
@property (nonatomic,strong) UILabel *msg_label;


/** 认证按钮 */
@property (nonatomic,strong) UIButton *start_btn;



/** 弹出视图 */
@property (nonatomic,strong) ApproveAlertView *alertView;


/** id */
@property (nonatomic,strong) NSNumber *verify_id;

/** 实名 */
@property (nonatomic,copy) NSString *rname;

@property (nonatomic,copy) NSString * tmp_token; //临时token

/** 货架id */
@property (nonatomic,copy) NSString *hid;


/** 类型 */
@property(nonatomic, assign) NSInteger type;//0充值,1下单 ---代码中并无调用 可以忽略

/** 金额 */
@property (nonatomic,copy) NSString *amount;


/** 协议提示按钮 */
@property (nonatomic,strong) UIButton *agree_click_btn;

/** 是否同意协议 */
@property (nonatomic,strong) UIButton *agree_btn;

/** 协议提示语 */
@property (nonatomic,strong) UILabel *agree_msg_label;

/** 人脸采集隐私政策 */
@property (nonatomic,strong) UIButton *face_zc_btn;

/** 身份认证隐私政策 */
@property (nonatomic,strong) UIButton *id_rz_btn;

/** 隐私协议 */
@property (nonatomic,strong) AgreeAlertView *agree_alert_view;
@end

@implementation NTESApproveMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    DFFaceVerifyItem * item = [DFFaceVerifyManager shareManager].currentItem;
    
    if (item.purpose != 0) {
        
        self.user_info_label.text = item.rname;
        self.msg_label.text = @"尊敬的用户，为进一步验证您的身份，防止未成年人沉迷游戏，需完成人脸识别验证";
        self.alertView.msg_label.text = @"退出验证将不能识别您的身份";
    }else{
        
        self.user_info_label.text = [NSString stringWithFormat:@"已认证用户：%@", item.rname];
    }
    
   
}

- (void)setVerify_id:(NSNumber *)verify_id {
    _verify_id = verify_id;
   
}

- (void)setRname:(NSString *)rname {
    _rname = rname;
    self.user_info_label.text = [NSString stringWithFormat:@"已认证用户：%@", rname];
}

- (void)setHid:(NSString *)hid {
    _hid = hid;
}

- (void)setType:(NSInteger)type {
    _type = type;
}

- (void)setAmount:(NSString *)amount {
    _amount = amount;
}

- (void)df_CustomeSubClassNav {
    self.navModel = [DFNavigationModel new];
    self.navModel.showLineLabel = YES;
    self.navModel.leftBtnImage = @"left_back";
    self.navModel.leftBtnSize = CGSizeMake(32.0f, 32.0f);
    self.navBar = [[DFNavigationBar alloc] initWithBackModel:self.navModel];
    [self.view addSubview:self.navBar];
    
    
    [self.navBar.leftBtn setImage:[DFFileUtil imageWithName:@"left_back" withBundleName:DFPublicSourceBundle] forState:UIControlStateNormal];
    
    @WeakObj(self);
    
    DFFaceVerifyItem * item = [DFFaceVerifyManager shareManager].currentItem;
    
    self.navBar.leftActionBlock = ^{
        
        [selfWeak.view addSubview:selfWeak.alertView];
        [selfWeak.alertView setBtnActionBlock:^(NSInteger type) {
            
            if (type == 1) {
                
                [[DFFaceVerifyManager shareManager] closeAllPage];
                
                if (item.purpose == 4) {
                    
                    [NSNOTIFICATIONCENTER postNotificationName:@"DF_NOTIFICATION_LOGINFACE_IGNORE" object:nil userInfo:@{@"type":@(2)}];
                }
            }
                
                
            
        }];

    };
}


/*
 开始认证按钮点击事件
 */
- (void)start_btnAction {
    if (self.agree_btn.selected) {
        NTESLDMainViewController *lvc = [NTESLDMainViewController new];
        [self.navigationController pushViewController:lvc animated:YES];
    }else {
        
       MBProgressHUD * hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       hud.mode = MBProgressHUDModeText;
       hud.label.text = @"请勾选协议";
       [hud showAnimated:true];
        [hud hideAnimated:true afterDelay:1];
    }
}

/*
 是否同意协议按钮点击事件
 */
- (void)agree_btnClickAction:(UIButton *)button {
    self.agree_btn.selected = !self.agree_btn.selected;
}

/*
 人脸离线采集SDK
 */
- (void)face_zc_btnClickAction {
   
    self.agree_alert_view.url = @"https://dun.163.com/clause/privacy";
    
    [self.view addSubview:self.agree_alert_view];
    
    @WeakObj(self);
    self.agree_alert_view.knowBlock = ^{
       
        [selfWeak.agree_alert_view removeFromSuperview];
    };
}

/*
 身份识别SDK
 */
- (void)id_rz_btnClickAction {

}


- (void)configureContent {
    [self.view addSubview:self.title_label];
    [self.view addSubview:self.user_info_label];
    [self.view addSubview:self.msg_imageview];
    [self.view addSubview:self.msg_label];
    [self.view addSubview:self.start_btn];
    
    [self.view addSubview:self.agree_btn];
    [self.view addSubview:self.agree_msg_label];
    [self.view addSubview:self.agree_click_btn];
    [self.view addSubview:self.face_zc_btn];
//    [self.view addSubview:self.id_rz_btn];
    [self myAutoLayout];
}


- (void)myAutoLayout {
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(SCALE_WIDTHS(80.0f));
        make.right.mas_equalTo(self.view.mas_right).offset(SCALE_WIDTHS(-80.0f));
        make.top.mas_equalTo(self.view.mas_top).offset(SCALE_HEIGTHS(47.0f) + NAVBASE_HEIGHT + StatueHeight);
        make.height.mas_equalTo(SCALE_HEIGTHS(20.0f));
    }];
    [self.user_info_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(SCALE_WIDTHS(80.0f));
        make.right.mas_equalTo(self.view.mas_right).offset(SCALE_WIDTHS(-80.0f));
        make.top.mas_equalTo(self.title_label.mas_bottom).offset(SCALE_HEIGTHS(12.0f));
        make.height.mas_equalTo(SCALE_HEIGTHS(15.0f));
    }];
    [self.msg_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(SCALE_WIDTHS(55.0f));
        make.right.mas_equalTo(self.view.mas_right).offset(SCALE_WIDTHS(-55.0f));
        make.top.mas_equalTo(self.user_info_label.mas_bottom).offset(SCALE_HEIGTHS(24.0f));
        make.height.mas_equalTo(SCALE_HEIGTHS(265.0f));
    }];
    [self.msg_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(SCALE_WIDTHS(60.0f));
        make.right.mas_equalTo(self.view.mas_right).offset(SCALE_WIDTHS(-60.0f));
        make.top.mas_equalTo(self.msg_imageview.mas_bottom).offset(SCALE_HEIGTHS(0.0f));
    }];
    [self.start_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(SCALE_WIDTHS(45.0f));
        make.right.mas_equalTo(self.view.mas_right).offset(SCALE_WIDTHS(-45.0f));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(SCALE_HEIGTHS(StatueHeight > 20.0f ? -(124.0f + 34.0f) : -124.0f));
        make.height.mas_equalTo(SCALE_HEIGTHS(47.0f));
    }];
    [self.agree_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(SCALE_WIDTHS(50.0f));
        make.top.mas_equalTo(self.start_btn.mas_bottom).offset(SCALE_HEIGTHS(16.0f));
        make.size.mas_equalTo(CGSizeMake(SCALE_WIDTHS(12.0f), SCALE_WIDTHS(12.0f)));
    }];
    [self.agree_msg_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.agree_btn.mas_right).offset(SCALE_WIDTHS(5.0f));
        make.top.mas_equalTo(self.start_btn.mas_bottom).offset(SCALE_HEIGTHS(12.0f));
        make.right.mas_equalTo(self.view.mas_right).offset(SCALE_WIDTHS(-52.0f));
    }];
    [self.agree_click_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(SCALE_WIDTHS(50.0f));
        make.right.mas_equalTo(self.view.mas_right).offset(SCALE_WIDTHS(-50.0f));
        make.top.mas_equalTo(self.start_btn.mas_bottom).offset(SCALE_HEIGTHS(12.0f));
        make.height.mas_equalTo(self.agree_msg_label.mas_height);
    }];
    [self.face_zc_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(SCALE_HEIGTHS(StatueHeight > 20.0f ? -(36.0f + 34.0f) : -36.0f));
        make.height.mas_equalTo(SCALE_HEIGTHS(30.0f));
    }];
//    [self.id_rz_btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.view.mas_right).offset(SCALE_WIDTHS(-30.0f));
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(SCALE_HEIGTHS(StatueHeight > 20.0f ? -(16.0f + 34.0f) : -16.0f));
//        make.height.mas_equalTo(SCALE_HEIGTHS(30.0f));
//    }];
}


- (UILabel *)title_label {
    if (!_title_label) {
        _title_label = [UILabel new];
        _title_label.textColor = OX_COLOR(0x333333);
        _title_label.font = DFFont(23.0f, FONT_TYPE_MEDIUM);
        _title_label.textAlignment = NSTextAlignmentCenter;
        _title_label.text = @"请确保本人操作";
    }
    return _title_label;
}

- (UILabel *)user_info_label {
    if (!_user_info_label) {
        _user_info_label = [UILabel new];
        _user_info_label.textColor = OX_COLOR(0x333333);
        _user_info_label.font = DFFont(14.0f, FONT_TYPE_REGULAR);
        _user_info_label.textAlignment = NSTextAlignmentCenter;
    }
    return _user_info_label;
}

- (UIImageView *)msg_imageview {
    if (!_msg_imageview) {
        _msg_imageview = [UIImageView new];
        _msg_imageview.image = [DFFileUtil imageWithName:@"approve_msg_icon" withBundleName:DFPublicSourceBundle];
    }
    return _msg_imageview;
}

- (UILabel *)msg_label {
    if (!_msg_label) {
        _msg_label = [UILabel new];
        _msg_label.textColor = OX_COLOR(0xA1A0AB);
        _msg_label.font = DFFont(13.0f, FONT_TYPE_REGULAR);
        _msg_label.textAlignment = NSTextAlignmentCenter;
        _msg_label.numberOfLines = 0;
        _msg_label.text = @"尊敬的用户，您本次付款金额较高，为保障您的账户安全，需先完成身份认证，再继续支付。";
    }
    return _msg_label;
}

- (UIButton *)start_btn {
    if (!_start_btn) {
        _start_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _start_btn.titleLabel.font = DFFont(16.0f, FONT_TYPE_MEDIUM);
        _start_btn.adjustsImageWhenHighlighted = NO;
        [_start_btn setTitle:@"开始认证" forState:UIControlStateNormal];
        [_start_btn setTitleColor:OX_COLOR(0xFFFFFF) forState:UIControlStateNormal];
        [_start_btn setBackgroundImage:[DFFileUtil imageWithName:@"approve_btn_bg" withBundleName:DFPublicSourceBundle] forState:UIControlStateNormal];
        [_start_btn addTarget:self action:@selector(start_btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _start_btn;
}

- (ApproveAlertView *)alertView {
    if (!_alertView) {
        _alertView = [ApproveAlertView new];
        _alertView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _alertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _alertView;
}

- (AgreeAlertView *)agree_alert_view {
    if (!_agree_alert_view) {
        _agree_alert_view = [AgreeAlertView new];
        _agree_alert_view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
       
    }
    return _agree_alert_view;
}

- (UIButton *)agree_btn {
    if (!_agree_btn) {
        _agree_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agree_btn.adjustsImageWhenHighlighted = NO;
        [_agree_btn setBackgroundImage:[DFFileUtil imageWithName:@"no_sel_icon" withBundleName:DFPublicSourceBundle] forState:UIControlStateNormal];
        [_agree_btn setBackgroundImage:[DFFileUtil imageWithName:@"sel_icon" withBundleName:DFPublicSourceBundle] forState:UIControlStateSelected];
    }
    return _agree_btn;
}

- (UILabel *)agree_msg_label {
    if (!_agree_msg_label) {
        _agree_msg_label = [UILabel new];
        _agree_msg_label.textColor = OX_COLOR(0xA1A0AB);
        _agree_msg_label.font = DFFont(12.0f, FONT_TYPE_REGULAR);
        _agree_msg_label.numberOfLines = 0;
        _agree_msg_label.text = @"您同意服务提供者使用并传送相关数据用于身份核验";
    }
    return _agree_msg_label;
}

- (UIButton *)agree_click_btn {
    if (!_agree_click_btn) {
        _agree_click_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agree_click_btn addTarget:self action:@selector(agree_btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agree_click_btn;
}

- (UIButton *)face_zc_btn {
    if (!_face_zc_btn) {
        _face_zc_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _face_zc_btn.titleLabel.font = DFFont(12.0f, FONT_TYPE_REGULAR);
        _face_zc_btn.adjustsImageWhenHighlighted = NO;
        [_face_zc_btn setTitle:@"《网易易盾隐私政策》" forState:UIControlStateNormal];
        [_face_zc_btn setTitleColor:OX_COLOR(0x3186EA) forState:UIControlStateNormal];
        [_face_zc_btn addTarget:self action:@selector(face_zc_btnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _face_zc_btn;
}

- (UIButton *)id_rz_btn {
    if (!_id_rz_btn) {
        _id_rz_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _id_rz_btn.titleLabel.font = DFFont(12.0f, FONT_TYPE_REGULAR);
        _id_rz_btn.adjustsImageWhenHighlighted = NO;
        [_id_rz_btn setTitle:@"《身份识别SDK隐私政策》" forState:UIControlStateNormal];
        [_id_rz_btn setTitleColor:OX_COLOR(0x3186EA) forState:UIControlStateNormal];
        [_id_rz_btn addTarget:self action:@selector(id_rz_btnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _id_rz_btn;
}


- (void)dealloc {
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
