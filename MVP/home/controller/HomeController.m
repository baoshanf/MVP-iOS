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

@interface HomeController ()<HomeViewProtocol>
@property (nonatomic,strong)HomePresenter *homePresenter;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
}
- (void)setupData{
    _homePresenter = [[HomePresenter alloc] initWithView:self];
    [_homePresenter getMovieListWithUrlString:@"https://api.douban.com/v2/book/search?count=20&q=iOS"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - HomeViewProtocol

- (void)onGetMovieListSuccess:(HomeModel *)homeModel{
   
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"result" message:@"request success" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)onGetMovieListFail:(NSInteger)errorCode des:(NSString *)des{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"result" message:@"request fail" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertCtl animated:YES completion:nil];
}
@end
