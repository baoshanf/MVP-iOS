//
//  HKHttpGroupRequest.m
//  HKHttpManager
//
//  Created by hans on 2018/4/9.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HKHttpGroupRequest.h"
#import "HKHttpConstant.h"
#import "HKHttpResponse.h"

@interface HKHttpGroupRequest()

@property (nonatomic, strong) dispatch_semaphore_t lock;

@property (nonatomic, assign) NSUInteger finishedCount;

@property (nonatomic, assign, getter=isFailed) BOOL failed;

@property (nonatomic, copy) HKGroupResponseBlock completeBlock;
@end

@implementation HKHttpGroupRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray new];
        _responseArray = [NSMutableArray new];
    }
    return self;
}

- (void)addRequest:(HKHttpRequest *)request {
    [_requestArray addObject:request];
}
- (BOOL)onFinishedOneRequest:(HKHttpRequest *)request response:(nullable HKHttpResponse *)responseObject {
    BOOL isFinished = NO;
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if (responseObject) {
        [_responseArray addObject:responseObject];
    }
    _failed |= (responseObject.status == HKHttpResponseStatusError);
    
    _finishedCount ++;
    if (_finishedCount == _requestArray.count) {
        if (_completeBlock) {
            _completeBlock(_responseArray.copy, !_failed);
        }
        [self cleanCallbackBlocks];
        isFinished = YES;
    }
    dispatch_semaphore_signal(_lock);
    return isFinished;
}
- (void)cleanCallbackBlocks {
    _completeBlock = nil;
}
#pragma mark - lazy load
- (dispatch_semaphore_t)lock{
    if (!_lock) {
        _lock = dispatch_semaphore_create(1);
    }
    return _lock;
}

@end
