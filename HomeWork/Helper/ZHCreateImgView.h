//
//  ZHCreateImgView.h
//  HomeWork
//
//  Created by 博云智慧 on 16/10/21.
//  Copyright © 2016年 博云智慧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHCreateImgView : NSObject

+ (UIWebView *)createWebViewWithUrlStr:(NSString *)urlStr;

+ (UIView *) createForeground;

+ (UIImageView *) createImageViewWith:(NSString *)stringName tag:(NSInteger)tag;

+ (UIImageView *) createRefreshImageView;

@end
