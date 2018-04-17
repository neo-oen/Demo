//
//  HB_ContactSettingVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_ContactSettingVC.h"
#import "HB_SettingSwitchCell.h"
#import "HB_SettingSwitchCellModel.h"
#import "SettingInfo.h"
@interface HB_ContactSettingVC ()<UITableViewDelegate,UITableViewDataSource,HB_SettingSwitchCellDelegate>
/**
 *  主tableView
 */
@property(nonatomic,retain)UITableView * tableView;
/**  数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;

@property(nonatomic,assign)BOOL isbgShow;

@end

@implementation HB_ContactSettingVC

-(void)dealloc{
    [_tableView release];
    [_dataArr release];
    
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isbgShow = [SettingInfo getIsShowContactBg];
    [self setupNavigationBar];
    [self setupInterface];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    HB_SettingSwitchCellModel * model1=[HB_SettingSwitchCellModel modelWithName:@"显示无号码联系人" andSwitchIsOn:[SettingInfo getIsShowNoNumberContact]];
    HB_SettingSwitchCellModel * model2=[HB_SettingSwitchCellModel modelWithName:@"显示联系人背景" andSwitchIsOn:[SettingInfo getIsShowContactBg]];
    HB_SettingSwitchCellModel * model3=[HB_SettingSwitchCellModel modelWithName:@"仅在WIFI下显示背景" andSwitchIsOn:[SettingInfo getIsShowPicInWifiContactSetting]];
    
    [self.dataArr addObjectsFromArray:@[model1,model2,model3]];
}
#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //标题
    self.title=@"联系人设置";
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
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
}

#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_SettingSwitchCell * cell=[HB_SettingSwitchCell cellWithTableView:tableView];
    cell.model=self.dataArr[indexPath.row];
    cell.delegate=self;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - cell的代理方法
-(void)settingSwitchCell:(HB_SettingSwitchCell *)cell switchValueChanged:(UISwitch *)switcher{
    NSIndexPath * indexPath=[_tableView indexPathForCell:cell];
    HB_SettingSwitchCellModel * model=self.dataArr[indexPath.row];
    if ([model.name isEqualToString:@"显示联系人背景"]) {
        [SettingInfo setIsShowContactBg:switcher.on];
        self.isbgShow = switcher.on;
        [self initDataArr];
        NSIndexPath * indePathTemp = [NSIndexPath indexPathForRow:2 inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[indePathTemp] withRowAnimation:UITableViewRowAnimationFade];
    }else if ([model.name isEqualToString:@"显示无号码联系人"]){
        [SettingInfo setIsShowNoNumberContact:switcher.on];
    }else if ([model.name isEqualToString:@"仅在WIFI下显示背景"]){
        [SettingInfo setIsShowPicInWifiContactSetting:switcher.on];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        if (!self.isbgShow) {
            return 0.00001;
        }
    }
    return 50;
}
@end
