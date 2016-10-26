//
//  PicCell.h
//  HomeWork
//
//  Created by 博云智慧 on 16/10/21.
//  Copyright © 2016年 博云智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+XLExtension.h"

@interface PicCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, strong) RACSubject *popSubject;

@end
