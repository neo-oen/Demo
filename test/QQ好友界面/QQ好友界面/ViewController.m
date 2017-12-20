//
//  ViewController.m
//  QQ好友界面
//
//  Created by 王雅强 on 2017/12/19.
//  Copyright © 2017年 王雅强. All rights reserved.
//

#import "ViewController.h"
#import "TableSectionView.h"
#import "TableSectionModel.h"
#import "Public.h"

@interface ViewController ()
@property(nonatomic,strong)TableSectionView * tableView;
@property(nonatomic,strong)NSArray * models;

@end

@implementation ViewController

#pragma mark - ============== 懒加载 ==============
-(TableSectionView *)tableView
{
    if(!_tableView) {
        
        _tableView = [TableSectionView TableSectionWithFrame:CGRectMake(0, 0, screen_width, screen_height)
                                                   withStyle:UITableViewStylePlain
                                                    andModel:self.models];
        [self.view addSubview:_tableView];
        //
    }
    return _tableView;
}
-(NSArray *)models
{
    if(!_models) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"friends.plist" ofType:nil];
        _models = [TableSectionModel cellBrandsWithPath:path];
        
    }
    return _models;
}

#pragma mark - ============== 开始 ==============
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView;
}

#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
#pragma mark - ============== 代理 ==============



#pragma mark - ============== 设置 ==============
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
