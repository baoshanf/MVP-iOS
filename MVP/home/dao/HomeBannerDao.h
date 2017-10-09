//
//  HomeBannerDao.h
//  MVP
//
//  Created by hans on 2017/10/9.
//  Copyright © 2017年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomeBannerModel;
static NSString *const HomeBannerTableName = @"home_banner";
@interface HomeBannerDao : NSObject

/**
 插入
 
 @param model 插入的对象
 @param complection 回调
 */
+ (void)saveHomeBannerWithHomeModel:(HomeBannerModel *)model complection:(void(^)(BOOL success)) complection;
/**
 查询
 
 @param completion 回调
 */
+ (void)loadHomeBannerCompletion:(void (^)(HomeBannerModel *model))completion;

/**
 删除
 
 @param bannerUrl bannerUrl
 @param complection 回调
 */
+ (void)deleteHomeBannerWithBannerUrl:(NSString *)bannerUrl complection:(void(^)(void)) complection;
@end
