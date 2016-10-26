//
//  HomeViewController.m
//  HomeWork
//
//  Created by 博云智慧 on 16/10/20.
//  Copyright © 2016年 博云智慧. All rights reserved.
//

#import "HomeVC.h"

#import "HomeView.h"

#import "OnLineVC.h"

@interface HomeVC ()

@property (nonatomic, strong) HomeView *mainView;

@end

@implementation HomeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self bindMainView];
    
}
- (void) bindMainView {
    
    self.view = self.mainView;
    
     @weakify(self);
    
    [self.mainView.pushOnLineVCSubject subscribeNext:^(id x) {
     
    @strongify(self);
        
    [self.navigationController pushViewController:[OnLineVC alloc] animated:YES];
        
    }];
    
}
#pragma mark ----------lazyLoad----------
- (HomeView *)mainView {
    
    if (_mainView == nil) {
        
        _mainView = [HomeView viewFromNIB];
        
        _mainView.VC = self;
       
    }
    return _mainView;
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
