# SYScrollerViewCycleDemo

#SYCycle
循环轮播控件2.0版，全新改版，可定制化视图，加载网络图片需要配合SDWebImage使用

#SYCycleManage
SYCycleManage 轮播控件的管理类，使用、视图定制全部通过该类实现

#pragma makr -- 点击回调
点击回调提供两种方式

1、通过使用代理方法

- (void)cycleManager:(SYCycleManager *)manager index:(NSInteger)index model:(SYCycleModel *)model;

2、通过block方式回调

@property (nonatomic, copy) void (^cycleTouchCallback)(SYCycleManager *currManager, NSInteger index, SYCycleModel *currModel);

#pragma mark -- 必选项
//控件父视图

@property (nonatomic, weak) UIView *parentView;

//源数据

@property (nonatomic, strong) NSArray<SYCycleModel*> *cycleDatasource;

#pragma mark -- 定制项
//控件分页风格

@property (nonatomic, assign) SYCyclePageStyle style;

//分页控件设置图片

@property (nonatomic, strong) UIImage *pageIndicatorTintImage;

@property (nonatomic, strong) UIImage *currentPageIndicatorTintImage;

//分页控件设置颜色

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

//控件宽度，默认为屏幕宽度

@property (nonatomic, assign) CGFloat cycleWidth;

//控件高度，默认为180

@property (nonatomic, assign) CGFloat cycleHeight;

//停留时间，默认4秒

@property (nonatomic, assign) NSTimeInterval duration;


大家如果觉得好用不要忘了star，另外如果有问题可以联系我QQ：1102210843 tel：18610863095，大家共同学习，谢谢
