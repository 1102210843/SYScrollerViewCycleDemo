//
//  SYScrollerViewCycleTool.h
//  SYScrollerViewCycleDemo
//
//  Created by sunyu on 16/4/29.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYScrollerViewCycleTool : UIView


/**
 *  初始化控件
 *
 *  @param height 视图高度
 *  @param images 图片数组，图片支持 NSURL, NSString, UIImage, 本地图片名
 *
 *  @return 返回控件指针
 */
+ (instancetype)createScrollerViewCycleWithHeight:(CGFloat)height images:(NSArray *)images;

/**
 *  设置图片自动播放时间，默认2秒
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/**
 *  控件触摸事件回调
 */
@property (nonatomic, copy) void (^touchClick)(NSInteger touchIndex);


@end
