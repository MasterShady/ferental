//
//  DFNavigationBar.h
//  zuhaowan
//
//  Created by chenhui on 2018/3/22.
//  Copyright © 2018年 chenhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFNavigationModel.h"

@class DFNavigationBar;

typedef void(^SearchAction)(NSString *searchText);

typedef void(^SearchBeginAction)(UITextField *textField, DFNavigationBar *navbar);

typedef void(^SearchEditing)(NSString *searchText);

@interface DFNavigationBar : UIView
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, copy) NSString *navTitle;

@property(nonatomic, strong) UITextField *searchTF;
@property(nonatomic, copy) NSString *leftBtnImageStr;
@property(nonatomic, assign) BOOL showCorain;//显示圆角
@property (nonatomic, strong) DFNavigationModel *navModel;

@property(nonatomic, assign) BOOL isHiddenRigheBtn;

@property(nonatomic, copy) NSString *rightBtnImageStr;
@property (nonatomic, strong) UIButton *leftBtn;
@property(nonatomic, copy) dispatch_block_t leftActionBlock;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) dispatch_block_t rightActionBlock;//右侧按钮点击事件

@property (nonatomic, strong) UIButton *rightSecondBtn;
@property(nonatomic, copy) NSString *rightSecondBtnImage;
@property (nonatomic, copy) dispatch_block_t rightSecondActionBlock;//右侧按钮点击事件

@property (nonatomic, strong) UIButton *rightFirstBtn;
@property(nonatomic, copy) NSString *rightFirstBtnImage;
@property (nonatomic, copy) dispatch_block_t rightFirstActionBlock;//右侧按钮点击事件

/**输入框已经开始编辑**/
@property(nonatomic, copy) SearchBeginAction searchBeginBlock;

@property(nonatomic, copy) SearchAction searchBlock;

@property(nonatomic, copy) SearchEditing searchEditingBlock;

- (instancetype)initWithBackModel:(DFNavigationModel *)backModel;










@end
