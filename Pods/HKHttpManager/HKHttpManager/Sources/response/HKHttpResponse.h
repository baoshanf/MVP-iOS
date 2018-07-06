//
//  HKHttpResponse.h
//  HKHttpManager
//
//  Created by hans on 2018/1/4.
//  Copyright © 2018年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKHttpConstant.h"

/**
 网络响应类
 */
@interface HKHttpResponse : NSObject
@property (nullable, nonatomic, copy, readonly) NSData *rawData;

/**
 请求状态
 */
@property (nonatomic, assign, readonly) HKHttpResponseStatus status;

@property (nullable, nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger statueCode;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonnull, nonatomic, copy, readonly) NSURLRequest *request;

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                   status:(HKHttpResponseStatus)status;

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                    error:(nullable NSError *)error;
@end
