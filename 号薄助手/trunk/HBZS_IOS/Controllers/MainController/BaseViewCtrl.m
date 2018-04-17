//
//  BaseViewCtrl.m
//  HBZS_IOS
//
//  Created by yingxin on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "HBZSAppDelegate.h"
#import "UIAlertView+Extension.h"
#import "BaiduMobStat.h"
#import "UIViewController+TitleView.h"
#import "FormatPhoneNumber.h"
#import "SettingInfo.h"
#import <MessageUI/MessageUI.h>

#import "CheckNewVersionRequest.h"
#define CheckAlertTag 51
@interface BaseViewCtrl ()<MFMessageComposeViewControllerDelegate,
                            MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@end

@implementation BaseViewCtrl

@synthesize leftBtnItem;
@synthesize leftBtnBackItem;
@synthesize rightBtnItem;

@synthesize titleLabel;

@synthesize pageviewStartWithName;

- (void)dealloc
{
    if (leftBtnItem) {
        [leftBtnItem release];
        
        leftBtnItem = nil;
    }
    
    if (rightBtnItem) {
        [rightBtnItem release];
        
        rightBtnItem = nil;
    }
    
    if (leftBtnBackItem) {
        [leftBtnBackItem release];
        
        leftBtnBackItem = nil;
    }
    
    if (pageviewStartWithName) {
        [pageviewStartWithName release];
    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self setLeftBtnIsBack:YES];
//    [self setupNavigationBarAppearance];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}
/**
 *  设置全局的导航栏
 */
-(void)setupNavigationBarAppearance{
//1.统一设置导航栏的属性
    UINavigationBar * navigationBar=[UINavigationBar appearance];
    
//    navigationBar.translucent = YES;
    
    
    
    //1.1标题属性
    NSMutableDictionary * attributeDict=[[NSMutableDictionary alloc]init];
    attributeDict[NSFontAttributeName]=[UIFont boldSystemFontOfSize:20];
    attributeDict[NSForegroundColorAttributeName]=COLOR_I;
    [navigationBar setTitleTextAttributes:attributeDict];
    navigationBar.tintColor=COLOR_I;
    
//    navigationBar.barTintColor  = COLOR_B;
    //1.2背景图
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    
//2.navigationBarItem属性设置
    UIBarButtonItem * item =[UIBarButtonItem appearance];
    NSMutableDictionary * itemDict=[[NSMutableDictionary alloc]init];
    itemDict[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    itemDict[NSForegroundColorAttributeName]=[UIColor whiteColor];
    [item setTitleTextAttributes:itemDict forState:UIControlStateNormal];
    [itemDict release];
}

- (void)setButtonBackgroundImage:(NSString *)nomalImg highlighted:(NSString *)highlightedImg
                          button:(UIButton *)btn{
    if (nomalImg) {
        NSString *imgPath = [[NSBundle mainBundle]pathForResource:nomalImg ofType:@"png"];
        
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:imgPath];
        
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        
        [image release];
    }
    
    if (highlightedImg) {
        NSString *imgPath = [[NSBundle mainBundle]pathForResource:highlightedImg ofType:@"png"];
        
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:imgPath];
        
        [btn setBackgroundImage:image forState:UIControlStateHighlighted];
        
        [image release];
    }
}


- (void)initLeftButton:(NSString*)imgNormal imgHighlight:(NSString*)imgHlight{
    
    if (imgHlight&&imgHlight) {
        leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [leftBtn setFrame:CGRectMake(0, 0, 20, 20)];//62.5 44

        leftBtn.exclusiveTouch = YES;
        
        [leftBtn setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:imgHlight] forState:UIControlStateSelected];

        [leftBtn addTarget:self action:@selector(titleLeftBtnDo:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.leftBtnItem == nil) {
            leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        }
    }
}

- (void)setLeftButton:(NSString*)imgNormal imgHighlight:(NSString*)imgHlight{
    
    if (imgHlight&&imgHlight&&leftBtn) {
        
        [self setButtonBackgroundImage:imgNormal highlighted:imgHlight button:leftBtn];
    }
}

-(void)initRightButton:(NSString*)imgNormal imgHighlight:(NSString*)imgHlight{
    
    if (imgHlight&&imgHlight) {
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightBtn setFrame:CGRectMake(0, 0, 20, 20)];
        
        rightBtn.exclusiveTouch = YES;
        [rightBtn setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:imgHlight] forState:UIControlStateSelected];
        
        [rightBtn addTarget:self action:@selector(titleRightBtnDo:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.rightBtnItem == nil) {
            rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        }
    }
}

- (void)setRightButton:(NSString*)imgNormal imgHighlight:(NSString*)imgHlight{
    
    if (imgHlight&&imgHlight&&rightBtn) {
        
        [self setButtonBackgroundImage:imgNormal highlighted:imgHlight button:rightBtn];
    }
}
/**
 *  判断左侧按钮是否是返回按钮(baseViewCtrl)
 */
-(void)setLeftBtnIsBack:(BOOL)leftBtnIsBack{
    _leftBtnIsBack=leftBtnIsBack;
    if (leftBtnIsBack) {
        [self initBackBtn];
    }else{
        //左侧按钮置为空
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.hidesBackButton=YES;
    }
}
- (void)initBackBtn {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 60, 44);
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(titleLeftBackBtnDo:) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted=NO;
    button.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    UIBarButtonItem * item=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=item;
    [item release];
}
-(void)titleLeftBackBtnDo:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)titleLeftBtnDo:(UIButton *)btn{

}

-(void)titleRightBtnDo:(UIButton *)btn{


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [CheckNewVersionRequest requestDidFinsh:^(BOOL hasNewVersion) {
            NSLog(@"%d",hasNewVersion);
            if (hasNewVersion) {
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"立即更新", nil];
                al.tag = CheckAlertTag;
                [al show];
            }
        }];
    });
    self.pageviewStartWithName = [[NSUserDefaults standardUserDefaults]objectForKey:@"PageViewStartWithName"];
    if (pageviewStartWithName) {
        [[BaiduMobStat defaultStat] pageviewStartWithName:pageviewStartWithName];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    NSString *pageviewName = [self vcTitle];
//    [[BaiduMobStat defaultStat]pageviewEndWithName:pageviewName];
//    
//    if (pageviewName) {
//        [[NSUserDefaults standardUserDefaults]setObject:pageviewName forKey:@"PageViewStartWithName"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}

- (void)setTitleLeftBtnHidden:(BOOL)bhidden{
    if (leftBtn) {
        [leftBtn setHidden:bhidden];
    }
}

- (void)setTitleBackLeftBtnHidden:(BOOL)bhidden{
    self.navigationItem.leftBarButtonItem.customView.hidden = bhidden;
}

- (void)setTitleRightBtnHidden:(BOOL)bhidden{
    if (rightBtn) {
        [rightBtn setHidden:bhidden];
    }
}

#pragma mark  Show Hide TabBar
- (void)showTabBar{
    HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [delegate setTabBarHidden:NO animated:YES];
}

- (void)hiddenTabBar{
    HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [delegate setTabBarHidden:YES animated:YES];
}

#pragma mark UIAlertView
- (void)alertViewWithMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - 拨打电话
- (void)dialPhone:(NSString*)phoneStr contactID:(NSInteger)contactID Called:(void (^)())CalledBlock{
    [[BaiduMobStat defaultStat] logEvent:@"callDial" eventLabel:@"拨号事件"];
    
    NSString *cleanString = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"cleanString1==%@",cleanString);
    UIApplication *app = [UIApplication sharedApplication];
    
    NSString * urlString =[NSString stringWithFormat:@"%@",cleanString];
//    if (willMakeAIPCall)
//    {
//        willMakeAIPCall = NO;
//        
//        urlString  = [NSString stringWithFormat:@"%@%@",[SettingInfo getIPDialNumber],cleanString];
//    }
//    else
//    {
//        urlString = ;
//    }
    
    NSURL *url = [NSURL URLWithString:[FormatPhoneNumber formatPhoneNumber:urlString]];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>9.0)
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        UIWebView * phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
        //定义block，让程序进入前台时候执行
        void(^block)(void)=^(void){
            NSString *str=[[NSUserDefaults standardUserDefaults]objectForKey:@"isCall"];
            if ([str intValue]==1) {
                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isCall"];
                DialItem * dialItem = [[DialItem alloc]init];
                if (contactID > 0){
                    dialItem.contactID = contactID;
                    
                    dialItem.name = [ContactData getPersonNameByID:contactID];
                }
                else{
                    NSInteger recordID = [ContactData getRecordIDByPhone:cleanString];
                    
                    if (recordID > 0){
                        dialItem.contactID = recordID;
                        
                        dialItem.name = [ContactData getPersonNameByID:recordID];
                    }
                    else{
                        dialItem.contactID = -1;
                        
                        dialItem.name = cleanString;
                    }
                }
                NSString *phoneStr=[[NSString alloc]initWithString:cleanString];
                dialItem.phone = phoneStr;
                [phoneStr release];
                
                [SettingInfo addDialItems:dialItem];
                
                [dialItem release];
                
//                [self setTitleRightBtnHidden:NO];
                
                if (CalledBlock) {
                    CalledBlock();
                }
                
            }
        };
        HBZSAppDelegate *delegate=(HBZSAppDelegate *)app.delegate;
        [delegate blockCopy:block];
    
    
    
}

#pragma mark - 发短信
- (void)doSendMessage:(NSArray *)phoneArr{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            if (kSystemVersion < 8.0) {
                [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                [[UINavigationBar appearance] setBarTintColor:COLOR_B];
            }
            MFMessageComposeViewController *view = [[MFMessageComposeViewController alloc]init];
            
            
            view.messageComposeDelegate = self;
            view.recipients = phoneArr;
            
            [[view navigationBar] setTintColor:[UIColor whiteColor]];
            
            [self presentViewController:view animated:YES completion:NULL];
            [view release];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if (kSystemVersion < 8.0) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    }
    
    
    //  NSLog(@"messageComposeViewController") ;
    switch (result)
    {
        case MessageComposeResultCancelled:
            //      NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            //      NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
        {
            break;
        }
        default:
            //      NSLog(@"Result: SMS not sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - 发邮件
-(void)sendEmailWithEmailArr:(NSArray *)emailArr{
    BOOL ret = [MFMailComposeViewController canSendMail];
    if (ret) {
        //表示用户设置了邮箱账户，可以直接发送
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:emailArr];
        [self presentViewController:controller animated:YES completion:nil];
        [controller release];
    }else{
        //表示没有设置邮箱账户，不能直接发送
        NSMutableString * emailMutableStr=[[NSMutableString alloc]init];
        [emailMutableStr appendString:@"mailto:"];
        for (int i=0; i<emailArr.count; i++) {
            if (i==emailArr.count-1) {
                [emailMutableStr appendString:emailArr[i]];
            }else{
                [emailMutableStr appendFormat:@",%@",emailArr[i]];
            }
        }
        NSString * sendStr = [emailMutableStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [emailMutableStr release];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:sendStr]];
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result==MFMailComposeResultSent) {
        //发送成功
        ZBLog(@"发送邮件成功");
    }else{
        ZBLog(@"发送未成功");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CheckAlertTag) {
        if (buttonIndex == 1) {
//            NSString *strUrl = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", 499531986];
//            NSURL *url = [NSURL URLWithString:strUrl];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", 499531986]]];
        }
    }
}
@end
