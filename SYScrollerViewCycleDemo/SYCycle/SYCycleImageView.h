//
//  SYCycleImageView.h
//  SYScrollerViewCycleDemo
//
//  Created by 孙宇 on 2017/1/6.
//  Copyright © 2017年 孙宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCycleModel.h"

@class SYCycleImageView;

typedef NS_ENUM(NSInteger, SYImageViewState) {
    
    SYImageViewStateNone,
    SYImageViewStateShow,
    SYImageViewStateOut
};

typedef void(^SYImageStateCallback)(SYImageViewState state, SYCycleImageView *imageV);
typedef void(^SYImageTouchCallback)(SYCycleImageView *imageV);

@interface SYCycleImageView : UIImageView

@property (nonatomic, strong) SYCycleModel *model;
@property (nonatomic, copy) SYImageStateCallback callback;
@property (nonatomic, copy) SYImageTouchCallback touchCallback;

@end
