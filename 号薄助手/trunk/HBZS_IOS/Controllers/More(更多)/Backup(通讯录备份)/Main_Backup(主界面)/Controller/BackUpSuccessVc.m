//
//  BackUpSuccessVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/9/14.
//
//

#import "BackUpSuccessVc.h"
#import "UIViewController+TitleView.h"
#import "HB_WebviewCtr.h"
#import "MainViewCtrl.h"
@interface BackUpSuccessVc ()

@end

@implementation BackUpSuccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hiddenTabBar];
    [self createView];

    
}

-(void)dealloc
{
    [super dealloc];
    [_linkbutton release];
    [_logoImage release];
    [_statelabel release];
    [_detalLabel release];
    
}
-(id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


-(void)createView
{
    self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.logoImage.center = CGPointMake(self.view.center.x, self.view.center.y-64-50);
    [self.view addSubview:self.logoImage];
    [self.logoImage release];
    
    CGFloat Logobottom = self.logoImage.frame.origin.y+self.logoImage.frame.size.height;
    
    
    self.statelabel = [[UILabel alloc] initWithFrame:CGRectMake(50, Logobottom+15, Device_Width-100, 30)];
    self.statelabel.textAlignment = NSTextAlignmentCenter;
    self.statelabel.textColor =[UIColor orangeColor];
    [self.view addSubview:self.statelabel];
    [self.statelabel release];
    
    
    self.detalLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,Logobottom+15+30+15 , Device_Width-120, 50)];
    self.detalLabel.textColor = [UIColor grayColor];
    self.detalLabel.numberOfLines = 0;
    self.detalLabel.textAlignment = NSTextAlignmentCenter;
    self.detalLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.detalLabel];
    [self.detalLabel release];
    
    self.linkbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.linkbutton.frame = CGRectMake(10, Device_Height-80-64, Device_Width-20, 40);
    self.linkbutton.layer.cornerRadius = 5;
    self.linkbutton.backgroundColor = [UIColor grassColor];
    [self.view addSubview: self.linkbutton];
    [self.linkbutton addTarget:self action:@selector(linkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.linkbutton release];
    
}
-(void)setsendCount:(NSInteger)upcount andreceiveCount:(NSInteger)downcount
{
    self.upCount = upcount;
    self.downCount = downcount;
}
-(void)setType:(SyncTaskType)type andState:(SyncState_t)state
{
    tasktype = type;
    backstate = state;
}

-(void)setVcvalue
{
    NSString * typeString;
    if (tasktype == TASK_ALL_UPLOAD ||tasktype == TASK_SYNC_UPLOAD) {
        typeString = [NSString stringWithFormat:@"%@",@"上传"];
        
        self.detalLabel.text = [NSString stringWithFormat:@"已上传%ld个联系人到云端，您可登录 http://pim.189.cn 查看云端数据。",(long)self.upCount];
        [self.linkbutton setTitle:@"查看云端数据" forState:UIControlStateNormal];

    }
    else if(tasktype == TASK_ALL_DOWNLOAD || tasktype == TASK_SYNC_DOANLOAD)
    {
        typeString = [NSString stringWithFormat:@"%@",@"下载"];
        
        self.detalLabel.text = [NSString stringWithFormat:@"已下载%ld个联系人到手机，您可登录 http://pim.189.cn 查看云端数据。",(long)self.downCount];
        [self.linkbutton setTitle:@"查看本地数据" forState:UIControlStateNormal];

    }
    else if (tasktype == TASK_DIFFER_SYNC || tasktype == TASK_MERGE_SYNC)
    {
        typeString = [NSString stringWithFormat:@"%@",@"同步"];
        
        self.detalLabel.text = [NSString stringWithFormat:@"手机和云端都已更新到最近一次修改状态，您可登陆 http://pim.189.cn 查看云端数据。"];
        [self.linkbutton setTitle:@"查看云端数据" forState:UIControlStateNormal];

    }
    
    NSString * stateString;
    if (backstate == Sync_State_Success) {
        stateString = [NSString stringWithFormat:@"%@",@"成功"];
        self.linkbutton.hidden = NO;
    }
    else if (backstate == Sync_State_Faild)
    {
        stateString = [NSString stringWithFormat:@"%@",@"失败"];
        self.linkbutton.hidden = YES;
    }
    
    NSString * LogoimageString = [NSString stringWithFormat:@"反馈-%@",stateString];
    
    self.logoImage.image = [UIImage imageNamed:LogoimageString];
    
    self.statelabel.text = [NSString stringWithFormat:@"%@%@",typeString,stateString];
    
    [self setVCTitle:[NSString stringWithFormat:@"%@%@",typeString,stateString]];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setVcvalue];

}

-(void)linkButtonClick:(UIButton *)btn
{
    if (tasktype == TASK_ALL_DOWNLOAD || tasktype == TASK_SYNC_DOANLOAD) {
        NSArray * vcArr=[self.navigationController viewControllers];
        if (vcArr.count>3) {
            [self.navigationController popToViewController:vcArr[vcArr.count-3] animated:NO];
        }
        
        MyTabBar * ta   = [MyTabBar shareManger];
        UIButton * tempBtn = (UIButton *)[ta viewWithTag:101];
        [ta setButtonSelected:tempBtn];
        
    }
    else
    {
        NSUserDefaults * userManager = [NSUserDefaults standardUserDefaults];
       
        HB_WebviewCtr * webVc = [[HB_WebviewCtr alloc] init];
        webVc.titleName = [NSString stringWithFormat:@"号簿助手"];
        
        NSString * token = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)[userManager objectForKey:@"Authtoken"],NULL,(CFStringRef)@"!*'();:@&=+ $,/?%#[]",kCFStringEncodingUTF8));
        NSString * urlstr  = [NSString stringWithFormat:@"http://pim.189.cn/Client/CloudView/Bfaddressee.aspx?token=%@&userid=%ld",token,[[userManager objectForKey:@"userID"] integerValue]];
//        NSString * urlstrUTF8 = [urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        webVc.url = [NSURL URLWithString:urlstr];
        
        NSLog(@"00=====%@",urlstr);
        [self.navigationController pushViewController:webVc animated:YES];
        [webVc release];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
