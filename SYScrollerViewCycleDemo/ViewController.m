//
//  ViewController.m
//  SYScrollerViewCycleDemo
//
//  Created by sunyu on 16/4/29.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import "ViewController.h"
#import "SYScrollerViewCycleTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *images = @[@"344",
                        @"1.jpg",
                        @"11.jpg"];
    
    SYScrollerViewCycleTool *tool = [SYScrollerViewCycleTool createScrollerViewCycleWithHeight:180 images:images];
    tool.touchClick = ^(NSInteger touchIndex){
        NSLog(@"%ld", (long)touchIndex);
    };
    [self.view addSubview:tool];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
