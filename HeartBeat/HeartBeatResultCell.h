//
//  HeartBeatResultCell.h
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/27.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartBeatTagItem : NSObject
@property (nonatomic, copy) NSString  *image;
@property (nonatomic, copy) NSString  *descriptions;
@property (nonatomic, assign) BOOL  selected;
@end

@interface HeartBeatResultCell : UICollectionViewCell

@property (nonatomic, strong) HeartBeatTagItem *item;


@end


