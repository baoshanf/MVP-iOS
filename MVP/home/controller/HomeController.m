//
//  HomeController.m
//  MVP
//
//  Created by baoshan on 17/2/8.
//  Copyright © 2017年 hans. All rights reserved.
//

#import "HomeController.h"
#import "HomePresenter.h"
#import "HomeViewProtocol.h"
#import "HomeMainView.h"

@interface HomeController ()<HomeViewProtocol>
@property (nonatomic,strong)HomePresenter *homePresenter;
@property (nonatomic,strong)HomeMainView *homeMainView;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeMainView];
    [self setupData];
}
- (void)setupData{
    [self.homePresenter getMovieListWithUrlString:@"satinApi" param:@{@"type":@"1",
                                                                      @"page":@"1"}];
}

#pragma mark - HomeViewProtocol

- (void)onGetMovieListSuccess:(id)model{
    
    //同一个presenter如果存在多个回调，可以通过Model的类型来判断回调
    if ([model isKindOfClass:[HomeModel class]]) {
        [self.homeMainView configViewWithHomeModel:model];
    }else if([model isKindOfClass:[HomeBannerModel class]]){
        
    }
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"result" message:@"request success" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)onGetMovieListFail:(NSInteger)errorCode des:(NSString *)des{
    [self.homeMainView showErrorView];
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"result" message:@"request fail" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertCtl animated:YES completion:nil];
}
#pragma mark - lazy load
- (HomeMainView *)homeMainView{
    if (!_homeMainView) {
        _homeMainView = [[HomeMainView alloc] initWithFrame:CGRectZero];
    }
    return _homeMainView;
}
- (HomePresenter *)homePresenter{
    if (!_homePresenter) {
        _homePresenter = [[HomePresenter alloc] initWithView:self];
    }
    return _homePresenter;
}
@end
