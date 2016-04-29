//
//  SYCycleCollectionView.m
//  SYScrollerViewCycleDemo
//
//  Created by sunyu on 16/4/29.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import "SYCycleCollectionView.h"

@interface SYCycleCollectionView ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SYCycleCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.timeInterval = 2;
    }
    return self;
}

#pragma mark - NSTimer
- (void)createTimer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(onTimerClick:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = (timeInterval>0.3)?timeInterval:0.4;
    [self closeTimer];
    [self createTimer];
}

- (void)closeTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self closeTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self closeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self createTimer];
    CGPoint point = [self.panGestureRecognizer translationInView:self];
    NSInteger totalNumber = [self numberOfItemsInSection:0];
    if (point.x > 0) {
        _pageNum--;
        if (0 >= _pageNum) {
            _pageNum = totalNumber-2;
            [self setContentOffset:CGPointMake(self.frame.size.width*_pageNum, 0)];
        }
        [self thePageChangeClick];
    }else{
        _pageNum++;
        if (totalNumber-1 <= _pageNum) {
            _pageNum = 1;
            [self setContentOffset:CGPointMake(self.frame.size.width, 0)];
        }
    }
}

- (void)onTimerClick:(NSTimer *)timer
{
    _pageNum++;
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_pageNum inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    NSInteger totalNumber = [self numberOfItemsInSection:0];
    if (totalNumber-1 <= indexPath.item){
        [super scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
        _pageNum = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setContentOffset:CGPointMake(self.frame.size.width, 0)];
        });
    }else{
        [super scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
        _pageNum = indexPath.item;
    }
    
}

- (void)thePageChangeClick
{
    if (_pageChangeClick) {
        _pageChangeClick(_pageNum);
    }
}

@end
