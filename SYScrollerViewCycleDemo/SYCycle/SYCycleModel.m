//
//  SYCycleModel.h
//  SYScrollerViewCycleDemo
//
//  Created by 孙宇 on 2017/1/6.
//  Copyright © 2017年 孙宇. All rights reserved.
//

#import "SYCycleModel.h"

@implementation SYCycleModel


- (NSString *)img
{
    if ([self.datasource isKindOfClass:[NSDictionary class]]) {
        return self.datasource[@"img"];
    }else{
        return self.datasource;
    }
}

- (NSString *)text
{
    if ([self.datasource isKindOfClass:[NSDictionary class]]) {
        return self.datasource[@"text"];
    }else{
        return nil;
    }
}



@end
