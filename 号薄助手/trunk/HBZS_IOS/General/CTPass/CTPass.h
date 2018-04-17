//
//  CTPass.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/5/6.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import <MessageUI/MessageUI.h>

#define CTPassAuth @"AuthByCTPass"

@class SetAccountView;

@interface CTPass : NSObject<ASIHTTPRequestDelegate>

typedef enum _CTPassType
{
    CTPass_Auth = 1,
    CTPass_QRCode_Auth = 2
}CTPassType;

typedef enum
{
    QRCode_Result_auth =1,
}QrCodeMenu;

typedef enum
{
    CTPass_Result_Success =0,
    CTPass_Result_NotAllow = 1,
    CTPass_Result_ReqFaild = 2
}ResultType;

+(CTPass *)shareManager;

/*
 * 快速认证入口
 */
-(void)AuthByCTPassWithPhoneNum:(NSString *)phoneNum andCTPassType:(CTPassType)type;

-(void)CTPassTimerOverWithBlock:(void(^)())Blo;
-(void)timerCancel;

-(void)QRCodeResultAnalyze:(NSString *)ResultCode;//解析扫描结果

@property(assign)int currentType;
@property(nonatomic,strong)NSTimer * CTPassActiveTime;

@property(nonatomic,copy)void(^TimerOverBlock)();

@end

