//
//  HistoryCell.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HistoryCell.h"
@interface HistoryCell()
@property (strong, nonatomic) NSDateFormatter *dateformate;
@end
@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeartBeatData:(HeartBeatData *)heartBeatData{

    _heartBeatData = heartBeatData;
   NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:heartBeatData.timestamp];
    self.timeLabel.text = [self.dateformate stringFromDate:date];
    self.bmpLabel.text = [NSString stringWithFormat:@"%ld",heartBeatData.bmp];
    self.tagsLabel.text = heartBeatData.tag;
}

- (NSDateFormatter *)dateformate{
    if(_dateformate == nil){
        _dateformate = [[NSDateFormatter alloc] init];
        _dateformate.dateFormat = @"yyyy/MM/dd hh:mm";
    }
    return _dateformate;
}
@end
