//
//  HomeBannerDao.m
//  MVP
//
//  Created by hans on 2017/10/9.
//  Copyright © 2017年 hans. All rights reserved.
//

#import "HomeBannerDao.h"
#import "HomeBannerModel.h"
#import "DataBaseManager.h"

@implementation HomeBannerDao

/**
 插入

 @param model 插入的对象
 @param complection 回调
 */
+ (void)saveHomeBannerWithHomeModel:(HomeBannerModel *)model complection:(void(^)(BOOL success)) complection{
    [[DataBaseManager shareInstance].dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [self createTable:db];
       BOOL success = [db executeInsertOrReplaceInTable:HomeBannerTableName withParameterDictionary:@{@"banner_url":NULLABLE(model.bannerUrl),
                                                                                        @"banner_name":NULLABLE(model.bannerName)
                                                                                        }];
        if (complection) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complection(success);
            });
        }
    }];
}

/**
 查询

 @param completion 回调
 */
+ (void)loadHomeBannerCompletion:(void (^)(HomeBannerModel *model))completion{
    [[DataBaseManager shareInstance].dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [self createTable:db];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",HomeBannerTableName];
        FMResultSet *rs = [db executeQuery:sql];
        HomeBannerModel *model = [[HomeBannerModel alloc] init];
        while ([rs next]) {
            model.bannerUrl = [rs stringForColumn:@"banner_url"];
            model.bannerName = [rs stringForColumn:@"banner_name"];
        }
        [rs close];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(model);
            }
        });
    }];
}

/**
 删除

 @param bannerUrl bannerUrl
 @param complection 回调
 */
+ (void)deleteHomeBannerWithBannerUrl:(NSString *)bannerUrl complection:(void(^)(void)) complection{
    [[DataBaseManager shareInstance].dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [self createTable:db];
        NSString *sql = [NSString stringWithFormat:@"delete from %@ while banner_url = ?",HomeBannerTableName];
        [db executeUpdate:sql withArgumentsInArray:@[bannerUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complection) {
                complection();
            }
        });
    }];
}
+ (void)createTable:(FMDatabase *)db{
    if (![db tableExists:HomeBannerTableName]) {
        NSDictionary *table = @{@"banner_url":@"text",
                                @"banner_name":@"text"
                                };
        [db createTable:HomeBannerTableName columns:table];
    }
}
@end
