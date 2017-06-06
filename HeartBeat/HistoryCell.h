//
//  HistoryCell.h
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmpLabel;
@property (nonatomic, strong) HeartBeatData *heartBeatData;
@end
