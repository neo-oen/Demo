//
//  CTPass.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/5/6.
//
//

#import "CTPass.h"
#import "ASIHTTPRequest.h"
#import "DeviceTokenReportProto.pb.h"
#import "PushManager.h"
#import "ConfigMgr.h"
#import "Public.h"
#import "CtpassRequestProto.pb.h"
#import "QRCodeInfoModel.h"

#import "SVProgressHUD.h"
@implementation CTPass

@class CTPass;
static CTPass * CTP;

+(CTPass *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CTP = [[CTPass alloc] init];
    });
    return CTP;
}

-(void)dealloc
{
    [super dealloc];
    
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)CTPassTimerOverWithBlock:(void(^)())Blo
{
    self.TimerOverBlock = Blo;
    self.CTPassActiveTime = [NSTimer scheduledTimerWithTimeInterval:65 target:self selector:@selector(TimerOverClick) userInfo:nil repeats:NO];
}

-(void)TimerOverClick
{
    if (self.TimerOverBlock) {
        self.TimerOverBlock();
    }
}

-(void)timerCancel
{
    if (self.CTPassActiveTime) {
        [self.CTPassActiveTime invalidate];
        self.CTPassActiveTime = nil;
    }
}

/*
 * 快速认证入口
 */
-(void)AuthByCTPassWithPhoneNum:(NSString *)phoneNum andCTPassType:(CTPassType)type
{
    self.currentType = type;
    NSString*deviceToken= [[NSUserDefaults standardUserDefaults] objectForKey:PushDeviceToken];
    
    NSString *AuthByCTPassUrl = [[ConfigMgr getInstance] getValueForKey:@"AuthByOtaUrl" forDomain:nil];
    ASIHTTPRequest * request = [self CTPassTypeRequestWithUrl:AuthByCTPassUrl];
    DeviceTokenReportRequest * tokeninfo = [[[[[DeviceTokenReportRequest builder] setDeviceToken:deviceToken] setMdn:phoneNum] setMobileType:[PushManager doDevicePlatform]] build];
    
    NSData * data = [tokeninfo data];
    
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",[data length]]];
    
    [request setPostBody:[NSMutableData dataWithData:data]];
    
    request.delegate = self;
    [request startAsynchronous];
    
    
    

}


/*
 *第三方授权登录入口
 */
-(void)QRCodeAuthorizeByCTPassWithInfo:(NSDictionary *)QrCodeInfo andCTPassType:(CTPassType)type
{
    NSString* uname = [[ConfigMgr getInstance] getValueForKey:@"user_name" forDomain:nil];
    self.currentType = type;
    ASIHTTPRequest * request = [self CTPassTypeRequestWithUrl:[[ConfigMgr getInstance] getValueForKey:@"authByQrcodeUrl" forDomain:nil]];
    
    QRCodeInfoModel * model = [[QRCodeInfoModel alloc] init];
    [model setValuesForKeysWithDictionary:QrCodeInfo];
    model.mdn = uname;
    
    
    CTPassRequest * ctpassReq = [[[[[CTPassRequest builder] setMdn:model.mdn] setSeqId:model.seqId] setRandom:model.random] build];
    
    NSData * data = [ctpassReq data];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",[data length]]];
    
    [request setPostBody:[NSMutableData dataWithData:data]];
    
    request.delegate = self;
    
    [request startAsynchronous];
    
    [SVProgressHUD dismiss];
    
    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"授权请求已发送" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil] ;
    [al show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [al dismissWithClickedButtonIndex:0 animated:YES];
        [al release];

    });
    
    
}

/*
 *认证结果解析，跳转到相应后续处理
 */
-(void)QRCodeResultAnalyze:(NSString *)ResultCode
{
    if (ResultCode==nil) {
        
        return;
        
    }
    [SVProgressHUD showWithStatus:@"正在处理"];
    NSData * data = [ResultCode dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    QrCodeMenu operation = [dic[@"operation"] intValue];
    switch (operation) {
        case QRCode_Result_auth:
        {
            if ([self isAccountAllowed]) {
                [self QRCodeAuthorizeByCTPassWithInfo:dic andCTPassType:CTPass_QRCode_Auth];
            }
        }
            break;
            
        default:
        {
            [SVProgressHUD dismiss];
            UIAlertView * al = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"未能识别扫描结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [al show];
        }
            break;
    }
    
}

- (BOOL)isAccountAllowed{
    NSString* uname = [[ConfigMgr getInstance] getValueForKey:@"user_name" forDomain:nil];
    
    NSString* upass = [[ConfigMgr getInstance] getValueForKey:@"user_psw" forDomain:nil];
    BOOL isCTPassAuth = [[NSUserDefaults standardUserDefaults] boolForKey:CTPassAuth] ;
    if (isCTPassAuth && uname) {
        return YES;
    }
    if (uname == nil||upass==nil||[uname length]<=0||[upass length]<=0) {
        UIAlertView * al = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"使用CTPass授权第三方登录，请在登录状态下使用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [al show];
        
        return NO;
    }
    
    return YES;
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    switch (request.tag) {
        case CTPass_Auth:
            NSLog(@"登录接口请求错误 %d",request.responseStatusCode);
            
            break;
        case CTPass_QRCode_Auth:
        {
            NSLog(@"统一登录请求错误 %d",request.responseStatusCode);
            
        }
            break;
        default:
            break;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    switch (request.tag) {
            
        case CTPass_Auth:
            NSLog(@"登录接口请求错误 %d",request.responseStatusCode);
            break;
        case CTPass_QRCode_Auth:
            NSLog(@"统一登录请求错误 %d",request.responseStatusCode);
            break;
        default:
            break;
    }
}



-(ASIHTTPRequest *)CTPassTypeRequestWithUrl:(NSString * )url
{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    
    [request addRequestHeader:@"User-Agent" value:VersionClient];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    [request setShouldContinueWhenAppEntersBackground:YES];
    
    request.tag = self.currentType;

    
    return request;
}

@end
