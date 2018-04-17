//
//  AccountVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/9/6.
//
//

#import "AccountVc.h"
#import "Colours.h"
#import "UIDevice+Reachability.h"
#import "BaiduMobStat.h"
#import "PushManager.h"
#import "HB_AccWevVc.h"
#import "CTPass.h"
#import "SVProgressHUD.h"
#import "HB_httpRequestNew.h"
@interface AccountVc ()<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UIButton *  CTPassButton;

@end

@implementation AccountVc

typedef enum _buttonType
{
    buttonLogin,
    buttonLoginByCTPass,
    buttonRegister,
    buttonForgetPassword,

}buttonType;

-(void)dealloc
{
    [super dealloc];
    if (nameTextField) {
        nameTextField = nil;
        [nameTextField release];
    }
    
    if (passWordTextField) {
        passWordTextField = nil;
        [passWordTextField release];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setVCTitle:@"登录天翼账号"];
    
    [self createLoginButton];
//    [self createLoginByCTPassButton]; //CTPass版暂不开放
    [self createTextView];
    [self createForgetButton];
    [self createRigButton];
    self.view.backgroundColor = [UIColor oldLaceColor];
    // Do any additional setup after loading the view.
}

-(void)createTextView
{
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, Device_Width, 50)];
    nameTextField.delegate = self;
    nameTextField.placeholder = @"天翼账号/手机号";
    nameTextField.font = [UIFont systemFontOfSize:16];
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 50)]autorelease];
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:nameTextField];
    
    
    
    passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 71, Device_Width, 50)];
    passWordTextField.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 50)]autorelease];
    passWordTextField.leftViewMode = UITextFieldViewModeAlways;
    passWordTextField.delegate = self;
    passWordTextField.placeholder = @"请输入密码";
    passWordTextField.backgroundColor = [UIColor whiteColor];
    passWordTextField.secureTextEntry = YES;
    
    [self.view addSubview:passWordTextField];
}

-(void)createLoginButton
{
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20,200,Device_Width-40,40);
    loginButton.tag = buttonLogin;
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.backgroundColor  = [UIColor lightGrayColor];
    loginButton.userInteractionEnabled = NO;
    loginButton.layer.cornerRadius = 5;
    [self.view addSubview:loginButton];
}

-(void)createLoginByCTPassButton
{
    _CTPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _CTPassButton.frame = CGRectMake(20,260,Device_Width-40,40);
    _CTPassButton.tag = buttonLoginByCTPass;
    [_CTPassButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_CTPassButton setTitle:@"CTPass登录" forState:UIControlStateNormal];
    _CTPassButton.backgroundColor  = [UIColor lightGrayColor];
    _CTPassButton.userInteractionEnabled = NO;
    _CTPassButton.layer.cornerRadius = 5;
    [self.view addSubview:_CTPassButton];

}

-(void)createForgetButton
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, Device_Height-100, 80, 20);
    btn.tag = buttonForgetPassword;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grassColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
}

-(void)createRigButton
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(Device_Width-10-80, Device_Height-100, 80, 20);
    btn.tag = buttonRegister;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grassColor] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:btn];
}

-(void)buttonClick:(UIButton*)btn
{
    switch (btn.tag) {
        case buttonLogin:
        {
            [self accountLogin];
        }
            break;
        case buttonLoginByCTPass:
        {
            [self LoginByCTPass];
        }
            break;
        case buttonForgetPassword:
        {
            HB_AccWevVc * webvc = [[HB_AccWevVc alloc] init];
            webvc.titleName = [NSString stringWithFormat:@"找回密码"];
            webvc.url = [NSURL URLWithString:@"http://passport.189.cn/get.aspx"];
            [self.navigationController pushViewController:webvc animated:YES];
            [webvc release];
        }
            break;
        case buttonRegister:
        {
            HB_AccWevVc * webvc = [[HB_AccWevVc alloc] init];
            webvc.titleName = [NSString stringWithFormat:@"注册"];
            webvc.url = [NSURL URLWithString:@"http://passport.189.cn/SelfS/Reg/Cellphone.aspx"];
            [self.navigationController pushViewController:webvc animated:YES];
            [webvc release];
        }
            break;
        default:
            break;
    }
}


-(void)accountLogin
{
    [[BaiduMobStat defaultStat] logEvent:@"accountLogin" eventLabel:@"天翼帐号登录-快速注册点击量"];
    
    if (![UIDevice canConnectToNetwork]) {
        UIAlertView * al = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络，请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [al show];
        return;
    }
    [[ConfigMgr getInstance] setValue:nameTextField.text forKey:@"pimaccount" forDomain:nil];
    
    [[ConfigMgr getInstance] setValue:passWordTextField.text forKey:@"pimpassword" forDomain:nil];
    
    [self.view endEditing:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD show];
    HBZSAppDelegate *delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate setAccountViewInstance:self];
    
    StartSync(TASK_AUTHEN);
    
}

-(void)LoginByCTPass
{
    [self.view endEditing:YES];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types==0){
            UIAlertView * al = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"使用CTPass快速登录请确保推送通知服务已打开,在“设置-通知”中可以进行设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
            [al show];
            
            return;
        }
    }
    else
    {
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == 0) {
            UIAlertView * al = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"使用CTPass快速登录请确保推送通知服务已打开,在“设置-通知中心”中可以进行设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
            [al show];
            
            return;
        }
    }
    
    
    if (nameTextField == nil || [nameTextField.text length]<= 0)
    {
        [self allocAlertview:nil msg:@"请输入正确账号" btnTitle1:@"确定" btnTitle2:nil tag:Sync_State_Faild];
        
        return;
    }
    
    [nameTextField resignFirstResponder];
    
    
    CTPass * authCTPass = [CTPass shareManager];
    [authCTPass CTPassTimerOverWithBlock:^{
        [self CTPassResult:CTPass_Result_ReqFaild andResultInfo:nil];
    }];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [authCTPass AuthByCTPassWithPhoneNum:nameTextField.text andCTPassType:CTPass_Auth];
}


#pragma mark textFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger nameTextlenth=nameTextField.text.length;
    NSInteger passWordlenth=passWordTextField.text.length;
    if (string.length>0) {
        if (textField == nameTextField)
        {
            nameTextlenth = nameTextlenth + string.length;
        }
        else
        {
            passWordlenth = passWordlenth+ string.length;
        }
        
    }
    else
    {
        if (textField == nameTextField) {
            nameTextlenth = nameTextlenth-range.length;
        }
        else
        {
            passWordlenth = passWordlenth-range.length;
        }
    }
    
    if (nameTextlenth>0 && passWordlenth>0) {
        loginButton.backgroundColor = [UIColor grassColor];
        loginButton.userInteractionEnabled = YES;
        
        _CTPassButton.backgroundColor = [UIColor grassColor];
        _CTPassButton.userInteractionEnabled = YES;
        
    }
    else if(nameTextlenth>0)
    {
        
        _CTPassButton.backgroundColor = [UIColor grassColor];
        _CTPassButton.userInteractionEnabled = YES;
        
        loginButton.backgroundColor = [UIColor lightGrayColor];
        loginButton.userInteractionEnabled = NO;
        
    }
    else
    {
        loginButton.backgroundColor = [UIColor lightGrayColor];
        loginButton.userInteractionEnabled = NO;
        
        _CTPassButton.backgroundColor = [UIColor lightGrayColor];
        _CTPassButton.userInteractionEnabled = NO;
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

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
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:YES forKey:AccountRowIsRefresh];
            [userDefault synchronize];
            
            [[ConfigMgr getInstance] setValue:nameTextField.text forKey:@"user_name" forDomain:nil];
            
            [[ConfigMgr getInstance] setValue:passWordTextField.text forKey:@"user_psw" forDomain:nil];
            
#pragma mark 推送相关操作
            /*
             *登录成功时把devicetoken和联系人号码同时传给服务器端，让服务器端做推送操作
             */
            NSUserDefaults * userdef = [NSUserDefaults standardUserDefaults];
            if ([userdef objectForKey:PushDeviceToken]) {
                PushManager * manager = [PushManager shareManager];
                
                ConfigMgr * config_Mar = [ConfigMgr getInstance];
                
                manager.deviceTokenReportUrl = [config_Mar getValueForKey:@"deviceTokenReportUrl" forDomain:@"SyncServerInfo"];
                [manager pushInfoToServerWithToken:[userdef objectForKey:PushDeviceToken] andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobileNum"]];
            }
            /*****/
            HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
            [req getMyCardformServerResult:^(BOOL isisSuccess) {
                [SVProgressHUD dismiss];
                if (!isisSuccess) {
                    [SVProgressHUD showErrorWithStatus:@"名片信息获取失败"];
                }
                [self allocAlertview:nil msg:@"登录成功!" btnTitle1:@"确定" btnTitle2:nil tag:Sync_State_Success];
                
            }];
            
            
            
            break;
        }
        case Sync_State_Faild:
        {
            [SVProgressHUD dismiss];
            [self allocAlertview:nil msg:@"帐号或密码错误，请重新输入" btnTitle1:@"确定" btnTitle2:nil tag:Sync_State_Faild];
            break;
        }
        default:
            [SVProgressHUD dismiss];
            break;
    }
}

-(void)CTPassResult:(ResultType)Type andResultInfo:(NSDictionary *)ResultInfo
{
    CTPass * manager = [CTPass shareManager];
    //    manager.currentType = -1;
    [manager timerCancel];
    
    [SVProgressHUD dismiss];
    switch (Type) {
        case CTPass_Result_NotAllow:
        {
            [self allocAlertview:nil msg:@"用户名不存在" btnTitle1:@"确定" btnTitle2:nil tag:Sync_State_Faild];
        }
            break;
        case CTPass_Result_ReqFaild:
        {
            [self allocAlertview:nil msg:@"请求超时,请稍后再试" btnTitle1:@"确定" btnTitle2:nil tag:Sync_State_Faild];
        }
            break;
        case CTPass_Result_Success:
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:YES forKey:@"AccountRowIsRefresh"];
            [userDefault setObject:@"YES" forKey:CTPassAuth];
            [userDefault synchronize];
            
#warning 待修改
//            [[ConfigMgr getInstance] setValue:nameTextField.text forKey:@"user_name" forDomain:nil];
//
//            [[ConfigMgr getInstance] setValue:ResultInfo[@"token"] forKey:@"token" forDomain:nil];
//            [[ConfigMgr getInstance] setValue:ResultInfo[@"tokenExpire"] forKey:@"tokenExpire" forDomain:nil];
//            [[ConfigMgr getInstance] setValue:ResultInfo[@"userId"] forKey:@"userId" forDomain:nil];
            
            
            NSUserDefaults * userManger = [NSUserDefaults standardUserDefaults];
            [userManger setObject:ResultInfo[@"userId"] forKey:@"userID"];
            [userManger setObject:ResultInfo[@"token"] forKey:@"Authtoken"];
//            [userManger setObject:authResponse.pUserId forKey:@"pUserId"];
//            [userManger setObject:authResponse.mobileNum forKey:@"mobileNum"];
            [userManger synchronize];
            
            [self allocAlertview:nil msg:@"登录成功!" btnTitle1:@"确定" btnTitle2:nil tag:Sync_State_Success];
            
        }
            break;
        default:
            break;
    }
}

- (void)allocAlertview:(NSString *)title msg:(NSString *)msg btnTitle1:(NSString *)title1 btnTitle2:(NSString *)title2 tag:(int)_tag{
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:title1 otherButtonTitles:title2, nil];
    
    alert.tag = _tag ;
    
    [alert show];
    
    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == Sync_State_Success){
        if (self.AccountBlock) {
            self.AccountBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HBZSAppDelegate *delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate setAccountViewInstance:self];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
