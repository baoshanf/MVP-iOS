//
//  DataBaseManager.h
//  MVP
//
//  Created by hans on 2017/12/6.
//  Copyright © 2017年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "FMDatabase+Mapping.h"

#define NULLABLE(value) (value != nil ? value : [NSNull null])
@interface DataBaseManager : NSObject

@property (nonatomic,strong,readonly)FMDatabaseQueue *dbQueue;
/**
 *  单例
 */
+ (instancetype)shareInstance;
@end
