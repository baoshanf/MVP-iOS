//
//  HomePresenter.m
//  MVP
//
//  Created by baoshan on 17/2/8.
//  Copyright © 2017年 hans. All rights reserved.
//

#import "HomePresenter.h"

#import "HKHttpResponse.h"
@implementation HomePresenter

- (void)getMovieListWithUrlString:(NSString *)urlString param:(NSDictionary *)param{
    [self.httpClient get:urlString parameters:param];
}
#pragma mark - HttpResponseHandle

- (void)onSuccess:(id )responseObject{
    HKHttpResponse * responseObj = (HKHttpResponse *)responseObject;
    if ([responseObj.request.URL.absoluteString hasSuffix:@"satinApi"]) {
        HomeModel *model = [HomeModel yy_modelWithJSON:responseObj.content];
        if ([_view respondsToSelector:@selector(onGetMovieListSuccess:)]) {
            [_view onGetMovieListSuccess:model];
        }
    }else{
        HomeBannerModel *model = [HomeBannerModel yy_modelWithJSON:responseObj.content];
        if ([_view respondsToSelector:@selector(onGetMovieListSuccess:)]) {
            [_view onGetMovieListSuccess:model];
        }
    }
   
}

- (void)onFail:(id)clientInfo errCode:(NSInteger)errCode errInfo:(NSString *)errInfo{
    if ([_view respondsToSelector: @selector(onGetMovieListFail: des:)]) {
        [_view onGetMovieListFail:errCode des:errInfo];
    }
}
@end
