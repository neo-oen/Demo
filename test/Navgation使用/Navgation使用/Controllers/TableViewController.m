//
//  TableViewController.m
//  Navgation使用
//
//  Created by neo on 2018/1/17.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "TableViewController.h"
#import "ManViewController.h"
#import "EditManViewController.h"
#import "TableView.h"



@interface TableViewController ()

@property(nonatomic,strong)TableView *  tableView;
@property(nonatomic,strong)NSArray * models;

@end

@implementation TableViewController

#pragma mark - ============== 懒加载 ==============
-(NSString *)name
{
    if(!_name) {
        _name = @"未名人";
        //
    }
    return _name;
}

-(TableView *)tableView
{
    if(!_tableView) {
       
        _tableView =  [[NSBundle mainBundle]loadNibNamed:@"tableView" owner:nil options:nil].lastObject;
        self.view = _tableView;
        __weak typeof(self) weakSelf = self;
        _tableView.cellClickAction = ^(NSIndexPath *indexPath, CellModel *model) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            EditManViewController * viewControl = [[EditManViewController alloc]init];
            viewControl.model = model;
            viewControl.indexPath = indexPath;
            [strongSelf.navigationController pushViewController:viewControl animated:YES];
        };
#warning message
        _tableView.models = self.models;
        //
    }
    return _tableView;
}

//-(NSArray *)models
//{
//    if(!_models) {
//        CellModel * model1 = [[CellModel alloc]initWithName:@"张三1" andPhone:@"11111111"];
//        CellModel * model2 = [[CellModel alloc]initWithName:@"张三2" andPhone:@"2222222"];
//        CellModel * model3= [[CellModel alloc]initWithName:@"张三3" andPhone:@"33333333"];
//        CellModel * model4 = [[CellModel alloc]initWithName:@"张三4" andPhone:@"444444444"];
//        
//        _models = @[model1,model2,model3,model4] ;
//    }
//    return _models;
//}

#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
-(BOOL)addManWithModel:(CellModel *) model;{
    [self.tableView addManWithModel:model];
    
    return YES;
}

-(BOOL)addManWithModel:(CellModel *) model andIndexPath:(NSIndexPath *) indexPath;{
    [self.tableView addManWithModel:model andIndexPath:indexPath];
    
    return YES;
}
-(BOOL)editManWithModel:(CellModel *) model andIndexPath:(NSIndexPath *) indexPath{
    [self.tableView editManWithModel:model andIndexPath:indexPath];
    
    return YES;
}
#pragma mark - ============== 方法 ==============
-(void)setNavigationItem{
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(navigationLeftButton)]];
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@的通讯录",self.name]];
    
    UIBarButtonItem * button1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(navigationRightTrashButton)];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationRightAddButton)];
    
    [self.navigationItem setRightBarButtonItems:@[button2,button1]];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(navigationLeftButton)]];
     
     }
                                               
-(void)navigationLeftButton{
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:@"注销" message:@"确定注销吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];

    }]];
    [self presentViewController:alertControl animated:YES completion:^{
        
    }];
    
    
}

-(void)navigationRightAddButton{
    UIViewController * viewControll = [[ManViewController alloc]init];
    [self.navigationController pushViewController:viewControll animated:YES];
}

-(void)navigationRightTrashButton{
    [self.tableView.tabelView setEditing:!self.tableView.tabelView.editing animated:YES];
    
}

/**
 1.获取文件路径
 2.接档数据
 3.赋值数据
 */
-(void)getMansData{
       NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"Mans.plist"];
   
    self.models = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
//       NSArray * array = [NSArray arrayWithContentsOfFile:path];
//    NSMutableArray * mans = [NSMutableArray array];
//    for (NSData * data in array) {
//        CellModel * man = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [mans addObject:man];
//    }
//    
//    self.models = mans;
}

-(void)setMansData{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingPathComponent:@"Mans.plist"];
    
    [NSKeyedArchiver archiveRootObject:self.tableView.models toFile:path];
//    NSMutableArray * array = [NSMutableArray array];
//    for (CellModel * man in self.tableView.models) {
//        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:man];
//        [array addObject:data];
//    }
//    [array writeToFile:path atomically:YES];
    
}

                                               
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMansData];
    self.tableView;
    [self setNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)dealloc{
    [self setMansData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
