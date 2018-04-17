//
//  HB_LifeViewController.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/13.
//
//

#import "HB_LifeViewController.h"
#import "HB_LiftChildWebVC.h"
#import "lifeURLmodel.h"
@interface HB_LifeViewController ()<UIWebViewDelegate>
@end

@implementation HB_LifeViewController
-(void)dealloc{
    [_webView release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupInterface];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showTabBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
#pragma mark - 设置界面
-(void)setupNavigationBar{
    //标题
    self.leftBtnIsBack=NO;
    self.title=@"生活";
}
-(void)setupInterface{
    //webView
    UIWebView * webView=[[UIWebView alloc]init];
    CGFloat webView_W=SCREEN_WIDTH;
    CGFloat webView_H=SCREEN_HEIGHT-64-49;
    CGFloat webView_X=0;
    CGFloat webView_Y=0;
    webView.frame=CGRectMake(webView_X, webView_Y, webView_W, webView_H);
    webView.delegate=self;
    [self.view addSubview:webView];
    
    NSURL * url = [[NSBundle mainBundle]URLForResource:@"index" withExtension:@"html"];
    NSURLRequest * request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    self.webView=webView;
    [webView release];
}
#pragma mark - webView的协议方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString * str=[NSString stringWithFormat:@"%@",request.URL];
    NSArray * arr=[str componentsSeparatedByString:@"/"];
    NSArray * typeArr = [[arr lastObject] componentsSeparatedByString:@"-"];
    if ([[arr lastObject] isEqualToString:@"index.html"]) {
        return YES;
    }
    else if ([[arr objectAtIndex:2] isEqualToString:@"www.vnet.cn"])
    {
        return YES;
    }
    else if([[typeArr firstObject] isEqualToString:@"alert"])
    {
        NSString * alertMessger = [NSString stringWithString:[[typeArr lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessger delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return NO;
    }
    else
    {
        HB_LiftChildWebVC * childVC=[[HB_LiftChildWebVC alloc]init];
        lifeURLmodel * model = [self requsetURLAnalyze:str];
        childVC.titleName=model.titleName;
        childVC.url = [NSURL URLWithString:model.url];
        [model release];
        childVC.leftBtnIsBack = YES;
        [self.navigationController pushViewController:childVC animated:YES];
        [childVC release];
        return NO;
        
    }
    
}
-(lifeURLmodel *)requsetURLAnalyze:(NSString *)urlstring
{
    lifeURLmodel * model = [[lifeURLmodel alloc]init];
    NSArray * arr = [urlstring componentsSeparatedByString:@"-/title"];
    model.titleName =[[arr lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    model.url = [arr firstObject];
    return model;
    
}

@end
