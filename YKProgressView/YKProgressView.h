//
//  YKProgressView.h
//  YKProgressView
//
//  Created by yzl on 2017/4/25.
//  Copyright © 2017年 yzl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YKCircleIncraseMode){
    
    YKCircleIncreaseSameTime    = 0, //同等时间
    YKCircleIncreaseByProgress  = 1, //根据进度决定动画时间
};

@interface YKProgressView : UIView

//定制圆形功能
/** 线条背景色*/
@property(nonatomic, strong) UIColor *lineBackColor;
/** 线条填充色*/
@property(nonatomic, strong) UIColor *lineFillColor;
/** 小圆点图片*/
@property(nonatomic, strong) UIImage *pointImage;


//角度相关
/** 起点角度，角度从水平右侧开始为0，顺时针为增加角度，直接传度数 如-90*/
@property(nonatomic, assign) CGFloat startAngle;

/** 减少的角度 直接传度数 如30、40、80*/
@property(nonatomic, assign) CGFloat reduceValue;
/** 设定progressView的线宽*/
@property(nonatomic, assign) CGFloat lineWidth;

/** 是否显示小圆点*/
@property(nonatomic, assign) BOOL showPoint;

/** 是否显示文字*/
@property(nonatomic, assign) BOOL showProgressText;

/** 是否从上次数值开始动画，默认为NO*/
@property(nonatomic, assign) BOOL increaseFromLast;

/** 不加动画，默认为NO*/
@property(nonatomic, assign) BOOL notAnimated;

/** 设置的进度progress等于上次时是否刷新，默认为NO*/
@property(nonatomic, assign) BOOL forceRefresh;


//*****************动画模式***************//
/** 动画场景模式*/
@property(nonatomic, assign) YKCircleIncraseMode animationMode;

/** 传递过来的进度值*/
@property(nonatomic, assign) CGFloat progress;



/**
 初始化progressView的坐标，背景线条颜色，线条填充颜色，进度条起始角度，进度条线宽

 @param frame 坐标
 @param lineBackColor 背景线条颜色
 @param lineFillColor 线条填充颜色
 @param startAngle 进度条起始角度
 @param lineWidth 进度条线宽
 @return progressView的初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
                lineBackColor:(UIColor *)lineBackColor
                lineFillColor:(UIColor *)lineFillColor
                   startAngle:(CGFloat)startAngle
                    lineWidth:(CGFloat)lineWidth;










@end
