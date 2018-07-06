//
//  HttpClient.h
//  MVP
//
//  Created by baoshan on 17/2/8.
//  Copyright © 2017年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 本类只写了POST、GET两种请求方法，如有需要的可参照这两个方法来写
 */
@protocol HttpResponseHandle;

@interface HttpClient : NSObject


/**
 构造方法
 */
- (instancetype)initWithHandle:(id<HttpResponseHandle>) responseHandle;

/**
 POST 请求

 @param URLString 路径
 @param parameters 参数
 @return 请求id
 */
- (NSString *)post:(NSString *)URLString parameters:(id)parameters;

/**
 GET 请求

 @param URLString 路径
 @param parameters 参数
 @return 请求id
 */
- (NSString *)get:(NSString *)URLString parameters:(id)parameters;


@end
