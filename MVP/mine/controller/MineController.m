//
//  MineController.m
//  MVP
//
//  Created by hans on 2018/7/6.
//  Copyright © 2018年 hans. All rights reserved.
//

#import "MineController.h"
#import "MineMainView.h"
@interface MineController ()
@property (nonatomic,strong)MineMainView *mainView;
@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainView];
}
#pragma mark - lazy load
- (MineMainView *)mainView{
    if (!_mainView) {
        _mainView = [[MineMainView alloc] initWithFrame:CGRectZero];
    }
    return _mainView;
}
@end
