//
//  memberWebViewCtr.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/29.
//
//

#import "memberWebViewCtr.h"
#import "HB_MessageCenterVC.h"
#import "HB_ContactCloudShareVc.h"
#import "TimeMachineCtrl.h"
#import "NetMessageViewController.h"
#import "HB_UnlimitedBackUpContorller.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GetMemberInfoProto.pb.h"
#import "SVProgressHUD.h"
#import "HB_httpRequestNew.h"
@interface memberWebViewCtr ()

@property(nonatomic,strong)JSContext *context;

@end

@implementation memberWebViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    
    [self webClickWithJavascript];
    
    
}

-(void)webClickWithJavascript
{
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context.exceptionHandler = ^(JSContext * context,JSValue * exceptionValue)
    {
        context.exception = exceptionValue;
        
        NSLog(@"%@",exceptionValue);
    };
    
    self.context[@"pimVipDredgeBackInTime"] =^()
    {
//        if ([self isVipMember]) {
//        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            HB_UnlimitedBackUpContorller * VC = [[HB_UnlimitedBackUpContorller alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            [VC release];
        });
        
        

        //跳转到时光机
    };
    self.context[@"pimVipSecuritUpgrade"] =^()
    {
        if ([self isVipMember]) {
            return ;
        }
        //ctpass登录  --待定
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"iOS版暂未开放" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            [al release];
        });
       
    };
    self.context[@"pimVipOpenToTemind"] =^()
    {
        //来电提醒
        if ([self isVipMember]) {
            return ;
        }
    };
    self.context[@"pimVipSharedMyAddressBook"] =^()
    {
        //通讯录云分享
        if ([self isVipMember]) {
            return ;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            HB_ContactCloudShareVc * vc= [[HB_ContactCloudShareVc alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        });
       
    };
    self.context[@"pimVipStartNetSms"] =^()
    {
        if ([self isVipMember]) {
            return ;
        }
        //网络短信
        NSLog(@"网络短信");
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NetMessageViewController * vc = [[NetMessageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        });
        

    };
    
    
    self.context[@"GetRechargeUrl"] =^()//pimVipRecharge
    {
        if ([self isVipMember]) {
            return ;
        }
        //充值
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://moneypay.live.189.cn/pimobi/?260"]]];

        });
    };
    
    
}

-(BOOL)isVipMember
{
     MemberInfoResponse * myMemberInfo = [MemberInfoResponse parseFromData:[SettingInfo getMemberInfo]];
    if (myMemberInfo.memberLevel<self.model.memberlevel) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
//            UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此服务为会员专享，请先购买会员" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [al show];
//            [al release];
            [SVProgressHUD showInfoWithStatus:@"此服务为会员专享，请先购买会员"];
            
            [HB_httpRequestNew buyMemberWithVc:self];
            
            
        });
       
        return YES;
    }
    
    return NO;
}

- (void)getServiceData:(NSNotification *)notification {
    
    NSLog(@"res_code: %@",[notification.object objectForKey:@"res_code"]);
    NSLog(@"res_message: %@",[notification.object objectForKey:@"res_message"]);
    NSLog(@"trade_id: %@",[notification.object objectForKey:@"trade_id"]);
    NSLog(@"%@",notification);
    
    NSDictionary * dic = notification.object;
    
    if ([[dic objectForKey:@"res_code"] integerValue] == 0&& [dic objectForKey:@"order_no"]) {
        
        [self orderMemberWithPayInfo:dic OrderType:MemberTypeBuy];
        
    }
    else
    {
        [HB_httpRequestNew PayBackInfo:[dic objectForKey:@"res_message"]];
    }
    
}
-(void)orderMemberWithPayInfo:(NSDictionary *)PayDic OrderType:(MemberType)type
{
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    
    HB_OrderMemberModel * model = [[HB_OrderMemberModel alloc] init];
    
    model.order_no= [PayDic objectForKey:@"order_no"];
    model.memberLevel = MemberLevelVip;
    model.memberType = type;
    if (type==MemberTypeBuy) {
        model.price = Open189_Price;
    }
    [req OrderMemberWithOrderInfo:model Result:^(BOOL isSuccess, MemberOrderResponse *MOResponse) {
        
        if (!isSuccess) {
            NSLog(@"请求失败");
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"会员变更失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return ;
        }
        
    }];
    
    
    [req release];
    [model release];
    
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
