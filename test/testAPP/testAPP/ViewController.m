//
//  ViewController.m
//  testAPP
//
//  Created by neo on 2019/3/21.
//  Copyright © 2019 王雅强. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ZBDraw.h"
#import "zbLabel.h"
@interface ViewController ()<UITableViewDataSource>


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    ZBbutton * button = [ZBbutton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"选框-选中"] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [button setTitle:@"这个是个按钮" forState:UIControlStateNormal];
//    [self.view addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(100);
//        make.left.equalTo(self.view).offset(50);
//        make.size.mas_offset(CGSizeMake(150, 80));
//    }];

    zbLabel * label =[[zbLabel alloc]init];
    label.text = @"sdfsdf";
    label.textColor = [UIColor redColor];
    [label setGradientColorWithStarColor:[UIColor blueColor] andEndColor:[UIColor yellowColor]];
    [label setClipPartRadiusWithradius:4 filletsStr:@"13"];
//    label.height = 20;
//    [self.view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(100);
//        make.left.equalTo(self.view).offset(50);
//    }];
    
    UITableView * tabelView = [[UITableView alloc]init];
    tabelView.dataSource = self;
    [label sizeToFit];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
    tabelView.tableHeaderView = label;

    
    [self.view addSubview:tabelView];
    [tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;
    return cell;
}

@end
