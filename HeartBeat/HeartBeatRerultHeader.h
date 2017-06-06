//
//  HeartBeatRerultHeader.h
//  HeartBeat
//
//  Created by fander on 2017/2/26.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartBeatRerultHeader : UICollectionReusableView
@property (copy, nonatomic) NSString *bmp;
@property (nonatomic, copy) void (^BackHeartBeatTest)(void);
@end
