//
//  HKHttpManager+Group.h
//  HKHttpManager
//
//  Created by hans on 2018/4/9.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HKHttpManager.h"
#import "HKHttpConstant.h"

@interface HKHttpManager (Group)
- (NSString *)sendGroupRequest:(nullable HKGroupRequestConfigBlock)configBlock
                      complete:(nullable HKGroupResponseBlock)completeBlock;


- (void)cancelGroupRequest:(NSString *)taskID;
@end
