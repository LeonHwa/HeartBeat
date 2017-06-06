//
//  ShareTool.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/3/3.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "ShareTool.h"

@implementation ShareTool
SingletonM(ShareTool);
- (void)getTableViewImage:(UICollectionView *)collectionView{
    CGPoint originOffset = collectionView.contentOffset;
    CGRect originFrame = collectionView.frame;
    
    collectionView.contentOffset = CGPointZero;
    NSLog(@"%f  %f",collectionView.contentSize.width,collectionView.contentSize.height);
    collectionView.frame = CGRectMake(0, 0, collectionView.contentSize.width, collectionView.contentSize.height);
    
    UIGraphicsBeginImageContextWithOptions(collectionView.contentSize, YES, [UIScreen mainScreen].scale);
    CGContextRef contect = UIGraphicsGetCurrentContext();
    [collectionView.layer renderInContext:contect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    collectionView.contentOffset = originOffset;
    collectionView.frame = originFrame;
    
    UIGraphicsEndImageContext();
    if(image){
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error){
        NSLog(@"保存失败%@",error);
    }else{
        NSLog(@"保存成功");
    }
}

@end
