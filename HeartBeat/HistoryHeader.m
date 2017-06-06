//
//  HistoryHeader.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HistoryHeader.h"
#import "Masonry.h"
#define COLUMN_COUNT 10
#define OFFSET 30

#define MIN_BMP 40.0
#define MAX_BMP 120.0
@interface HistoryHeader()
@property (nonatomic, strong) NSMutableArray *layerArray;
@property (nonatomic, strong) NSArray *heartBeats;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) CAShapeLayer *yLine;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (assign, nonatomic) BOOL animate;
@end
@implementation HistoryHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"Make at least two measure to view graph";
        _tipLabel.textColor = [UIColor darkGrayColor];
        _tipLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
        [self addSubview:_tipLabel];
        _minLabel = [[UILabel alloc] init];
         _maxLabel = [[UILabel alloc] init];
        _middleLabel = [[UILabel alloc] init];
        
        [self setupLabel:_minLabel width:[NSString stringWithFormat:@"%ld",(NSUInteger)MIN_BMP]];
        [self setupLabel:_maxLabel width:[NSString stringWithFormat:@"%ld",(NSUInteger)MAX_BMP]];
        [self setupLabel:_middleLabel width:[NSString stringWithFormat:@"%ld",(NSUInteger)((MAX_BMP - MIN_BMP)/2 + MIN_BMP)]];

        __weak typeof(self) weakSelf = self;
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-30);
            make.bottom.centerX.equalTo(weakSelf);
        }];
    }
    return self;
}
- (void)setupLabel:(UILabel *)label width:(NSString *)text{
    label.text = text;
    [label sizeToFit];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightUltraLight];
    [self addSubview:label];
}
- (void)draw:(BOOL)animate{
    _animate = animate;
   dispatch_async(dispatch_get_main_queue(), ^{
       for (CAShapeLayer *layer in self.layerArray) {
           [layer removeFromSuperlayer];
       }
       [_yLine removeFromSuperlayer];
       [self.layerArray removeAllObjects];
       [self getData];
       if(self.heartBeats.count){
        [self drawCoordinate];   
        [self drawColumn];
        
           self.backgroundColor = [UIColor whiteColor];
           self.tipLabel.hidden = YES;
           self.minLabel.hidden = NO;
           self.maxLabel.hidden = NO;
           self.middleLabel.hidden = NO;
       }else{
           self.backgroundColor = BG_COLOR;
           self.tipLabel.hidden = NO;
           self.minLabel.hidden = YES;
           self.maxLabel.hidden = YES;
           self.middleLabel.hidden = YES;
       }
   });

}


- (void)getData{
    __weak typeof(self) weakSelf = self;
    [[HeartBeatDataManager sharedHeartBeatData] findHeartBeatDataIn:10 result:^(NSArray *array) {
        weakSelf.heartBeats = array;
    }];
    
}
- (void)drawCoordinate{
    _yLine = [CAShapeLayer layer];
    _yLine.strokeColor = COLOR(188, 188, 188, 1).CGColor;
    _yLine.fillColor = [UIColor clearColor].CGColor;
    _yLine.lineWidth = 1;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat height = self.height - OFFSET * 2;
    CGFloat yMargin = height/2.0;
    

    for (NSUInteger i = 0; i < 3; i++) {
        [path moveToPoint:CGPointMake(OFFSET, i * yMargin + OFFSET)];
        [path addLineToPoint:CGPointMake(self.width - OFFSET, i * yMargin + OFFSET)];
        switch (i) {
            case 0:
                _maxLabel.frame = CGRectMake(OFFSET - _maxLabel.width, i * yMargin + OFFSET - _maxLabel.height/2, _maxLabel.width, _maxLabel.height);
                break;
            case 1:
                _middleLabel.frame = CGRectMake(OFFSET - _middleLabel.width, i * yMargin + OFFSET - _middleLabel.height/2, _middleLabel.width, _middleLabel.height);
                break;
            case 2:
                 _minLabel.frame = CGRectMake(OFFSET - _minLabel.width, i * yMargin + OFFSET - _minLabel.height/2, _minLabel.width, _minLabel.height);
                break;
                
            default:
                break;
        }
    }

    _yLine.path = path.CGPath;
    [self.layer addSublayer:_yLine];
}

- (void)drawColumn{
    CGFloat xMargin = 14;
    CGFloat w = (WIDTH - (COLUMN_COUNT - 1) * xMargin - OFFSET * 2)/COLUMN_COUNT;
    CGFloat startX = w/2;
    CGFloat screenH = self.height - OFFSET * 2;
    //因为每个柱子都要做动画 所以每个柱子都是单独的layer和path
    for (NSUInteger i = 0; i < self.heartBeats.count;i++) {
        HeartBeatData *data  = self.heartBeats[i];
        CGFloat percent = (data.bmp - MIN_BMP)/(MAX_BMP - MIN_BMP);
        CGFloat delta = percent * screenH;
        CAShapeLayer *shaprpLayer = [CAShapeLayer layer];
        shaprpLayer.lineWidth = w;
        shaprpLayer.strokeColor = APP_COLOR.CGColor;
        shaprpLayer.fillColor = [UIColor clearColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(OFFSET + startX + (w +xMargin) * i, screenH + OFFSET)];
        [path addLineToPoint:CGPointMake(OFFSET +startX + (w +xMargin) * i, OFFSET + (screenH - delta))];
        shaprpLayer.path = path.CGPath;
        [self.layer addSublayer:shaprpLayer];
        [self.layerArray addObject:shaprpLayer];
        
        if(_animate){
        shaprpLayer.strokeEnd = 1;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 0.5;
        animation.fromValue = @0;
        animation.toValue = @1;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.removedOnCompletion = NO;
        [shaprpLayer addAnimation:animation forKey:@"clumnAnimation"];
        }
    }
}
- (NSMutableArray *)layerArray{
    if(_layerArray == nil){
        _layerArray= [[NSMutableArray  alloc] init];
    }
    return _layerArray;
}
@end
