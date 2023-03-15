//
//  DFFaceVerifyManager.m
//  zuhaowan
//
//  Created by mac on 2021/9/15.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import "DFFaceVerifyManager.h"






static DFFaceVerifyManager * manager;


@interface DFFaceVerifyManager()
{
    BOOL sdkInit;
}
@property(nonatomic,strong,readwrite)DFFaceVerifyItem * currentItem;

@end

@implementation DFFaceVerifyManager



+(instancetype)shareManager{
    
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DFFaceVerifyManager alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(faceSuccessno:) name:@"DF_NOTIFICATION_PUBLIC_FACE_SUCCESS" object:nil];
        
    });
    
    return  manager;
}



-(void)verifyTaskWith:(DFFaceVerifyItem *)item withTarget:(id<DFFaceVerifyProtocol>)delegate{
    
    self.delegate = delegate;
    
    _currentItem = item;
    
    //打开页面
    
    UIViewController * vc = [[NSClassFromString(@"NTESApproveMsgController") alloc] init];
    
    [self push:vc];
}

-(void)push:(UIViewController*)page{
    
    if (self.delegate.viewController == nil && ![self.delegate isKindOfClass:[UIViewController class]]) {
        
        
        NSLog(@"无法打开页面");
        return;
        
        
    }
    
    if ([self.delegate.viewController isKindOfClass:[UINavigationController class]]) {
        
        [(UINavigationController *)self.delegate.viewController pushViewController:page animated:true];
    }else{
        
        UINavigationController * nv = [[UINavigationController alloc] initWithRootViewController:page];
        nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        if (self.delegate.viewController != nil) {
            
            [self.delegate.viewController presentViewController:nv animated:true completion:nil];
            
        }else{
            
            [(UIViewController *)self.delegate presentViewController:nv animated:true completion:nil];
        }
        
        
    }
    
}

-(void)closeAllPage{
    
    if (self.delegate.viewController == nil) {
        
        
        [((UIViewController *)self.delegate ).presentedViewController dismissViewControllerAnimated:true completion:nil];
        return;
    }
    
    if ([self.delegate.viewController isKindOfClass:[UINavigationController class]]) {
       
       NSArray * array = [(UINavigationController *)self.delegate.viewController viewControllers];
        __block NSUInteger index = 0;
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([obj isKindOfClass:NSClassFromString(@"NTESApproveMsgController")]) {
                
                index = idx;
                
                *stop = YES;
            }
        }];
       
        [(UINavigationController *)self.delegate.viewController popToViewController: array[index - 1] animated:true];
        
       
    }else{
        
        [self.delegate.viewController.presentedViewController dismissViewControllerAnimated: true completion:nil];
    }
}


-(void)faceSuccessno:(NSNotification*)no{
    
    NSDictionary * dic = no.userInfo;
    
    NSString * token = dic[@"token"];
    
    DFFaceVerifyItem * item   = dic[@"item"];
    
    if (item != _currentItem) {
        
        return;
        
    }
    
    [self.delegate DFFaceVerifySuccessWithMsg:token];
    
    [self closeAllPage];
     
    self.currentItem = nil;
    
    self.delegate = nil;
}



@end


@implementation DFFaceVerifyItem




@end
