//
//  SingleTon.h
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/28.
//  Copyright © 2017年 Leon. All rights reserved.
//

#ifndef SingleTon_h
#define SingleTon_h
// .h文件
#define SingletonH(name)  + (instancetype)shared##name;

// .m文件
#define SingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}


#endif /* SingleTon_h */
