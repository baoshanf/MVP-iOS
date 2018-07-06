//
//  MinePresenter.h
//  MVP
//
//  Created by hans on 2018/7/6.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "HttpPresenter.h"
#import "MineViewProtocol.h"

@interface MinePresenter : HttpPresenter <id<MineViewProtocol>>
- (void)getMineInfoWithURLString:(NSString *)URLString param:(NSDictionary *)param;
@end
