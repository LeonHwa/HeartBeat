//
//  HeartBeatNavigationController.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HeartBeatNavigationController.h"

@interface HeartBeatNavigationController ()

@end

@implementation HeartBeatNavigationController


+ (void)initialize{
   UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                     NSForegroundColorAttributeName:APP_COLOR}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count == 2) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            viewController.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, self.tabBarController.tabBar.height);
                self.navigationBar.alpha = 0;

            } completion:nil];
    }

}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.topViewController.tabBarController.tabBar.transform = CGAffineTransformIdentity;
            self.navigationBar.alpha = 1;
    } completion:nil];
    
    return [super popViewControllerAnimated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
