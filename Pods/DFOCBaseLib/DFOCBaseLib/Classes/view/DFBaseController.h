//
//  DFBaseController.h
//  zuhaowan
//
//  Created by chenhui on 2018/3/21.
//  Copyright © 2018年 chenhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFNavigationBar.h"
#import "DFNavigationModel.h"

@interface DFBaseController : UIViewController

@property (nonatomic, strong) DFNavigationModel *navModel;
@property (nonatomic, strong) DFNavigationBar *navBar;

- (void)df_CustomeSubClassNav;

- (void)configureContent;

@end
