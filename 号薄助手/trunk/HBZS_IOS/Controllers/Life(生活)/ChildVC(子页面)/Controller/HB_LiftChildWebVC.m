//
//  HB_LiftChildWebVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/14.
//
//

#import "HB_LiftChildWebVC.h"
#import "lifeURLmodel.h"
#import "NJKWebViewProgressView.h"
@interface HB_LiftChildWebVC ()
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@end

@implementation HB_LiftChildWebVC

-(void)dealloc{
    [_webView release];
    [_titleName release];
    [_url release];
    [_progressProxy release];
    [_progressView release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupInterface];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    NSURLRequest * request=[NSURLRequest requestWithURL:_url];
    [_webView loadRequest:request];
    [self hiddenTabBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    [self showTabBar];
}
#pragma mark - 设置界面
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
-(void)setupInterface{
    //webView
    _webView=[[UIWebView alloc]init];
    CGFloat webView_W=SCREEN_WIDTH;
    CGFloat webView_H=SCREEN_HEIGHT-64;
    CGFloat webView_X=0;
    CGFloat webView_Y=0;
    _webView.frame=CGRectMake(webView_X, webView_Y, webView_W, webView_H);
    _webView.scalesPageToFit = YES;
    [self SetupProgress];
    
    [self.view addSubview:_webView];
    
    
}



#pragma mark - webView的协议方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

//    NSString * tel=[NSString stringWithFormat:@"%@",request.URL];
//    NSArray * arr=[[[tel componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"-"];
//    if ([arr[0] isEqualToString:@"tel"]) {
//        [self dialPhone:arr[1] contactID:-1];
//        return NO;
//    }
//    
//    return YES;
    
    NSString * tel = [NSString stringWithFormat:@"%@",request.URL];
    NSArray * arr = [tel componentsSeparatedByString:@"/"];
    NSArray * comBytitleArr = [tel componentsSeparatedByString:@"-/title"];
//    if ([request.URL isEqual:self.url]) {
//        return YES;
//    }
//    else if ([[arr objectAtIndex:2] isEqualToString:@"www.vnet.cn"])
//    {
//        return YES;
//    }
    if ([[[[arr lastObject] componentsSeparatedByString:@"-" ] firstObject] isEqualToString:@"tel"]) {
        [self dialPhone:[[[arr lastObject] componentsSeparatedByString:@"-"]lastObject] contactID:-1 Called:nil];
        return NO;
    }
    else if (comBytitleArr.count>1)
    {
        HB_LiftChildWebVC * childVC=[[HB_LiftChildWebVC alloc]init];
        lifeURLmodel * model = [self requsetURLAnalyze:comBytitleArr];
        childVC.titleName=model.titleName;
        childVC.url = [NSURL URLWithString:model.url];
        childVC.leftBtnIsBack = YES;
        [self.navigationController pushViewController:childVC animated:YES];
        [childVC release];
        return NO;
    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(void)navItemClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            if ([_webView canGoBack])
            {
                [_webView goBack];
                
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

-(lifeURLmodel *)requsetURLAnalyze:(NSArray *)arr
{
    lifeURLmodel * model = [[[lifeURLmodel alloc]init] autorelease];
    model.titleName =[[arr lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    model.url = [arr firstObject];
    return model;
    
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

@end
