//
//  HB_AboutVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/13.
//
//

#import "HB_AboutVC.h"
#import "HB_share.h"
@interface HB_AboutVC ()
/**
 *  右侧分享按钮
 */
@property(nonatomic,retain)UIButton * shareBtn;
@property (retain, nonatomic) IBOutlet UIButton *urlBtn;
- (IBAction)btnClick:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation HB_AboutVC
-(void)dealloc{
    [_shareBtn release];
    [_urlBtn release];
    [_versionLabel release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self hiddenTabBar];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)setupNavigationBar{
    //设置标题
    self.title=@"关于";
    //右侧分享按钮
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, 0, 20, 20)];
    shareBtn.exclusiveTouch = YES;
    [shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * shareBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    shareBtn.tag=10;
    self.shareBtn=shareBtn;
    self.navigationItem.rightBarButtonItem=shareBtnItem;
    [shareBtnItem release];
    
    
    //设置版本号
    self.versionLabel.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag==10) {//分享
        HB_share * share = [[[HB_share alloc] init] autorelease];
        [share shareWithCurrentVc:self andTitle:nil andText:@"号簿助手，让生活更便捷，马上下载安装吧！http://pim.189.cn" andUrl:nil andImage:[UIImage imageNamed:@"官方图标"] andSharePlatForms:nil];
    }else if (sender.tag==11){//url
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pim.189.cn"]];
    }
}


@end
