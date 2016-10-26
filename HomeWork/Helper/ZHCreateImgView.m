//
//  ZHCreateImgView.m
//  HomeWork
//
//  Created by 博云智慧 on 16/10/21.
//  Copyright © 2016年 博云智慧. All rights reserved.
//

#import "ZHCreateImgView.h"

@implementation ZHCreateImgView

+ (UIWebView *)createWebViewWithUrlStr:(NSString *)urlStr {
    
   UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
   
    [webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlStr]]];
    
    webView.scalesPageToFit = YES;
    
    webView.alpha = .0f;

    return webView;
    
}

+ (UIView *) createForeground {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    
    view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
    
    return view;
}

+ (UIImageView *)createImageViewWith:(NSString *)stringName tag:(NSInteger)tag {
    
    UIImageView *bagImg = [[UIImageView alloc]init];
    
    bagImg.tag = tag;
    
    bagImg.userInteractionEnabled = YES;
    
    bagImg.image = [UIImage imageNamed:@"head_3"];
    
    UILabel *label = [[UILabel alloc]init];
    
    label.text = stringName;
    
    label.textColor = [UIColor whiteColor];
    
    [bagImg addSubview:label];
    
   ZHWeakObject(bagImg)
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakObject);
    }];
    
    return bagImg;
}

+ (UIImageView *)createRefreshImageView {
    
    UIImageView *bagImg = [[UIImageView alloc]init];
    
    bagImg.userInteractionEnabled = YES;
    
    bagImg.backgroundColor = [UIColor yellowColor];
    
    bagImg.frame = CGRectMake(0, 0, 40, 40);
    
    bagImg.image = [UIImage imageNamed:@"head_3"];
    
    bagImg.layer.cornerRadius = 45.f;
    
    bagImg.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc]init];
    
    label.text = @"刷新";
    
    label.textColor = [UIColor blackColor];
    
    [bagImg addSubview:label];
    
    ZHWeakObject(bagImg)
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakObject);
    }];
    
    return bagImg;
}
@end
