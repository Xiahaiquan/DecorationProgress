//
//  HomeView.m
//  HomeWork
//
//  Created by 博云智慧 on 16/10/20.
//  Copyright © 2016年 博云智慧. All rights reserved.
//

#import "HomeView.h"

#import "PicCell.h"

#import "LPPhotoViewer.h"

@interface HomeView ()

@property (weak, nonatomic) IBOutlet UIImageView *onLineImg;

@property (weak, nonatomic) IBOutlet UIImageView *upArrowImg;

@property (weak, nonatomic) IBOutlet UIImageView *downArrowImg;

@property (weak, nonatomic) IBOutlet UITableViewCell *StageCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *LabelAndImageCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *SignaLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *downStageCell;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation HomeView

+ (instancetype) viewFromNIB {
    
    return [[NSBundle mainBundle] loadNibNamed:@"HomeView" owner:nil options:nil].firstObject;
}


-(void)layoutSubviews {
    
    //调整尾标的朝向
    self.upArrowImg.transform = CGAffineTransformMakeScale(-1.0,1.0);
    
    self.downArrowImg.transform = CGAffineTransformMakeScale(-1.0,1.0);
    
    self.onLineImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToOnLineVC)];
    
    [self.onLineImg addGestureRecognizer:tap];
    
    [self.tableView registerClass:[PicCell class] forCellReuseIdentifier:picCellReuseId];
    
    
    ZHWeakSelf();
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:photoBrowserNot object:nil]subscribeNext:^(NSNotification *notification) {
        
         NSDictionary *infor = [notification userInfo];
        
        NSIndexPath *indexPath = infor[@"indexPath"];
        
        NSArray *dataArr = infor[@"data"];
        
        [kUserDefaults setObject:dataArr forKey:@"dataArr"];
        
        [weakSelf showPhotoBrower:indexPath and:dataArr];
        
    }];
    
    //各个cell的选择状态
    _StageCell.selectionStyle = 0;
    
    _LabelAndImageCell.selectionStyle = 0;
    
    _SignaLabel.selectionStyle = 0;
    
    _downStageCell.selectionStyle = 0;
    
}
- (void)showPhotoBrower:(NSIndexPath *)indexPath and:(NSArray *)dataArr {
    
    LPPhotoViewer *pvc = [[LPPhotoViewer alloc] init];
    
    NSMutableArray *mDataArr = [NSMutableArray array];
    
    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *picPath = (NSString *)obj;
        
        [mDataArr addObject:[UIImage imageNamed:picPath]];
        
    }];
    
    
    pvc.currentIndex = indexPath.row;
    
    pvc.imgArr       = mDataArr;

    [pvc showFromViewController:_VC sender:nil];
}

#pragma mark - PushAction
- (void)pushToOnLineVC {
    
    [self.pushOnLineVCSubject sendNext:@"pushToOnLineVC"];
    
}
- (void)setVC:(UIViewController *)VC {
    
    _VC = VC;
}
#pragma mark - UITableViewDataSource UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFootInSection:(NSInteger)section {
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFootInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height ;
    switch (indexPath.row) {
        case 0:
            height = StageCellHeight;
            break;
        case 1:
            
            height = LabelAndImageCell;
            break;
        case 2:
            height = SignaLabel;
            break;
        case 3:
            height = picCellHeight;
            break;
        case 4:
            height = StageCellHeight;
            break;
        default:
            break;
    }
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            
            return _StageCell;
            break;
        case 1:
           
            return _LabelAndImageCell;
            break;
        case 2:
        
            return _SignaLabel;
            break;
        case 3:
            
            cell = (PicCell *) [tableView dequeueReusableCellWithIdentifier:picCellReuseId forIndexPath:indexPath];
        return cell;
            break;
        case 4:
       
            return _downStageCell;
            break;

        default:
           break;
    }
    
    return cell;
}
#pragma mark ----------lazyLoad----------

- (RACSubject *)pushOnLineVCSubject {
    
    if (!_pushOnLineVCSubject) {
        
        _pushOnLineVCSubject = [RACSubject subject];
    }
    
    return _pushOnLineVCSubject;
}
@end
