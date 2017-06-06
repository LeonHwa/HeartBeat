//
//  UIImage+tool.h
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/24.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface UIImage (tool)
- (UIImage *)imageMaskWithColor:(UIColor *)maskColor;
- (UIColor *)averageColorPrecise;
- (UIColor *)averageColor;
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end
