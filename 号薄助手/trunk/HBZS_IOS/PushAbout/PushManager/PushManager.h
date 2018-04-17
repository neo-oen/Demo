//
//  PushManager.h
//  HBZS_iOS
//
//  Created by 冯强迎 on 15/3/27.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "DeviceTokenReportProto.pb.h"
#import "sys/sysctl.h" //后去设备型号用
#import "NewMessage.h"
#define PushDeviceToken @"deviceToken"
#define isUploadTokenToServer @"isUploadToServer"
#define PushIsAllowed @"PushIsAllowed"
@class MainViewCtrl;// 遇到相互包含的问题了




@protocol PushNotificationDelegate <NSObject>

-(void)pustToNotificationDetailVC:(NewMessage *)Message;
//跳转到消息详情页面
@end



@interface PushManager : NSObject<ASIHTTPRequestDelegate>

@property(nonatomic,strong)NSString * deviceTokenReportUrl;

@property(nonatomic,strong)NSString * Version_client;

@property(nonatomic,strong)id<PushNotificationDelegate>PushDelegate;


+(PushManager *)shareManager;
+ (NSString*) doDevicePlatform;

-(NSInteger)getNoReadMessagesCount;

-(BOOL)pushInfoToServerWithToken:(NSString *)deviceToken andUserID:(NSString *)UserID;

- (NSString*) doDevicePlatform; //获取当前设备详细型号

-(UIViewController *)getCurrentVC;//获取当前视图

-(void)pushToViewControllver:(int)MessageID andMainVc:(MainViewCtrl *)mainVc;

-(BOOL)getMessgerforServer;

-(NSArray *)getmemberHotActivityFormServer;
@end
