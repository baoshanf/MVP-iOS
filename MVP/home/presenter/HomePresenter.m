//
//  HomePresenter.m
//  MVP
//
//  Created by baoshan on 17/2/8.
//  Copyright © 2017年 hans. All rights reserved.
//

#import "HomePresenter.h"
#import "HomeModel.h"

@implementation HomePresenter

- (void)getMovieListWithUrlString:(NSString *)urlString{
    [self.httpClient get:urlString parameters:nil];
}
#pragma mark - HttpResponseHandle

- (void)onSuccess:(id)responseObject{
    
}

- (void)onFail:(id)clientInfo errCode:(NSInteger)errCode errInfo:(NSString *)errInfo{
    
}
@end
