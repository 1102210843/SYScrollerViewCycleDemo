//
//  SYCyclePageControl.m
//  SYScrollerViewCycleDemo
//
//  Created by 孙宇 on 2017/1/9.
//  Copyright © 2017年 孙宇. All rights reserved.
//

#import "SYCyclePageControl.h"

@implementation SYCyclePageControl


- (void)setPageIndicatorTintImage:(UIImage *)pageIndicatorTintImage
{
    _pageIndicatorTintImage = pageIndicatorTintImage;
    
    [self setValue:pageIndicatorTintImage forKey:@"pageImage"];
}
- (void)setCurrentPageIndicatorTintImage:(UIImage *)currentPageIndicatorTintImage
{
    _currentPageIndicatorTintImage = currentPageIndicatorTintImage;
    
    [self setValue:currentPageIndicatorTintImage forKey:@"currentPageImage"];
}


@end
