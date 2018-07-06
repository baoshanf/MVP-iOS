//
//  HKHttpLogger.h
//  HKHttpManager
//
//  Created by hans on 2018/1/4.
//  Copyright © 2018年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKHttpRequest;
@interface HKHttpLogger : NSObject

/**
 输出签名
 */
+ (void)logSignInfoWithString:(NSString *)sign;


/**
 请求参数
 */
+ (void)logDebugInfoWithRequest:(HKHttpRequest *)request;


/**
 响应数据输出
 */
+ (void)logDebugInfoWithTask:(NSURLSessionTask *)sessionTask data:(NSData *)data error:(NSError *)error;
@end
