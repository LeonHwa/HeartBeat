//
//  HeartBeatResultCell.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/27.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HeartBeatResultCell.h"
#import "Masonry.h"

@implementation HeartBeatTagItem
@end

@interface HeartBeatCellMainView : UIView
@property (nonatomic, strong) UILabel *descripLabel;
@property (nonatomic, strong) UIImageView *imgView;
@end
@implementation HeartBeatCellMainView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _descripLabel = [[UILabel alloc] init];
        _descripLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightUltraLight];
        _descripLabel.textAlignment = NSTextAlignmentCenter;
        _descripLabel.numberOfLines = 0;
        [self addSubview:_descripLabel];
        
        
        _imgView = [[UIImageView alloc] init];
        [self addSubview:_imgView];
        
        
        __weak typeof(self)  weakSelf = self;
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf).offset(-10);
            make.width.equalTo(@30);
            make.height.equalTo(@36);
        }];
        [_descripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(10);
            make.top.equalTo(_imgView.mas_bottom).offset(0);
            make.right.equalTo(weakSelf.mas_right).offset(-10);
            make.bottom.equalTo(weakSelf.mas_bottom);
        }];

    }
    return self;
}

@end

@interface HeartBeatResultCell(){
    CAShapeLayer *_maskLayer;
    UIBezierPath *_circlePath;
}
@property (nonatomic, strong) NSMutableArray *borderArray;
@property (strong, nonatomic) HeartBeatCellMainView *bottomView;
@property (strong, nonatomic) HeartBeatCellMainView *upView;
@property (nonatomic, retain) AVAudioPlayer *selectSoud;
@end

@implementation HeartBeatResultCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        __weak typeof(self)  weakSelf = self;
        NSURL *selectSoudURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"select" ofType:@"m4a"]];
        self.selectSoud = [[AVAudioPlayer alloc] initWithContentsOfURL:selectSoudURL error:nil];
        
        self.selectSoud.volume = 1;
        _bottomView = [[HeartBeatCellMainView alloc] init];
        [self.contentView addSubview:_bottomView];
        
        _upView = [[HeartBeatCellMainView alloc] init];
        _upView.backgroundColor = APP_COLOR;
        _upView.descripLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_upView];
        
        _maskLayer = [[CAShapeLayer alloc] init];
        _maskLayer.strokeColor = [UIColor blackColor].CGColor;
        _maskLayer.fillColor = [UIColor blackColor].CGColor;
        _maskLayer.frame = CGRectMake(0, 0, 120, 120);
        _upView.layer.mask = _maskLayer;
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            make.right.equalTo(weakSelf.contentView.mas_right);
        }];
        [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            make.right.equalTo(weakSelf.contentView.mas_right);
        }];

        _borderArray = [NSMutableArray array];
        for (NSUInteger i = 0;i  < 4; i++) {
            UIView *line = [[UIView alloc] init];
            [self.contentView addSubview:line];
            switch (i) {
                case 0:{
                    [line mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(weakSelf.contentView.mas_top);
                        make.right.equalTo(weakSelf.contentView.mas_right);
                        make.left.equalTo(weakSelf.contentView.mas_left);
                        make.height.equalTo(@0.5);
                    }];
                    break;
                }
                case 1:{
                    [line mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(weakSelf.contentView.mas_top);
                        make.right.equalTo(weakSelf.contentView.mas_right);
                        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
                        make.width.equalTo(@0.5);
                    }];
                    break;
                }
                case 2:{
                    [line mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
                        make.right.equalTo(weakSelf.contentView.mas_right);
                        make.left.equalTo(weakSelf.contentView.mas_left);
                        make.height.equalTo(@0.5);
                    }];
                    break;
                }
                case 3:{
                    [line mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(weakSelf.contentView.mas_top);
                        make.left.equalTo(weakSelf.contentView.mas_left);
                        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
                        make.width.equalTo(@0.5);
                    }];
                    break;
                }
                default:
                    break;
            }
     
            line.backgroundColor = COLOR(188, 188, 188, 1);
            [_borderArray addObject:line];
        }
    }
    return self;
}
- (void)setItem:(HeartBeatTagItem *)item{
    _item = item;
    self.bottomView.imgView.image = [UIImage imageNamed:item.image];
    self.bottomView.descripLabel.text = item.descriptions;
    
    self.upView.imgView.image = [[UIImage imageNamed:item.image] imageMaskWithColor:[UIColor whiteColor]];
    self.upView.descripLabel.text = item.descriptions;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch =  [touches anyObject];
    CGPoint p = [touch locationInView:[touch view]];
    self.item.selected = !self.item.selected;
    UIBezierPath *beginPath = nil;
    UIBezierPath *endPath = nil;
    if(self.item.selected){
        beginPath = [UIBezierPath bezierPathWithArcCenter:p radius:0.0001 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        endPath = [UIBezierPath bezierPathWithArcCenter:p radius:[self returnMaxR:p] startAngle:0 endAngle:2 * M_PI clockwise:YES];
    }else{
        beginPath = [UIBezierPath bezierPathWithArcCenter:p radius:[self returnMaxR:p] startAngle:0 endAngle:2 * M_PI clockwise:YES];
        endPath = [UIBezierPath bezierPathWithArcCenter:p radius:0.0001  startAngle:0 endAngle:2 * M_PI clockwise:YES];
    }
    _maskLayer.path = endPath.CGPath;
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"path"];
    animate.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    animate.toValue = (__bridge id _Nullable)(endPath.CGPath);
    animate.duration = 0.15;
    [_maskLayer addAnimation:animate forKey:@"HeartBeatTagAnimate"];
    [self.selectSoud play];
}

- (CGFloat)returnMaxR:(CGPoint)p{
    CGFloat maxY = 0;
    if(p.y >= self.height/2){
        maxY = p.y;
    }else{
     maxY = self.height - p.y;
    }
      CGFloat maxX = 0;
    if(p.x >= self.width/2){
        maxX = p.x;
    }else{
        maxX = self.width - p.x;
    }
    return sqrt(pow(maxX, 2) + pow(maxY, 2));
}


@end
