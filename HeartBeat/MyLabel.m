//
//  MyLabel.m
//  blankTest
//
//  Created by fander on 2017/3/4.
//  Copyright © 2017年 fander. All rights reserved.

//
#import "MyLabel.h"

@implementation MyLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       _insets = UIEdgeInsetsMake(20, 20, 20, 10);
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
_insets = UIEdgeInsetsMake(20, 20, 20, 10);
}
- (void)drawTextInRect:(CGRect)rect{
    //[super drawTextInRect:rect];
   [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _insets)];

}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,
                                                                 self.insets) limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.insets.left;
    rect.origin.y -= self.insets.top;
    rect.size.width += self.insets.left + self.insets.right;
    rect.size.height += self.insets.top + self.insets.bottom;
    _lastRect = rect;
    return rect;

}

@end
