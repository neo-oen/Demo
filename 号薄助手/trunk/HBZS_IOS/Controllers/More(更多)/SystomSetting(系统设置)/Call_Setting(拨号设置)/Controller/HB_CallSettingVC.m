//
//  HB_CallSettingVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_CallSettingVC.h"
#import "HB_SettingPushCell.h"
#import "HB_SettingPushCellModel.h"
#import "HB_SettingSwitchCell.h"
#import "HB_SettingSwitchCellModel.h"
#import "SettingInfo.h"//全局的一些设置
#import "HB_OneKeyCallVC.h"//一键拨号设置

@interface HB_CallSettingVC ()<UITableViewDelegate,UITableViewDataSource,HB_SettingSwitchCellDelegate,UIAlertViewDelegate>
/**
 *  主tableView
 */
@property(nonatomic,retain)UITableView * tableView;
/**  数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;


@end

@implementation HB_CallSettingVC

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
}
#pragma mark - 数据源
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
        [self initDataArr];
    }
    return _dataArr;
}
-(void)initDataArr{
    [_dataArr removeAllObjects];

    
    HB_SettingPushCellModel * model1=[HB_SettingPushCellModel modelWithName:[NSString stringWithFormat:@"IP前缀设置"] andViewController:nil];
    HB_SettingPushCellModel * model2=[HB_SettingPushCellModel modelWithName:@"一键拨号设置" andViewController:[HB_OneKeyCallVC class]];
//    HB_SettingPushCellModel * model3=[HB_SettingPushCellModel modelWithName:@"手势拨号设置" andViewController:[UIViewController class]];
    HB_SettingSwitchCellModel * model4=[HB_SettingSwitchCellModel modelWithName:@"按键声音" andSwitchIsOn:[SettingInfo getIsDialSound]];
    HB_SettingSwitchCellModel * model5=[HB_SettingSwitchCellModel modelWithName:@"按键振动" andSwitchIsOn:[SettingInfo getIsDialShake]];
    
    [_dataArr addObjectsFromArray:@[model1,model2,model4,model5]];
}
#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //标题
    self.title=@"拨号设置";
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
    HB_SettingCellModel * model=self.dataArr[indexPath.row];
    if ([model isKindOfClass:[HB_SettingPushCellModel class]]) {
        HB_SettingPushCell * cell=[HB_SettingPushCell cellWithTableView:tableView];
        cell.model=(HB_SettingPushCellModel *)model;
        if (indexPath.row == 0) {
            cell.RightLabel.text =[SettingInfo getIPDialNumber]?[SettingInfo getIPDialNumber]:@"";
        }
        return cell;
    }else if ([model isKindOfClass:[HB_SettingSwitchCellModel class]]){
        HB_SettingSwitchCell * cell=[HB_SettingSwitchCell cellWithTableView:tableView];
        cell.model=(HB_SettingSwitchCellModel *)model;
        cell.delegate=self;
        return cell;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id obj=self.dataArr[indexPath.row];
    if ([obj isKindOfClass:[HB_SettingPushCellModel class]]) {
        if (indexPath.row==0) {
            [self setIPNumber];
            return;
        }
        HB_SettingPushCellModel * model=(HB_SettingPushCellModel *)obj;
        UIViewController * vc=[[model.viewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}
#pragma mark - switch的代理方法
-(void)settingSwitchCell:(HB_SettingSwitchCell *)cell switchValueChanged:(UISwitch *)switcher{
    if ([cell.model.name isEqualToString:@"按键声音"]) {
        [SettingInfo setIsDialSound:switcher.on];
    }else if ([cell.model.name isEqualToString:@"按键振动"]){
        [SettingInfo setIsDialShake:switcher.on];
    }
}

-(void)setIPNumber
{
    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"输入IP前缀" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    al.alertViewStyle = UIAlertViewStylePlainTextInput;
    [al show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
         UITextField *tf=[alertView textFieldAtIndex:0];
        [SettingInfo setIPDialNumber:tf.text];
        [self.tableView reloadData];
        
    }
}

@end
