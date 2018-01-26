//
//  ViewController.m
//  内边距和Frame
//
//  Created by neo on 2018/1/10.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
#pragma mark - ============== 懒加载 ==============
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============
- (void)viewDidLoad {
    [super viewDidLoad];
//    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(40, 40, 80, 80)];
    UIView * view1 = [[UIView alloc]init];
    [view1 setBackgroundColor:[UIColor redColor]];

    [self.view addSubview:view1];
    
//    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
//    UIView * view2 = [[UIView alloc]init];
//    [view2 setBackgroundColor:[UIColor yellowColor]];
//
//    [view1 addSubview:view2];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
//    view2.translatesAutoresizingMaskIntoConstraints = NO;


    
    NSArray * arrayH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-delta-[view1]-delta-|"
                                                               options:NSLayoutFormatAlignAllTop
                                                               metrics:@{@"delta":@20}
                                                                 views:@{@"view1":view1}];
    [self.view addConstraints:arrayH];
    NSArray * arrayV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-delta-[view1]-delta-|"
                                                               options:NSLayoutFormatAlignAllLeft
                                                               metrics:@{@"delta":@20}
                                                                 views:@{@"view1":view1}];
    
    
    [self.view addConstraints:arrayV];
//    NSArray * arrayH2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-delta-[view2]-delta-|"
//                                                                options:NSLayoutFormatAlignAllTop
//                                                                metrics:@{@"delta":@20}
//                                                                  views:@{@"view2":view2}];
//    NSArray * arrayV2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-delta-[view2]-delta-|"
//                                                                options:NSLayoutFormatAlignAllLeft
//                                                                metrics:@{@"delta":@20}
//                                                                  views:@{@"view2":view2}];
//    [view2 addConstraints:arrayH2];
//    [view2 addConstraints:arrayV2];
    
    NSLog(@"%@",NSStringFromUIEdgeInsets(view1.alignmentRectInsets) );
    
//
//    UIView *redView = [[UIView alloc] init];
//    [redView setBackgroundColor:[UIColor redColor]];
//    
//    [self.view addSubview:redView];
//    
//    
//    UIView *purpleView = [[UIView alloc] init];
//    [purpleView setBackgroundColor:[UIColor purpleColor]];
//    
//    [self.view addSubview:purpleView];
//    
//    redView.translatesAutoresizingMaskIntoConstraints = NO;
//    purpleView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    /**
//     @"H:|-20-[redView]-20-|"
//     H 水平方向
//     | 边界 左/右
//     |-  和左侧边界有距离  |-20 距离是20
//     
//     |-20-[redView]   redView 距离 左侧边距有20的间距
//     
//     
//     
//     
//     "V:|-20-[redView(50)]-20-[purpleView(==redView)]"
//     V 垂直方向
//     |-20-[redView(50)] : redView 距离 顶部有20 的间距, 自身 高度为50
//     -20-[purpleView(==redView)]
//     purpleView 的高度 和 redView 相等, purpleView 距离 redView 有 20的间距
//     
//     
//     */
//    
//    /**
//     constraintsWithVisualFormat : 放置 VFL语言
//     options :
//     */
//    NSArray *redViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-delta-[redView]-delta-|"
//                                                                options:NSLayoutFormatAlignAllTop
//                                                                metrics:@{@"delta":@20}
//                                                                  views:@{@"redView":redView}];
//    
//    [self.view addConstraints:redViewH];
//    
//    NSArray *redViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[redView(50)]-20-[purpleView(==redView)]"
//                                                                options:NSLayoutFormatAlignAllRight
//                                                                metrics:nil
//                                                                  views:@{@"redView":redView,@"purpleView":purpleView}];
//    
//    [self.view addConstraints:redViewV];
//    
//    //  NSArray *purpleViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[redView]-20-[purpleView]"
//    //                                                                 options:NSLayoutFormatAlignAllRight
//    //                                                                 metrics:nil
//    //                                                                   views:@{@"purpleView":purpleView,@"redView":redView}];
//    //
//    //  [self.view addConstraints:purpleViewV];
//    
//    
//    // 不支持这种运算符
//#warning  VFL 语言不支持乘法 除法
//    //  NSArray *purpleViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[purpleView(==redView * 0.5)]"
//    //                                                                 options:NSLayoutFormatAlignAllTop
//    //                                                                 metrics:nil
//    //                                                                   views:@{@"purpleView":purpleView,@"redView":redView}];
//    //    [self.view addConstraints:purpleViewH];
//    
//    NSLayoutConstraint *purpleViewW = [NSLayoutConstraint constraintWithItem:purpleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
//    
//    [self.view addConstraint:purpleViewW];
//    //
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
