//
//  HeartBeatResultViewController.h
//  HeartBeat
//
//  Created by fander on 2017/2/26.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HeartBeatResultViewControllerType) {
    HeartBeatResultViewControllerResultType ,
    HeartBeatResultViewControllerShareType
};
@interface HeartBeatResultViewController : UIViewController
@property (strong, nonatomic)HeartBeatData *heartBeatData;
@property (nonatomic, assign) HeartBeatResultViewControllerType  type;
@end
