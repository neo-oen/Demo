//
//  HB_PrivacyNoticeVC.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/10/30.
//

#define ClauseUrl @"http://passport.189.cn/SelfS/About/Agreement.aspx"
#define PrivacyNoticeUrl @"http://passport.189.cn/SelfS/About/Privacy.aspx"

#define userNoticeUrl @"http://pim.189.cn/About/Agreement.html"
#import "HB_PrivacyNoticeVC.h"

@interface HB_PrivacyNoticeVC ()<UITextViewDelegate>

@end

@implementation HB_PrivacyNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpWeb];
    [self btnDeal];
    
}
-(void)btnDeal
{
    UIButton * closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closebtn.frame = CGRectMake(15, 15, 30, 30);
    [closebtn setBackgroundImage:[UIImage imageNamed:@"关闭箭头"] forState:UIControlStateNormal];
    [closebtn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closebtn];
}

-(void)setUpWeb
{
    UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:web];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userNoticeUrl]]];
}

-(void)Click
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)dealloc {

    [super dealloc];
}
@end
