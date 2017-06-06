//
//  MenuTabarViewController.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/24.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "MenuTabarViewController.h"
#import "UIImage+tool.h"
@interface MenuTabarViewController ()

@end

@implementation MenuTabarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 1;
    [self setupTabbar];

//        UINavigationBar *navBar = [UINavigationBar appearance];
//        [navBar setBarTintColor:COLOR(88, 194, 170, 1)];
    
//    self.tabBar.barTintColor = COLOR(88, 194, 170, 1);
}

- (void)setupTabbar{
    NSArray *itemArr =  self.tabBar.items;
    NSArray *titleArr = @[@"历史记录",@"测量",@"设置"];
    NSArray *normalImage = @[@"ic_list~iphone",@"ic_heartrate_measure~iphone",@"ic_settings~iphone"];
    for (NSInteger i = 0; i < itemArr.count; i++) {
        UITabBarItem *item = itemArr[i];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:APP_COLOR} forState:UIControlStateSelected];
        item.title = titleArr[i];
        UIImage *img = [[UIImage imageNamed:normalImage[i]] imageMaskWithColor:APP_COLOR];
        item.image = img;
        item.selectedImage = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
