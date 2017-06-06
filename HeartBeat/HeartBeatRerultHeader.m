//
//  HeartBeatRerultHeader.m
//  HeartBeat
//
//  Created by fander on 2017/2/26.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HeartBeatRerultHeader.h"

@interface HeartBeatRerultHeader()
@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *bmpLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIImageView *hrIndicatorView;//hr-zone-indicator
@property (nonatomic, weak) UIImageView *colorImageView ;
@end
@implementation HeartBeatRerultHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor whiteColor];
        

        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"backNew"] forState:UIControlStateNormal];
        _backBtn.frame = CGRectMake(20, 20, 40, 40);
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 220, 220)];
        _bgView.backgroundColor = [UIColor grayColor];
         _bgView.center = CGPointMake(self.width/2, self.height/2- 30);
        [self addSubview:_bgView];
        _bgView.backgroundColor = COLOR(188, 188, 188, 0.06);
        _bgView.layer.cornerRadius = _bgView.width/2;
        
        _bgView.clipsToBounds = YES;

        
        UIView *boundary = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 180 , 180)];
        boundary.center = CGPointMake(self.width/2, self.height/2 - 30);
        [self  addSubview:boundary];
        boundary.backgroundColor = COLOR(255, 255, 255, 1);
        boundary.layer.borderColor = COLOR(188, 188, 188, 1).CGColor;
        boundary.layer.borderWidth = 0.5;
        boundary.layer.cornerRadius = boundary.width/2;
        
        _circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 160 , 160)];
        _circleView.backgroundColor = APP_COLOR;
        _circleView.center = CGPointMake(self.width/2, self.height/2- 30);
        [self addSubview:_circleView];
        _circleView.layer.cornerRadius = _circleView.width/2;
        _circleView.clipsToBounds = NO;
        
        
        self.bmpLabel = [[UILabel alloc] init];
        
        self.bmpLabel.size = CGSizeMake(self.width, 60);
        self.bmpLabel.text = @"0";
        self.bmpLabel.textColor = [UIColor whiteColor];
        self.bmpLabel.y = (self.height - self.bmpLabel.height)/2 - 30;
        self.bmpLabel.textAlignment = NSTextAlignmentCenter;
        self.bmpLabel.font = [UIFont systemFontOfSize:80 weight:UIFontWeightUltraLight];
        [self addSubview:self.bmpLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.height - 36, 260, 26)];
        imageView.centerX = self.width/2;
        imageView.image = [UIImage imageNamed:@"HRZonesNewTwo"];
        [self addSubview:imageView];
        _colorImageView = imageView;
        
        _hrIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hr-zone-indicator"]];
        [_colorImageView addSubview:_hrIndicatorView];

    }
    return self;
}

- (void)back{
    if(self.BackHeartBeatTest){
        self.BackHeartBeatTest();
    }
}
- (void)setBmp:(NSString *)bmp{
    _bmp = bmp;
    self.bmpLabel.text = bmp;
    NSInteger n_bmp = [bmp integerValue];
    CGFloat percent = (n_bmp- 50.0)/(180.0 - 50.0);
    if (percent<0) {
        percent = 0;
    }
    self.hrIndicatorView.height = _colorImageView.height;
    self.hrIndicatorView.width = self.hrIndicatorView.image.size.width/self.hrIndicatorView.image.size.height * self.hrIndicatorView.height;
    CGFloat x = percent * _colorImageView.width - self.hrIndicatorView.width/2;
    if(x < 0){
        x = 0;
    }
    self.hrIndicatorView.x = x;
}
@end
