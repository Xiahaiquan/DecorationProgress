//
//  OnLineView.m
//  HomeWork
//
//  Created by 博云智慧 on 16/10/21.
//  Copyright © 2016年 博云智慧. All rights reserved.
//

#import "OnLineView.h"

#import "ZHCreateImgView.h"

#import "MBProgressHUD+Simple.h"

#define currentSelTag @"currentSelTag"

typedef NS_ENUM(NSUInteger, ImageTag) {
    
    sitTag = 1001,
    
    bedTag,
    
    bathTag,
};

@interface OnLineView  () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *sitWebView;

@property (nonatomic, strong) UIWebView *bedWebView;

@property (nonatomic, strong) UIWebView *bathWebView;

@property (nonatomic, strong) UIImageView *sitImgView;

@property (nonatomic, strong) UIImageView *bedImgView;

@property (nonatomic, strong) UIImageView *bathImgView;

@property (nonatomic, strong) UIImageView *refreshImgView;

@property (nonatomic, strong) UIView *foregroundViewOne;

@property (nonatomic, strong) UIView *foregroundViewTwo;

@property (nonatomic, strong) UIImageView *mainImg;

@property (nonatomic ,strong) UIButton *backBtn;

@end

@implementation OnLineView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        [self setUI];
        
        [self bindBackAction];
    }
    return self;
}
- (void) setUI {
    
    self.backgroundColor = [UIColor blackColor];
    
    [self mainImg];
    
    [self backBtn];
    
    //添加手势
    UITapGestureRecognizer *sitTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshAction:)];
    [self.sitImgView addGestureRecognizer:sitTap];
    
   
    UITapGestureRecognizer *bedTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshAction:)];
    [self.bedImgView addGestureRecognizer:bedTap];

    
    UITapGestureRecognizer *bathTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshAction:)];
    [self.bathImgView addGestureRecognizer:bathTap];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshAction)];
    [self.refreshImgView addGestureRecognizer:tap];
    
}
#pragma mark - ----------Action----------
- (void)bindBackAction {
    
      @weakify(self);
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
      @strongify(self);
        [self.popSubject sendNext:@"popSubject"];
    }];
}
- (void)refreshAction:(UIGestureRecognizer *)gestureRecognizer {
    
   
    NSInteger tag = gestureRecognizer.view.tag;
    
    [kUserDefaults setInteger:tag forKey:currentSelTag];
    
   switch (tag) {
            
        case sitTag:
            
            [self.bedImgView addSubview:self.foregroundViewTwo];
            [self.bathImgView addSubview:self.foregroundViewOne];
           
            break;
            
        case bedTag:
            
            [self.sitImgView addSubview:self.foregroundViewOne];
            [self.bathImgView addSubview:self.foregroundViewTwo];
            
            break;
            
        case bathTag:
            
            [self.sitImgView addSubview:self.foregroundViewOne];
            [self.bedImgView addSubview:self.foregroundViewTwo];
            break;
            
        default:
            
            break;
    }
    
}
//刷新背景
- (void)refreshAction {
    
    NSInteger tag = [[kUserDefaults objectForKey:currentSelTag] integerValue];
    
    if (!tag) {
        tag = sitTag;
    }
    
       switch (tag) {
               
        case sitTag:
            
               [self.sitWebView reload];

            break;
        case bedTag:
               
               [self.bedWebView reload];
            
            break;
        case bathTag:
               
               [self.bathWebView reload];

            break;
        default:
            break;
    }

   
    [MBProgressHUD showHUDWithMessage:@"正在加载" toView:self];
}
#pragma mark ----------webViewDelegate----------
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
    [MBProgressHUD hideHUDForView:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //js对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    NSMutableArray *mUrlArray;
    //调用js方法
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];
    
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
    mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    
    if (mUrlArray.count >= 2) {
        
        [mUrlArray removeLastObject];
    }
    

    NSMutableArray *newArr = [NSMutableArray array];
    //快速遍历数组，取出相应的图片组成数组
    [mUrlArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *listStr = (NSString *)obj;
        
        NSString *lastStr = [[listStr componentsSeparatedByString:@"."]lastObject];
        
        if ([lastStr isEqualToString:@"jpg"]) {
            
            [newArr addObject:listStr];
        }
        
    }];
    
    [self changeImgeWith:newArr];
}

- (void)changeImgeWith:(NSMutableArray *)allArray {
    
    NSInteger tag = [[kUserDefaults objectForKey:currentSelTag] integerValue];
    
    if(!allArray.count) {
        
        return;
    }
    
    NSInteger num =  arc4random()  % ( allArray.count );
    
    NSURL *ImgUrl = (NSURL *) allArray[num];
    
  [self.mainImg sd_setImageWithURL:ImgUrl placeholderImage:nil];
    
    switch (tag) {
        case sitTag:
            
            [self.sitImgView sd_setImageWithURL:ImgUrl placeholderImage:[UIImage imageNamed:@"head_3"]];
            
            break;
        case bedTag:
            
            [self.bedImgView sd_setImageWithURL:ImgUrl placeholderImage:[UIImage imageNamed:@"head_3"]];
            
            break;
        case bathTag:
            
            [self.bathImgView sd_setImageWithURL:ImgUrl placeholderImage:[UIImage imageNamed:@"head_3"]];
            
            break;
        default:
            break;
    }
}
#pragma mark ----------lazyLoad----------
- (UIWebView *)sitWebView {
    
    if (_sitWebView == nil) {
        
        _sitWebView = [ZHCreateImgView  createWebViewWithUrlStr:sittingRoom];
        _sitWebView.delegate = self;
       [self addSubview:_sitWebView];
       
        [_sitWebView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 250, 0));
        }];
        
    }
    return _sitWebView;
}
- (UIWebView *)bedWebView {
    
    if (_bedWebView == nil) {
        
        _bedWebView = [ZHCreateImgView  createWebViewWithUrlStr:bedroom];
        _bedWebView.delegate = self;
        [self addSubview:_bedWebView];
        
        [_bedWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 250, 0));
        }];
        
    }
    return _bedWebView;
}
- (UIWebView *)bathWebView{
    
    if (_bathWebView == nil) {
        
        _bathWebView = [ZHCreateImgView  createWebViewWithUrlStr:bathroom];
        _bathWebView.delegate = self;
   
        [self addSubview:_bathWebView];
        [_bathWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 250, 0));
        }];
        
    }
    return _bathWebView;
}

- (UIImageView *)sitImgView {
    
    if (_sitImgView == nil) {
        _sitImgView = [ZHCreateImgView createImageViewWith:@"客厅" tag:1001];
        [self addSubview:_sitImgView];
        ZHWeakSelf();
        [_sitImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.bathWebView.mas_bottom).offset(20);
            make.left.equalTo(@(20));
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
    }
    return _sitImgView;
}
- (UIImageView *)bedImgView {
    
    if (_bedImgView == nil) {
        _bedImgView = [ZHCreateImgView createImageViewWith:@"卧室" tag:1002];
        [self addSubview:_bedImgView];
        ZHWeakSelf();
        [_bedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf.sitImgView);
             make.size.mas_equalTo(CGSizeMake(80, 80));
            
        }];
    }
    return _bedImgView;
}
- (UIImageView *)bathImgView {
    
    if (_bathImgView == nil) {
        _bathImgView = [ZHCreateImgView createImageViewWith:@"卫生间" tag:1003];
        [self addSubview:_bathImgView];
        ZHWeakSelf();
        [_bathImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
             make.right.equalTo(@(-20));
            make.centerY.equalTo(weakSelf.sitImgView);
           make.size.mas_equalTo(CGSizeMake(80, 80));
            
        }];
    }
    return _bathImgView;
}
- (UIImageView *)refreshImgView {
    
    
    if (_refreshImgView == nil) {
        _refreshImgView = [ZHCreateImgView createRefreshImageView];
        [self addSubview:_refreshImgView];
        ZHWeakSelf();
        [_refreshImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(@(-20));
           
        }];
        
    }
    return _refreshImgView;
}
- (UIView *)foregroundViewOne {
    
    if (_foregroundViewOne == nil) {
        
        _foregroundViewOne = [ZHCreateImgView createForeground];
      
    }
    return _foregroundViewOne;
}
- (UIView *)foregroundViewTwo {
    
    if (_foregroundViewTwo == nil) {
        
        _foregroundViewTwo = [ZHCreateImgView createForeground];
        
    }
    return _foregroundViewTwo;
}
- (UIImageView *)mainImg {
    
    if (_mainImg == nil) {
        _mainImg = [[UIImageView alloc]init];
        _mainImg.userInteractionEnabled = YES;
        [_mainImg sd_setImageWithURL:[NSURL URLWithString:@"http://pic.to8to.com/smallcase/1610/20/20161020_2d6d681a9c04bb923864nihe9ku3hgv0_r.jpg"] placeholderImage:nil];
        [self addSubview:_mainImg];
        [_mainImg mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 250, 0));
        }];
    }
    return _mainImg;
}
- (UIButton *)backBtn {
    
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[UIImage imageNamed:@"left_arrow"] forState:0];
    
        [self.mainImg addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.equalTo(@(20));
            make.size.mas_equalTo(CGSizeMake(20, 20));
            
        }];
    }
    return _backBtn;
}
- (RACSubject *)popSubject {
    
    if (!_popSubject) {
        
        _popSubject = [RACSubject subject];
    }
    
    return _popSubject;
}
@end
