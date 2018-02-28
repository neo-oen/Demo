//
//  SwipLockViewController.m
//  主流框架SB
//
//  Created by 王雅强 on 2018/2/28.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "SwipLockViewController.h"
#import "SwipLockView.h"

@interface SwipLockViewController ()

@property(nonatomic,strong)SwipLockView * swipLockView;

@end

@implementation SwipLockViewController

#pragma mark - ============== 懒加载 ==============

-(SwipLockView *)swipLockView
{
    if(!_swipLockView) {
        _swipLockView = [[SwipLockView alloc] init];
        
        
        [self.view addSubview:_swipLockView];
    }
    return _swipLockView;
}

#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============

-(void)updateView{
    [self.swipLockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_swipLockView.mas_width);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.center.mas_offset(CGPointMake(0, 0));
    }];
    
}

#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]]];
    self.swipLockView;
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
