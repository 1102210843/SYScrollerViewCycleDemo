//
//  SYCycleManager.h
//  SYScrollerViewCycleDemo
//
//  Created by 孙宇 on 2017/1/6.
//  Copyright © 2017年 孙宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SYCycleModel.h"

typedef NS_ENUM(NSInteger, SYCyclePageStyle) {
    
    SYCyclePageStyleDefault,
    SYCyclePageStyleLeft,
    SYCyclePageStyleRight,
    SYCyclePageStyleCenter = SYCyclePageStyleDefault,
};

@class SYCycleManager;

@protocol SYCycleManagerDelegate <NSObject>

@optional

/**
 点击回调

 @param manager 返回轮播控制器对象
 @param index 点击图片的位置信息
 @param model 点击图片的model信息
 */
- (void)cycleManager:(SYCycleManager *)manager index:(NSInteger)index model:(SYCycleModel *)model;

@end


@interface SYCycleManager : NSObject

+ (instancetype)manager;

//回调方式可选择代理或block方式
@property (nonatomic, weak) id <SYCycleManagerDelegate> delegate;
#pragma mark -- block方式触摸回调
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


@end
