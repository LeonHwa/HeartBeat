//
//  SortView.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/3/2.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "SortView.h"
#import "Masonry.h"


NSString *const SortByTagsNotification = @"SortByTagsNotification";
#pragma mark--SortViewController
@interface SortViewController : UIViewController
@property (nonatomic, weak) SortView *sortView;
@end
@implementation SortViewController
- (void)loadView{
    self.view = self.sortView;
}

@end


@interface SortTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *checkBtn;
@end
@implementation SortTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_checkBtn];
        [_checkBtn setImage:[UIImage imageNamed:@"checkMark"] forState:UIControlStateSelected];
        
        _checkBtn.userInteractionEnabled = NO;
        __weak typeof(self) weakSelf = self;
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(0);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(0);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(0);
              make.width.equalTo(_checkBtn.mas_width);
        }];
  }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if(highlighted){
    self.backgroundColor = COLOR(124, 199, 167, 0.8);
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}
@end

#pragma mark--SortTableHeader
@interface SortTableHeader : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, copy) void  (^closeHandle)(void);
@end
@implementation SortTableHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = APP_COLOR;
        
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = COLOR(210, 210, 210, 1);
        [self addSubview:whiteView];
         __weak typeof(self) weakSelf = self;
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.equalTo(weakSelf.mas_left).offset(0);
             make.right.equalTo(weakSelf.mas_right).offset(0);
             make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        }];
        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"标签分类";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightThin];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top).offset(8);
             make.bottom.equalTo(whiteView.mas_bottom).offset(-8);
            make.center.equalTo(weakSelf);
        }];
        
        _closeBtn = [[UIButton alloc] init];
        [self addSubview:_closeBtn];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(0);
            make.right.equalTo(weakSelf).offset(0);
            make.bottom.equalTo(whiteView).offset(0);
            make.width.equalTo(_closeBtn.mas_height);
        }];
    }
    return self;
}

- (void)close{
    if(self.closeHandle){
        self.closeHandle();
    }
}
@end



#pragma mark--SortView
@interface SortView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSMutableArray *selectItems;

@end
@implementation SortView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tags = @[@"just woke up",@"Before bed",@"Exercising",@"Tired"];
        self.selectItems = [NSMutableArray array];
        for (NSUInteger i = 0; i < _tags.count; i++) {
            [self.selectItems addObject:@(NO)];
        }
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:containerView];
        containerView.layer.shadowColor = [UIColor grayColor].CGColor;
        containerView.layer.shadowRadius = 4;
        containerView.layer.shadowOpacity = 0.8;

        __weak typeof(self) weakSelf = self;
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(weakSelf).multipliedBy(0.5);
            make.center.equalTo(weakSelf);
            make.right.equalTo(weakSelf.mas_right).offset(-20);
            make.left.equalTo(weakSelf.mas_left).offset(20);
        }];
        
         SortTableHeader *header = [[SortTableHeader alloc] init];
        header.closeHandle =^(){
            weakSelf.window.rootViewController = nil;
            [weakSelf.window removeFromSuperview];
            [containerView removeFromSuperview];
            [weakSelf removeFromSuperview];
        };
        [containerView addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView.mas_top).offset(0);
            make.height.equalTo(@40);
            make.right.equalTo(containerView.mas_right).offset(0);
            make.left.equalTo(containerView.mas_left).offset(0);
        }];
        
        
        _tableView= [[UITableView  alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = COLOR(190, 78, 73, 0.8);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = COLOR(197, 122, 118, 1);;
    
        [containerView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(containerView.mas_top).offset(40);
            make.bottom.equalTo(containerView.mas_bottom).offset(0);
            make.right.equalTo(containerView.mas_right).offset(0);
            make.left.equalTo(containerView.mas_left).offset(0);
        }];
      
    }
    return self;
}
- (void)show{
    SortViewController *viewController = [[SortViewController alloc] init];
    viewController.sortView = self;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
     self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     self.window.opaque = NO;
     self.window.windowLevel = 2002.0;
     self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tags.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString * ID = @"cell";
    SortTableViewCell *cell = [[SortTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    if(!cell){
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.textLabel.text = _tags[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL select = [self.selectItems[indexPath.row] boolValue];
    SortTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checkBtn.selected = !select;
    self.selectItems[indexPath.row] = @(!select);
    NSMutableString *tags = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < self.selectItems.count; i++) {
        if([self.selectItems[i] boolValue]){
            [tags appendFormat:@"%@,",_tags[i]];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SortByTagsNotification object:tags];
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
