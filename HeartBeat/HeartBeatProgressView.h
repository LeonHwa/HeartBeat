//
//  HeartBeatProgressView.h
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/24.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartBeatProgressView : UIView
@property (nonatomic, strong) UILabel *bmpLabel;
- (void)animateBeat;
//- (void)setProgress:(double)progress;
- (void)progressBegin;
- (void)progressPause;
@end
