//
//  ViewController.m
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "ViewController.h"
#import "TableAView.h"
#import "TableSectionModel.h"
#import "Public.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * path = [[NSBundle mainBundle]pathForResource:@"cars_simple.plist" ofType:nil];
    NSArray * array = [TableSectionModel carBrandsWithPath:path];
    CGRect frame = CGRectMake(5, 50, screen_width-10, 200);
    TableSectionView * tableView = [TableSectionView TableSectionWithFrame:frame withStyle:UITableViewStylePlain andModel:array];
    [self.view addSubview:tableView];
}




@end
