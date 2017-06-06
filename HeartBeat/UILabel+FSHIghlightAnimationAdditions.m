//
//  UILabel+FSHIghlightAnimationAdditions.m
//  Heartbeat
//
//  Created by michael leybovich on 10/19/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import "UILabel+FSHIghlightAnimationAdditions.h"

@implementation UILabel (FSHIghlightAnimationAdditions)

- (void)setTextWithChangeAnimation:(NSString*)text
{
    NSLog(@"value changing");
    self.text = text;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15f] CGColor];
    maskLayer.contents = (id)[[UIImage imageNamed:@"Mask.png"] CGImage];
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(self.frame.size.width * -1, 0.0f, self.frame.size.width * 2, self.frame.size.height);
    CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    maskAnim.byValue = [NSNumber numberWithFloat:self.frame.size.width];
    maskAnim.repeatCount = FLT_MAX;
    maskAnim.duration = 2.0f;
    [maskLayer addAnimation:maskAnim forKey:@"slideAnim"];
    maskAnim.removedOnCompletion = NO;
    self.layer.mask = maskLayer;
}

@end
