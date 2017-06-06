//
//  HelpViewController.m
//  HeartBeat
//
//  Created by fander on 2017/3/4.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpCollectionViewCell.h"
#import "HelpAnimateCollectionViewCell.h"
@interface HelpViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *content;
    NSArray *contentDetailArray;
    NSArray *imageNames;;
}
@property (strong, nonatomic) UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
    [self setupBg];
    [self setupData];
    [self addCloseBtn];
}

- (void)addCloseBtn{
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 80 -10,10, 80, 80)];
    [closeBtn setTintColor: [UIColor clearColor]];
    [closeBtn setImage: [UIImage imageNamed:@"play_pen_info_close"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupData{
    content = @"心率是每单位心跳次数，通常以每\n分钟心跳(bmp)表示。";
    contentDetailArray = @[@"热身\n128bmp-139bmp\n\n心率储备的50%-60%\n\n\n该心率是最轻  松的心率区域。\n保持心率在该区域进行热身或放松，可避免受伤。",
                           @"燃脂\n139bmp-151bmp\n\n心率储备的50%-60%\n\n\n如果您的目标是要瘦身，请\n将心率保持在此区域。您的身\n体通过10%碳水化合物、\n5%的蛋白质和85%的脂肪来\n供能。虽然每分钟实际燃烧的卡路里会低于更高区域,但您\n可以更长时间地保持运动以消耗\n更多的卡路里"];
    imageNames = @[@"warm_up_box",@"fat_burn_box",@"cardio_box",@"extreme_box",@"max_box"];
}
- (void)setupLayout{
    self.layout.itemSize = CGSizeMake(WIDTH, HEIGH);
    self.collectionView.backgroundColor = [UIColor clearColor];
}
- (void)setupBg{
   NSString *path = [[NSBundle mainBundle] pathForResource:@"LaunchImage" ofType:@"png"];
   self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    self.bgImageView.frame = self.view.bounds;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.bgImageView belowSubview:self.collectionView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.view.bounds;
    [self.bgImageView addSubview:effectView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
    HelpAnimateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HelpAnimateCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }else{
        HelpCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HelpCollectionViewCell" forIndexPath:indexPath];
        if(indexPath.row == 0){
            cell.contentLabel.text = content;
        }else{
            cell.contentLabel.text = @"";
        }
        cell.contentDetailLabel.text = contentDetailArray[0];
        cell.imageName = imageNames[indexPath.row];
        return cell;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
