//
//  HeartLive.m
//  HeartBeatsPlugin
//
//  Created by A053 on 16/9/9.
//  Copyright © 2016年 Yvan. All rights reserved.
//

#import "HeartLive.h"

#import "Butterworth.h"
#define PADDING 3
#define KW 3
#define RIGHT_MARGIN  20
@interface HeartLive ()
{
    float max;
    float min;
}

@property (nonatomic , readwrite) double ** buttterworthValues;
@property (nonatomic,strong) UIView *dotView;
@property (nonatomic,strong) CAShapeLayer *heartLayer;
@property (nonatomic,strong) UIBezierPath *heartPath;
@end

static CGFloat grid_w = 30.0f;

@implementation HeartLive

#define FILTER_ORDER 5
#define FILTER_LOWER_BAND 0.04 //36  (最低心跳)
#define FILTER_UPPER_BAND 0.2 //180  (最高心跳)


- (double**)buttterworthValues{
    if (!_buttterworthValues) {
        double frequencyBands[2] = {FILTER_LOWER_BAND , FILTER_UPPER_BAND};
        _buttterworthValues = butter(frequencyBands, FILTER_ORDER);
    }
    return _buttterworthValues;
}
- (void)getBoundary{
     min = 10000000;
     max = 0;
    for (NSUInteger i = 0 ; i < self.points.count;i++) {
        float h = [self.points[i] floatValue];
        if(h > max){
            max = h;
        }
        if(h < min){
            min = h;
        }
    }
}

- (void)abandon{
    float sum = 0;
    for (NSUInteger i = 0 ; i < self.points.count;i++) {
       float h = [self.points[i] floatValue];
       sum += h;
    }
    float avg = sum/self.points.count;
    for (NSUInteger i = 0 ; i < self.points.count;i++) {
        float h = [self.points[i] floatValue];
        if (h/avg > 5){
            [self.points removeObjectAtIndex:i];
        }
    }
}

- (void)drawRateWithPoint:(NSNumber *)point {
    // 倒叙插入数组
    [self.points addObject:point];
    if(self.points.count < 3){
        return;
    }
  //  [self abandon];
    if( ((KW + PADDING) * self.points.count + RIGHT_MARGIN) > WIDTH){
        
        if ([point doubleValue]/max < 3){
            [self.points removeObjectAtIndex:0];
              [self getBoundary];
        }else{
            [self.points  removeLastObject];
        }
     
    }else{
       [self getBoundary];
    }
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [self draw];
    });
}

- (void)drawRate {
    
    CGFloat ww = self.frame.size.width;
    CGFloat hh = self.frame.size.height;
    CGFloat pos_x = 0;
    CGFloat pos_y = hh/2;
    // 获取当前画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 折线宽度
    CGContextSetLineWidth(context, 3.0);
    //消除锯齿
    //CGContextSetAllowsAntialiasing(context,false);
    // 折线颜色
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextMoveToPoint(context, pos_x, pos_y);
    float valueH = max - min;
    float topAndBottomMargin = 10;
    for (int i = 0; i < self.points.count; i++) {
        float h = [self.points[i] floatValue];
        pos_y = topAndBottomMargin + (1 - (h-min)/valueH) * (self.height - topAndBottomMargin * 2);
        CGContextAddLineToPoint(context, pos_x, pos_y);
        pos_x += (PADDING + KW);
    }
    CGContextStrokePath(context);
}
- (void)clearLine{
    [self.points removeAllObjects];
    [self.heartPath removeAllPoints];
    [self.heartLayer removeFromSuperlayer];
    _heartLayer = nil;
    
    [_dotView removeFromSuperview];
    _dotView = nil;
}
- (void)draw{
    
    [self.heartPath removeAllPoints];

    CGFloat hh = self.frame.size.height;
    CGFloat pos_x = 0;
    CGFloat pos_y = hh/2;

    float valueH = max - min;
    float topAndBottomMargin = 10;
    for (int i = 0; i < self.points.count; i++) {
        float h = [self.points[i] floatValue];
        pos_y = topAndBottomMargin + (1 - (h-min)/valueH) * (self.height - topAndBottomMargin * 2);
        if(i == 0){
            [self.heartPath moveToPoint:CGPointMake(pos_x, pos_y)];
        }else{
          [self.heartPath addLineToPoint:CGPointMake(pos_x, pos_y)];
        }
        if(i == self.points.count - 1){
        self.dotView.origin = CGPointMake(pos_x - KW, pos_y - KW);
        }
        pos_x += (PADDING + KW);
    }
    
self.heartLayer.path = _heartPath.CGPath;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.points = [[NSMutableArray alloc]init];
        self.clearsContextBeforeDrawing = YES;
        _heartPath = [[UIBezierPath alloc] init];
       
    }
    return self;
}

- (UIView *)dotView{
    if(_dotView == nil){
        _dotView = [[UIView alloc] init];
        _dotView.size = CGSizeMake(8, 8);
        _dotView.layer.cornerRadius = _dotView.width/2;
        _dotView.backgroundColor = COLOR(255, 0, 40, 1);
        [self addSubview:_dotView];
    }
    return _dotView;
}
- (CAShapeLayer *)heartLayer{
    if(!_heartLayer){
        _heartLayer = [[CAShapeLayer alloc] init];
        _heartLayer.lineWidth = KW;
        _heartLayer.lineJoin = @"round";
        _heartLayer.strokeColor = APP_COLOR.CGColor;
        _heartLayer.fillColor = [UIColor clearColor].CGColor;
         _heartLayer.path = _heartPath.CGPath;
        [self.layer addSublayer:_heartLayer];
    }
    return _heartLayer;
}

@end
