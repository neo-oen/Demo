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
    UIViewController * viewControll1 = [[UIViewController alloc]init];
    [viewControll1.view setBackgroundColor:[UIColor blueColor]];
    UINavigationController * navigationController1 = [[UINavigationController alloc]initWithRootViewController:viewControll1];
    
    UIViewController * viewControll2 = [[UIViewController alloc]init];
    [viewControll2.view setBackgroundColor:[UIColor redColor]];
    UINavigationController * navigationController2 = [[UINavigationController alloc]initWithRootViewController:viewControll2];
    
    UIViewController * viewControll3 = [[UIViewController alloc]init];
    [viewControll3.view setBackgroundColor:[UIColor yellowColor]];
    UINavigationController * navigationController3 = [[UINavigationController alloc]initWithRootViewController:viewControll3];
    
    UIViewController * viewControll4 = [[UIViewController alloc]init];
    [viewControll4.view setBackgroundColor:[UIColor grayColor]];
    UINavigationController * navigationController4 = [[UINavigationController alloc]initWithRootViewController:viewControll4];
    
    [self setViewControllers:@[navigationController1,navigationController2,navigationController3,navigationController4]];
    
    [viewControll3.rdv_tabBarItem setTitle:@"sdfs"];
    

    [viewControll2.navigationItem setTitle:@"werwer"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
