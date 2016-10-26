//
//  MBProgressHUD+Simple.h
//  EEGSmart
//
//  Created by 李新星 on 15/6/18.
//  Copyright (c) 2015年 深圳创达云睿智能科技有限公司. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Simple)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showHUDWithMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showHUDWithMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view  hideAfterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showHUDWithMessageOnly:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideWindowAllHUD;

@end
