//
//  WYQTabBarController.m
//  主流框架纯代码
//
//  Created by 王雅强 on 2018/3/10.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "WYQTabBarController.h"

@interface WYQTabBarController ()

@end

@implementation WYQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController * navigationController1 = [[UIStoryboard storyboardWithName:@"one" bundle:nil] instantiateInitialViewController];
    UINavigationController * navigationController2 = [[UIStoryboard storyboardWithName:@"two" bundle:nil] instantiateInitialViewController];
    UINavigationController * navigationController3 = [[UIStoryboard storyboardWithName:@"three" bundle:nil] instantiateInitialViewController];
    UINavigationController * navigationController4 = [[UIStoryboard storyboardWithName:@"four" bundle:nil] instantiateInitialViewController];
    
      [self setViewControllers:@[navigationController1,navigationController2,navigationController3,navigationController4]];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
