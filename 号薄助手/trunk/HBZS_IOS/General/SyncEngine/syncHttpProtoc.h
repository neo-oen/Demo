//
//  syncHttpProtoc.h
//  pimer
//
//  Created by Lee John on 12-5-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIHTTPRequest.h"
#import "ProtocolBuffers.h"
#import "GetConfigProto.pb.h"
#import "AuthProto.pb.h"
#import "GetContactListSummaryProto.pb.h"
#import "SyncDownloadContactProto.pb.h"
#import "GetContactListVersionProto.pb.h"
#import "DownloadPortraitProto.pb.h"
#import "SyncPortraitProto.pb.h"
#import "UploadPortraitProto.pb.h"
#import "UploadContactInfoProto.pb.h"
#import "SyncUploadContactProto.pb.h"
#import "TpnoolProto.pb.h"
#import "DeviceSignProto.pb.h"
#import "ClientReportProto.pb.h"
#import "SyncEngine.h"
#import "GetUserCloudSummaryProto.pb.h"
#import "HBZSAppDelegate.h"

@class syncHttpProtoc;




typedef enum _ProtocStatus
{
	PROTOC_STATUS_GET_CONFIG = 1,               //获取系统配置
	PROTOC_STATUS_AUTHEN = 2,                   //认证
	PROTOC_STATUS_GET_CONTACTLIST_SUM = 3,      //获取联系人与联系人组列表摘要
	PROTOC_STATUS_UPLOAD_ALL = 4,               //全量上传联系人信息
	PROTOC_STATUS_GET_VERSION = 5,              //取得联系人列表版本号
	PROTOC_STATUS_DOWNLOAD_CONTACT = 6,         //联系人同步下载
	PROTOC_STATUS_UPLOAD_DIFFER_CONTACT = 7,	//联系人同步上传
	PROTOC_STATUS_SYNC_PROTRAIT = 8,			//头像摘要同步
	PROTOC_STATUS_UPLOAD_PROTRAIT = 9,          //头像上传
	PROTOC_STATUS_DOWNLOAD_PROTRAIT = 10,       //头像下载
	PROTOC_STATUS_GET_TPNOOL = 11,              //归属地数据下载
	PROTOC_STATUS_SYNC_SMS = 12,				//短信摘要同步
	PROTOC_STATUS_SMS_UPLOAD = 13,              //短信上传
	PROTOC_STATUS_SMS_DOWNLOAD = 14             //短信下载
}ProtocStatus;

// call back function of syncEngine
@protocol syncHttpProtocDelegate <NSObject>

@optional

- (void)syncTaskStatus:(SyncState_t)statusCode;

- (void)syncTaskFinished:(ASIHTTPRequest *)request;

- (void)requestFailed:(ASIHTTPRequest *)request;

@end

@interface syncHttpProtoc : NSObject <ASIHTTPRequestDelegate>
{
	// The url for get-config
	NSURL *configUrl;

	NSArray *arrayTaskString;
	
	GetConfigResponse *configResponse;
	
    AuthResponse *authResponse;

	ASIHTTPRequest *currentRequest;         // 记录当前Http请求，为了能够执行取消动作
	
	NSTimer *timer;
	
    int tokenExpires;
    
    NSString *clientVersion;
    
    HBZSAppDelegate *appDelegate;
	
	// The delegate - will be notified of http protoc in state via the syncHttpProtocDelegate protocol
	id <syncHttpProtocDelegate> delegate;
    
    NSThread* syncThread;
    
    
}

@property (assign, nonatomic) id <syncHttpProtocDelegate> delegate;

@property (assign, nonatomic) int tokenExpires;


- (void)reAuth;

- (AuthResponse *)getAuthResponse;

- (id)initWithURLString:(NSString *)strServerURL;

- (void)startTaskRequest:(SyncTaskType)syncTaskType;

- (void)cancelCurrentTask;                 //取消当前任务

- (void)syncStatusRefresh:(BOOL) waitDone;

// method of protocol ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request;

- (void)requestFailed:(ASIHTTPRequest *)request;

/*
 * 对memAB操作失败处理
 */
- (void)procABFailed:(ASIHTTPRequest *)request ErrCode:(int32_t)errCode;
/*
 * 对Portrait操作失败处理
 */
- (void)procPortraitFailed:(ASIHTTPRequest *)request ErrCode:(int32_t)errCode;

- (void)handleTimer:(NSTimer *) timer;
/*
 * 保存联系人总版本号
 */
- (void)saveContactListVersion:(int32_t)contactListVersion;
/*
 * 获取本地保存的联系人总版本号
 */
- (int32_t)getContactListVersion;
/*
 * 改变使用代理的状态
 */
- (void)changeProxyStatus;
/*
 * 判断是否使用代理
 */
- (BOOL)isNeedProxy;
/*
 * 设备签到
 */
- (void)deviceSign;

#pragma mark 同步协议

//init ASIHTTPRequest
- (ASIHTTPRequest *)initConfigRequest;

- (ASIHTTPRequest *)initAuthRequest;

- (ASIHTTPRequest *)initGetContactSummaryRequest;

- (ASIHTTPRequest *)initPortraitSummaryRequest;

- (ASIHTTPRequest *)initGetVersionRequest;

- (ASIHTTPRequest *)initDownloadContactRequest;

- (ASIHTTPRequest *)initBatchUploadAllContactRequest:(NSURL *)url;

- (ASIHTTPRequest *)initBatchDownloadContactRequest;

- (ASIHTTPRequest *)initDownloadPortraitRequest;

- (ASIHTTPRequest *)initUPloadDifferContactRequest;

//上传consle 日志
- (ASIHTTPRequest *)initPlainClientReportRequest;
- (ASIHTTPRequest *)initDeviceSignRequest;
/*
 * 保存 configUrl
 */
- (void)saveConfigUrl;
/*
 * 获取服务地址列表
 */
- (BOOL)syncGetConfig;
/*
 * 获取归属地信息
 */
- (BOOL)syncGetTpnool;

#pragma mark 异步协议：protocType用于流程跳转控制
/*
 * 认证
 */
- (void)syncAuthen:(SyncTaskType)syncTaskType;
/*
 * 下载联系人
 */
- (void)syncDownloadContact:(NSArray *)contactSummaryList 
				GroupIDList:(NSArray *)groupSummaryList 
                   TaskType:(SyncTaskType)syncTaskType;
/*
 * 获取联系人列表信息和组信息
 */
- (void)syncGetContactSummary:(SyncTaskType)syncTaskType;
/*
 * 获取联系人版本号
 */
- (void)syncGetVersion:(SyncTaskType)syncTaskType;
/*
 * 下载联系人头像
 */
- (void)syncDownloadPortrait:(NSArray *)contactSummaryList
				CardPortrait:(BOOL)IsRequestBusinessCardPortrait
                    TaskType:(SyncTaskType)syncTaskType;
/*
 * 头像摘要同步
 */
- (void)syncPortraitSummary:(NSArray *)portraitSummary 
        BusinessCardVersion:(int32_t)businessCardVersion 
                   TaskType:(SyncTaskType)syncTaskType;
/*
 * 头像上传
 */
- (void)syncUploadPortrait:(NSArray*)mutablePortraitList 
      BusinessCardPortrait:(PortraitData*)businessCardPortrait
                  TaskType:(SyncTaskType)syncTaskType;
/*
 * 全量上传
 */
- (void)syncUploadAllContact:(NSArray*)contactList
                   GroupList:(NSArray*)groupList
                BusinessCard:(Contact*)businessCard
                    TaskType:(SyncTaskType)syncTaskType;

/*
 * 同步上传
 */
- (void)syncUPloadDifferContact:(NSArray*)contactAddList		//追加联系人信息
				 ContactUpdList:(NSArray*)contactUpdList		//更新联系人信息
				 ContactDelList:(NSArray*)contactDelList		//删除联系人信息
				   GroupAddList:(NSArray*)groupAddList			//追加分组信息
				   GroupUpdList:(NSArray*)groupUpdList			//更新分组信息
				   GroupDelList:(NSArray*)groupDelList			//删除分组信息
			 ContactListSummary:(NSArray*)contactListSummary	//所有联系人信息摘要
			   GroupListSummary:(NSArray*)groupListSummary		//所有联系人组信息摘要
				   BusinessCard:(Contact*)businessCard			//名片
			BusinessCardVersion:(int32_t)businessCardVersion	//名片版本号
                       TaskType:(SyncTaskType)syncTaskType;


#pragma mark 异步协议结果处理
- (void)syncAuthenFinished:(ASIHTTPRequest *)request;

- (void)syncGetContactSummaryFinished:(ASIHTTPRequest *)request;

- (void)syncDownloadContactFinished:(ASIHTTPRequest *)request;

- (void)syncGetVersionFinished:(ASIHTTPRequest *)request;

- (void)syncDownloadPortraitFinished:(ASIHTTPRequest *)request;

- (void)syncPortraitSummaryFinished:(ASIHTTPRequest *)request;

- (void)syncUploadPortraitFinished:(ASIHTTPRequest *)request;

//- (void)syncUploadAllContactFinished:(ASIHTTPRequest *)request;

- (void)syncUPloadDifferContactFinished:(ASIHTTPRequest *)request;

// ASI返回结果的处理线程
- (void)syncResponseHandler;

- (void)syncHandlerTimeout;

- (void)notifyAction:(SEL)aSelector ASIRequest:(ASIHTTPRequest *)request;

- (void)requestFinishedHandler:(ASIHTTPRequest *)request;

#pragma mark batch upload and download 
/*
 * 下载联系人: 同步方式分批下载
 */
- (void)batchDownloadContact:(NSArray *)contactSummaryList
                 GroupIDList:(NSArray *)groupSummaryList
                    TaskType:(SyncTaskType)syncTaskType;
/*
 * 全量上传: 同步方式分批上传
 */
- (void)batchUploadAllContact:(NSArray*)contactList
                    GroupList:(NSArray*)groupList
                 BusinessCard:(Contact*)businessCard
                     TaskType:(SyncTaskType)syncTaskType;

#pragma mark jumpToPortraitSync 
/*
 *  客户端判断不需要做联系人各种同步，但是需要进行头像同步时，可由以下方法跳转
 *  包括：双向同步、慢同步、同步上传、同步下载
 */
- (void)jumpToPortraitSync:(SyncTaskType)syncTaskType;

/*
 * 更新群组MappingInfo
 */
- (void)updateGroupMappingInfo:(NSArray *)groupMappingInfoList request:(ASIHTTPRequest *)request;

/*
 * 更新联系人MappingInfo
 */
- (void)updateContactMappingInfo:(NSArray *)contactMappingInfoList request:(ASIHTTPRequest *)request;

/*
 * 删除群组
 */
- (void)deleteGroup:(NSArray *)deletedGroupIdList request:(ASIHTTPRequest *)request;

/*
 * 删除联系人
 */
- (void)deleteContact:(NSArray *)deletedContactIdList request:(ASIHTTPRequest *)request;

#pragma mark 如果没有联系人或者群组下载，则单独下载名片
- (BOOL)downloadBussinessCard:(SyncTaskType)syncTaskType;

+ (void)setSyncStatusEvent;

@end





