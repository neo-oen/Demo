//
//  NetMessageViewController.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/9/18.
//
//


#import "NetMessageViewController.h"
#import "SyncEngine.h"
#import "AccountVc.h"
#import "UIViewController+TitleView.h"

#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

#import "SVProgressHUD.h"
#import "HB_httpRequestNew.h"
#import "GetMemberInfoProto.pb.h"
#import "SettingInfo.h"

#define vipmsmUrl @"http://pim.189.cn/SmsMassVIP/NewSms/Index"
#define msmUrl @"http://pim.189.cn/SmsMass/NewSms/Index"
static dispatch_once_t onceToken;

@interface NetMessageViewController ()<UIWebViewDelegate,UIAlertViewDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView; //web进度条
    NJKWebViewProgress *_progressProxy;
}

@end

@implementation NetMessageViewController

-(void)dealloc
{
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setVCTitle:@"网络短信"];
    [self hiddenTabBar];
    [self createView];
    [self createNavItem];

}

-(void)createNavItem
{
#pragma mark 左导航按钮
    UIButton * leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.tag =1;
    [leftbtn setTitle:@"返回" forState:UIControlStateNormal];
    leftbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftbtn.titleLabel.textAlignment = NSTextAlignmentRight;
    leftbtn.frame = CGRectMake(0, 0, 50, 30);
    [leftbtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(navItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    
#pragma mark 右导航按钮
    UIButton * rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = CGRectMake(0, 0, 40, 40);
    [rightbtn setTitle:@"关闭" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightbtn.tag = 2;
//    [rightbtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(navItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    
    self.navigationItem.rightBarButtonItem =rightitem;
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)createView
{
    self.web = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)] autorelease];
    [self.view addSubview:self.web];
    [self SetupProgress];
    
}

-(NSString *)dictionaryTojson:(NSDictionary *)dic
{
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
}

-(void)loadweb
{
    NSUserDefaults * userManager = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[userManager objectForKey:@"userID"] forKey:@"userID"];
    [dic setObject:[userManager objectForKey:@"Authtoken"] forKey:@"Authtoken"];
    [dic setObject:[userManager objectForKey:@"pUserId"] forKey:@"pUserId"];
    [dic setObject:[userManager objectForKey:@"mobileNum"] forKey:@"mobileNum"];

    
    MemberLevel level = [MemberInfoResponse parseFromData:[SettingInfo getMemberInfo]].memberLevel;
    NSString * mainUrl;
    if (level == MemberLevelVip) {
        mainUrl = vipmsmUrl;
//        mainUrl = [NSString stringWithFormat:@"http://outinterface.tykd.vnet.cn/SmsMassVIP/NewSms/Login"];
    }
    else
    {
        mainUrl = msmUrl;
//        mainUrl = [NSString stringWithFormat:@"http://outinterface.tykd.vnet.cn/SmsMass/NewSms/Login"];
    }
    NSString * urlstr = [[NSString stringWithFormat:@"%@?userID=%@&Authtoken=%@&pUserId=%@&mobileNum=%@",mainUrl,dic[@"userID"],dic[@"Authtoken"],dic[@"pUserId"],dic[@"mobileNum"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:mainUrl]];
    
    [self.web loadRequest:request];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"读取失败"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        
        [self.navigationController popViewControllerAnimated:YES];
    });
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
//    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        AccountVc * vc = [[AccountVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    else if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HBZSAppDelegate *delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate setAccountViewInstance:self];
    [self.navigationController.navigationBar addSubview:_progressView];
    if (![USERDEFAULTS boolForKey:AccountRowIsRefresh]) {
        onceToken=0;
    }
    
    if (onceToken == -1) {
        [self loadweb];
    }
    
    dispatch_once(&onceToken, ^{
        StartSync(TASK_AUTHEN);
        
    });
    
}

-(void)SetupProgress
{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _web.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_progressView setProgress:0];
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    
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
            [self loadweb];
            break;
        }
        case Sync_State_Faild:
        {
            UIAlertView * al =[[ UIAlertView alloc] initWithTitle:@"提示" message:@"网络短信需要登录后才能使用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去登录",@"取消", nil];
            al.delegate = self;
            [al show];
            [al release];
            onceToken = 0;
            
            break;
        }
        default:
            break;
    }
}

-(void)navItemClick:(UIButton *)sender
{

    if ([_web isLoading]) {
        [_web stopLoading];
    }
    switch (sender.tag) {
        case 1:
        {
            if ([self.web canGoBack])
            {
                [self.web goBack];
                
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 2:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)setCookies
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        NSLog(@"cookie%@", cookie);
    }
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
