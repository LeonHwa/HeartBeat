//
//  HelpAnimateCollectionViewCell.m
//  HeartBeat
//
//  Created by fander on 2017/3/4.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HelpAnimateCollectionViewCell.h"
#import "Masonry.h"
@interface HelpAnimateCollectionViewCell()
@property (strong, nonatomic) UIImageView *fingerImgView;
@end
@implementation HelpAnimateCollectionViewCell


- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
     self.explainLabel.text = @"“即时心率”可通过分析指间颜色变\n化代表的血流量来测得您的心率";
    self.operateLabel.text = @"将指尖轻放在前置摄像头\n上，使其完全遮挡镜头。读取数据\n过程中，请拿稳手机。";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"how_to_animation_bg_7@2x" ofType:@"png"];
    self.imgView.image = [UIImage imageWithContentsOfFile:path];
    
     NSString *fingerPath = [[NSBundle mainBundle] pathForResource:@"ihr_new_hand_7" ofType:@"png"];

     self.fingerImgView = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:fingerPath]];
//    self.fingerImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imgView addSubview:self.fingerImgView];
    [self.imgView setClipsToBounds:YES];
     __weak typeof(self) weakSelf = self;
    [self.fingerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(weakSelf.imgView);
        make.height.equalTo(weakSelf.imgView.mas_height);
        make.left.equalTo(weakSelf.imgView.mas_left);
        make.right.equalTo(weakSelf.imgView.mas_right);
        
    }];
    
//    [self tipAnimate];
}


- (void)tipAnimate{
         __weak typeof(self) weakSelf = self;
[UIView animateWithDuration:2 animations:^{
    [self.fingerImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgView).offset(weakSelf.imgView.height);
    }];
    [weakSelf layoutIfNeeded];
}];



}

@end
