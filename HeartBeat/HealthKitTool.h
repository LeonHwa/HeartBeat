//
//  HealthKitTool.h
//  HeartBeat
//
//  Created by Leon.Hwa on 17/3/3.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleTon.h"
@interface HealthKitTool : NSObject

- (void)storeBmp:(double)bmp;

SingletonH(HelthKit);
@end
