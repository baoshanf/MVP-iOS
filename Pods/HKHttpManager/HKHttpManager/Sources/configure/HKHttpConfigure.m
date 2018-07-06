//
//  HKNetConfigure.m
//  HKHttpManager
//
//  Created by hans on 2018/1/4.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HKHttpConfigure.h"

@implementation HKHttpConfigure
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static HKHttpConfigure *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _enableDebug = NO;
    }
    return self;
}
#pragma mark - interface
/**
 添加公共请求参数
 */
+ (void)addGeneralParameter:(NSString *)sKey value:(id)sValue {
    HKHttpConfigure *manager = [HKHttpConfigure shareInstance];
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    mDict[sKey] = sValue;
    [mDict addEntriesFromDictionary:manager.generalParameters];
    manager.generalParameters = mDict.copy;
}

/**
 移除请求参数
 */
+ (void)removeGeneralParameter:(NSString *)sKey {
    HKHttpConfigure *manager = [HKHttpConfigure shareInstance];
    NSMutableDictionary *mDict = manager.generalParameters.mutableCopy;
    [mDict removeObjectForKey:sKey];
    manager.generalParameters = mDict.copy;
}
@end
