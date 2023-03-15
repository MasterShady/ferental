//
//  DFBaseController.m
//  zuhaowan
//
//  Created by chenhui on 2018/3/21.
//  Copyright © 2018年 chenhui. All rights reserved.
//

#import "DFBaseController.h"
#import "OC_Const.h"
#import "UIColor+Hex.h"
@interface DFBaseController ()<UIGestureRecognizerDelegate>//侧滑手势



@end

@implementation DFBaseController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
   

 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = OX_COLOR(0xffffff);
    [self df_CustomeSubClassNav];
    [self configureContent];
}

- (void)df_CustomeSubClassNav
{
    
}

- (void)configureContent
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
