//
//  HB_CloudShareSuccessVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/8/29.
//
//

#import "HB_CloudShareSuccessVc.h"
#import "HB_share.h"
#import "SVProgressHUD.h"
#import "MemAddressBook.h"
@interface HB_CloudShareSuccessVc ()

@end

@implementation HB_CloudShareSuccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self stepNav];
    
    self.UrlAndExtractCode.layoutManager.allowsNonContiguousLayout = NO; 
}


-(void)stepNav
{
    self.title = @"成功创建云分享";
    
    //右侧分享按钮
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, 0, 20, 20)];
    shareBtn.exclusiveTouch = YES;
    [shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * shareBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    shareBtn.tag=10;
//    self.shareBtn=shareBtn;
    self.navigationItem.rightBarButtonItem=shareBtnItem;
    [shareBtnItem release];
    
    
    
}

-(void)setCloudUrl
{
    NSString * str1 = @"成功创建云分享链接!\n\r";
    NSString * str2 = [NSString stringWithFormat:@"%@\r提取码：%@",self.shareSucModel.shareUrl,self.shareSucModel.extractCode];
    
    NSMutableAttributedString * attrtext = [[NSMutableAttributedString alloc] init];
    
    
    
    NSAttributedString * attr1 = [[NSAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorFromHexString:@"fd8727"]}];
    
    
    
    NSAttributedString * attr2 = [[NSAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorFromHexString:@"999999"]}];
    
    [attrtext appendAttributedString:attr1];
    [attrtext appendAttributedString:attr2];
    

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment=NSTextAlignmentCenter;
    [attrtext addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str1.length)];
    
    
    NSMutableParagraphStyle * paragraph2 = [[NSMutableParagraphStyle alloc] init];
    paragraph2.lineSpacing = 7;
    paragraph2.alignment = NSTextAlignmentCenter;
    [attrtext addAttribute:NSParagraphStyleAttributeName value:paragraph2 range:NSMakeRange(str1.length, str2.length)];
    
    _UrlAndExtractCode.attributedText = attrtext;
    
    [attr1 release];
    [attr2 release];
    [attrtext release];
    
    [paragraphStyle release];
    [paragraph2 release];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setCloudUrl];
    return;
    
}

-(void)titleLeftBackBtnDo:(UIButton *)btn
{
    NSArray * arr = self.navigationController.viewControllers;
    UIViewController * viewcontroller = arr[arr.count-3];
    [self.navigationController popToViewController:viewcontroller animated:YES];
}

-(void)btnClick:(UIButton *)sender
{
    NSArray * arr = @[UMShareToWechatSession,UMShareToQQ,UMShareToYXSession,UMShareToSms,UMShareToEmail];
    HB_share * share = [[[HB_share alloc] init] autorelease];
    
    NSString * str = [NSString stringWithFormat:@"【号簿助手】你的好友 %@ 给你分享了通讯录，请访问以下链接进行查看。链接：%@ 提取码：%@     温馨提示：请认准号簿助手官方网址pim.189.cn ，勿轻信其他链接。",self.MyshareName,self.shareSucModel.shareUrl,self.shareSucModel.extractCode];
    NSString * title = [NSString stringWithFormat:@"联系人提取码:%@",self.shareSucModel.extractCode];
    [share shareWithCurrentVc:self andTitle:title andText:str andUrl:nil andImage:nil andSharePlatForms:arr];
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (Device_Height<=480) {
        self.bottomTextFormBottom.constant = 10;
        self.headImageFormText.constant = 20;

    }
}

- (IBAction)copyBtnClick:(id)sender {
    //辅助到剪贴板
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = [NSString stringWithFormat:@"【号簿分享】链接：%@ 提取码：%@ ；",self.shareSucModel.shareUrl,self.shareSucModel.extractCode];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"已复制到剪贴板"];
    
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
    [_UrlAndExtractCode release];
    [_bottomTextFormBottom release];
    [_headImageFormText release];
    [super dealloc];
}
@end
