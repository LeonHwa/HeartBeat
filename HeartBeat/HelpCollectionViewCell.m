//
//  HelpCollectionViewCell.m
//  HeartBeat
//
//  Created by fander on 2017/3/4.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HelpCollectionViewCell.h"
#import "Masonry.h"
@interface HelpCollectionViewCell()
@property (strong, nonatomic) UIImageView *imgView;
@end

@implementation HelpCollectionViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
     _imgView = [[UIImageView alloc] init];
    [self.contentView insertSubview:_imgView belowSubview:self.contentDetailLabel];
    __weak typeof(self) weakSelf = self;
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentDetailLabel);
         make.bottom.equalTo(weakSelf.contentDetailLabel);
         make.left.equalTo(weakSelf.contentDetailLabel);
         make.right.equalTo(weakSelf.contentDetailLabel);
    }];
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   NSLog(@"%@",NSStringFromCGRect(self.contentLabel.frame));

}
- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imgView.image = [UIImage imageNamed:imageName];
}
@end
