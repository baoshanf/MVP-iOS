//
//  HKHttpManager+Validate.m
//  HKHttpManager
//
//  Created by hans on 2018/1/4.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HKHttpManager+Validate.h"

@implementation HKHttpManager (Validate)
+ (void)registerResponseInterceptor:(nonnull Class)cls{
    if (![cls conformsToProtocol:@protocol(HKResponseInterceptorProtocol)])
    {
        return;
    }
    
    [HKHttpManager unregisterResponseInterceptor:cls];
    
    HKHttpManager *share = [HKHttpManager shareManager];
    [share.responseInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterResponseInterceptor:(nonnull Class)cls{
    HKHttpManager *share = [HKHttpManager shareManager];
    
    for (id obj in share.responseInterceptorObjectArray)
    {
        if ([obj isKindOfClass:[cls class]])
        {
            [share.responseInterceptorObjectArray removeObject:obj];
            break;
        }
    }
}

+ (void)registerRequestInterceptor:(nonnull Class)cls{
    if (![cls conformsToProtocol:@protocol(HKRequestInterceptorProtocol)])
    {
        return;
    }
    
    [HKHttpManager unregisterRequestInterceptor:cls];
    
    HKHttpManager *share = [HKHttpManager shareManager];
    [share.requestInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterRequestInterceptor:(nonnull Class)cls{
    HKHttpManager *share = [HKHttpManager shareManager];
    for (id obj in share.requestInterceptorObjectArray)
    {
        if ([obj isKindOfClass:[cls class]])
        {
            [share.requestInterceptorObjectArray removeObject:obj];
            break;
        }
    }
}
@end
