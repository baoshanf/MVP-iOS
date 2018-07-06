//
//  HomePresenter.h
//  MVP
//
//  Created by baoshan on 17/2/8.
//  Copyright © 2017年 hans. All rights reserved.
//

#import "HttpPresenter.h"
#import "HomeViewProtocol.h"

#import "HomeModel.h"
#import "HomeBannerModel.h"
@interface HomePresenter : HttpPresenter <id<HomeViewProtocol>>

- (void)getMovieListWithUrlString:(NSString *)urlString param:(NSDictionary *)param;
@end
