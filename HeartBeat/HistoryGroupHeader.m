//
//  HistoryGroupHeader.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/3/2.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HistoryGroupHeader.h"
#import "Masonry.h"
@interface HistoryGroupHeader()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIButton *filterBtn;
@end

@implementation HistoryGroupHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"分类";
        _leftLabel.textColor = APP_COLOR;
        _leftLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightThin];
        [self addSubview:_leftLabel];
        
        _filterBtn = [[UIButton alloc] init];
        _filterBtn.userInteractionEnabled = NO;
        [_filterBtn setImage:[UIImage imageNamed:@"goPro03"] forState:UIControlStateNormal];
        [self addSubview:_filterBtn];
        
        __weak typeof(self) weakSelf = self;
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(40);
            make.centerY.equalTo(weakSelf);
            
        }];
        [_filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf).offset(60);
            make.top.equalTo(weakSelf.mas_top).offset(10);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
            make.width.equalTo(_filterBtn.mas_height);
        }];
        
        
        UIView *upLine = [[UIView alloc] init];
        upLine.backgroundColor = COLOR(188, 188, 188, 1);
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = COLOR(188, 188, 188, 1);
        [self addSubview:upLine];
        [self addSubview:bottomLine];
        [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left);
          make.top.equalTo(weakSelf.mas_top);
            make.right.equalTo(weakSelf.mas_right);
            make.height.equalTo(@1);
            
        }];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left);
            make.bottom.equalTo(weakSelf.mas_bottom);
            make.right.equalTo(weakSelf.mas_right);
            make.height.equalTo(@1);
            
        }];
    }
    return self;
}

@end
