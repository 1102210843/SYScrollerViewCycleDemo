//
//  SYCycleManager.m
//  SYScrollerViewCycleDemo
//
//  Created by 孙宇 on 2017/1/6.
//  Copyright © 2017年 孙宇. All rights reserved.
//

#import "SYCycleManager.h"
#import "SYCycleImageView.h"
#import "SYCyclePageControl.h"

@interface SYCycleManager () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SYCyclePageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *pageControlConstraints;
//当前页码
@property (nonatomic, assign) NSUInteger currentPage;

//当前显示控件
@property (nonatomic, strong) NSMutableArray *currentViews;
//复用池
@property (nonatomic, strong) NSMutableArray *reusePool;

//判断滑动方向
@property (nonatomic, assign) BOOL scrollLeftOrRight;
@property (nonatomic, assign) CGFloat oldx;

//定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SYCycleManager

+ (instancetype)manager
{
    return [[self alloc]init];
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.reusePool = [NSMutableArray array];
        self.currentViews = [NSMutableArray array];
        self.pageControlConstraints = [NSMutableArray array];
        self.style = SYCyclePageStyleDefault;
        self.currentPage = 0;
        self.duration = 4.0;
        self.cycleWidth = [UIScreen mainScreen].bounds.size.width;
        self.cycleHeight = 180;
        
    }
    return self;
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (SYCyclePageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[SYCyclePageControl alloc]init];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}


#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat newx = scrollView.contentOffset.x;
    if (newx != self.oldx) {
        //Left-YES,Right-NO
        if (newx > self.oldx) {
            self.scrollLeftOrRight = NO;
        }else if(newx < self.oldx){
            self.scrollLeftOrRight = YES;
        }
        self.oldx = newx;
    }
    [self slideHorizontalOptions];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self timer];
}


/**
 横向滑动选项
 */
- (void)slideHorizontalOptions
{
    if (self.cycleDatasource.count == 0) {
        return;
    }
    
    if (self.reusePool.count == 0 &&
        self.currentViews.count == 1) {
        [self creatImage];
    }
    
    if (!self.scrollLeftOrRight){
        
        [self turnRight];
    }else{
        
        [self turnLeft];
    }
    
    [self selfInspection];
}


- (void)turnLeft
{
    SYCycleImageView *imageView = self.reusePool.firstObject;
    SYCycleImageView *currentView = self.currentViews.firstObject;
    NSUInteger page = self.currentPage;
    if (page == 0) {
        page = self.cycleDatasource.count-1;
    }else{
        page -= 1;
    }
    
    imageView.model = self.cycleDatasource[page];
    [self.scrollView addSubview:imageView];
    
    imageView.frame = CGRectMake(currentView.frame.origin.x-self.cycleWidth, 0, self.cycleWidth, self.cycleHeight);
}
- (void)turnRight
{
    SYCycleImageView *imageView = self.reusePool.firstObject;
    SYCycleImageView *currentView = self.currentViews.firstObject;
    NSUInteger page = self.currentPage;
    if (page == (self.cycleDatasource.count-1)) {
        page = 0;
    }else{
        page += 1;
    }
    
    imageView.model = self.cycleDatasource[page];
    [self.scrollView addSubview:imageView];
    
    imageView.frame = CGRectMake(currentView.frame.origin.x+self.cycleWidth, 0, self.cycleWidth, self.cycleHeight);
}




/**
 视图自检
 */
- (void)selfInspection
{
    for (SYCycleImageView *view in self.reusePool) {
        [view setNeedsLayout];
    }
    for (SYCycleImageView *view in self.currentViews) {
        [view setNeedsLayout];
    }
}


#pragma mark -- 定制UI
- (void)custom
{
    _scrollView.frame = CGRectMake(0, 0, self.cycleWidth, self.cycleHeight);
    
    [_scrollView setContentSize:CGSizeMake(MAXFLOAT, 0)];
    [_scrollView setContentOffset:CGPointMake(self.cycleWidth*(INT_MAX/2), 0)];
    
    if (self.cycleDatasource.count == 0) {
        return;
    }
    
    [self makePageControlLayoutConstraint];
    
    [self creatImage];
    
    if (self.currentViews.count == 0) {
        SYCycleImageView *imageView = self.reusePool.firstObject;
        imageView.model = self.cycleDatasource[self.currentPage];
        [self.scrollView addSubview:imageView];
    }
    
    [self timer];
}



//创建图片视图
- (void)creatImage
{
    if (self.cycleDatasource.count == 0) {
        return;
    }
    
    if (self.reusePool.count == 0) {
        
        CGFloat X = 0;
        CGFloat Y = 0;

        X = _scrollView.contentOffset.x;
        
        SYCycleImageView *imageView = [[SYCycleImageView alloc]initWithFrame:CGRectMake(X, Y, self.cycleWidth, self.cycleHeight)];
        
        __weak typeof(self)weakself = self;
        
        //轮播状态回调
        imageView.callback = ^(SYImageViewState state, SYCycleImageView *imageV){
            
            if (state == SYImageViewStateShow) {
                
                [weakself.currentViews addObject:imageV];
                [weakself.reusePool removeObject:imageV];
                
            }else{
                
                [weakself.reusePool addObject:imageV];
                [weakself.currentViews removeObject:imageV];
                
                SYCycleImageView *current = weakself.currentViews.firstObject;
                weakself.currentPage = [weakself.cycleDatasource indexOfObject:current.model];
            }
            
        };
        
        //图片点击回调
        imageView.touchCallback = ^(SYCycleImageView *imageV){
            
            NSInteger index = [weakself.cycleDatasource indexOfObject:imageV.model];
            if ([weakself.delegate respondsToSelector:@selector(cycleManager:index:model:)]){
                
                [weakself.delegate cycleManager:weakself index:index model:imageV.model];
            }else if (weakself.cycleTouchCallback) {
                
                weakself.cycleTouchCallback(weakself, index, imageV.model);
            }
        };
        
        [self.reusePool addObject:imageView];
    }
}


#pragma mark -- 定时器
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.duration target:self selector:@selector(onTimerClick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)onTimerClick
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x+self.cycleWidth, 0) animated:YES];
}


#pragma mark -- makePageControlLayoutConstraint
- (void)makePageControlLayoutConstraint
{
    if (self.parentView == nil) {
        return;
    }
    
    [self.parentView addSubview:self.pageControl];
    
    [self.parentView removeConstraints:self.pageControlConstraints];
    [self.pageControlConstraints removeAllObjects];
    
    self.pageControl.numberOfPages = self.cycleDatasource.count;
    
    [self.pageControlConstraints addObject:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    
    switch (self.style) {
        case SYCyclePageStyleDefault:
            [self pageControlLayoutConstraintCenter];
            break;
        case SYCyclePageStyleLeft:
            [self pageControlLayoutConstraintLeft];
            break;
        case SYCyclePageStyleRight:
            [self pageControlLayoutConstraintRight];
            break;
    }
    [self.parentView addConstraints:self.pageControlConstraints];
}

- (void)pageControlLayoutConstraintLeft
{
    [self.pageControlConstraints addObject:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:12.f]];
}
- (void)pageControlLayoutConstraintRight
{
    [self.pageControlConstraints addObject:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-12.f]];
}
- (void)pageControlLayoutConstraintCenter
{
    [self.pageControlConstraints addObject:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}




#pragma mark -- 
- (void)setCycleDatasource:(NSArray<SYCycleModel *> *)cycleDatasource
{
    _cycleDatasource = cycleDatasource;
    [self custom];
}

- (void)setParentView:(UIView *)parentView
{
    _parentView = parentView;
    [parentView addSubview:self.scrollView];
    [parentView addSubview:self.pageControl];
    [self custom];
}

- (void)setStyle:(SYCyclePageStyle)style
{
    _style = style;
    [self custom];
}
- (void)setCycleWidth:(CGFloat)cycleWidth
{
    _cycleWidth = cycleWidth;
    [self custom];
}

- (void)setCycleHeight:(CGFloat)cycleHeight
{
    _cycleHeight = cycleHeight;
    [self custom];
}

//分页控制器设置图片
-(void)setPageIndicatorTintImage:(UIImage *)pageIndicatorTintImage
{
    _pageIndicatorTintImage = pageIndicatorTintImage;
    self.pageControl.pageIndicatorTintImage = pageIndicatorTintImage;
}
- (void)setCurrentPageIndicatorTintImage:(UIImage *)currentPageIndicatorTintImage
{
    _currentPageIndicatorTintImage = currentPageIndicatorTintImage;
    self.pageControl.currentPageIndicatorTintImage = currentPageIndicatorTintImage;
}

//分页控制器设置颜色
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}
- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
    _currentPage = currentPage;
    self.pageControl.currentPage = currentPage;
}


@end
