//
//  HB_BackupAddressBookVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/13.
//
//
typedef enum {
    ButtonTypeMoreBtn=1,//导航栏右侧按钮
}ButtonType;
#define PROGRESS_SPEED 5.5

#import "HB_BackupAddressBookVC.h"
#import "HB_SettingOptionCell.h"
#import "HB_SettingOptionCellModel.h"
#import "HB_BackupMoreView.h"
#import "SyncProgressView.h"
#import "CTPass.h"
#import "Public.h"
#import "SyncEngine.h"
#import "ContactData.h"
#import "GroupData.h"
#import "HBZSAppDelegate.h"
#import "BaiduMobStat.h"
#import "SettingInfo.h"
#import "SyncLogItem.h"
#import "SyncErr.h"
#import "BackUpSuccessVc.h"
#import "HB_BackupSettingVC.h"
#import "AccountVc.h"
#import "SyncLogListVC.h"

#import "TimeMachineCtrl.h"
#import "HB_MachineDataModel.h"
#import "HB_BackUpBottomView.h"

#import "ConfigMgr.h"
#import "SyncEngine.h"

#import "SVProgressHUD.h"

#import "HB_UnlimitedBackUpContorller.h"
@interface HB_BackupAddressBookVC ()<UITableViewDelegate,UITableViewDataSource,HB_BackupMoreViewDelegate,UIAlertViewDelegate>
/**
 *  主tableView
 */
@property(nonatomic,retain)UITableView * tableView;
/**  数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;

/**  tableViewHeaderTitles */
@property(nonatomic,retain)NSArray * headerTitles;
/**
 *  导航栏右侧“更多”按钮
 */
@property(nonatomic,assign)UIButton *moreBtn_navigation;
/**
 *  右侧“更多”视图
 */
@property(nonatomic,retain)HB_BackupMoreView *moreView;

@property(nonatomic,strong)SyncProgressView * progressv;
@end

@implementation HB_BackupAddressBookVC

-(void)dealloc{
    [_tableView release];
    [_dataArr release];
    [_moreView release];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerTitles = @[@"上传通讯录",@"下载通讯录",@"时光机"];
    
    [self setupNavigationBar];
    [self setupInterface];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(EnterForeground:)
     
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

-(void)EnterForeground:(NSNotification *)notifi
{
    HBZSAppDelegate * delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.bottonview.LocalContactCountLabel.text = [NSString stringWithFormat:@"%lu",ABAddressBookGetPersonCount([delegate getAddressBookRef])];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self hiddenTabBar];
    [self initDataArr];
    if ([self isAccountAllowed]) {
        HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate setSyncViewController:self];
        [delegate setAccountViewInstance:self];
        StartSync(TASK_USERCLOUDSUMMARY);
        [self setSelfViewUserinterface:NO];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD show];
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        
    }
    
}
-(void)setSelfViewUserinterface:(BOOL)userinterface
{
    self.view.userInteractionEnabled = userinterface;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hiddenRightView];
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
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
}
-(void)setupGroup1{
    NSMutableArray * group=[[NSMutableArray alloc]init];
    HB_SettingOptionCellModel * model1=[HB_SettingOptionCellModel modelWithName:@"手机通讯录与云端合并(推荐)"andOption:nil];
    HB_SettingOptionCellModel * model2=[HB_SettingOptionCellModel modelWithName:@"手机通讯录覆盖云端"andOption:nil];
    [group addObjectsFromArray:@[model1,model2]];
    [self.dataArr addObject:group];
    [group release];
}
-(void)setupGroup2{
    NSMutableArray * group=[[NSMutableArray alloc]init];
    HB_SettingOptionCellModel * model3=[HB_SettingOptionCellModel modelWithName:@"云端通讯录与手机合并(推荐)"andOption:nil];
    HB_SettingOptionCellModel * model4=[HB_SettingOptionCellModel modelWithName:@"云端通讯录覆盖手机"andOption:nil];
    [group addObjectsFromArray:@[model3,model4]];
    [self.dataArr addObject:group];
    [group release];
}

-(void)setupGroup3
{
    NSMutableArray * group=[[NSMutableArray alloc]init];
    HB_SettingOptionCellModel * model5=[HB_SettingOptionCellModel modelWithName:@"查看历史备份版本" andOption:nil];
    [group addObject:model5];
    
//    HB_SettingOptionCellModel * model6 = [HB_SettingOptionCellModel modelWithName:@"同步" andOption:nil];
//    [group addObject:model6];
    
    [self.dataArr addObject:group];
    [group release];
}
#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //标题
    self.title=@"通讯录备份";
    //右侧更多按钮
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(0, 0, 20, 20)];
    moreBtn.exclusiveTouch = YES;
    [moreBtn setImage:[UIImage imageNamed:@"更多_header"] forState:UIControlStateNormal];
    moreBtn.tag=ButtonTypeMoreBtn;
    [moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    self.moreBtn_navigation=moreBtn;
    self.navigationItem.rightBarButtonItem=moreItem;
    [moreItem release];
}
-(void)btnClick:(UIButton *)btn{
    if (btn.tag==ButtonTypeMoreBtn) {
        btn.selected=!btn.selected;
        if (btn.selected) {
            self.moreView.clipsToBounds=NO;
            CGFloat rightView_W=120;
            CGFloat rightView_H=170;
            CGFloat rightView_X=self.view.bounds.size.width-8-rightView_W;
            CGFloat rightView_Y=0;
            self.moreView.frame=CGRectMake(rightView_X, rightView_Y, rightView_W, rightView_H);
        }else{
            self.moreView.clipsToBounds=YES;
            self.moreView.frame=CGRectZero;
        }
    }
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
    UITableView * tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.rowHeight=50;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    //右侧“更多”
    [self initRightViewNavigationBar];
    
    //底部
    self.bottonview = [[HB_BackUpBottomView alloc] initWithFrame:CGRectMake(0, Device_Height-50-64, Device_Width, 50)];
    [self.view addSubview:self.bottonview];
}
/**
 *  初始化右侧“更多”按钮视图
 */
-(void)initRightViewNavigationBar{
    HB_BackupMoreView * moreView=[[HB_BackupMoreView alloc]init];
    moreView.delegate=self;
    moreView.frame=CGRectZero;
    moreView.clipsToBounds=YES;//保证一开始隐藏起来
    [self.view addSubview:moreView];
    self.moreView=moreView;
    [moreView release];
}
/**
 *  隐藏右侧视图
 */
-(void)hiddenRightView{
    self.moreBtn_navigation.selected=NO;
    self.moreView.frame=CGRectZero;
    self.moreView.clipsToBounds=YES;
}
#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_SettingOptionCell * cell=[HB_SettingOptionCell cellWithTableView:tableView];
    cell.model=self.dataArr[indexPath.section][indexPath.row];
    cell.textfield.userInteractionEnabled=NO;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [self.headerTitles objectAtIndex:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenRightView];
    if (indexPath.section==0) {//上传通讯录
        if (indexPath.row==0) {//手机通讯录与云端合并(推荐)
            [self startSyncUpload];
        }else if (indexPath.row==1){//手机通讯录覆盖云端
            NSString * alertTitle=@"覆盖上传通讯录";
            NSString * alertMessage=@"本操作会将手机通讯录上传到云端并覆盖云端的现有通讯录";
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
            alert.tag = 1012;
            [alert show];
            [alert release];
        }
    }else if (indexPath.section==1){//下载通讯录
        if (indexPath.row==0) {//云端通讯录与手机合并(推荐)
            [self startSyncDownLoad];
        }else if (indexPath.row==1){//云端通讯录覆盖手机
            NSString * alertTitle=@"覆盖下载通讯录";
            NSString * alertMessage=@"本操作会将云端通讯录下载到手机并覆盖手机通讯录";
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
            alert.tag = 1022;
            [alert show];
            [alert release];
        }
    }
    else if (indexPath.section == 2)
    {
        [self hiddenRightView];
        if (indexPath.row == 0) {
            NSLog(@"时光机");
            TimeMachineCtrl * vc = [[TimeMachineCtrl alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
        else if (indexPath.row == 1)
        {
            [self startSynchronize];
        }
        
    }
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self hiddenRightView];
}
#pragma mark - 右侧“更多”视图的协议方法

-(void)backupMoreView:(HB_BackupMoreView *)backupMoreView WithIndexPath:(NSIndexPath *)indexPath
{
    [self hiddenRightView];

    switch (indexPath.row) {
        case 0:
        {
            SyncLogListVC * vc = [[SyncLogListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            NSLog(@"同步日志");
        }
            break;
        case 1:
        {
            HB_BackupSettingVC * vc = [[HB_BackupSettingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            NSLog(@"设置");
        }
            break;
        case 2:
        {
            //无限时光机入口
            HB_UnlimitedBackUpContorller * VC = [[HB_UnlimitedBackUpContorller alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            [VC release];
        }
            break;
        default:
            break;
    }
}
-(void)backupMoreView:(HB_BackupMoreView *)backupMoreView didSynchronizeContactWithIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)backupMoreView:(HB_BackupMoreView *)backupMoreView TimeMachineWithIndexPath:(NSIndexPath *)indexPath{
    [self hiddenRightView];
    

}
-(void)backupMoreView:(HB_BackupMoreView *)backupMoreView didSettingWithIndexPath:(NSIndexPath *)indexPath{
    [self hiddenRightView];
    
}
#pragma mark -

#pragma mark 全量下载
- (void)startAllDownLoad{
    [[BaiduMobStat defaultStat] logEvent:@"syncContactDownload" eventLabel:@"通讯录备份-联系人下载点击量"];
    if ([self isAutoSyncOperating]) {
        return ;
    }
    if (![self isAccountAllowed]) {
        return;
    }
    [self checkSyncBreakAndDataCount];
    
    [self.view setUserInteractionEnabled:NO];
    
    self.progressv = [[SyncProgressView alloc] init];
    [self.progressv setProTitleWithString:@"已完成"];
    [self.progressv show];
    [self.progressv setProgressMin];
    
    
     HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate setSyncViewController:self];
    
    StartSync(TASK_ALL_DOWNLOAD);
    
    fProgress = 0.0;
    
    fstamp = 0.0001;
    
    PRO_GOING = YES;
    
    [delegate setIsSyncOperatingOrRemovingRepead:YES];
    
    [self makeMyProgressBarMoving];
}

#pragma mark 全量上传
- (void)startAllUpLoad{
    [[BaiduMobStat defaultStat]logEvent:@"syncContactUpload" eventLabel:@"通讯录备份-联系人上传点击量"];
    if ([self isAutoSyncOperating]) {
        return ;
    }
    if (![self isAccountAllowed]) {
        return;
    }
    
    if ([self isContactsAndGroupsCountAllowed]) {
        [self checkSyncBreakAndDataCount];
        
        self.progressv = [[SyncProgressView alloc] init];
        [self.progressv setProTitleWithString:@"已完成"];
        [self.progressv show];
        [self.progressv setProgressMin];
        [self.view setUserInteractionEnabled:NO];
        
        HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate setSyncViewController:self];
        StartSync(TASK_ALL_UPLOAD);
        
        fProgress = 0.0;

        fstamp = 0.0001;
//
        PRO_GOING = YES;
        
        
        [delegate setIsSyncOperatingOrRemovingRepead:YES];
        [self makeMyProgressBarMoving];
    }
}

#pragma mark 增量下载
- (void)startSyncDownLoad{
    [[BaiduMobStat defaultStat] logEvent:@"syncContactDownload" eventLabel:@"通讯录备份-联系人下载点击量"];
    
    if ([self isAutoSyncOperating]) {
        return ;
    }
    if ([self isAccountAllowed]) {
        [self checkSyncBreakAndDataCount];
        
        
        
        self.progressv = [[SyncProgressView alloc] init];
        [self.progressv setProTitleWithString:@"已完成"];
        [self.progressv show];
        [self.progressv setProgressMin];
        [self.view setUserInteractionEnabled:NO];
        
        
        HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate setSyncViewController:self];
        StartSync(TASK_SYNC_DOANLOAD);
        
        fProgress = 0.0;
        
        fstamp = 0.0001;
        
        PRO_GOING = YES;
        
        [delegate setIsSyncOperatingOrRemovingRepead:YES];
        
        [self makeMyProgressBarMoving];
    }
}

#pragma mark 增量上传
- (void)startSyncUpload{
    [[BaiduMobStat defaultStat]logEvent:@"syncContactUpload" eventLabel:@"通讯录备份-联系人上传点击量"];
    if ([self isAutoSyncOperating]) {
        return ;
    }
    if ([self isAccountAllowed]) {
        if ([self isContactsAndGroupsCountAllowed]) {
            [self checkSyncBreakAndDataCount];
            [self.view setUserInteractionEnabled:NO];
            
            HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication]delegate];
            [delegate setSyncViewController:self];
            self.progressv = [[SyncProgressView alloc] init];
            [self.progressv setProTitleWithString:@"已完成"];
            [self.progressv show];
            [self.progressv setProgressMin];
            
            StartSync(TASK_SYNC_UPLOAD);
            
            fProgress = 0.0;
            
            fstamp = 0.0001;
            
            PRO_GOING = YES;
            
            [delegate setIsSyncOperatingOrRemovingRepead:YES];
            
            [self makeMyProgressBarMoving];
        }
    }
}

#pragma mark 双向同步
-(void)startSynchronize
{
    [[BaiduMobStat defaultStat]logEvent:@"syncContactUpload" eventLabel:@"通讯录备份-双向同步"];
    if ([self isAutoSyncOperating]) {
        return ;
    }
    if ([self isAccountAllowed]) {
        if ([self isContactsAndGroupsCountAllowed]) {
            [self checkSyncBreakAndDataCount];
            [self.view setUserInteractionEnabled:NO];
            
            HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication]delegate];
            [delegate setSyncViewController:self];
            self.progressv = [[SyncProgressView alloc] init];
            [self.progressv setProTitleWithString:@"已完成"];
            [self.progressv show];
            [self.progressv setProgressMin];
            
            StartSync(TASK_DIFFER_SYNC);
            
            fProgress = 0.0;
            
            fstamp = 0.0001;
            
            PRO_GOING = YES;
            
            [delegate setIsSyncOperatingOrRemovingRepead:YES];
            
            [self makeMyProgressBarMoving];
        }
    }
}
-(BOOL)isAutoSyncOperating
{
    HBZSAppDelegate * delegate = (HBZSAppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL isSyncOperating = [delegate isSyncOperatingOrRemovingRepead];
    if (isSyncOperating) {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在进行自动同步，请稍后再备份" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
        [al release];
    }
    
    return isSyncOperating;
}

- (BOOL)isAccountAllowed{
    BOOL isAcc = [[NSUserDefaults standardUserDefaults] boolForKey:AccountRowIsRefresh];
    if (!isAcc) {
        [Public allocAlertview:@"提示" msg:@"您还没有登录,请先登录!" btnTitle:@"去登录" btnTitle:@"取消" delegate:self tag:500];
    }
    return isAcc;
}
-(BOOL)isContactsAndGroupsCountAllowed{
    NSInteger contactsCount = [ContactData getAllContactsCount];
    
    NSInteger groupsCount = [GroupData getAllGroupsCount];
    
    if (contactsCount+groupsCount == 0) {
        
        [Public allocAlertview:nil msg:@"手机终端联系人为空,请执行同步或者下载操作!" btnTitle:@"确定" btnTitle:nil delegate:self tag:nil];
        
        return NO;
    }
    
    return YES;
}
#pragma mark  进度条移动
- (void)makeMyProgressBarMoving {
    
    if (!PRO_GOING){
        //当进度条完成移动的时候，让返回按钮允许点击
        return;
    }
    
    if(fProgress>0.7){
        fProgress += (fstamp*0.2);
    }
    else if (fProgress>0.4) {
        fProgress += (fstamp*0.5);
    }else {
        fProgress += fstamp;
    }
    
    
    CGFloat all = fProgress;
    
    if(all<0.9){
        
        int pro1 = all*100;
        
        int pro2 = all*1000;
        
        pro2 = pro2%100;
        
        pro2 = pro2%10;
        
        [self.progressv.precentlabel setText:[NSString stringWithFormat:@"%d.%d%%",pro1,pro2]];
        
        [self.progressv.progressView setProgress:all animated:YES ];
    }
    else
    {
        int pro1 = self.progressv.progressView.progress*100;
        
        int pro2 = self.progressv.progressView.progress*1000;
        
        pro2 = pro2%100;
        
        pro2 = pro2%10;
        
        if (pro1 == 100) {
            [self.progressv.precentlabel setText:[NSString stringWithFormat:@"100%%"]];
            
            [self.progressv.progressView setProgress:1.0 animated:YES];
        }
        else{
            [self.progressv.precentlabel setText:[NSString stringWithFormat:@"%d.%d%%",pro1,pro2]];
            
            [self.progressv.progressView setProgress:self.progressv.progressView.progress animated:YES];
        }
    }
    
    [self performSelector:@selector(makeMyProgressBarMoving) withObject:nil afterDelay:0.1];
}

- (void)checkSyncBreakAndDataCount{
    if ([SettingInfo getSyncIsBreak]) {//检查上一次同步操作是否中断
        [[ConfigMgr getInstance] setValue:[NSString stringWithFormat:@"%d", -1]
                                   forKey:[NSString stringWithFormat:@"contactListVersion"] forDomain:nil];
    }
    //所有请求之前判断数量为0则发起慢同步
    NSInteger contactsCount = [ContactData getAllContactsCount];
    
    NSInteger groupsCount = [GroupData getAllGroupsCount];
    
    if (contactsCount+groupsCount == 0){
        [[ConfigMgr getInstance] setValue:[NSString stringWithFormat:@"%d", -1] forKey:[NSString stringWithFormat:@"contactListVersion"] forDomain:nil];
    }
    
    [SettingInfo syncBegan];
}

#pragma mark 登录失败返回结果
- (void)loginStatus:(SyncState_t)state{
    
    switch (state) {
        case Sync_State_Initiating:
        {
            break;
        }
        case Sync_State_Connecting:
        {
            break;
        }
        case Sync_State_Success:
        {
            
            break;
        }
        case Sync_State_Faild:
        {
            [SVProgressHUD dismiss];
            UIAlertView * al =[[UIAlertView alloc] initWithTitle:@"提示" message:@"账户信息已过期，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            al.tag = 100;
            al.delegate = self;
            [al show];
            [al release];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark 同步返回结果
- (void)noticeBySyncEvent:(id)event{
    
    SyncStatusEvent* curEvent = (SyncStatusEvent*)event;
    
    switch (curEvent->status) {
        case Sync_State_Initiating:{
            break;
        }
        case Sync_State_Connecting:{
            break;
        }
        case Sync_State_Uploading:{
            if (bDataFirst == NO) {
                bDataFirst = YES;
                if (curEvent->iSendTotalNum == 0) {
                    fstamp = 0.9/(1000/PROGRESS_SPEED);
                }
                else {
                    fstamp = 0.9/(curEvent->iSendTotalNum/PROGRESS_SPEED) ;
                }
            
            }
            
            SyncStatusEvent* curEvent = (SyncStatusEvent*)event;
            
            iSendNum = curEvent->iSendTotalNum;
            //      iReceiveNum = curEvent->iRecvNum ;
            break;
        }
        case Sync_State_Downloading:{
            if (bDataFirst == NO) {
                bDataFirst = YES;
                if (curEvent->iRecvTotalNum == 0) {
                    fstamp = 0.9/(1000/PROGRESS_SPEED);
                }
                else {
                    fstamp = 0.9/(curEvent->iRecvTotalNum/PROGRESS_SPEED);
                }
            }
            SyncStatusEvent* curEvent = (SyncStatusEvent*)event;
            iReceiveNum = curEvent->iRecvTotalNum;
            break;
        }
        case Sync_State_Portrait_Uploading:{
//                iSendNum += curEvent->iSendTotalNum;
            }
            break;
        
        case Sync_State_Portrait_Downloading:{
//            iReceiveNum += curEvent->iRecvTotalNum;
        }
            break;
        case Sync_State_Success:{
            [self.progressv.progressView setProgress:1.0 animated:YES];
            
            
            PRO_GOING = NO;
            
            [self.progressv.precentlabel setText:[NSString stringWithFormat:@"100%%"]];
            
            if (curEvent->taskType == TASK_USERCLOUDSUMMARY) {//
                [self alertResult];
            }
            else
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self alertResult];
                });
            }
            break;
        }
        case Sync_State_Faild:{
            PRO_GOING = NO;
            
            [self.progressv.precentlabel setText:[NSString stringWithFormat:@"0%%"]];
            
            
            [self.progressv.progressView setProgress:0.0 animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self alertResult];
            });
            
            
            break;
        }
        default:
            break;
    }
}

- (void)alertResult{
    
    if (self.progressv) {
        [self.progressv dismiss];
        self.progressv = nil;
        [self.progressv release];

    }
    //解除锁定
    [self setSelfViewUserinterface:YES];
    [SVProgressHUD dismiss];

    
    SyncStatusEvent* curEvent;
    
    curEvent = GetSyncStatus();
    
    bDataFirst = NO;
//    bHeadDataFirst = NO;
    
    
    SyncLogItem* syncLog = [[SyncLogItem alloc]init];
    
    [syncLog setStartTime:[self getLogTime:[SettingInfo getSyncLastBeganTime]]];
    
    [syncLog setEndTime:[self getLogTime:[NSDate date]]];
    
    HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    switch (curEvent->taskType) {
        case TASK_ALL_UPLOAD:
            [syncLog setSyncType:@"全量上传"];
            break;
        case TASK_ALL_DOWNLOAD:
            [syncLog setSyncType:@"全量下载"];
            [delegate addressBookRevert];
            [delegate initSearchContactData];
            [delegate resetDialItemInfos:delegate.searchContactArray];
            break;
        case TASK_SYNC_UPLOAD:
            [syncLog setSyncType:@"增量上传"];
            break;
        case TASK_SYNC_DOANLOAD:
            [syncLog setSyncType:@"增量下载"];
            [delegate addressBookRevert];
            [delegate initSearchContactData];
            [delegate resetDialItemInfos:delegate.searchContactArray];
            [USERDEFAULTS setBool:NO forKey:@"ISNeedInitAddressBookRef"];
            [USERDEFAULTS synchronize];
            
            
            break;
        case TASK_DIFFER_SYNC:
            [syncLog setSyncType:@"同步"];
            [delegate addressBookRevert];
            [delegate initSearchContactData];
            [delegate resetDialItemInfos:delegate.searchContactArray];
            [USERDEFAULTS setBool:NO forKey:@"ISNeedInitAddressBookRef"];
            [USERDEFAULTS synchronize];
            
            break;
        case TASK_MERGE_SYNC:
            [syncLog setSyncType:@"慢同步"];
            [delegate addressBookRevert];
            [delegate initSearchContactData];
            [delegate resetDialItemInfos:delegate.searchContactArray];
            [USERDEFAULTS setBool:NO forKey:@"ISNeedInitAddressBookRef"];
            [USERDEFAULTS synchronize];
            
            break;
        case TASK_USERCLOUDSUMMARY:
        {
            //设置账号底部数据
            
            [self setBotton:curEvent->status];
            CancelSyncTask();  //Added by fqy on  2016
            return;
            
        }
            break;
        default:
            [syncLog setSyncType:@"其他"];
            
            break;
    }
    
    BackUpSuccessVc * backUpVc = [[BackUpSuccessVc alloc] init];
    [backUpVc setType:curEvent->taskType andState:curEvent->status];

    if (curEvent->status == Sync_State_Success){
        [SettingInfo syncEnd];
        
        [syncLog setSyncResult:@"任务成功"];
        
        [backUpVc setsendCount:iSendNum andreceiveCount:iReceiveNum];
        
        //通知UI更新联系人
        [SettingInfo setContractViewShouldReloadData:YES];

#pragma mark 时光机数据保存
        SyncTaskType type = curEvent->taskType;
        switch (type) {
            case TASK_ALL_DOWNLOAD:
            case TASK_SYNC_DOANLOAD:
            case TASK_DIFFER_SYNC:
            case TASK_MERGE_SYNC:
            [[HB_MachineDataModel getglobalMachineModel] globalTimeMachineSave];
                break;
                
            default:
                break;
        }
        
        
    }
    else  if (curEvent->status == Sync_State_Faild&&curEvent->reason==GENERAL_ERROR_PASSWORD){

        
        [[ConfigMgr getInstance] setValue:@"" forKey:@"pimaccount" forDomain:nil];
        
        [[ConfigMgr getInstance] setValue:@"" forKey:@"pimpassword" forDomain:nil];
        
        [[ConfigMgr getInstance] setValue:@"" forKey:@"user_name" forDomain:nil];
        
        [[ConfigMgr getInstance] setValue:@"" forKey:@"user_psw" forDomain:nil];
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setBool:NO forKey:AccountRowIsRefresh];
        [user synchronize];
        
        [syncLog setSyncResult:@"帐号或密码错误，请重新输入"];
        
        
    }
    else if(curEvent->status == Sync_State_Faild){
        
        [syncLog setSyncResult:@"任务失败"];
    }
    
    [self.navigationController pushViewController:backUpVc animated:YES];
    
    //加入一条日志
    [SettingInfo addSyncLog:syncLog];
    
    [syncLog release];
    
    //记录上次备份时间
    [SettingInfo setlastSyncdate:[NSDate date]];
    
    [delegate setIsSyncOperatingOrRemovingRepead:NO];
    
    iReceiveNum = 0;
    
    iSendNum = 0;
    
    
    
    
    CancelSyncTask();  //Added by kevin on June,19 2013
}

- (NSString*)getLogTime:(NSDate*)date{
    if (date == nil) {
        return @"";
    }
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    [formatter release];
    
    return dateString;
}
#pragma mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [alertView dismissWithClickedButtonIndex:1 animated:NO];
        switch (alertView.tag) {
            case 1012:{
                
                [self startAllUpLoad];   //全量上传
                break;
            }
            case 1022:{
                [self startAllDownLoad];  //全量下载
                break;
            }
            default:
                break;
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //当密码被修改了 提示并跳转到登陆
    if (alertView.tag == 1025) {
        return;
    }
    
    
    else if (alertView.tag == 500)
    {
        if (buttonIndex == 0) {
            AccountVc * vc = [[AccountVc alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 100)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)setBotton:(SyncState_t)Event
{
    if (Event == Sync_State_Faild) {
        return;
    }
    self.bottonview.accountLabel.text = [[ConfigMgr getInstance] getValueForKey:@"user_name" forDomain:nil];
    HBZSAppDelegate * delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.bottonview.LocalContactCountLabel.text = [NSString stringWithFormat:@"%lu",ABAddressBookGetPersonCount([delegate getAddressBookRef])];
    self.bottonview.ServiceContctCountLabel.text = [NSString stringWithFormat:@"%ld",[USERDEFAULTS integerForKey:@"ServiceContactCount"]];
}
@end
