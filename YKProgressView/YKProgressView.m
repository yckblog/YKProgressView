//
//  YKProgressView.m
//  YKProgressView
//
//  Created by yzl on 2017/4/25.
//  Copyright © 2017年 yzl. All rights reserved.
//

#import "YKProgressView.h"
#import "NSTimer+timer.h"

//角度转换为弧度
#define YKCircleDegreeToRadian(d) ((d) * M_PI)/180.0

//255进制颜色转换
#define YKCircleRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//屏幕宽高
#define ScreenWith self.frame.size.width
#define ScreenHeight self.frame.size.height


@implementation YKProgressView
{
    CGFloat fakeProgress;
    NSTimer *timer;//定时器用来做动画
}

- (instancetype)init{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

#pragma mark ===========初始化方法实现============
- (instancetype)initWithFrame:(CGRect)frame
                lineBackColor:(UIColor *)lineBackColor
                lineFillColor:(UIColor *)lineFillColor
                   startAngle:(CGFloat)startAngle
                    lineWidth:(CGFloat)lineWidth{
    
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        if (lineBackColor) {
            _lineBackColor = lineBackColor;
        }
        if (lineFillColor) {
            _lineFillColor = lineFillColor;
        }
        
        _startAngle = YKCircleDegreeToRadian(startAngle);
        _lineWidth = lineWidth;
    }
    return self;
    
}

#pragma mark ===========初始化视图数据============
- (void)initialization{
    
    self.backgroundColor = [UIColor clearColor];
    _lineBackColor = YKCircleRGB(204, 204, 204);
    _lineFillColor = YKCircleRGB(219, 186, 103);
    _lineWidth = 10;                 //线宽默认为10
    _startAngle = - YKCircleDegreeToRadian(90); //圆起点位置
    _reduceValue = YKCircleDegreeToRadian(0);   //整个圆缺少的角度
    _animationMode = YKCircleIncreaseByProgress; //根据进度来走进度条
    
    _showPoint = YES;        //默认出现小圆点
    _showProgressText = YES; //默认存在进度文字
    _forceRefresh = NO;      //一直刷新动画
    fakeProgress = 0.0;      //用来逐渐增加知道等于progress的值
    
    _pointImage = [UIImage imageNamed:@"circle_point1"];//可以更换小圆点
    
 
}

#pragma mark ===========set 方法============
- (void)setStartAngle:(CGFloat)startAngle{
    if (_startAngle != YKCircleDegreeToRadian(startAngle)) {
        _startAngle = YKCircleDegreeToRadian(startAngle);
        [self setNeedsDisplay];
    }
}

- (void)setReduceValue:(CGFloat)reduceValue{
    if (_reduceValue != YKCircleDegreeToRadian(reduceValue)) {
        _reduceValue = YKCircleDegreeToRadian(reduceValue);
        [self setNeedsDisplay];
    }
}

- (void)setLineWidth:(CGFloat)lineWidth{
    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
        [self setNeedsDisplay];
    }
}

- (void)setLineBackColor:(UIColor *)lineBackColor{
    if (_lineBackColor != lineBackColor) {
        _lineBackColor = lineBackColor;
        [self setNeedsDisplay];
    }
}

- (void)setLineFillColor:(UIColor *)lineFillColor{
    if (_lineFillColor != lineFillColor) {
        _lineFillColor = lineFillColor;
        [self setNeedsDisplay];
    }
}

- (void)setShowPoint:(BOOL)showPoint{
    if (_showPoint != showPoint) {
        _showPoint = showPoint;
        [self setNeedsDisplay];
    }
}

- (void)setShowProgressText:(BOOL)showProgressText{
    if (_showProgressText != showProgressText) {
        _showProgressText = showProgressText;
        [self setNeedsDisplay];
    }
}


#pragma mark ===========重写drawRect方法============
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置中心点 半径 起点及终点
    CGFloat maxWidth = self.frame.size.width < self.frame.size.height ? self.frame.size.width : self.frame.size.height;
    CGPoint center = CGPointMake(maxWidth/2.0, maxWidth/2.0);
    CGFloat radius = maxWidth/2.0 - _lineWidth/2.0 - 1; //留出1像素，防止与边界相切的地方被切平
    CGFloat endA = _startAngle + (YKCircleDegreeToRadian(360) - _reduceValue);//圆终点位置
    CGFloat valueEndA = _startAngle + (YKCircleDegreeToRadian(360) - _reduceValue)*fakeProgress; //数值终点位置
    
    //背景线
    UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:endA clockwise:YES];
    
    //线条宽度
    CGContextSetLineWidth(ctx, _lineWidth);
    //设置线条顶端
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //线条颜色
    [_lineBackColor setStroke];
    //把路径添加到上下文
    CGContextAddPath(ctx, basePath.CGPath);
    //渲染背景色
    CGContextStrokePath(ctx);
    
    
    //路径填充线
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:valueEndA clockwise:YES];
    //设置线条顶端
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //线条颜色
    [_lineFillColor setStroke];
    
    //把路径添加到上下文
    CGContextAddPath(ctx, fillPath.CGPath);
    //渲染数值线
    CGContextStrokePath(ctx);
    
    
    //画小圆点
    if (_showPoint) {
        CGContextDrawImage(ctx, CGRectMake(ScreenWith/2 + ((CGRectGetWidth(self.bounds) - _lineWidth)/2.f - 1) * cosf(valueEndA) - _lineWidth/2.0, (ScreenWith/2.0 + (CGRectGetWidth(self.bounds) - _lineWidth/2.f - 1))*sinf(valueEndA) - _lineWidth/2.0, _lineWidth, _lineWidth), _pointImage.CGImage);
    }
    
    if (_showProgressText) {
        
        NSString *currentText = [NSString stringWithFormat:@"%.f%%",fakeProgress*100];
        //段落格式
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;//水平居中
        //字体
        UIFont *font = [UIFont systemFontOfSize:0.15*ScreenWith];
        //构建属性集合
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:[UIColor orangeColor]};
        //获得size
        CGSize stringSize = [currentText sizeWithAttributes:attributes];
        //垂直居中
        CGRect r = CGRectMake((ScreenWith-stringSize.width)/2.0, (ScreenHeight - stringSize.height)/2.0,stringSize.width, stringSize.height);
        [currentText drawInRect:r withAttributes:attributes];
        
    }
    
}

#pragma mark ===========设置进度动画============
- (void)setProgress:(CGFloat)progress{
    if ((_progress == progress && !_forceRefresh) || progress > 1.0 || progress < 0.0) {
        return;
    }
    
    fakeProgress = _increaseFromLast == YES ? _progress : 0.0;
    BOOL isReverse = progress < fakeProgress ? YES : NO;
    
    //赋值真实值
    _progress = progress;
    
    //先暂停计时器
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    //如果为0或者没有动画则直接刷新
    if (_progress == 0.0 || _notAnimated) {
        fakeProgress = _progress;
        [self setNeedsDisplay];
        return;
    }
    
    //设置每次增加的数值
    CGFloat sameTimeIncreaseValue = _increaseFromLast==YES?fabs(fakeProgress-_progress):_progress;
    
    CGFloat defaultIncreaseValue = isReverse == YES ? - 0.01 : 0.01;
    
    
    __weak typeof(self) weakSelf = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.005 block:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //反方向动画
        if (isReverse) {
            if (fakeProgress <= _progress || fakeProgress <= 0.0f ) {
                [strongSelf dealWithLast];
                return ;
            }else{
                //进度条动画
                [strongSelf setNeedsDisplay];
            }
        }else{
            //正方向动画
            if (fakeProgress >= _progress || fakeProgress >= 1.0f) {
                [strongSelf dealWithLast];
                return;
            }else{
                //进度条动画
                [strongSelf setNeedsDisplay];
            }
        }
        
        //数值增加或减少
        if (_animationMode == YKCircleIncreaseSameTime) {
            fakeProgress += defaultIncreaseValue *sameTimeIncreaseValue;//不同进度
            
        }else{
            fakeProgress += defaultIncreaseValue;//进度越大动画时间越长
        }
        
    } repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    
    
}


- (void)dealWithLast{
    fakeProgress = _progress;
    [self setNeedsDisplay];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}


@end
