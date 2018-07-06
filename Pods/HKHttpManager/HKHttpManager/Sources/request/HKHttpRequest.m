//
//  HKRequest.m
//  HKHttpManager
//
//  Created by hans on 2018/1/4.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HKHttpRequest.h"
#import "HKHttpConfigure.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+Base64.h"
#import "NSDictionary+JSON.h"

@implementation HKHttpRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        _requestMethod = HKHttpRequestTypePost;
        _reqeustTimeoutInterval = 30.0;
        _encryptParams = @{};
        _normalParams = @{};
        _requestHeader = @{};
        _retryCount = 0;
        _apiVersion = @"1.0";
        
    }
    return self;
}

/**
 生成请求

 @return NSURLRequest
 */
- (NSURLRequest *)generateRequest{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = [self reqeustTimeoutInterval];
    serializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSMutableURLRequest *request = [serializer requestWithMethod:[self httpMethod] URLString:[self.baseURL stringByAppendingString:self.requestURL] parameters:[self generateRequestBody] error:NULL];
    // 请求头
    NSMutableDictionary *header = request.allHTTPHeaderFields.mutableCopy;
    if (!header)
    {
        header = [[NSMutableDictionary alloc] init];
    }
    [header addEntriesFromDictionary:[HKHttpConfigure shareInstance].generalHeaders];
    request.allHTTPHeaderFields = header;
    
    return request.copy;
}

/**
 公共请求参数

 @return 请求参数字典
 */
- (NSDictionary *)generateRequestBody{
    NSDictionary *commonDic = [HKHttpConfigure shareInstance].generalParameters;
//    NSMutableDictionary *encryptDict = @{}.mutableCopy;
//    NSAssert(self.requestPath.length > 0, @"请求 Path 不能为空");
//    encryptDict[@"uri"] = self.requestPath;
//    [encryptDict addEntriesFromDictionary:commonDic];
//    [encryptDict addEntriesFromDictionary:self.encryptParams];
//
//    NSMutableDictionary *rslt = @{}.mutableCopy;
//    [rslt addEntriesFromDictionary:self.normalParams];
#warning 这里要看后台怎么设置
//    rslt[@"params2"] = [[encryptDict toJsonString] base64EncodedString];
    
    
//    NSLog(@"%@", encryptDict);
    return commonDic;
}
- (NSString *)httpMethod{
    HKHttpRequestType type = [self requestMethod];
    switch (type)
    {
        case HKHttpRequestTypePost:
            return @"POST";
        case HKHttpRequestTypeGet:
            return @"GET";
        case HKHttpRequestTypePut:
            return @"PUT";
        case HKHttpRequestTypeDelete:
            return @"DELETE";
        case HKHttpRequestTypePatch:
            return @"PATCH";
        default:
            break;
    }
    return @"GET";
}

- (NSString *)baseURL{
    if (!_baseURL) {
        _baseURL = [HKHttpConfigure shareInstance].generalServer;
    }
    return _baseURL;
}
- (void)dealloc {
    if ([HKHttpConfigure shareInstance].enableDebug) {
        NSLog(@"dealloc: %@", ([self class]));
    }
}
@end
