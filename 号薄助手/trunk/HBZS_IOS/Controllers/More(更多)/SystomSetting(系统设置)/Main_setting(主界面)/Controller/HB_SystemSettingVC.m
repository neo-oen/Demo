//
//  HB_SystemSettingVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SystemSettingVC.h"
#import "HB_SettingPushCell.h"
#import "HB_SettingPushCellModel.h"
#import "HB_CallSettingVC.h"//1.拨号设置
#import "HB_ContactSettingVC.h"//2.联系人设置
#import "HB_MessageSettingVC.h"//3.消息设置
#import "HB_BackupSettingVC.h"//4.通讯录备份设置
#import "HB_IndividualitySettingVC.h"//5.个性化设置
#import "HB_HelpAndFeedBackVC.h"//6.帮助与反馈
#import "HB_AboutVC.h"//7.关于
#import "AccountVc.h"
#import "SettingInfo.h"
#import "MemAddressBook.h"
@interface HB_SystemSettingVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
/**
 *  主tableView
 */
@property(nonatomic,retain)UITableView * tableView;
/**  数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**
 *  是否登录了天翼账号
 */
@property(nonatomic,assign)BOOL isLogin;

@end

@implementation HB_SystemSettingVC

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
    [_tableView reloadData];

}
#pragma mark - 是否登录了
/**
 *  是否登录天翼账号
 */
-(BOOL)isLoginAccountNumber{
#warning 是否登录了
    BOOL isAcc = [[NSUserDefaults standardUserDefaults] boolForKey:AccountRowIsRefresh];
    
    return isAcc;
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
    //判断是否登录了天翼账号
    _isLogin=[self isLoginAccountNumber];
    //根据是否登录账号，显示不同内容
    HB_SettingPushCellModel * model1=nil;
    if (_isLogin) {
        NSString * str = [NSString stringWithFormat:@"当前账号：%@",[[ConfigMgr getInstance] getValueForKey:@"user_name" forDomain:nil]];
        model1=[HB_SettingPushCellModel modelWithName:str andViewController:nil];
        _tableView.tableFooterView.hidden=NO;
    }else{
        model1=[HB_SettingPushCellModel modelWithName:@"登录天翼账号" andViewController:[AccountVc class]];
        _tableView.tableFooterView.hidden=YES;
    }
    HB_SettingPushCellModel * model2=[HB_SettingPushCellModel modelWithName:@"拨号设置" andViewController:[HB_CallSettingVC class]];
    HB_SettingPushCellModel * model3=[HB_SettingPushCellModel modelWithName:@"联系人设置" andViewController:[HB_ContactSettingVC class]];
    HB_SettingPushCellModel * model4=[HB_SettingPushCellModel modelWithName:@"消息设置" andViewController:[HB_MessageSettingVC class]];
    HB_SettingPushCellModel * model5=[HB_SettingPushCellModel modelWithName:@"通讯录备份设置" andViewController:[HB_BackupSettingVC class]];
    HB_SettingPushCellModel * model6=[HB_SettingPushCellModel modelWithName:@"个性化设置" andViewController:[HB_IndividualitySettingVC class]];
//    HB_SettingPushCellModel * model7=[HB_SettingPushCellModel modelWithName:@"帮助与反馈" andViewController:[HB_HelpAndFeedBackVC class]];
    HB_SettingPushCellModel * model7=[HB_SettingPushCellModel modelWithName:@"关于" andViewController:[HB_AboutVC class]];
    
    [self.dataArr addObjectsFromArray:@[model1,model2,model3,model4,model5,model6,model7]];
}
#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //标题
    self.title=@"系统设置";
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
    [self setupFooterViewToTableView:tableView];
    self.tableView=tableView;
    [tableView release];
    
}
/**
 *  设置tableView的底部视图
 */
-(void)setupFooterViewToTableView:(UITableView *)tableView{
    UIView * footerView=[[UIView alloc]init];
    footerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 100);
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btn_W=SCREEN_WIDTH-15 * 2;
    CGFloat btn_H=45;
    CGFloat btn_X=15;
    CGFloat btn_Y=footerView.frame.size.height-btn_H-15;
    btn.frame=CGRectMake(btn_X, btn_Y, btn_W, btn_H);
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    btn.backgroundColor=COLOR_J;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont boldSystemFontOfSize:16.5];
    [btn setTitle:@"退出账号" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(footerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    tableView.tableFooterView=footerView;
    [footerView release];
}
-(void)footerBtnClick{
    
    //退出登录
#warning ..退出登录
    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出当前账号？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    [al show];
    [al release];
    
    
}
#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_SettingPushCell * cell=[HB_SettingPushCell cellWithTableView:tableView];
    cell.model=self.dataArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 &&self.isLogin) {
        //提示退出登录
        [self footerBtnClick];
        return;
    }
    
    HB_SettingCellModel * model=self.dataArr[indexPath.row];
    if ([model isKindOfClass:[HB_SettingPushCellModel class]]) {
        HB_SettingPushCellModel * pushModel=(HB_SettingPushCellModel *)model;
        UIViewController * vc=[[pushModel.viewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

//注销 按钮响应方法
- (void)accountLogout{
    
    
    [[MemAddressBook getInstance] delMyCard];
    [[MemAddressBook getInstance] delMyPortrait];
    [SettingInfo setAccountState:NO];
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setBool:NO forKey:AccountRowIsRefresh];
//    [userDefault synchronize];
//    BOOL isAuthByCTPass = [userDefault boolForKey:CTPassAuth];
//    if (isAuthByCTPass) {
//#warning 待修改
//        [userDefault setBool:NO forKey:CTPassAuth];
//        [userDefault synchronize];
//        [[ConfigMgr getInstance] setValue:@"" forKey:@"token" forDomain:nil];
//        [[ConfigMgr getInstance] setValue:@"" forKey:@"tokenExpire" forDomain:nil];
//        [[ConfigMgr getInstance] setValue:@"" forKey:@"userId" forDomain:nil];
//        
//    }
    
    [[ConfigMgr getInstance] setValue:[NSString stringWithFormat:@"%d", -1] forKey:[NSString stringWithFormat:@"contactListVersion"] forDomain:nil];
    
    [[ConfigMgr getInstance] setValue:@"" forKey:@"pimaccount" forDomain:nil];
    
    [[ConfigMgr getInstance] setValue:@"" forKey:@"pimpassword" forDomain:nil];
    
    [[ConfigMgr getInstance] setValue:@"" forKey:@"user_name" forDomain:nil];
    
    [[ConfigMgr getInstance] setValue:@"" forKey:@"user_psw" forDomain:nil];
    
    
    [[MemAddressBook getInstance] delMyCard];
    [[MemAddressBook getInstance] delMyPortrait];
    
    NSUserDefaults * userManger = [NSUserDefaults standardUserDefaults];
    [userManger removeObjectForKey:@"userID"];
    [userManger removeObjectForKey:@"Authtoken"];
    [userManger removeObjectForKey:@"pUserId"];
    [userManger removeObjectForKey:@"mobileNum"];
    [userManger synchronize];

    
}

+(void)accountLogout
{
    
    [[MemAddressBook getInstance] delMyCard];
    [[MemAddressBook getInstance] delMyPortrait];
    [SettingInfo setAccountState:NO];
    
    [[ConfigMgr getInstance] setValue:[NSString stringWithFormat:@"%d", -1] forKey:[NSString stringWithFormat:@"contactListVersion"] forDomain:nil];
    
    [[ConfigMgr getInstance] setValue:@"" forKey:@"pimaccount" forDomain:nil];
    
    [[ConfigMgr getInstance] setValue:@"" forKey:@"pimpassword" forDomain:nil];
    
    [[ConfigMgr getInstance] setValue:@"" forKey:@"user_name" forDomain:nil];
    
    [[ConfigMgr getInstance] setValue:@"" forKey:@"user_psw" forDomain:nil];
    
    
    [[MemAddressBook getInstance] delMyCard];
    [[MemAddressBook getInstance] delMyPortrait];
    
    NSUserDefaults * userManger = [NSUserDefaults standardUserDefaults];
    [userManger removeObjectForKey:@"userID"];
    [userManger removeObjectForKey:@"Authtoken"];
    [userManger removeObjectForKey:@"pUserId"];
    [userManger removeObjectForKey:@"mobileNum"];
    [userManger synchronize];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _tableView.tableFooterView.hidden=YES;
        [self accountLogout];
        [self initDataArr];
        [_tableView reloadData];
    }
}

@end
