//
//  HKResponseInterceptorProtocol.h
//  HKHttpManager
//
//  Created by hans on 2018/1/4.
//  Copyright © 2018年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKHttpResponse;
/**
 网络响应返回前的拦截协议
 */
@protocol HKResponseInterceptorProtocol <NSObject>
- (void)validatorResponse:(HKHttpResponse *)rsp;
@end
