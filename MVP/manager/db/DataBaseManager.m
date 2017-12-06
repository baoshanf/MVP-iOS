//
//  DataBaseManager.m
//  MVP
//
//  Created by hans on 2017/12/6.
//  Copyright © 2017年 hans. All rights reserved.
//

#import "DataBaseManager.h"

@implementation DataBaseManager
/**
 *  单例
 */
+ (instancetype)sharedInstance{
    
    static DataBaseManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}
/**
 *  构造函数
 */
- (instancetype)init{
    
    if (self = [super init]) {
        [self initDatabase];
    }
    return self;
}

/**
 *  初始化
 */
- (void)initDatabase{
    
    long long userId;
    // 数据库路径
    NSString *path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                       stringByAppendingPathComponent:@"sunshineHealthy"]
                      stringByAppendingPathComponent:[NSString stringWithFormat:@"%llu", userId]];
    
    // 创建数据库保存路径
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    
    NSString *dbPath = [path stringByAppendingString:@"sunshineHealthy.sqlite"];
    NSLog(@"数据库路径:[%@]",dbPath);
    
    //数据库队列
    _dbQueue = [[FMDatabaseQueue alloc]initWithPath:dbPath];
    //    [DBUpdateManager updateDatabase];
}

@end
