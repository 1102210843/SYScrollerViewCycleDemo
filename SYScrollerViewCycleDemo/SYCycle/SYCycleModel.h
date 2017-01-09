//
//  SYCycleModel.h
//  SYScrollerViewCycleDemo
//
//  Created by 孙宇 on 2017/1/6.
//  Copyright © 2017年 孙宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYCycleModel : NSObject

/**
 数据源，支持两种类型数据，使用前请认真阅读
 
 NSString       图片链接
 NSDictionary   传入字典数据时，需要修改 .m 文件key值
 */
@property (nonatomic, readwrite, strong) id datasource;



//图片
@property (nonatomic, readonly, strong) NSString *img;
//显示文字
@property (nonatomic, readonly, strong) NSString *text;
 
@end
