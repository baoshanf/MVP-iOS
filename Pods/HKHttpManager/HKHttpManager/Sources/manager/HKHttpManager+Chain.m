//
//  HKHttpManager+Chain.m
//  HKHttpManager
//
//  Created by hans on 2018/4/9.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HKHttpManager+Chain.h"
#import "HKHttpChainRequest.h"
#import "HKHttpManager+Group.h"
#import <objc/runtime.h>

@implementation HKHttpManager (Chain)
- (NSMutableDictionary *)chainRequestDictionary {
    return objc_getAssociatedObject(self, @selector(chainRequestDictionary));
}

- (void)setChainRequestDictionary:(NSMutableDictionary *)mutableDictionary {
    objc_setAssociatedObject(self, @selector(chainRequestDictionary), mutableDictionary, OBJC_ASSOCIATION_RETAIN);
}
- (NSString *)sendChainRequest:(nullable HKChainRequestConfigBlock)configBlock complete:(nullable HKGroupResponseBlock)completeBlock {
    HKHttpChainRequest *chainRequest = [[HKHttpChainRequest alloc] init];
    if (configBlock) {
        configBlock(chainRequest);
    }
    
    if (chainRequest.runningRequest) {
        if (completeBlock) {
            [chainRequest setValue:completeBlock forKey:@"_completeBlock"];
        }
        
        NSString *uuid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self __sendChainRequst:chainRequest uuid:uuid];
        return uuid;
    }
    return nil;
}

- (void)__sendChainRequst:(HKHttpChainRequest *)chainRequest uuid:(NSString *)uuid {
    if (chainRequest.runningRequest != nil) {
        if (![self chainRequestDictionary]) {
            [self setChainRequestDictionary:[[NSMutableDictionary alloc] init]];
        }
        __weak __typeof(self) weakSelf = self;
        NSString *taskID = [self sendRequest:chainRequest.runningRequest
                                    complete:^(HKHttpResponse *_Nullable response) {
                                        __weak __typeof(self) strongSelf = weakSelf;
                                        if ([chainRequest onFinishedOneRequest:chainRequest.runningRequest response:response]) {
                                        } else {
                                            if (chainRequest.runningRequest != nil) {
                                                [strongSelf __sendChainRequst:chainRequest uuid:uuid];
                                            }
                                        }
                                    }];
        [self chainRequestDictionary][uuid] = taskID;
    }
}

- (void)cancelChainRequest:(NSString *)taskID {
    // 根据 Chain id 找到 taskid
    NSString *tid = [self chainRequestDictionary][taskID];
    [self cancelRequestWithRequestID:tid];
}
@end
