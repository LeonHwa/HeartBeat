//
//  HelpCollectionViewCell.h
//  HeartBeat
//
//  Created by fander on 2017/3/4.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLabel.h"
@interface HelpCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet MyLabel *contentDetailLabel;
@property (copy, nonatomic) NSString *imageName;
@end
