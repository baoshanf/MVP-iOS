//
//  MineViewProtocol.h
//  MVP
//
//  Created by hans on 2018/7/6.
//  Copyright © 2018年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineModel.h"
@protocol MineViewProtocol <NSObject>
- (void)onGetMineInfoSuccess:(MineModel *)model;

- (void)onGetMineInfoFail:(NSInteger) errorCode des:(NSString *)des;
@end
