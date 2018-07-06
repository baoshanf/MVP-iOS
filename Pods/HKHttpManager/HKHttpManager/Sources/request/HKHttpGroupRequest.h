//
//  HKHttpGroupRequest.h
//  HKHttpManager
//
//  Created by hans on 2018/4/9.
//  Copyright © 2018年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKHttpRequest, HKHttpResponse;
NS_ASSUME_NONNULL_BEGIN
@interface HKHttpGroupRequest : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<HKHttpRequest *> *requestArray;
@property (nonatomic, strong, readonly) NSMutableArray<HKHttpResponse *> *responseArray;

- (void)addRequest:(HKHttpRequest *)request;

- (BOOL)onFinishedOneRequest:(HKHttpRequest *)request response:(nullable HKHttpResponse *)responseObject;

@end
NS_ASSUME_NONNULL_END

