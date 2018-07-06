//
//  MineMainView.m
//  MVP
//
//  Created by hans on 2018/7/6.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "MineMainView.h"
#import "MinePresenter.h"

@interface MineMainView()<MineViewProtocol>
@property (nonatomic,strong)MinePresenter *presenter;
@end

@implementation MineMainView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.presenter getMineInfoWithURLString:@"mine" param:@{}];
    }
    return self;
}
#pragma mark - lazy load
- (MinePresenter *)presenter{
    if (!_presenter) {
        _presenter = [[MinePresenter alloc] initWithView:self];
    }
    return _presenter;
}
#pragma MineViewProtocol
- (void)onGetMineInfoSuccess:(MineModel *)model{
    //这里做一些与UI相关的事情
}

- (void)onGetMineInfoFail:(NSInteger) errorCode des:(NSString *)des{
    
}
@end
