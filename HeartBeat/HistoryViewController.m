//
//  HistoryViewController.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/24.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"
#import "HistoryHeader.h"
#import "HistoryGroupHeader.h"
#import "SortView.h"
#import "HeartBeatResultViewController.h"
@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *heartBeatDataArraty;
@property (nonatomic, weak) HistoryHeader *header;
@property (nonatomic, strong) NSMutableString *sortTags;
@end

@implementation HistoryViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self setupHeader];
    [self addNotification];
   
}
- (void)configure{
    self.title = @"历史记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BG_COLOR;
    
    self.tableView.rowHeight = 68;
    self.tableView.backgroundColor = BG_COLOR;
}

- (void)addNotification{
     __weak typeof(self) weakSelf = self;
 [[NSNotificationCenter defaultCenter ] addObserverForName:SortByTagsNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
     weakSelf.sortTags = note.object;
     [weakSelf getData];
 }];
}
- (void)setupHeader{
   
    HistoryHeader *header= [[HistoryHeader alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    self.tableView.tableHeaderView= header;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.header = header;
    [header draw:YES];
}


- (void)getData{
    __weak typeof(self) weakSelf = self;
 [[HeartBeatDataManager sharedHeartBeatData] findHeartBeatDataIn:0 result:^(NSArray *array) {
          [weakSelf.heartBeatDataArraty removeAllObjects];
     if(weakSelf.sortTags){
         for ( NSUInteger i = 0; i < array.count;i++) {
             HeartBeatData *model = array[i];
             if([model.tag containsString:@","]){
                NSArray *arr =[model.tag componentsSeparatedByString:@","];
                 for (NSString *t in arr) {
                     if([weakSelf.sortTags containsString:t]){
                         [weakSelf.heartBeatDataArraty addObject:model];
                         break;
                     }
                 }
                 
             }else{
                 if([weakSelf.sortTags containsString:model.tag]){
                     [weakSelf.heartBeatDataArraty addObject:model];
                 };
             }
         }
   
     }else{
         [weakSelf.heartBeatDataArraty addObjectsFromArray:array];
        
     }
      [weakSelf.tableView reloadData];
      [weakSelf.header draw:NO];
 }];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HistoryGroupHeader *groupHeader = [[HistoryGroupHeader alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    [groupHeader addTarget:self action:@selector(sort) forControlEvents:UIControlEventTouchUpInside];
    return groupHeader;
}
- (void)sort{
    SortView *sortView = [[SortView alloc] init];
    [sortView show];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.heartBeatDataArraty.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    cell.heartBeatData = self.heartBeatDataArraty[indexPath.row];
    if(indexPath.row == self.heartBeatDataArraty.count - 1){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
      cell.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [[HeartBeatDataManager sharedHeartBeatData] remove:self.heartBeatDataArraty[indexPath.row]];
        [self.heartBeatDataArraty  removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.header draw:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HeartBeatResultViewController *vc = [[HeartBeatResultViewController alloc] init];
    vc.type = HeartBeatResultViewControllerShareType;
    vc.heartBeatData = self.heartBeatDataArraty[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)heartBeatDataArraty{
    if(_heartBeatDataArraty== nil){
        _heartBeatDataArraty= [[NSMutableArray  alloc] init];
    }
    return _heartBeatDataArraty;
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
