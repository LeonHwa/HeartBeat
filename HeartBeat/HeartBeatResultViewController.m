//
//  HeartBeatResultViewController.m
//  HeartBeat
//
//  Created by fander on 2017/2/26.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HeartBeatResultViewController.h"
#import "HeartBeatRerultHeader.h"
#import "HeartBeatResultCell.h"
#import "Masonry.h"
#import "HeartBeatDataManager.h"
#import "HealthKitTool.h"
#import "ShareTool.h"
@interface HeartBeatResultViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation HeartBeatResultViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self registerView];
    [self setupButtom];
    [self setupData];
}

- (void)setupData{
    NSArray  *images = @[@"argusicon-HR-just-woke-up~iphone",@"argusicon-HR-before-bed~iphone",@"argusicon-workout~iphone",@"argusicon-HR-post-workout~iphone",@"argusicon-ST-stress~iphone",@"argusicon-HR-resting~iphone",@"argusicon-HR-home~iphone"];
    NSArray  *descriptions = @[@"just woke up",@"Before bed",@"Exercising",@"Post workout",@"Tired",@"Resting",@"Home"];
    self.items = [NSMutableArray array];
    for (NSUInteger i = 0; i < images.count;i++) {
        HeartBeatTagItem *item = [[HeartBeatTagItem alloc] init];
        item.image = images[i];
        item.descriptions = descriptions[i];
        [self.items addObject:item];
    }
    [self.collectionView reloadData];
}
- (void)setupButtom{
    UIButton *bottomBtn = [[UIButton alloc] init];
    [self.view addSubview:bottomBtn];
    [bottomBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.backgroundColor = APP_COLOR;
    if(self.type == HeartBeatResultViewControllerResultType){
     [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
    }else{
     [bottomBtn setTitle:@"分享" forState:UIControlStateNormal];
    }
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightUltraLight];
    __weak typeof(self)  weakSelf = self;
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
}
- (void)done{
    if(self.type == HeartBeatResultViewControllerResultType){
        HeartBeatDataManager *manager = [HeartBeatDataManager sharedHeartBeatData];
        NSMutableArray *tagArr = [NSMutableArray array];
        for (HeartBeatTagItem *item in self.items) {
            if(item.selected){
                [tagArr addObject:item.descriptions];
            }
        }
        NSString *tags = [tagArr componentsJoinedByString:@","];
        self.heartBeatData.tag = tags;
        [manager save:self.heartBeatData];
        [[HealthKitTool sharedHelthKit] storeBmp:self.heartBeatData.bmp];
        [[ShareTool sharedShareTool] getTableViewImage:self.collectionView];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
    }

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        HeartBeatRerultHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeartBeatRerultHeader" forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        header.BackHeartBeatTest = ^(){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
         header.bmp = [NSString stringWithFormat:@"%ld",self.heartBeatData.bmp];
        return header;
    }
    return [UICollectionReusableView new];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 250);
}

- (void)registerView{
    [self.collectionView registerClass:[HeartBeatResultCell class] forCellWithReuseIdentifier:@"HeartBeatResultCell"];
    
    [self.collectionView registerClass: [HeartBeatRerultHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"HeartBeatRerultHeader"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HeartBeatResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeartBeatResultCell" forIndexPath:indexPath];
    cell.item = self.items[indexPath.row];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return  cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(WIDTH/3, (WIDTH /3) * 0.8);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.estimatedItemSize = CGSizeZero;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        __weak typeof(self) weakSelf = self;
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view.mas_top);
            make.left.equalTo(weakSelf.view.mas_left).offset(0);
            make.right.equalTo(weakSelf.view.mas_right).offset(0);
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-40);
        }];

    }
    return _collectionView;
}

@end
