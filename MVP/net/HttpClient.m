//
//  HttpClient.m
//  MVP
//
//  Created by baoshan on 17/2/8.
//  Copyright © 2017年 hans. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworking.h"
#import "HttpResponseHandle.h"
#import "HKHttpManagerHeader.h"

@interface HttpClient ()

/**
 响应处理器对象
 */
@property (nonatomic,weak) id<HttpResponseHandle> responseHandle;

@end

@implementation HttpClient

/**
 初始化方法
 */
- (instancetype)initWithHandle:(id<HttpResponseHandle>)responseHandle
{
    self = [super init];
    if (self) {
        //指定delegate
        _responseHandle = responseHandle;
        
        [HKHttpConfigure shareInstance].generalServer = @"https://www.apiopen.top/";
    }
    return self;
}

- (NSString *_Nullable)post:(NSString *)URLString parameters:(id)parameters{
  NSString *requestId =  [[HKHttpManager shareManager] sendRequestWithConfigBlock:^(HKHttpRequest * _Nullable request) {
        request.requestURL = URLString;
        request.requestMethod = HKHttpRequestTypePost;
        request.normalParams = parameters;
    } complete:^(HKHttpResponse * _Nullable response) {
        if (response.status == HKHttpResponseStatusSuccess) {
            //返回响应
            if([_responseHandle respondsToSelector:@selector(onSuccess:)]){
                [_responseHandle onSuccess:response];
            }
        }else{
            if ([_responseHandle respondsToSelector:@selector(onFail:errCode:errInfo:)]) {
                [_responseHandle onFail:parameters  errCode:response.statueCode errInfo:response.content];
            }
        }
    }];
    return requestId;
    
}

- (NSString *_Nullable)get:(NSString *)URLString parameters:(id)parameters{
  NSString *requestId = [[HKHttpManager shareManager]sendRequestWithConfigBlock:^(HKHttpRequest * _Nullable request) {
        request.requestMethod = HKHttpRequestTypeGet;
        request.requestURL = URLString;
        request.normalParams = parameters;
    } complete:^(HKHttpResponse * _Nullable response) {
        if (response.status == HKHttpResponseStatusSuccess) {
            //返回响应
            if([_responseHandle respondsToSelector:@selector(onSuccess:)]){
                [_responseHandle onSuccess:response];
            }
        }else{
            if ([_responseHandle respondsToSelector:@selector(onFail:errCode:errInfo:)]) {
                [_responseHandle onFail:parameters  errCode:response.statueCode errInfo:response.content];
            }
        }
    }];
    return requestId;
    
}

@end
