//
//  HKRequestInterceptorProtocol.h
//  HKHttpManager
//
//  Created by hans on 2018/1/4.
//  Copyright © 2018年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKHttpRequest;
/**
 请求前的拦截协议
 */
@protocol HKRequestInterceptorProtocol <NSObject>

- (BOOL)needRequestWithRequest:(HKHttpRequest *)request;
- (NSData *)cacheDataFromRequest:(HKHttpRequest *)request;
@end
