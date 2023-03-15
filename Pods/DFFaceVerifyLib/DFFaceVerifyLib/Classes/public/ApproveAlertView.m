//
//  ApproveAlertView.m
//  zuhaowan
//
//  Created by mac on 2020/9/15.
//  Copyright © 2020 chenhui. All rights reserved.
//

#import "ApproveAlertView.h"
#import <Masonry/Masonry.h>
#import <DFOCBaseLib/OC_Const.h>
#import "DFFileUtil.h"
@interface ApproveAlertView ()

/** bg_view */
@property (nonatomic,strong) UIView *bg_view;

/** 内容view */
@property (nonatomic,strong) UIView *content_view;

/** 图片 */
@property (nonatomic,strong) UIImageView *image_view;

/** 标题 */
@property (nonatomic,strong) UILabel *title_label;



/** 退出 */
@property (nonatomic,strong) UIButton *quit_btn;


/** 继续验证 */
@property (nonatomic,strong) UIButton *go_btn;


@end


@implementation ApproveAlertView


- (void)quit_btnAction {
    
    [self removeFromSuperview];
    
    if (self.btnActionBlock) {
        self.btnActionBlock(1);
    }
}


- (void)go_btnAction {
    [self removeFromSuperview];
    
    if (self.btnActionBlock) {
        self.btnActionBlock(2);
    }
}


- (void)configureContentView {
    
    
    
    [self addSubview:self.content_view];
    [self addSubview:self.image_view];
    [self.content_view addSubview:self.title_label];
    [self.content_view addSubview:self.msg_label];
    [self.content_view addSubview:self.quit_btn];
    [self.content_view addSubview:self.go_btn];
    [self myAutoLayout];
}


- (void)myAutoLayout {
    [self.content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCALE_WIDTHS(305.0f), SCALE_HEIGTHS(240.0f)));
    }];
    [self.image_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCALE_WIDTHS(181.0f), SCALE_HEIGTHS(68.0f)));
        make.bottom.mas_equalTo(self.content_view.mas_top).offset(SCALE_HEIGTHS(43.0f));
    }];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.content_view.mas_top).offset(SCALE_HEIGTHS(70.0f));
        make.left.mas_equalTo(self.content_view.mas_left).offset(SCALE_WIDTHS(30.0f));
        make.right.mas_equalTo(self.content_view.mas_right).offset(SCALE_WIDTHS(-30.0f));
        make.height.mas_equalTo(SCALE_HEIGTHS(25.0f));
    }];
    [self.msg_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title_label.mas_bottom).offset(SCALE_HEIGTHS(17.0f));
        make.left.mas_equalTo(self.content_view.mas_left).offset(SCALE_WIDTHS(25.0f));
        make.right.mas_equalTo(self.content_view.mas_right).offset(SCALE_WIDTHS(-25.0f));
    }];
    [self.quit_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.content_view.mas_left).offset(SCALE_WIDTHS(25.0f));
        make.bottom.mas_equalTo(self.content_view.mas_bottom).offset(SCALE_HEIGTHS(-20.0f));
        make.size.mas_equalTo(CGSizeMake(SCALE_WIDTHS(119.0f), SCALE_HEIGTHS(44.0f)));
    }];
    [self.go_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.content_view.mas_right).offset(SCALE_WIDTHS(-25.0f));
        make.bottom.mas_equalTo(self.content_view.mas_bottom).offset(SCALE_HEIGTHS(-20.0f));
        make.size.mas_equalTo(CGSizeMake(SCALE_WIDTHS(119.0f), SCALE_HEIGTHS(44.0f)));
    }];
}

- (UIView *)content_view {
    if (!_content_view) {
        _content_view = [UIView new];
        _content_view.backgroundColor = [UIColor whiteColor];
        _content_view.layer.cornerRadius = SCALE_HEIGTHS(15.0f);
        _content_view.layer.masksToBounds = YES;
    }
    return _content_view;
}

- (UIImageView *)image_view {
    if (!_image_view) {
        _image_view = [UIImageView new];
//        _image_view.image = DF_IMG(@"alert_img_icon");
        
        _image_view.image = [DFFileUtil imageWithName:@"alert_img_icon" withBundleName:DFPublicSourceBundle];
    }
    return _image_view;
}

- (UILabel *)title_label {
    if (!_title_label) {
        _title_label = [UILabel new];
        _title_label.font = DFFont(18.0f, FONT_TYPE_BOLD);
        _title_label.textColor = OX_COLOR(0x333333);
        _title_label.textAlignment = NSTextAlignmentCenter;
        _title_label.text = @"请确认是否退出验证流程";
    }
    return _title_label;
}

- (UILabel *)msg_label {
    if (!_msg_label) {
        _msg_label = [UILabel new];
        _msg_label.font = DFFont(14.0f, FONT_TYPE_REGULAR);
        _msg_label.numberOfLines = 0;
        _msg_label.textColor = OX_COLOR(0x333333);
        _msg_label.textAlignment = NSTextAlignmentCenter;
        _msg_label.text = @"退出验证将不能识别您的身份，无法继续充值";
    }
    return _msg_label;
}

- (UIButton *)quit_btn {
    if (!_quit_btn) {
        _quit_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _quit_btn.adjustsImageWhenHighlighted = NO;
        _quit_btn.titleLabel.font = DFFont(15.0f, FONT_TYPE_MEDIUM);
        [_quit_btn setTitle:@"退出" forState:UIControlStateNormal];
        [_quit_btn setTitleColor:OX_COLOR(0x0099FF) forState:UIControlStateNormal];
        _quit_btn.layer.borderColor = OX_COLOR(0x0099FF).CGColor;
        _quit_btn.layer.borderWidth = SCALE_WIDTHS(1.0f);
        _quit_btn.layer.cornerRadius = SCALE_HEIGTHS(22.0f);
        [_quit_btn addTarget:self action:@selector(quit_btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quit_btn;
}

- (UIButton *)go_btn {
    if (!_go_btn) {
        _go_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _go_btn.adjustsImageWhenHighlighted = NO;
        _go_btn.backgroundColor = OX_COLOR(0x0099FF);
        _go_btn.titleLabel.font = DFFont(15.0f, FONT_TYPE_MEDIUM);
        [_go_btn setTitle:@"继续验证" forState:UIControlStateNormal];
        [_go_btn setTitleColor:OX_COLOR(0xFFFFFF) forState:UIControlStateNormal];
        _go_btn.layer.cornerRadius = SCALE_HEIGTHS(22.0f);
        _go_btn.layer.masksToBounds = YES;
        [_go_btn addTarget:self action:@selector(go_btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _go_btn;
}


@end
