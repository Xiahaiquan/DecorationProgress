//
//  HomeView.h
//  HomeWork
//
//  Created by 博云智慧 on 16/10/20.
//  Copyright © 2016年 博云智慧. All rights reserved.
//

#import "BaseView.h"

@interface HomeView : BaseView

@property (nonatomic, strong) RACSubject *pushOnLineVCSubject;

@property (nonatomic, strong) UIViewController *VC;

+ (instancetype) viewFromNIB;

@end
