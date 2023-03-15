//
//  DFNavigationBar.m
//  zuhaowan
//
//  Created by chenhui on 2018/3/22.
//  Copyright © 2018年 chenhui. All rights reserved.
//

#import "DFNavigationBar.h"
#import "Masonry.h"
#import "UIButton+Alignment.h"
#import "UIButton+WebCache.h"


@interface DFNavigationBar ()<UITextFieldDelegate>

@property(nonatomic, strong) UILabel *lineLabel;
@property(nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *searchBtn;

@end

@implementation DFNavigationBar

- (instancetype)initWithBackModel:(DFNavigationModel *)backModel
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, StatueHeight + NAVBASE_HEIGHT)];
    if (self) {
        self.navModel = backModel;
        [self configureNavView];
    }
    return self;
}

- (UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [UILabel new];
        _lineLabel.backgroundColor = OX_COLOR(0xcccccc);
    }
    return _lineLabel;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.contentMode = UIViewContentModeCenter;
        _leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _leftBtn.adjustsImageWhenHighlighted = NO;
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.contentMode = UIViewContentModeCenter;
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _rightBtn.adjustsImageWhenHighlighted = NO;
    }
    return _rightBtn;
}

- (UIButton *)rightFirstBtn
{
    if (!_rightFirstBtn) {
        _rightFirstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         _rightFirstBtn.contentMode = UIViewContentModeCenter;
    }
    return _rightFirstBtn;
}

- (UIButton *)rightSecondBtn
{
    if (!_rightSecondBtn) {
        _rightSecondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         _rightSecondBtn.contentMode = UIViewContentModeCenter;
    }
    return _rightSecondBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
       // _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = OX_COLOR(0xffffff);
        _bgView.layer.borderColor = OX_COLOR(0xf0f0f0).CGColor;
        _bgView.layer.borderWidth = 1.0f;
        _bgView.layer.cornerRadius = 4.0f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setImage:[UIImage imageNamed:@"seach"] forState:UIControlStateNormal];
    }
    return _searchBtn;
}

- (UITextField *)searchTF
{
    if (!_searchTF) {
        _searchTF = [UITextField new];
        _searchTF.delegate = self;
        _searchTF.font = [UIFont systemFontOfSize:14.0f];
        _searchTF.borderStyle = UITextBorderStyleNone;
    }
    return _searchTF;
}

- (void)setIsHiddenRigheBtn:(BOOL)isHiddenRigheBtn
{
    _isHiddenRigheBtn = isHiddenRigheBtn;
    if (isHiddenRigheBtn) {
        self.rightBtn.hidden = YES;
    }
}

- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    self.titleLabel.text = navTitle;
}


- (void)configureNavView
{
    self.backgroundColor = self.navModel.bgColor ? self.navModel.bgColor : OX_COLOR(0xFFFFFF);
    [self addSubview:self.lineLabel];
    self.lineLabel.hidden = self.navModel.showLineLabel;
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(LEFT_MARGIN);
        make.top.mas_equalTo(self.mas_top).offset(StatueHeight + 8.0f);
        make.size.mas_equalTo(self.navModel.leftBtnSize);
        if (self.navModel.leftBtnTitle.length != 0) {
            [self.leftBtn setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:8.0f];
        }
    }];
    if (!self.navModel.showRounded) {
        [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15.0f)];
    }else {
        [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0.0)];
    }
    
    [self.leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.navModel.leftBtnImage.length != 0) {
        if ([self.navModel.leftBtnImage containsString:@"https://"] || [self.navModel.leftBtnImage containsString:@"http://"]) {
            [self.leftBtn sd_setImageWithURL:[NSURL URLWithString:self.navModel.leftBtnImage] forState:UIControlStateNormal];
        }else {
            [self.leftBtn setImage:[UIImage imageNamed:self.navModel.leftBtnImage] forState:UIControlStateNormal];
        }
    }
    self.leftBtn.titleLabel.font = self.navModel.leftBtnFont == 0 ? [UIFont systemFontOfSize:15.0f] : [UIFont systemFontOfSize:self.navModel.leftBtnFont];
    if (self.navModel.leftBtnTitleColor) {
        [self.leftBtn setTitleColor:self.navModel.leftBtnTitleColor forState:UIControlStateNormal];
    }else {
        [self.leftBtn setTitleColor:OX_COLOR(0x333333) forState:UIControlStateNormal];
    }
    
    if (self.navModel.leftBtnTitle.length != 0) {
        [self.leftBtn setTitle:self.navModel.leftBtnTitle forState:UIControlStateNormal];
    }
    self.leftBtn.hidden = self.navModel.showLeftBtn;
    
    [self addSubview:self.rightBtn];
    self.rightBtn.hidden = self.navModel.showRightBtn;
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self.navModel.navTitle isEqualToString:@"刀锋互娱客服"] || [self.navModel.navTitle isEqualToString:@"login"]) {
            make.right.mas_equalTo(self.mas_right).offset(0.0f);
        }else {
            make.right.mas_equalTo(self.mas_right).offset(-LEFT_MARGIN);
        }
        if ([self.navModel.navTitle isEqualToString:@"login"]) {
            make.top.mas_equalTo(self.mas_top).offset(0.0f);
        }else {
            make.top.mas_equalTo(self.mas_top).offset(StatueHeight + 7.0f);
        }
        make.size.mas_equalTo(self.navModel.rightBtnSize);
    }];
    [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.navModel.rightBtnImage.length != 0) {
        [self.rightBtn setImage:[UIImage imageNamed:self.navModel.rightBtnImage] forState:UIControlStateNormal];
    }
    self.rightBtn.titleLabel.font = self.navModel.rightBtnFont == 0 ? [UIFont systemFontOfSize:15.0f] : [UIFont systemFontOfSize:self.navModel.rightBtnFont];
    if (self.navModel.rightBtnTitleColor) {
        [self.rightBtn setTitleColor:self.navModel.rightBtnTitleColor forState:UIControlStateNormal];
    }else {
        [self.rightBtn setTitleColor:OX_COLOR(0x333333) forState:UIControlStateNormal];
    }
    
    if (self.navModel.rightBtnTitle.length != 0) {
        [self.rightBtn setTitle:self.navModel.rightBtnTitle forState:UIControlStateNormal];
    }
    
    if(self.navModel.showFirstSecondRightBtn){
        self.rightBtn.hidden =YES;
        [self addSubview:self.rightFirstBtn];
        [self addSubview:self.rightSecondBtn];
        [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.top.mas_equalTo(self.mas_top).offset(StatueHeight + 8.0f);
            make.size.mas_equalTo(self.navModel.leftBtnSize);
            [self.leftBtn setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:8.0f];
        }];
        [self.rightFirstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-30.0f);
            make.top.mas_equalTo(self.mas_top).offset(StatueHeight + 10.0f);
            make.size.mas_equalTo(self.navModel.rightFirstBtnSize);
        }];
        [self.rightSecondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-95.0f);
            make.top.mas_equalTo(self.mas_top).offset(StatueHeight + 10.0f);
            make.size.mas_equalTo(self.navModel.rightSecondBtnSize);
        }];
        [self.rightFirstBtn addTarget:self action:@selector(rightFirstBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.navModel.rightFirstBtnImage.length != 0) {
            [self.rightFirstBtn setBackgroundImage:[UIImage imageNamed:self.navModel.rightFirstBtnImage] forState:UIControlStateNormal];
        }
        [self.rightSecondBtn addTarget:self action:@selector(rightSecondBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.navModel.rightSecondBtnImage.length != 0) {
            [self.rightSecondBtn setBackgroundImage:[UIImage imageNamed:self.navModel.rightSecondBtnImage] forState:UIControlStateNormal];
        }
    }
    
    [self addSubview:self.titleLabel];
    self.titleLabel.backgroundColor = self.navModel.bgColor ? self.navModel.bgColor : OX_COLOR(0xffffff);
    self.titleLabel.text = self.navModel.navTitle.length == 0 ? @"" : self.navModel.navTitle;
    self.titleLabel.hidden = self.navModel.navTitle.length == 0 ? YES : [self.navModel.navTitle isEqualToString:@"login"] ? YES : NO;
    self.titleLabel.textColor = self.navModel.navTitleColor ? self.navModel.navTitleColor : OX_COLOR(0x333333);
    self.titleLabel.font = self.navModel.navTitleFont == 0 ? DFFont(18.0f, FONT_TYPE_BOLD) : DFFont(self.navModel.navTitleFont, FONT_TYPE_BOLD);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(StatueHeight + 9);
        make.left.mas_equalTo(self.mas_left).offset(110.0f);
        make.right.mas_equalTo(self.mas_right).offset(-110.0f);
        make.height.mas_equalTo(24.0f);
    }];
    
    [self addSubview:self.bgView];
    self.bgView.hidden = self.navModel.placehoderStr.length == 0 ? YES : NO;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(StatueHeight + 9);
        make.left.mas_equalTo(self.leftBtn.mas_right).offset(CGRectGetWidth(self.leftBtn.frame) + 10.0f);
        make.height.mas_equalTo(32.0f);
        if (self.navModel.showRightBtn) {
            make.right.mas_equalTo(self.mas_right).offset(-10.0f);
        }else {
            make.right.mas_equalTo(self.rightBtn.mas_left).offset(-10.0f);
        }
    }];
    
    [self addSubview:self.searchBtn];
    self.searchBtn.hidden = self.navModel.placehoderStr.length == 0 ? YES : NO;
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-10.0f);
        make.top.mas_equalTo(self.bgView.mas_top).offset(0.0);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(0.0);
        make.width.mas_equalTo(26.0f);
    }];
    [self.searchBtn addTarget:self action:@selector(clickToSearch) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.searchTF];
    if (self.navModel.placehoderStr.length != 0) {
        self.searchTF.placeholder = self.navModel.placehoderStr;
    }
    self.searchTF.hidden = self.navModel.placehoderStr.length == 0 ? YES : NO;
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.searchBtn.mas_left).offset(0.0f);
        make.left.mas_equalTo(self.bgView.mas_left).offset(3.0f);
        make.top.bottom.mas_equalTo(self.bgView);
    }];
    [self.searchTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setLeftBtnImageStr:(NSString *)leftBtnImageStr
{
    _leftBtnImageStr = leftBtnImageStr;
    if ([leftBtnImageStr containsString:@"https://"] || [leftBtnImageStr containsString:@"http://"]) {
        [self.leftBtn sd_setImageWithURL:[NSURL URLWithString:leftBtnImageStr] forState:UIControlStateNormal];
    }else {
        [self.leftBtn setImage:[UIImage imageNamed:leftBtnImageStr] forState:UIControlStateNormal];
    }
}

- (void)setRightBtnImageStr:(NSString *)rightBtnImageStr
{
    _rightBtnImageStr = rightBtnImageStr;
    if ([rightBtnImageStr containsString:@"https://"] || [rightBtnImageStr containsString:@"http://"]) {
        [self.rightBtn sd_setImageWithURL:[NSURL URLWithString:rightBtnImageStr] forState:UIControlStateNormal];
    }else {
        [self.rightBtn setImage:[UIImage imageNamed:rightBtnImageStr] forState:UIControlStateNormal];
    }
}

- (void)setShowCorain:(BOOL)showCorain
{
    _showCorain = showCorain;
    if (showCorain) {
        self.leftBtn.layer.cornerRadius = 16.0f;
        self.leftBtn.layer.masksToBounds = YES;
    }
}


#pragma mark - leftBtnAction:
- (void)leftBtnAction:(UIButton *)sender
{
    if (self.leftActionBlock) {
        self.leftActionBlock();
    }
}

#pragma mark - rightBtnAction:
- (void)rightBtnAction:(UIButton *)sender
{
    if (self.rightActionBlock) {
        self.rightActionBlock();
    }
}

#pragma mark - rightBtnAction:
- (void)rightFirstBtnAction:(UIButton *)sender
{
    if (self.rightFirstActionBlock) {
        self.rightFirstActionBlock();
    }
}

#pragma mark - rightBtnAction:
- (void)rightSecondBtnAction:(UIButton *)sender
{
    if (self.rightSecondActionBlock) {
        self.rightSecondActionBlock();
    }
}

#pragma mark - clickToSearch
- (void)clickToSearch
{
    [self endEditing:YES];
    [self.searchTF resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - 开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.searchBeginBlock) {
        self.searchBeginBlock(self.searchTF, self);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    /**搜索框结束编辑**/
    /**触发搜索事件**/
    if (self.searchBlock) {
        self.searchBlock(textField.text);
    }
}

-(void)textFieldTextChange:(UITextField *)theTextField
{
    if (self.searchEditingBlock) {
        self.searchEditingBlock(theTextField.text);
    }
}

@end
