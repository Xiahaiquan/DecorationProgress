//
//  OnLineVC.m
//  HomeWork
//
//  Created by 博云智慧 on 16/10/20.
//  Copyright © 2016年 博云智慧. All rights reserved.
//

#import "OnLineVC.h"

#import "OnLineView.h"

@interface OnLineVC ()

@property (nonatomic, strong) OnLineView *mainView;

@end

@implementation OnLineVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self bindMainView];
    
}
- (void) bindMainView {
    
    self.view = self.mainView;
    
    @weakify(self);
    
    [self.mainView.popSubject subscribeNext:^(id x) {
        
         @strongify(self);
        
       [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}

#pragma mark ----------lazyLoad----------

- (OnLineView *)mainView {
    
    if (_mainView == nil) {
        
        _mainView = [[OnLineView alloc]initWithFrame:self.view.frame];
        
    }
    return _mainView;
}


@end
