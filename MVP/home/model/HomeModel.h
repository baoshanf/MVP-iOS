//
//  HomeModel.h
//  MVP
//
//  Created by baoshan on 17/2/8.
//  Copyright © 2017年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
//"count":20,
//"start":0,
//"total":1037,
//"books":Array[20]
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,assign)NSInteger start;
@property (nonatomic,assign)NSInteger total;
@property (nonatomic,assign)NSArray *books;
@end
