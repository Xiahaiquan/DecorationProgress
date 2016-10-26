//
//  PicCell.m
//  HomeWork
//
//  Created by 博云智慧 on 16/10/21.
//  Copyright © 2016年 博云智慧. All rights reserved.
//

#import "PicCell.h"

#import "PicCollCell.h"

#define padding 5

#define itemW (self.contentView.xl_width - 20 - ( 3 *padding ) ) / 4

@interface PicCell ()

@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) UIView *rectangleView;

@property (nonatomic, strong) UILabel *headLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation PicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self getData];
        
        [self setUI];
    }
    return self;
}
- (void)getData {
    
    for (NSInteger i = 1 ; i < 9; i ++) {
        
        NSString *picPath = [NSString stringWithFormat:@"pic_%ld",(long)i];
        
        [self.dataArray addObject:picPath];
    }
}
- (void)setUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self circleView];
    
    [self rectangleView];
    
    [self headLabel];
    
    [self collectionView];
    
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count ? self.dataArray.count : 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
    PicCollCell *cell = (PicCollCell *) [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([PicCollCell class])] forIndexPath:indexPath];
    
    if (self.dataArray.count > indexPath.row) {
        
         cell.picPath = self.dataArray[indexPath.row];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPat {
    
    return CGSizeMake(itemW , itemW);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *infor = @{@"indexPath":indexPath,@"data":self.dataArray};
    
    postNotification(photoBrowserNot, self, infor);
    
}
#pragma mark ----------lazyLoad----------
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        
        _collectionView.delegate = self;
        
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.scrollEnabled = NO;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"PicCollCell" bundle:nil] forCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([PicCollCell class])]];
        
        [self.contentView addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(30, 20, 0, 0));
        }];
        
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        //设置每一列的间距
        _flowLayout.minimumInteritemSpacing = padding;
        //设置每一行的间距
        _flowLayout.minimumLineSpacing = padding / 2;
    }
    
    return _flowLayout;
}

- (UIView *)circleView {
    
    if (_circleView == nil) {
        
        _circleView = [[UIView alloc]init];
        [self.contentView addSubview:_circleView];
        ZHWeakSelf();
        [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        _circleView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
        
        _circleView.layer.cornerRadius = 7.5f;
        
        _circleView.layer.masksToBounds = YES;

    }
    return _circleView;
    
}
- (UIView *)rectangleView {
    
    if (_rectangleView == nil) {
        _rectangleView = [[UIView alloc]init];
        
        _rectangleView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
        
       [self.contentView addSubview:_rectangleView];
        ZHWeakSelf();
        [_rectangleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.circleView.mas_bottom).offset(0);
            make.centerX.equalTo(weakSelf.circleView);
            make.width.equalTo(@(5));
            make.bottom.equalTo(weakSelf);
        }];
    }
    return _rectangleView;
    
}

- (UILabel *)headLabel {
    if (_headLabel  == nil) {
        
        _headLabel = [[UILabel alloc]init];
        _headLabel.text = @"现场照片";
        _headLabel.font = [UIFont systemFontOfSize:17];
        _headLabel.textColor = [UIColor orangeColor];
        [self.contentView addSubview:_headLabel];
        ZHWeakSelf();
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(5));
        make.left.equalTo(weakSelf.circleView.mas_right).offset(5);
    }];
    
    }
    return _headLabel;
}
- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
    
}
- (RACSubject *)popSubject {
    
    if (!_popSubject) {
        
        _popSubject = [RACSubject subject];
    }
    
    return _popSubject;
}
@end
