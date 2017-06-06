//
//  ShareTool.h
//  HeartBeat
//
//  Created by Leon.Hwa on 17/3/3.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleTon.h"
#define UMeng_Key @"58b91ee699f0c73b78002420"
@interface ShareTool : NSObject
SingletonH(ShareTool);
- (void)getTableViewImage:(UICollectionView *)collectionView;
@end
