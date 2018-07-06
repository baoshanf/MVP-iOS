//
//  HKHttpManager+Group.m
//  HKHttpManager
//
//  Created by hans on 2018/4/9.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HKHttpManager+Group.h"
#import "HKHttpGroupRequest.h"
#import "HKHttpRequest.h"
#import <objc/runtime.h>

@implementation HKHttpManager (Group)
- (NSMutableDictionary *)groupRequestDictionary {
    return objc_getAssociatedObject(self, @selector(groupRequestDictionary));
}

- (void)setGroupRequestDictionary:(NSMutableDictionary *)mutableDictionary {
    objc_setAssociatedObject(self, @selector(groupRequestDictionary), mutableDictionary, OBJC_ASSOCIATION_RETAIN);
}
- (NSString *)sendGroupRequest:(nullable HKGroupRequestConfigBlock)configBlock
                      complete:(nullable HKGroupResponseBlock)completeBlock {
    
    if (![self groupRequestDictionary]) {
        [self setGroupRequestDictionary:[[NSMutableDictionary alloc] init]];
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    HKHttpGroupRequest *groupRequest = [[HKHttpGroupRequest alloc] init];
    configBlock(groupRequest);
    
    if (groupRequest.requestArray.count > 0) {
        if (completeBlock) {
            [groupRequest setValue:completeBlock forKey:@"_completeBlock"];
        }
        
        [groupRequest.responseArray removeAllObjects];
        for (HKHttpRequest *request in groupRequest.requestArray) {
            
            NSString *taskID = [self sendRequest:request complete:^(HKHttpResponse * _Nullable response) {
                if ([groupRequest onFinishedOneRequest:request response:response]) {
                    NSLog(@"finish");
                }
            }];
            [tempArray addObject:taskID];
        }
        NSString *uuid = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self groupRequestDictionary][uuid] = tempArray.copy;
        return uuid;
    }
    return nil;
}

- (void)cancelGroupRequest:(NSString *)taskID {
    NSArray *group = [self groupRequestDictionary][taskID];
    for (NSString *tid in group) {
        [self cancelRequestWithRequestID:tid];
    }
}
@end
