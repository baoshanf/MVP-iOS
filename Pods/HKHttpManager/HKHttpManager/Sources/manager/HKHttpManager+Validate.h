//
//  HKHttpManager+Validate.h
//  HKHttpManager
//
//  Created by hans on 2018/1/4.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HKHttpManager.h"

@interface HKHttpManager (Validate)
/**
 请求前的拦截器
 
 @param cls 实现 HKRequestInterceptorProtocol 协议的 实体类
 可以在该实体类中做请求前的处理
 */
+ (void)registerRequestInterceptor:(nonnull Class)cls;
+ (void)unregisterRequestInterceptor:(nonnull Class)cls;

/**
 返回数据前的拦截器
 
 @param cls 实现 HKResponseInterceptorProtocol 协议的 实体类
 可以在该实体类中做统一的数据验证
 */
+ (void)registerResponseInterceptor:(nonnull Class)cls;
+ (void)unregisterResponseInterceptor:(nonnull Class)cls;
@end
