//
//  SYScrollerViewCycleTool.m
//  SYScrollerViewCycleDemo
//
//  Created by sunyu on 16/4/29.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import "SYScrollerViewCycleTool.h"
#import "SYScrollerCycleCell.h"
#import "SYCycleCollectionView.h"
#import "UIImageView+WebCache.h"

#define SYScreenWidth [UIScreen mainScreen].bounds.size.width

#define SYCollectionCellID @"SYCollectionCellID"

@interface SYScrollerViewCycleTool () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation SYScrollerViewCycleTool
{
    SYCycleCollectionView *_collectionView;
    UIPageControl *_pageControl;
}

+ (instancetype)createScrollerViewCycleWithHeight:(CGFloat)height images:(NSArray *)images
{
    CGRect rect = CGRectMake(0, 0, SYScreenWidth, height*375/SYScreenWidth);
    return [[self alloc]initWithFrame:rect images:images];
}

-(instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    if (self = [super initWithFrame:frame]) {
        if (images.count) {
            _images = [NSMutableArray arrayWithArray:images];
            [_images insertObject:images.lastObject atIndex:0];
            [_images addObject:images.firstObject];
            [self createCollectionView];
            [self createPageControl];
            _pageControl.numberOfPages = images.count;
            _pageControl.currentPage = 0;
            [_collectionView layoutIfNeeded];
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    return self;
}

#pragma mark - attribute
- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _collectionView.timeInterval = timeInterval;
}

- (void)createPageControl
{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 20)];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self addSubview:_pageControl];
}


#pragma mark - UICollectionView

- (void)createCollectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = self.frame.size;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[SYCycleCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    }
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[SYScrollerCycleCell class] forCellWithReuseIdentifier:SYCollectionCellID];
    
    _collectionView.pageChangeClick = ^(NSInteger pageNum){
        _pageControl.currentPage = pageNum-1;
    };
    
    [self addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYScrollerCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYCollectionCellID forIndexPath:indexPath];

    id obj = _images[indexPath.item];
    
    if ([obj isKindOfClass:[UIImage class]]) {
        [cell.imageView setImage:_images[indexPath.item]];
    }else if ([obj isKindOfClass:[NSURL class]]){
        [cell.imageView sd_setImageWithURL:_images[indexPath.item] placeholderImage:nil];
    }else if ([obj isKindOfClass:[NSString class]]){
        if ([obj hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_images[indexPath.item]] placeholderImage:nil];
        }else{
            [cell.imageView setImage:[UIImage imageNamed:_images[indexPath.item]]];
        }
    }
    return cell;
}


#pragma mark - click

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollX = scrollView.contentOffset.x/SYScreenWidth;
    if (0 == scrollX) {
        _pageControl.currentPage = _images.count-2;
    }else if (_images.count-1 == scrollX){
        _pageControl.currentPage = 0;
    }else{
        _pageControl.currentPage = scrollX-1;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [_collectionView scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_collectionView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_collectionView scrollViewDidEndDecelerating:scrollView];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_touchClick){
        NSInteger touchIndex = indexPath.item;
        
        if (0 == touchIndex) {
            touchIndex = _images.count-3;
        }else if (_images.count-1 == touchIndex) {
            touchIndex = 0;
        }else{
            touchIndex -= 1;
        }
        _touchClick(touchIndex);
    }
}


@end
