//
//  ViewController.m
//  AppMange
//
//  Created by 王雅强 on 2017/12/25.
//  Copyright © 2017年 王雅强. All rights reserved.
//

#import "ViewController.h"
#import "Public.h"
#import "TableSectionView.h"
#import "TableSectionModel.h"

@interface ViewController ()
@property(nonatomic,strong)TableSectionView * table;
@property(nonatomic,strong)NSArray * models;

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
    NSString * path = [[NSBundle mainBundle] pathForResource:@"apps_full.plist" ofType:nil];
    _models = [TableSectionModel cellBrandsWithPath:path andDicType:singleDic AndRange:CGSizeMake(screen_width-60, 0)];
    _table = [TableSectionView TableSectionWithFrame:CGRectMake(30, 40, screen_width-60, 500) withStyle:UITableViewStylePlain andModel:_models];
    [self.view addSubview:_table];
//    _table addConstraint:<#(nonnull NSLayoutConstraint *)#>
    NSLayoutConstraint * sd = [NSLayoutConstraint constraintWithItem:<#(nonnull id)#>
                                                           attribute:<#(NSLayoutAttribute)#>
                                                           relatedBy:<#(NSLayoutRelation)#>
                                                              toItem:<#(nullable id)#>
                                                           attribute:<#(NSLayoutAttribute)#>
                                                          multip  lier:<#(CGFloat)#>
                                                            constant:<#(CGFloat)#>]
    
    
    NSLayoutConstraint * fd = [NSLayoutConstraint constraintsWithVisualFormat:<#(nonnull NSString *)#>
                                                                      options:<#(NSLayoutFormatOptions)#>
                                                                      metrics:<#(nullable NSDictionary<NSString *,id> *)#>
                                                                        views:<#(nonnull NSDictionary<NSString *,id> *)#>
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
