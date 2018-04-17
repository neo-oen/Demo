//
//  HB_OnlineServiceVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/2/23.
//
//

#import "HB_OnlineServiceVc.h"

@interface HB_OnlineServiceVc ()

@end

@implementation HB_OnlineServiceVc


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupInterface];
    [self initdata];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.title = self.titleName;
}

-(void)initdata
{
    self.titleName = [NSString stringWithFormat:@"在线客服"];
    self.url = [NSURL URLWithString:@"http://im.189.cn/cw/?cf=1&cid=1043&manid=730"];
}
-(void)setupInterface
{
    self.webview = [[UIWebView alloc] init];
    CGFloat webView_W=SCREEN_WIDTH;
    CGFloat webView_H=SCREEN_HEIGHT-64;
    CGFloat webView_X=0;
    CGFloat webView_Y=0;
    self.webview.frame=CGRectMake(webView_X, webView_Y, webView_W, webView_H);
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hiddenTabBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self showTabBar];
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
