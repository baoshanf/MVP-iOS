//
//  HKHttpChainRequest.m
//  HKHttpManager
//
//  Created by hans on 2018/4/9.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HKHttpChainRequest.h"
#import "HKHttpRequest.h"
#import "HKHttpResponse.h"

@interface HKHttpChainRequest()

@property (nonatomic, strong) NSMutableArray<HKNextBlock> *nextBlockArray;
@property (nonatomic, strong) NSMutableArray<HKHttpResponse *> *responseArray;

@property (nonatomic, copy) HKGroupResponseBlock completeBlock;
@end
@implementation HKHttpChainRequest
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _responseArray = [NSMutableArray array];
    _nextBlockArray = [NSMutableArray array];
    
    return self;
}

- (HKHttpChainRequest *)onFirst:(HKRequestConfigBlock)firstBlock {
    NSAssert(firstBlock != nil, @"The first block for chain requests can't be nil.");
    NSAssert(_nextBlockArray.count == 0, @"The `-onFirst:` method must called befault `-onNext:` method");
    _runningRequest = [HKHttpRequest new];
    firstBlock(_runningRequest);
    return self;
}

- (HKHttpChainRequest *)onNext:(HKNextBlock)nextBlock {
    NSAssert(nextBlock != nil, @"The next block for chain requests can't be nil.");
    [_nextBlockArray addObject:nextBlock];
    return self;
}


- (BOOL)onFinishedOneRequest:(HKHttpRequest *)request response:(nullable HKHttpResponse *)responseObject {
    BOOL isFinished = NO;
    [_responseArray addObject:responseObject];
    // 失败
    if (responseObject.status == HKHttpResponseStatusError) {
        _completeBlock(_responseArray.copy, NO);
        [self cleanCallbackBlocks];
        isFinished = YES;
        return isFinished;
    }
    // 正常完成
    if (_responseArray.count > _nextBlockArray.count) {
        _completeBlock(_responseArray.copy, YES);
        [self cleanCallbackBlocks];
        isFinished = YES;
        return isFinished;
    }
    /// 继续运行
    _runningRequest = [HKHttpRequest new];
    HKNextBlock nextBlock = _nextBlockArray[_responseArray.count - 1];
    BOOL isSent = YES;
    nextBlock(_runningRequest, responseObject, &isSent);
    if (!isSent) {
        _completeBlock(_responseArray.copy, YES);
        [self cleanCallbackBlocks];
        isFinished = YES;
    }
    return isFinished;
}
- (void)cleanCallbackBlocks {
    _runningRequest = nil;
    _completeBlock = nil;
    [_nextBlockArray removeAllObjects];
}

@end
