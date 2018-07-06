//
//  HKHttpManager+Chain.h
//  HKHttpManager
//
//  Created by hans on 2018/4/9.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HKHttpManager.h"

@interface HKHttpManager (Chain)
- (NSString *)sendChainRequest:(nullable HKChainRequestConfigBlock)configBlock
                      complete:(nullable HKGroupResponseBlock)completeBlock;

- (void)cancelChainRequest:(NSString *)taskID;
@end
