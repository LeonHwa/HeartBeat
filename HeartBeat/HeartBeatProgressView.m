//
//  HeartBeatProgressView.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/24.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HeartBeatProgressView.h"
#import "HAnimation.h"
@interface HeartBeatProgressView()
{
    NSTimer *timer;
}
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, assign) double progress;
@property (nonatomic, strong) UIImageView *heartImgView;
@property (nonatomic, assign) double count;
@property (nonatomic, strong) UIImage *grayImage;
@property (nonatomic, strong) UIImage *redImage;
@property (nonatomic, strong) UIView *bgView;

@property (strong, nonatomic) UILabel *startLabel;
@end

@implementation HeartBeatProgressView

#define MARGIN 60
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.bgView = [[UIView alloc] init];
        self.bgView.size = CGSizeMake(self.width - 2*MARGIN, self.width - 2*MARGIN);
        self.bgView.center = CGPointMake(self.width/2, self.height/2);
        self.bgView.backgroundColor = APP_COLOR;
        self.bgView.layer.cornerRadius = self.bgView.width/2;
        [self addSubview:self.bgView];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:self.width/2 - MARGIN startAngle:0 endAngle: M_PI * 2 clockwise:YES];
        self.bgLayer.path = path.CGPath;
        self.heartImgView = [[UIImageView alloc] init];
        UIImage *himage = [UIImage imageNamed:@"ic_values_heartrate~iphone"];
        self.grayImage = [himage imageMaskWithColor:COLOR(213, 207, 187, 1)];
        self.redImage = [himage imageMaskWithColor:[UIColor whiteColor]];
        self.heartImgView.size = himage.size;
        self.heartImgView.image = self.grayImage;
        self.heartImgView.center = CGPointMake(self.width/2, self.height/4 + 20);
        [self addSubview:self.heartImgView];
        
        self.bmpLabel = [[UILabel alloc] init];
        
        self.bmpLabel.size = CGSizeMake(self.width, 60);
        self.bmpLabel.text = @"0";
        self.bmpLabel.textColor = [UIColor whiteColor];
        self.bmpLabel.y = (self.height - self.bmpLabel.height)/2;
        self.bmpLabel.textAlignment = NSTextAlignmentCenter;
        self.bmpLabel.font = [UIFont systemFontOfSize:80 weight:UIFontWeightUltraLight];
        NSLog(@"%@",[UIFont familyNames]);
        [self addSubview:self.bmpLabel];
        
        UILabel *staticLabel  = [[UILabel alloc] init];
        staticLabel.text = @"BMP";
        staticLabel.font = [UIFont fontWithName:@"Oriya Sangam MN" size:26];
        [staticLabel sizeToFit];
        staticLabel.centerY = self.bmpLabel.centerY + 10;
        staticLabel.centerX = self.bmpLabel.centerX + 80;
        staticLabel.textColor = COLOR(220, 220, 220, 1);
        [self addSubview:staticLabel];
        
        _startLabel = [[UILabel alloc] init];
        _startLabel.text = @"点击开始";
        _startLabel.font = [UIFont systemFontOfSize:20];
        _startLabel.textColor = [UIColor whiteColor];
        [_startLabel sizeToFit];
        _startLabel.centerX = _bmpLabel.centerX;
        _startLabel.y =  CGRectGetMaxY(_bmpLabel.frame) + 20;
        [self addSubview:_startLabel];
        [self startFlash];
    }
    return self;
}

- (void)startFlash{
    CAKeyframeAnimation *keyAnimate  = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    keyAnimate.values = @[@1,@0,@1];
    keyAnimate.repeatCount = FLT_MAX;
    keyAnimate.duration = 2.0f;
    keyAnimate.removedOnCompletion = NO;
    keyAnimate.fillMode=kCAFillModeForwards;
    keyAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.startLabel.layer addAnimation:keyAnimate forKey:@"flash"];
    
}
- (void)progressPause{
     self.heartImgView.image = self.grayImage;
    if(timer){
     [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer =nil;
        self.circleLayer.path = NULL;
    }
    self.startLabel.hidden = NO;
}
- (void)progressBegin{
    if(!timer){
        timer = [NSTimer timerWithTimeInterval:0.01f target:self selector:@selector(running) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.count = 0;
    }
    self.startLabel.hidden = YES;
}
- (void)running{
    @autoreleasepool {
        if(self.count >= 10)  return;
        self.progress = sin((M_PI *_count)/22.02);
        CGFloat angle = self.progress * M_PI * 2;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:self.width/2 - 60 startAngle: -M_PI/2 endAngle: angle - M_PI/2 clockwise:YES];
        self.circleLayer.path = path.CGPath;
        self.count += 0.004;
    }

}
- (void)animateBeat{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(self.heartImgView.image == self.grayImage){
            self.heartImgView.image = self.redImage;
        }
        CAKeyframeAnimation *animate =  [CAKeyframeAnimation animation];
        animate.duration = 0.5;
        animate.keyPath = @"transform.scale";
        animate.values = @[@1,@1.1,@1.2,@1.4,@1.2,@1];
        animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.heartImgView.layer addAnimation:animate forKey:@"heartBeartAnimate"];
    });
  
}



//- (void)setProgress:(double)progress{
//    _progress = progress;
//    [self draw];
//}
//
//- (void)draw{
//    double angle = _progress/100 * M_PI * 2 - M_PI/2;
//     UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:self.width/2 - 60 startAngle: -M_PI/2 endAngle: angle clockwise:YES];
//    self.circleLayer.path = path.CGPath;
//}



- (CAShapeLayer *)circleLayer{
    if(_circleLayer == nil){
        _circleLayer= [[CAShapeLayer  alloc] init];
        _circleLayer.strokeColor = [UIColor whiteColor].CGColor; //COLOR(97, 211,167, 1).CGColor;
        _circleLayer.lineWidth = 20;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_circleLayer];
    }
    return _circleLayer;
}


- (CAShapeLayer *)bgLayer{
    if(_bgLayer == nil){
        _bgLayer= [[CAShapeLayer  alloc] init];
        _bgLayer.strokeColor = COLOR(217, 211, 211, 1).CGColor;
        _bgLayer.fillColor = [UIColor clearColor].CGColor;
        _bgLayer.lineWidth = 20;
        _bgLayer.lineJoin = @"round";
        _bgLayer.lineCap = @"round";
        [self.layer addSublayer:_bgLayer];
        
        
    }
    return _bgLayer;
}


@end
