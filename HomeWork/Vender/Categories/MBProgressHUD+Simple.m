//
//  MBProgressHUD+Simple.m
//  EEGSmart
//
//  Created by 李新星 on 15/6/18.
//  Copyright (c) 2015年 深圳创达云睿智能科技有限公司. All rights reserved.
//

#import "MBProgressHUD+Simple.h"
#import <objc/runtime.h>

#import "AppDelegate.h"
@implementation MBProgressHUD (Simple)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    [self hideHUDForView:view];
    
    if (view == nil) view = [AppDelegate appDelegate].window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = text;
    hud.detailsLabelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 2秒之后再消失
    [hud hide:YES afterDelay:2];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showHUDWithMessage:(NSString *)message toView:(UIView *)view {
    [self hideHUDForView:view];
    
    if (view == nil) view = [AppDelegate appDelegate].window;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    if (message == nil) {
        return nil;
    }
    
    if (view == nil) view = [AppDelegate appDelegate].window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置模式
    hud.mode = MBProgressHUDModeText;
    //设置内容
    hud.detailsLabelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];
    
    return hud;
}

+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showHUDWithMessage:(NSString *)message {
    return [self showHUDWithMessage:message toView:nil];
}

+ (MBProgressHUD *)showHUDWithMessageOnly:(NSString *)message {
    UIView *view = [AppDelegate appDelegate].window;
    [self hideHUDForView:view];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    
    [hud hide:YES afterDelay:2];
    
    return hud;
}

+ (void)hideHUDForView:(UIView *)view {
    [self hideHUDForView:view animated:YES];
}

+ (void)hideWindowAllHUD {
    UIView * view = [AppDelegate appDelegate].window;
    [self hideAllHUDsForView:view animated:YES];
}

#pragma mark - swizzling

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method ovr_Method = class_getInstanceMethod([self class], @selector(hide:));
        Method swz_Method = class_getInstanceMethod([self class], @selector(swizzlingHide:));
        method_exchangeImplementations(ovr_Method, swz_Method);
    });
}

- (void)swizzlingHide:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self swizzlingHide:animated];
    });
}

@end
