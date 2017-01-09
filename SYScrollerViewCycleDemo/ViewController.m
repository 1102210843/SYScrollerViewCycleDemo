//
//  ViewController.m
//  SYScrollerViewCycleDemo
//
//  Created by 孙宇 on 2017/1/6.
//  Copyright © 2017年 孙宇. All rights reserved.
//

#import "ViewController.h"
#import "SYCycleManager.h"

#define IMAGES @[@"http://static.newnewle.com/bundles/webappindex/upload/user/img/232aa1d6d0d81701599b2770d7507bcd.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/ddf806c52b4fffed8d10ea22fe0aefa7.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/fbcd050542555e6a4d35cc92f4fc5cec.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/d3e7c20acb70b2554825e4fa35919da8.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/f58cf571f152660ef09b150f9b3b1f0c.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/725621ddcb287ffcb0bc3524e62dfc21.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/fe899e8d631d586224edb11fb0842df7.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/220ab5198d566031e00e82f9583cd453.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/9ef8a9a6ae90a54df25a9727223c3bc2.jpeg"]


@interface ViewController () <UIScrollViewDelegate, SYCycleManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    int i = 1;
    NSMutableArray *datasource = [NSMutableArray array];
    for (NSString *img in IMAGES) {
        
        //        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //        [dict setObject:img forKey:@"img"];
        //        [dict setObject:[NSString stringWithFormat:@"标题 %d", i] forKey:@"text"];
        //
        //        [dada addObject:dict];
        //
        //        i++;
        
        SYCycleModel *model = [SYCycleModel new];
        //        model.datasource = dict;
        model.datasource = img;
        [datasource addObject:model];
    }
    
    SYCycleManager *manager = [SYCycleManager manager];
    //    manager.delegate = self;
    manager.parentView = self.view;
    manager.cycleDatasource = datasource;
    manager.style = SYCyclePageStyleLeft;
    manager.pageIndicatorTintImage = [UIImage imageNamed:@"page"];
    manager.currentPageIndicatorTintImage = [UIImage imageNamed:@"current"];
    
    manager.cycleTouchCallback = ^(SYCycleManager *currManager, NSInteger index, SYCycleModel *currModel){
        NSLog(@"%ld <><><><>  %@", index, currModel);
    };
    
}

- (void)cycleManager:(SYCycleManager *)manager index:(NSInteger)index model:(SYCycleModel *)model
{
    NSLog(@"%ld <><><><>  %@", index, model);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
