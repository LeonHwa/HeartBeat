//
//  HeartBeatDataManager.m
//  HeartBeat
//
//  Created by fander on 2017/2/27.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HeartBeatDataManager.h"

#import <FMDB.h>

@implementation HeartBeatData
@end

@interface HeartBeatDataManager()
{
  FMDatabaseQueue *_queue;
}
@property(nonatomic,strong)FMDatabase *database;
@end
@implementation HeartBeatDataManager

SingletonM(HeartBeatData);

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fullPath = [path stringByAppendingPathComponent:@"Leon.db"];
        _queue = [FMDatabaseQueue databaseQueueWithPath:fullPath];
        _database = [FMDatabase databaseWithPath:fullPath];
        //打开数据库
        if(![_database open])
        {
            NSLog(@"数据库打开失败");
            
        }
       BOOL ret = [_database executeUpdate:@"create table if not exists HeartBeatData (id integer primary key autoincrement,bmp integer,create_timestamp double,tag text)"];
        if(ret){
            NSLog(@"数据库创建成功");
        }else{
         NSLog(@"数据库创建失败");
        }
    }
    return self;
}
- (void)findHeartBeatDataIn:(NSInteger)count result:(void (^)(NSArray *array))block{
    [_queue inDatabase:^(FMDatabase *db) {
        [db open];
        
        NSMutableArray *array = [NSMutableArray array];
        NSMutableString *sql = [NSMutableString stringWithString:@"select * from HeartBeatData  order by create_timestamp desc"];
        if(count != 0){
            [sql appendFormat:@" limit %ld",count];
        }
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            HeartBeatData *model = [[HeartBeatData alloc] init];
            model.bmp = [[rs stringForColumn:@"bmp"] integerValue];
            model.timestamp = [[rs stringForColumn:@"create_timestamp"] doubleValue];
            model.tag  = [rs stringForColumn:@"tag"];
            
            [array addObject:model];
            
        }
        [db close];
        block(array);
    }];
}

- (void)findHeartBeatDataWithTags:(NSArray *)tags result:(void (^)(NSArray *array))block{

    [_queue inDatabase:^(FMDatabase *db) {
        [db open];
        NSMutableArray *array = [NSMutableArray array];
        NSString *sql = [NSString stringWithFormat:@"select * from HeartBeatData where order by create_timestamp desc"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            HeartBeatData *model = [[HeartBeatData alloc] init];
            model.bmp = [[rs stringForColumn:@"bmp"] integerValue];
            model.timestamp = [[rs stringForColumn:@"create_timestamp"] doubleValue];
            model.tag  = [rs stringForColumn:@"tag"];
            
            [array addObject:model];
            
        }
        [db close];
        block(array);
    }];
}

- (void)save:(HeartBeatData *)model{
    [_queue inDatabase:^(FMDatabase *db) {
       [db open];
       NSString *findSql =  [NSString stringWithFormat:@"SELECT * from HeartBeatData  WHERE create_timestamp = %@", [NSString stringWithFormat:@"%f",model.timestamp]];
        if([[db executeQuery:findSql] next] == NO){
            BOOL ret = [db executeUpdate:@"INSERT INTO HeartBeatData (bmp,create_timestamp,tag) VALUES(?,?,?)",[NSString stringWithFormat:@"%ld",model.bmp],[NSString stringWithFormat:@"%f",model.timestamp],model.tag];
            if(ret){
                NSLog(@"插入数据成功");
            }else{
                NSLog(@"插入数据失败");
            }
        }
        [db close];
    }];
}
- (void)remove:(HeartBeatData *)model{
    [_queue inDatabase:^(FMDatabase *db) {
        [db open];
        BOOL ret = [db executeUpdate:@"DELETE  FROM  HeartBeatData WHERE create_timestamp = ?",[NSString stringWithFormat:@"%f",model.timestamp]];
        if(ret){
            NSLog(@"删除数据成功");
        }else{
            NSLog(@"删除数据失败");
        }
        [db close];
    }];
}
@end
