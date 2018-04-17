//
//  HB_HelpAndFeedBackVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_HelpAndFeedBackVC.h"
#import "HB_SettingPushCell.h"
#import "HB_SettingPushCellModel.h"
#import "HB_FeedBackListVC.h"//反馈

@interface HB_HelpAndFeedBackVC ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  主tableView
 */
@property(nonatomic,retain)UITableView * tableView;
/**  数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;

@end

@implementation HB_HelpAndFeedBackVC

-(void)dealloc{
    [_tableView release];
    [_dataArr release];
    
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupInterface];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hiddenTabBar];
    [self initDataArr];
}
#pragma mark - 数据源
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(void)initDataArr{
    [_dataArr removeAllObjects];
    
    HB_SettingPushCellModel * model2=[HB_SettingPushCellModel modelWithName:@"意见反馈" andViewController:[HB_FeedBackListVC class]];
    HB_SettingPushCellModel * model3=[HB_SettingPushCellModel modelWithName:@"在线客服" andViewController:nil];
    
    [self.dataArr addObjectsFromArray:@[model2,model3]];
}
#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //标题
    self.title=@"帮助与反馈";
}
/**
 *  设置界面
 */
-(void)setupInterface{
    //tableView
    CGFloat tableView_W=SCREEN_WIDTH;
    CGFloat tableView_H=SCREEN_HEIGHT-64;
    CGFloat tableView_X=0;
    CGFloat tableView_Y=0;
    CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    UITableView * tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.rowHeight=50;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
}

#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_SettingPushCell * cell=[HB_SettingPushCell cellWithTableView:tableView];
    cell.model=self.dataArr[indexPath.row];
    if ([cell.nameLabel.text isEqualToString:@"意见反馈"]) {
        cell.alertBluePointIV.hidden=NO;
#warning ...这里需要做出判断
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HB_SettingPushCellModel * model=self.dataArr[indexPath.row];
    if (model.viewController) {
        UIViewController * vc=[[model.viewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

@end
