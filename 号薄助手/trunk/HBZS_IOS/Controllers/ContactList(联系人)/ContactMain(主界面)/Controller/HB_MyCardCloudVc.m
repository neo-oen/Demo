//
//  HB_MyCardCloudVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/9.
//
//

#import "HB_MyCardCloudVc.h"
#import "HB_ShareByQRcodeMoreView.h"
#import "MemAddressBook.h"
#import "HB_share.h"
#import "HB_MyCardQRCodeVc.h"

@interface HB_MyCardCloudVc ()<shareByQRcodeMoreViewDelegate,UIScrollViewDelegate>

@property (nonatomic,retain) HB_ShareByQRcodeMoreView * MoreView;

@end

@implementation HB_MyCardCloudVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reStepRightNav];
    [self.view addSubview:self.MoreView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.MoreView.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.MoreView.hidden = YES;
}
-(HB_ShareByQRcodeMoreView *)MoreView
{
    if (!_MoreView) {
        NSArray * arr = @[@"分享",@"二维码"];
        _MoreView = [[HB_ShareByQRcodeMoreView alloc] initWithNames:arr andStyle:More_View_Style_Right2];
        _MoreView.delegate = self;
        
    }
    return _MoreView;
}
-(void)reStepRightNav
{
#pragma mark 右导航按钮
    UIButton * rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = CGRectMake(0, 0, 40, 40);
//    [rightbtn setTitle:@"更多_header" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightbtn.tag = 2;
    [rightbtn setImage:[UIImage imageNamed:@"更多_header"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(navItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    
    self.navigationItem.rightBarButtonItem =rightitem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navItemClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            if ([self.webView canGoBack])
            {
                [self.webView goBack];
                
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 2:
        {
            self.MoreView.hidden = !self.MoreView.hidden;
        }
            break;
            
        default:
            break;
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"123");
}
-(void)shareByQRcodeMoreView:(HB_ShareByQRcodeMoreView *)moreView WithselectIndex:(NSInteger)index
{
    self.MoreView.hidden = YES;
    switch (index) {
        case 0:
        {
            NSArray * arr = @[UMShareToWechatSession,UMShareToQQ,UMShareToYXSession,UMShareToSms,UMShareToEmail];
            HB_share * share = [[[HB_share alloc] init] autorelease];
            
            NSString * title = @"云名片分享";
            NSString * text = [NSString stringWithFormat:@"【号簿助手】你的好友 %@ 给你分享了名片，请访问 %@ 进行查看。温馨提示：请认准号簿助手官方网址pim.189.cn ，勿轻信其他链接。",[self getCloudShareName],self.url.absoluteString];
            UIImage * image = [UIImage imageNamed:@"官方图标"];
            [share shareWithCurrentVc:self andTitle:title andText:text andUrl:self.url.absoluteString andImage:image andSharePlatForms:arr];
            
        }
            break;
        case 1:
        {
            HB_MyCardQRCodeVc * vc = [[HB_MyCardQRCodeVc alloc] initWithContactModel:self.mycardModel];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
        
        default:
            break;
    }
}


-(NSString *)getCloudShareName
{
    Contact * MeContact = [[MemAddressBook getInstance] myCard];
    
    NSString * lastname = MeContact.name.familyName?MeContact.name.familyName:@"";
    NSString * firstname = MeContact.name.nickName?MeContact.name.nickName:@"";
    NSString * name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    if (!name.length) {
        name = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileNum"];
    }
    
    return name;
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString isEqualToString:self.url.absoluteString]) {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        
    }
    else
    {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    self.MoreView.hidden = YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString * titleFormWeb = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (titleFormWeb.length) {
        self.title =titleFormWeb;
    }
    else
    {
        self.title = self.titleName;
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
