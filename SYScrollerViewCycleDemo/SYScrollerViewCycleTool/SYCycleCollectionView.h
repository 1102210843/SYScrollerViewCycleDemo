//
//  SYCycleCollectionView.h
//  SYScrollerViewCycleDemo
//
//  Created by sunyu on 16/4/29.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYCycleCollectionView : UICollectionView <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, copy) void (^pageChangeClick)(NSInteger pageNum);

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
