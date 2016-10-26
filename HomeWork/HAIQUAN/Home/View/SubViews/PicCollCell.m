//
//  PicCollCell.m
//  HomeWork
//
//  Created by 博云智慧 on 16/10/21.
//  Copyright © 2016年 博云智慧. All rights reserved.
//

#import "PicCollCell.h"

@interface PicCollCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImg;

@end


@implementation PicCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPicPath:(NSString *)picPath {
    
    _picPath = picPath;
    
    [self.mainImg setImage:[UIImage imageNamed:_picPath]];
    
}

@end
