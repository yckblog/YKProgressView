//
//  ViewController.m
//  YKProgressView
//
//  Created by yzl on 2017/4/25.
//  Copyright © 2017年 yzl. All rights reserved.
//

#import "ViewController.h"
#import "YKProgressView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //进度条
    
    /**1. 有动画缺口 带小圆点 */
    YKProgressView *progressView = [[YKProgressView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150)/2,  250, 150, 150) lineBackColor:nil lineFillColor:nil startAngle:-240 lineWidth:10];
    progressView.lineBackColor = [UIColor lightGrayColor];
    progressView.lineFillColor = [UIColor orangeColor];
    progressView.reduceValue = -90;
//    progressView.increaseFromLast = YES;
    progressView.progress = 0.9;
    [self.view addSubview:progressView];

    /**2. 无动画*/
    progressView.animationMode = YKCircleIncreaseSameTime;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
