//
//  HeartBeatDataManager.h
//  HeartBeat
//
//  Created by fander on 2017/2/27.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleTon.h"

@interface HeartBeatData : NSObject
@property (nonatomic, assign) double  timestamp;
@property (nonatomic, assign) NSInteger  bmp;
@property (nonatomic, copy) NSString  *tag;
@end


@interface HeartBeatDataManager : NSObject

SingletonH(HeartBeatData)

- (void)findHeartBeatDataIn:(NSInteger)count result:(void (^)(NSArray *array))block;
- (void)save:(HeartBeatData *)model;
- (void)remove:(HeartBeatData *)model;
- (void)findHeartBeatDataWithTags:(NSArray *)tags result:(void (^)(NSArray *array))block;
@end
