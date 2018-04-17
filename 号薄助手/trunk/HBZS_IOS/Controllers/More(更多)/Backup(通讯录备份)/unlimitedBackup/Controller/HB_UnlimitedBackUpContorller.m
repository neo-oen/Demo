//
//  HB_UnlimitedBackUpContorller.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/7/15.
//
//

#import "HB_UnlimitedBackUpContorller.h"
#import "SettingUnlimitedBackupView.h"
#import "AddGetMemberinfoProto.pb.h"
#import "HBZSAppDelegate.h"
#import "SyncEngine.h"
#import "Public.h"
#import "AccountVc.h"

#import "HB_WebviewCtr.h"

#import "SVProgressHUD.h"
#import "HB_UnlimitedBackUpReq.h"
#import "PayInAppManager.h"
#import "HB_httpRequestNew.h"
#import "HB_MemberCenterVc.h"
@interface HB_UnlimitedBackUpContorller ()
{
    CGRect viewFram;
    
    CGFloat fProgress;
    
    CGFloat fstamp;
    
    BOOL PRO_GOING;
    
}

@property(nonatomic,strong)NSString * helpUrl;
@end

@implementation HB_UnlimitedBackUpContorller

-(void)dealloc
{
//    [_StartView release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title= @"开通云端无限次时光倒流";
    viewFram = CGRectMake(0, 0, Device_Width, Device_Height-64);
    
    self.helpUrl = @"http://pim.189.cn/clienthelp/index.html";
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self isAccountAllowed]) {
        [self getMemberInfoWithReqType:1];//验证是否为会员
    }
    
}

-(void)stepStartView
{
    _StartView = [[[NSBundle mainBundle] loadNibNamed:@"UnlimitedBpStartView" owner:nil options:nil]firstObject];
    _StartView.frame = viewFram;
    _StartView.delegate =self;
    
    [self.view addSubview: _StartView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UnlimitedBpStartViewDelegate
-(void)OpenNow
{
//    [_StartView removeFromSuperview];
////    _StartView = nil;
//    
//    //申请添加会员
//    [self getMemberInfoWithReqType:0];
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    [req orderVipIsValidResult:^(BOOL isSuccess, NSDictionary *dic) {
        if (!isSuccess) {
            NSLog(@"orderVipIsValid请求失败");
            return ;
        }
        if ([[dic objectForKey:@"code"] integerValue] == 0){
            //可以订购
            MemberInfoResponse * memberInfo = [MemberInfoResponse parseFromData:[SettingInfo getMemberInfo]];
            if (!memberInfo.isExperience && memberInfo.memberLevel == MemberLevelCommon) {
                //免费体验
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"免费体验" message:@"您已成功获赠1个月的号簿助手VIP会员服务，本服务每个用户仅限1次，自开通之日起30天，详情前往会员中心查看。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"立即体验", nil];
                alert.tag = 100;
                [alert show];
                [alert release];
            }
            else if (memberInfo.memberLevel == MemberLevelCommon && memberInfo.isExperience)
            {
                [self joinMember];
            }
            
        }
        else
        {
            //订购关闭
            HB_WebviewCtr * webvc = [HB_WebviewCtr new] ;
            webvc.url = [NSURL URLWithString:[dic objectForKey:@"tip_url"]];
            [self.navigationController pushViewController:webvc animated:YES];
            [webvc release];
            
        }
    }];
}


-(void)joinMember
{
    [HB_httpRequestNew buyMemberWithVc:self];
    
}
//应用内支付回调
- (void)getServiceData:(NSNotification *)notification {
    
    NSLog(@"res_code: %@",[notification.object objectForKey:@"res_code"]);
    NSLog(@"res_message: %@",[notification.object objectForKey:@"res_message"]);
    NSLog(@"trade_id: %@",[notification.object objectForKey:@"trade_id"]);
    NSLog(@"%@",notification);
    
    NSDictionary * dic = notification.object;
    
    if ([[dic objectForKey:@"res_code"] integerValue] == 0&& [dic objectForKey:@"order_no"]) {
        //扣费成功
        [self orderMemberWithPayInfo:dic OrderType:MemberTypeBuy];
    }
    else
    {
        [HB_httpRequestNew PayBackInfo:[dic objectForKey:@"res_code"]];
    }
    
}

#pragma mark SettingUnlimitedBackupViewDelegate
-(void)BtnClickWithStep:(NSInteger)step
{
    
    if (step == 2) {
        [self firstMenberSync];
    }
    else if (step==3) {
        //跳转到如何使用
        HB_WebviewCtr * helpVc = [[HB_WebviewCtr alloc] init];
        helpVc.url = [NSURL URLWithString:self.helpUrl];
        [self.navigationController pushViewController:helpVc animated:YES];
        helpVc.titleName = @"帮助";
        [helpVc release];
    }
}

-(void)toMemPrivilegeWeb
{
    HB_MemberCenterVc * vc = [[HB_MemberCenterVc alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)firstMenberSync
{
    if ([self isAutoSyncOperating]) {
        return ;
    }
    
    
    HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate setSyncViewController:self];
    [delegate setIsSyncOperatingOrRemovingRepead:YES];

    self.progressv = [[SyncProgressView alloc] init];
    [self.progressv setProTitleWithString:@"初始化中"];
    [self.progressv show];
    [self.progressv setProgressMin];
    
    StartSync(TASK_MERGE_SYNC);
    
    fProgress = 0.0;
    
    fstamp = 0.0001;
    
    PRO_GOING = YES;
    
    
    [self makeMyProgressBarMoving];

}

-(void)appearSettingStepViewWithstep:(NSInteger)step andStartDate:(NSString *)startdate
{
    _StepsView = [[[NSBundle mainBundle] loadNibNamed:@"SettingUnlimitedBackupView" owner:nil options:nil] firstObject];
    _StepsView.frame = viewFram;
    _StepsView.delegate = self;
    _StepsView.OpenTime = startdate;

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = COLOR_A;
    [self.view addSubview:self.StepsView];
    
//    [_StepsView layoutSubviews];
    //点击立即开通进入step1状态
    _StepsView.currentStep = step;
}

-(void)getMemberInfoWithReqType:(NSInteger)reqtype
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
    [HB_UnlimitedBackUpReq MemberInfoRequestType:reqtype resultBlock:^(NSError * _Nullable error, NSInteger resultCode, NSString * _Nullable startdate) {
        
        [SVProgressHUD dismiss];
        if (!error) {
            if (reqtype == 1) {
                if (resultCode == 1) {
                    //不是会员
                    [self stepStartView];
                }
                else if (resultCode == 0)
                {
                    //已经是会员 进入step3
                    if (![SettingInfo getIsInitedInfiniteMachine]) {
                        //没有初始化过
                        [self appearSettingStepViewWithstep:1 andStartDate:startdate];
                    }
                    else
                    {
                        
                        [self appearSettingStepViewWithstep:3 andStartDate:startdate];
                    }
                    
                }
            }
//            else
//            {
//                if (resultCode == 0) {
//                    //添加成功
//                    [self appearSettingStepViewWithstep:1 andStartDate:startdate];
//                    
//                }
//                else{
//                    //添加失败
//                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加会员失败,请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                    [alert show];
//                    [alert release];
//                }
//            }
        }
        else
        {
            //请求失败
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }];
    
    return;
    //待验证信息
    
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
            break;
        }
        case Sync_State_Downloading:{
            break;
        }
        case Sync_State_Portrait_Uploading:{
        }
            break;
            
        case Sync_State_Portrait_Downloading:{
        }
            break;
        case Sync_State_Success:{
            
            
            PRO_GOING = NO;
            
            [self.progressv.progressView setProgress:1.0 animated:YES];

            [self.progressv.precentlabel setText:[NSString stringWithFormat:@"100%%"]];
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self firstMenberSyncResult:Sync_State_Success];
                
            });
        }
            break;
        case Sync_State_Faild:{
            PRO_GOING = NO;
            
            [self.progressv.precentlabel setText:[NSString stringWithFormat:@"0%%"]];
            
            
            [self.progressv.progressView setProgress:0.0 animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self firstMenberSyncResult:Sync_State_Faild];

            });
        }
            break;
        default:
            break;
    }
}

-(void)firstMenberSyncResult:(SyncState_t)result
{
    
    if (self.progressv) {
        [self.progressv dismiss];
        self.progressv = nil;
        [self.progressv release];
        
    }
    [HBZSAppDelegate getAppdelegate].isSyncOperatingOrRemovingRepead = NO;
    if (result == Sync_State_Success) {
        self.StepsView.currentStep = 3;
        [SettingInfo SetIsInitedInfiniteMachine:YES];
    }
    else
    {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据初始化失败，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
        [al release];
    }
}
-(BOOL)isAutoSyncOperating
{
    HBZSAppDelegate * delegate = (HBZSAppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL isSyncOperating = [delegate isSyncOperatingOrRemovingRepead];
    if (isSyncOperating) {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在进行自动同步，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 500)
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
        //免费体验
        if (buttonIndex == 1) {
            [self orderMemberWithPayInfo:nil OrderType:MemberTypeFree];
        }
    }
    
}

-(void)orderMemberWithPayInfo:(NSDictionary *)PayDic OrderType:(MemberType)type
{
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    
    HB_OrderMemberModel * model = [[HB_OrderMemberModel alloc] init];
    
    model.order_no= [PayDic objectForKey:@"order_no"];
    model.memberLevel = MemberLevelVip;
    model.memberType = type;
    if (type==MemberTypeBuy) {
        model.price = Open189_Price;
    }
    [req OrderMemberWithOrderInfo:model Result:^(BOOL isSuccess, MemberOrderResponse *MOResponse) {
        
        if (!isSuccess) {
            NSLog(@"请求失败");
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"会员变更失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return ;
        }
        [self appearSettingStepViewWithstep:1 andStartDate:[self startTime:MOResponse.memberOrder.starttime]];
        
        
        
        
        
    }];
    
    
    [req release];
    [model release];
    
}
-(NSString *)startTime:(NSInteger)starttime
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:starttime/1000];
    NSString * dateString = [formatter stringFromDate:date];
    
    return dateString;
    
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
