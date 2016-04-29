
//
//  SYScrollerCycleCell.m
//  SYScrollerViewCycleDemo
//
//  Created by sunyu on 16/4/29.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import "SYScrollerCycleCell.h"

@implementation SYScrollerCycleCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end
