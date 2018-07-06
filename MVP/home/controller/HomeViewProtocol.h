//
//  HomeViewProtocol.h
//  MVP
//
//  Created by baoshan on 17/2/8.
//  Copyright © 2017年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeViewProtocol <NSObject>
- (void)onGetMovieListSuccess:(id)model;

- (void)onGetMovieListFail:(NSInteger) errorCode des:(NSString *)des;

@end
