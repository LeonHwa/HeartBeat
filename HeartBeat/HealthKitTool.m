//
//  HealthKitTool.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/3/3.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HealthKitTool.h"
#import <HealthKit/HealthKit.h>
@interface HealthKitTool()
@property (nonatomic, strong) HKHealthStore *helthStore;
@property (nonatomic, assign) BOOL authorize;

@end

@implementation HealthKitTool
SingletonM(HelthKit);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _helthStore = [[HKHealthStore alloc] init];
        
        if([HKHealthStore isHealthDataAvailable]){
        [_helthStore requestAuthorizationToShareTypes:[self dataTypesToWrite] readTypes:[self dataTypesToRead] completion:^(BOOL success, NSError * _Nullable error) {
            if(success){
                _authorize = YES;
            }else{
                _authorize = NO;
            }
        }];
       }
    }
    return self;
}
- (void)storeBmp:(double)bmp{
    if(_authorize){
        NSDictionary *metadata =
        @{HKMetadataKeyDeviceName:@"iOS"};
        
        HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
        HKUnit *bmpUnit = [HKUnit unitFromString:@"count/min"];
        HKQuantity  *quantity = [HKQuantity quantityWithUnit:bmpUnit doubleValue:bmp];
        HKQuantitySample *sameple = [HKQuantitySample  quantitySampleWithType:quantityType quantity:quantity startDate:[NSDate date] endDate:[NSDate date] metadata:metadata];
        [_helthStore saveObject:sameple withCompletion:^(BOOL success, NSError * _Nullable error) {
            if(success){
                NSLog(@"写入成功");
            }else{
                NSLog(@"写入失败");
                NSLog(@"%@",error);
            }
        }];
    }

}


- (NSSet *)dataTypesToWrite {
    HKQuantityType *heartRateType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    
    
    return [NSSet setWithObjects:heartRateType, nil];
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {

    
    HKQuantityType *heartRateType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];

    
    return [NSSet setWithObjects:heartRateType, nil];
}

@end
