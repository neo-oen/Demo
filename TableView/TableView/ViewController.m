//
//  ViewController.m
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "ViewController.h"
#import "TableSectionView.h"
#import "TableSectionModel.h"

@interface ViewController ()
@property(nonatomic,strong) TableSectionView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * path = [[NSBundle mainBundle]pathForResource:@"cars_simple.plist" ofType:nil];
    CGRect frame = CGRectMake(5, 50, screen_width-10, 200);
    NSArray * array = [TableSectionModel cellBrandsWithPath:path andDicType:1 AndRange:frame.size];
    NSLog(@"%@",array);
    _tableView = [TableSectionView TableSectionWithFrame:frame withStyle:UITableViewStylePlain andModel:array];
    [self.view addSubview:_tableView];
    
    
    
    UIButton * buttA = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton * buttD = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton * buttC = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton * buttAB = [UIButton buttonWithType:UIButtonTypeSystem];
    
    NSArray * butArray = @[buttA,buttD,buttC,buttAB];
    
    [buttA setFrame:CGRectMake(5, 260, 50, 30)];
    [buttD setFrame:CGRectMake(75, 260, 50, 30)];
    [buttC setFrame:CGRectMake(145, 260, 50, 30)];
    [buttAB setFrame:CGRectMake(215, 260, 50, 30)];
    
    for (UIButton * button in butArray) {
        [button setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:button];
    };
    
    [buttA addTarget:self action:@selector(addFuction) forControlEvents:UIControlEventTouchUpInside];
    [buttD addTarget:self action:@selector(delectFuction) forControlEvents:UIControlEventTouchUpInside];
    [buttC addTarget:self action:@selector(changeFuction) forControlEvents:UIControlEventTouchUpInside];
    [buttAB addTarget:self action:@selector(moveFuction) forControlEvents:UIControlEventTouchUpInside];
    

    
}




-(void)addFuction{
    NSDictionary * dic = @{@"name":@"yid",@"icon":@"m_4_100"};
    CellModel * cell = [CellModel cellWithDict:dic];
}
-(void)delectFuction{


}
-(void)changeFuction{
    NSDictionary * dic = @{@"name":@"yid",@"icon":@"m_4_100"};
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
    CellModel * cell = [CellModel cellWithDict:dic];
}
-(void)moveFuction{
    NSInteger a = 0;
    NSIndexPath * indexA = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath * indexB = [NSIndexPath indexPathForRow:1 inSection:0];
    
    
}





@end



