//
//  MinePresenter.m
//  MVP
//
//  Created by hans on 2018/7/6.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "MinePresenter.h"
#import "MineModel.h"
#import "HKHttpResponse.h"
@implementation MinePresenter
- (void)getMineInfoWithURLString:(NSString *)URLString param:(NSDictionary *)param{
    [self.httpClient get:URLString parameters:param];
}
#pragma mark - HttpResponseHandle

- (void)onSuccess:(id )responseObject{
    HKHttpResponse * responseObj = (HKHttpResponse *)responseObject;
    MineModel *model = [MineModel yy_modelWithJSON:responseObj.content];
    if ([_view respondsToSelector:@selector(onGetMineInfoSuccess:)]) {
        [_view onGetMineInfoSuccess:model];
    }
}

- (void)onFail:(id)clientInfo errCode:(NSInteger)errCode errInfo:(NSString *)errInfo{
    if ([_view respondsToSelector:@selector(onGetMineInfoFail:des:)]) {
        [_view onGetMineInfoFail:errCode des:errInfo];
    }
}
@end
