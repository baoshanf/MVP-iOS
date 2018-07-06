//
//  HKHttpConstant.h
//  HKHttpManager
//
//  Created by hans on 2018/1/4.
//  Copyright © 2018年 hans. All rights reserved.
//

#ifndef HKHttpConstant_h
#define HKHttpConstant_h

#import "HKRequestInterceptorProtocol.h"
#import "HKResponseInterceptorProtocol.h"

@class HKHttpResponse,HKHttpRequest,HKHttpGroupRequest,HKHttpChainRequest;

typedef NS_ENUM (NSUInteger, HKHttpRequestType){
    HKHttpRequestTypeGet,
    HKHttpRequestTypePost,
    HKHttpRequestTypePut,
    HKHttpRequestTypeDelete,
    HKHttpRequestTypePatch
};

typedef NS_ENUM (NSUInteger, HKHttpResponseStatus){
    HKHttpResponseStatusSuccess = 1,
    HKHttpResponseStatusError
};
///响应配置 Block
typedef void (^HKHttpResponseBlock)(HKHttpResponse * _Nullable response);
typedef void (^HKGroupResponseBlock)(NSArray<HKHttpResponse *> * _Nullable responseObjects, BOOL isSuccess);
typedef void (^HKNextBlock)(HKHttpRequest * _Nullable request, HKHttpResponse * _Nullable responseObject, BOOL * _Nullable isSent);

/// 请求配置 Block
typedef void (^HKRequestConfigBlock)(HKHttpRequest * _Nullable request);

typedef void (^HKGroupRequestConfigBlock)(HKHttpGroupRequest * _Nullable groupRequest);

typedef void (^HKChainRequestConfigBlock)(HKHttpChainRequest * _Nullable chainRequest);
#endif /* HKHttpConstant_h */
