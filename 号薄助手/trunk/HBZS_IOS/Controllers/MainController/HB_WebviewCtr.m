//
//  HB_WebviewCtr.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/3/1.
//
//

#import "HB_WebviewCtr.h"
@interface HB_WebviewCtr ()

@end

@implementation HB_WebviewCtr

-(void)dealloc{
    [_webView release];
    [_titleName release];
    [_url release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    [self setupNavigationBar];
    [self setupInterface];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    [self loadWeb];
}

-(void)loadWeb
{
    NSURLRequest * request=[NSURLRequest requestWithURL:_url];
    [_webView loadRequest:request];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];

}
-(void)setupNavigationBar{
    //标题
    self.title=_titleName;
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

-(void)SetupProgress
{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
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
    //    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)setupInterface{
    //webView
    _webView=[[UIWebView alloc]init];
    CGFloat webView_W=SCREEN_WIDTH;
    CGFloat webView_H=SCREEN_HEIGHT-64;
    CGFloat webView_X=0;
    CGFloat webView_Y=0;
    _webView.frame=CGRectMake(webView_X, webView_Y, webView_W, webView_H);
    _webView.scalesPageToFit = YES;
    
    [self SetupProgress];//添加进度条

    [self.view addSubview:_webView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString * titleFormWeb = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (titleFormWeb.length) {
        self.title =titleFormWeb;
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
