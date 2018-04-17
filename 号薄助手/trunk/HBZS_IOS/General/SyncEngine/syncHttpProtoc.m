//
//  syncHttpProtoc.m
//  pimer
//
//  Created by Lee John on 12-5-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "syncHttpProtoc.h"
#import "Public.h"
#import "GobalSettings.h"
#import "MemAddressBook.h"
#import "SyncErr.h"
#import "SettingInfo.h"
#import "UIDevice+Extension.h"
#import "CTPass.h"
#import "HB_MachineDataModel.h"

#define TOKEN_VALID_TIME	0x0FFFFFFF

extern SyncStatusEvent sse;

@implementation syncHttpProtoc

@synthesize delegate;

@synthesize tokenExpires;


- (AuthResponse *)getAuthResponse{
    return authResponse;
}

#pragma mark init / dealloc
- (id)initWithURLString:(NSString *)strServerURL
{
	self = [self init];
	configUrl = [[NSURL alloc] initWithString:strServerURL];
    
	appDelegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    // 这个timer目前仅用于计算token的超时时间
	timer = [NSTimer scheduledTimerWithTimeInterval: 1
											 target: self
										   selector: @selector(handleTimer:)
										   userInfo: nil
											repeats: YES];
	
    //版本号
    clientVersion = [[NSString alloc] initWithString:VersionClient];
	
    arrayTaskString = [[NSArray alloc] initWithObjects:@"unknown",@"ALL_UP",@"ALL_DOWN",@"SYNC_UP",@"SYNC_DOWN",@"SYNC",@"SLOW_SYNC",@"AUTHEN",@"DEVICE_SIGN",@"CLOUDSUMMARY",nil];
    
    // start routine thread.
	syncThread = [[NSThread alloc] initWithTarget:self selector:@selector(syncResponseHandler) object:nil];
    
	[syncThread start];
	
    currentRequest = nil;
	return self;
}



- (void)dealloc
{
	if (currentRequest)
	{
		[currentRequest release];
        
		currentRequest = nil;
	}
    
	[timer invalidate];
    
    if (configUrl) {
        [configUrl release];
        
        configUrl = nil;
    }
	
    if (authResponse) {
       [authResponse release];
        
        authResponse = nil;
    }
    
    if (configResponse) {
        [configResponse release];
        
        configResponse = nil;
    }
    
    if (clientVersion) {
        [clientVersion release];
        
        clientVersion = nil;
    }
    
    if (arrayTaskString) {
        [arrayTaskString release];
        
        arrayTaskString = nil;
    }
   
    
	[super dealloc];
}

- (void) handleTimer:(NSTimer *) timer
{
    // 计算token的超时时间。
    // token将在(tokenExpires)秒后失效
	if (tokenExpires > 0)
	{
		tokenExpires--;
	}
}

#pragma mark syncStatusRefresh
- (void)syncStatusRefresh:(BOOL) waitDone
{
#if 1
    //********************** 在刷新UI之前，若满足以下条件则开始上传日志 ************************************//
    if (sse.taskType >= 1 && sse.taskType <=6 && (sse.status == Sync_State_Success || sse.status == Sync_State_Faild))
    {
        // 获取当前已经连续上传日志的次数
        int32_t logUploadTimes = [[[ConfigMgr getInstance]getValueForKey:[NSString stringWithFormat:@"LogUploadTimes"]
                                                               forDomain:[NSString stringWithFormat:@"SyncInfo"]] intValue];
        logUploadTimes++;
        
        if (logUploadTimes >=5){//如果大于5，置0
            logUploadTimes = 0;
            
            [SettingInfo setIsLogged:NO];
        }
        
        // 保存当前已经连续上传日志的次数
        [[ConfigMgr getInstance] setValue:[NSString stringWithFormat:@"%d", logUploadTimes]
                                   forKey:[NSString stringWithFormat:@"LogUploadTimes"]
                                forDomain:[NSString stringWithFormat:@"SyncInfo"]];
        
        ZBLog(@"plain log report..%d", logUploadTimes);
        
        NSString *account = [[ConfigMgr getInstance] getValueForKey:[NSString stringWithFormat:@"user_name"]
                                                          forDomain:nil];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *fileName =[NSString stringWithFormat:@"PIMIOS.log"];
        
        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        //ZBLog(@"logFilePath...%@",logFilePath);
        
        NSArray *lines = [[NSString stringWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:nil]
                          componentsSeparatedByString:@"\n"];
        
        int32_t lineCount = [lines count];
        
        if (lineCount <= 0)
        {
           // ZBLog(@"no log ?");
            /// Added by Kevin Zhang on Feb,23 2013 18:45 p.m
            [appDelegate performSelectorOnMainThread:@selector(syncStatusRefresh)
                                          withObject:nil waitUntilDone:waitDone];
            return;
        }
        
        int32_t line = lineCount;
        
        while (line > 0)
        {
          //  ZBLog(@"line-1 = %d",line-1);
            NSString *lineString = [lines objectAtIndex:line-1];
       
            NSRange range = [lineString rangeOfString:@"start task:"];
            
            if (range.length > 0){
                break;
            }
            
            line--;
        }
        
        NSMutableString *logString = [[NSMutableString alloc] initWithString:@""];
        
        if (line > 0){
            while (line <= lineCount){
               // ZBLog(@"line-1 xx= %d",line-1);
                NSString *lineString = [lines objectAtIndex:line-1];
                
                [logString appendString:lineString];
                
                [logString appendString:@"\n"];
                
                line++;
            }
        }
        
        //ZBLog(@"%@", logString);
        
        if ([logString length] <= 0){
         //   ZBLog(@"no log !");
            [logString release];
            /// Added by Kevin Zhang on Feb,23 2013 18:45 p.m
            [appDelegate performSelectorOnMainThread:@selector(syncStatusRefresh)
                                          withObject:nil waitUntilDone:waitDone];
            return;
        }
        
        // 修改日志文件的编码为UTF8.否则在有中文的情况下，dataUsingEncoding会失败。
        PlainClientReportRequest *_logReport = [[[[PlainClientReportRequest builder]
                                                  setMobileNo:account]
                                                 setPlainTrace:[logString dataUsingEncoding:NSUTF8StringEncoding]]
                                                build];
        
        NSData *requestData = [_logReport data];
        
        NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
        
        ASIHTTPRequest *request = [self initPlainClientReportRequest];
        
        [request addRequestHeader:@"Content-Length" value:length];
        
        [request appendPostData:requestData];
        
        [request startSynchronous];
        
        NSError *error = [request error];
        
        if (error){
            ZBLog(@"localizedFailureReason:%@", [error localizedFailureReason]);
        }
        
        if (currentRequest) {
            [currentRequest release];
        }
        
        currentRequest = request;
        
        [currentRequest retain];
        
        [logString release];
        ZBLog(@"plain log report finish.");
    }
    
#endif
	[appDelegate performSelectorOnMainThread:@selector(syncStatusRefresh) withObject:nil waitUntilDone:waitDone];
}

- (void)saveContactListVersion:(int32_t)contactListVersion
{
    [[ConfigMgr getInstance] setValue:[NSString stringWithFormat:@"%d", contactListVersion]
                               forKey:[NSString stringWithFormat:@"contactListVersion"]
                            forDomain:[NSString stringWithFormat:@"SyncServerInfo"]];
}

#pragma mark 获得联系人列表版本
- (int32_t)getContactListVersion
{
    return [[[ConfigMgr getInstance] getValueForKey:[NSString stringWithFormat:@"contactListVersion"]
                                          forDomain:[NSString stringWithFormat:@"SyncServerInfo"]] intValue];
}

#pragma mark  改变代理状态
/*
 *  在HTTP请求失败时更改是否使用代理的标志
 */
- (void)changeProxyStatus
{
    int32_t needProxy = [[[ConfigMgr getInstance] getValueForKey:[NSString stringWithFormat:@"IsNeedProxy"]
                                                       forDomain:[NSString stringWithFormat:@"SyncServerInfo"]] intValue];
    needProxy = 1 - needProxy;
    
    NSLog(@"proxy: %d",needProxy);
    
    [[ConfigMgr getInstance] setValue:[NSString stringWithFormat:@"%d", needProxy]
                               forKey:[NSString stringWithFormat:@"IsNeedProxy"]
                            forDomain:[NSString stringWithFormat:@"SyncServerInfo"]];
    ZBLog(@"**********changeProxyStatus:%d**********", needProxy);
}

#pragma mark 判断是否需要代理 1 需要代理   0 不需要代理
- (BOOL)isNeedProxy
{
	int32_t needProxy = [[[ConfigMgr getInstance] getValueForKey:[NSString stringWithFormat:@"IsNeedProxy"]
                                                       forDomain:[NSString stringWithFormat:@"SyncServerInfo"]] intValue];
    if (needProxy == 1){
        return YES;
    }
    
    return NO;
}

#pragma mark 设备签到
- (void)deviceSign
{
    // 先获取system config，再调用device sign...
    if (configResponse == nil)
	{
		if ([self syncGetConfig] == NO)
		{
			return;
		}
	}
    
#pragma mark - 判断并上传deviceToken 推送相关
    NSUserDefaults *handler = [NSUserDefaults standardUserDefaults];
    if ([handler boolForKey:isUploadTokenToServer]==NO&&[handler objectForKey:PushDeviceToken] != nil) {
        //执行上传deviceToken
        PushManager * manager = [PushManager shareManager];
        manager.deviceTokenReportUrl = configResponse.deviceTokenReportUrl;
        BOOL issucceed=[manager pushInfoToServerWithToken:[handler objectForKey:PushDeviceToken] andUserID:@""];
        
        if (issucceed) {
            [handler setBool:YES forKey:isUploadTokenToServer];
        }
    }
#pragma mark -

    
  
    NSString *cfuuid = [UIDevice getUUID];
    
    DeviceSignRequest *_deviceSign =
    [[[DeviceSignRequest builder] setDeviceId:[NSString stringWithFormat:@"%@", cfuuid]] build];
    
    ZBLog(@"Device Sign:%@", cfuuid);
    
    NSData *requestData = [_deviceSign data];
    
    NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
    
    ASIHTTPRequest *request = [self initDeviceSignRequest];
    
    [request addRequestHeader:@"Content-Length" value:length];
	
    [request appendPostData:requestData];
    
	[request startSynchronous];
	
    if (currentRequest) {
		[currentRequest release];
	}
	
    currentRequest = request;
	
    [currentRequest retain];
}


#pragma mark entrance point
// 同步引擎syncEngine从这里开始调用
- (void)startTaskRequest:(SyncTaskType)syncTaskType
{
	if (currentRequest){
		if ([currentRequest isExecuting]){
			ZBLog(@"cannot start new task【%@】，old task in running【%@】", [arrayTaskString objectAtIndex:syncTaskType], [arrayTaskString objectAtIndex:currentRequest.syncTaskType]);
			return;
		}
	}
	
    if (syncTaskType == TASK_DEVICE_SIGN){
        [self deviceSign];     //设备签到,程序启动就调用
        
        return;
    }

	ZBLog(@"start task:【%@】...", [arrayTaskString objectAtIndex:syncTaskType]);
    
	memset(&sse, 0, sizeof(sse));
	
    sse.taskType = syncTaskType;
	
    sse.status = Sync_State_Initiating;
	
    [self syncStatusRefresh:YES];
	
	if (configResponse == nil){    // 在开始第一个protoc请求时，用同步方式先获取服务器配置的服务地址列表
		if ([self syncGetConfig] == NO){
            if (syncTaskType == TASK_AUTHEN) {
                
            }
			return;
		}
	}
    
	sse.status = Sync_State_Connecting;
	
    [self syncStatusRefresh:YES];
    
	ZBLog(@"startTaskRequest:%@", [arrayTaskString objectAtIndex:syncTaskType]);
    
    tokenExpires = 0;
    
    //内存提前释放？
    if (authResponse != nil){
        [authResponse release];
        
        authResponse = nil;
    }
    
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    BOOL isCTPassAuth = [user boolForKey:CTPassAuth];
    if (isCTPassAuth) {
        [self syncTypeByCTPassAuth:syncTaskType];
    }
    else{
        [self syncAuthen:syncTaskType];// 重新认证
    }
    
}

#pragma mark sync http response handler routine method.
/*
 *  sync http response handler routine method.
 */
- (void)syncResponseHandler
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	[NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(syncHandlerTimeout)
                                   userInfo:nil repeats:YES];
	while (TRUE){
        ZBLog(@"syncHttpProtoc:");
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		ZBLog(@"syncHttpProtoc: next step within runloop.");
	}
exit:
	[pool release];
	ZBLog(@"syncHttpProtoc: sync engine routine quit.");
}

- (void)syncHandlerTimeout
{
	ZBLog(@"syncHttpProtoc: syncHandlerTimeout called.");
}

- (void)notifyAction:(SEL)aSelector ASIRequest:(ASIHTTPRequest *)request
{
	[self performSelector:aSelector onThread:syncThread withObject:request waitUntilDone:NO];
}

#pragma mark 取消当前任务
/*
 * 取消当前任务
 */
- (void)cancelCurrentTask
{
	if (currentRequest){
		if ([currentRequest isExecuting]){
			[currentRequest cancel];
			ZBLog(@"%@:user cancel task。", [arrayTaskString objectAtIndex:currentRequest.syncTaskType]);
		}
	}
	else{
		ZBLog(@"canceling task : currentRequest unvalid");
	}
}

#pragma mark requestFinishedHandler
/*
 * requestFinishedHandler
 */
- (void)requestFinishedHandler:(ASIHTTPRequest *)request
{
    if ([request isCancelled] && ![request isFinished]){
		memset(&sse, 0, sizeof(sse));
        
		sse.taskType = currentRequest.syncTaskType;
		
        sse.status = Sync_State_Faild;  //存在
		
        sse.reason = GENERAL_ERR_USER_CANCEL;
		
        [self syncStatusRefresh:YES];
		ZBLog(@"%@:uner cancel task。task failed。", [arrayTaskString objectAtIndex:request.syncTaskType]);
		return;
	}
    
	switch (request.protocStatus)
	{
        case PROTOC_STATUS_AUTHEN:{
			[self syncAuthenFinished:request];//认证完成
            break;
        }
		case PROTOC_STATUS_DOWNLOAD_CONTACT:{
            [self syncDownloadContactFinished:request];//下载联系人完成
            break;
        }
        case PROTOC_STATUS_GET_CONTACTLIST_SUM:{
            [self syncGetContactSummaryFinished:request];//获取摘要完成
			break;
        }
		case PROTOC_STATUS_GET_VERSION:{
			[self syncGetVersionFinished:request];//获取联系人版本号完成
			break;
        }
        case PROTOC_STATUS_DOWNLOAD_PROTRAIT:{
            [self syncDownloadPortraitFinished:request];//下载联系人头像完成
            break;
        }
        case PROTOC_STATUS_UPLOAD_ALL:{
            // [self syncUploadAllContactFinished:request];//上传所有联系人完成
            break;
        }
        case PROTOC_STATUS_UPLOAD_PROTRAIT:{
            [self syncUploadPortraitFinished:request];//上传联系人头像完成
            break;
        }
        case PROTOC_STATUS_UPLOAD_DIFFER_CONTACT:{
            [self syncUPloadDifferContactFinished:request];//同步上传联系人完成
            break;
        }
        case PROTOC_STATUS_SYNC_PROTRAIT:{
            [self syncPortraitSummaryFinished:request];//头像摘要同步完成
            break;
        }
		default:
			break;
	}
}

#pragma mark ASIHTTPRequestDelegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self notifyAction:@selector(requestFinishedHandler:) ASIRequest:request];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self saveContactListVersion:-1];          // 操作失败以后，下一次必须使用慢同步，所以记录本地版本号为-1

	NSError *error = [request error];
	
    memset(&sse, 0, sizeof(sse));  //Added by Kevin on June,20 2013
    
    sse.taskType = request.syncTaskType;
	
    sse.status = Sync_State_Faild;  //存在
	
    if ([request isCancelled]){
		sse.reason = GENERAL_ERR_USER_CANCEL;
		ZBLog(@"%@:任务失败。原因:用户已取消任务。", [arrayTaskString objectAtIndex:request.syncTaskType]);
	}
	else{
		sse.reason = [error code];
        ZBLog(@"%@:任务失败。reason=%d", [arrayTaskString objectAtIndex:request.syncTaskType], [error code]);
        
        // 当用户突然某一天在平台侧修改了密码，需要通知UI提示密码错误 -- 2013/01/24
        if (request.protocStatus == PROTOC_STATUS_AUTHEN && request.responseStatusCode == 401){
            sse.reason = GENERAL_ERROR_PASSWORD;
        }
	}
    
	[self syncStatusRefresh:YES];
	
    switch (request.protocStatus)
	{
        case PROTOC_STATUS_AUTHEN://认证失败
			ZBLog(@"%@:认证失败. Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [error code]);
            break;
		case PROTOC_STATUS_DOWNLOAD_CONTACT://下载联系人失败
            ZBLog(@"%@:下载联系人失败. Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [error code]);
            break;
        case PROTOC_STATUS_GET_CONTACTLIST_SUM://获取摘要失败
            ZBLog(@"%@:获取摘要失败. Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [error code]);
			break;
		case PROTOC_STATUS_GET_VERSION://获取联系人版本号失败
			ZBLog(@"%@:获取联系人版本号失败. Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [error code]);
			break;
        case PROTOC_STATUS_DOWNLOAD_PROTRAIT://下载联系人头像失败
            ZBLog(@"%@:下载联系人头像失败. Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [error code]);
            break;
        case PROTOC_STATUS_UPLOAD_ALL://上传所有联系人失败
            ZBLog(@"%@:上传所有联系人失败. Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [error code]);
            break;
        case PROTOC_STATUS_UPLOAD_PROTRAIT://上传联系人头像失败
            ZBLog(@"%@:上传联系人头像失败. Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [error code]);
            break;
        case PROTOC_STATUS_UPLOAD_DIFFER_CONTACT://同步上传联系人失败
            ZBLog(@"%@:同步上传联系人失败. Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [error code]);
            break;
        case PROTOC_STATUS_SYNC_PROTRAIT://头像摘要同步失败
            ZBLog(@"%@:头像摘要同步失败. Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [error code]);
            break;
		default:
			ZBLog(@"requestFailed req=%@", [request error]);
			break;
	}
}

// 对memAB操作失败处理
// 在请求完成后，对MemAddressBook进行处理时，如果失败，则调用此处理方法
// 所以[self procABFailed]总是应该跟在[[MemAddressBook getInstance] ...]之后
#pragma mark 失败处理
/*
 * 失败处理
 */
- (void)procABFailed:(ASIHTTPRequest *)request ErrCode:(int32_t)errCode
{
	// 操作失败以后，下一次必须使用慢同步，所以记录本地版本号为-1
	[self saveContactListVersion:-1];
    
    memset(&sse, 0, sizeof(sse)); //Added by Kevin on June 20,2013
	
	sse.taskType = request.syncTaskType;
	
    sse.status = Sync_State_Faild; //存在
	
    sse.reason = errCode;
	
    ZBLog(@"%@:task failed。reason=%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
	
    [self syncStatusRefresh:YES];
	
    switch (request.protocStatus)
	{
		case PROTOC_STATUS_DOWNLOAD_CONTACT://下载联系人失败
			[[MemAddressBook getInstance] rollback];
            ZBLog(@"%@:下载联系人失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
            break;
        case PROTOC_STATUS_GET_CONTACTLIST_SUM://获取摘要失败
            ZBLog(@"%@:获取摘要失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
			break;
		case PROTOC_STATUS_GET_VERSION://获取联系人版本号失败
			ZBLog(@"%@:获取联系人版本号失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
			break;
        case PROTOC_STATUS_DOWNLOAD_PROTRAIT://下载联系人头像失败
            ZBLog(@"%@:下载联系人头像失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
            break;
        case PROTOC_STATUS_UPLOAD_ALL://上传所有联系人失败
            [[MemAddressBook getInstance] rollback];
			ZBLog(@"%@:上传所有联系人失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
            break;
        case PROTOC_STATUS_UPLOAD_PROTRAIT://上传联系人头像失败
            ZBLog(@"%@:上传联系人头像失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
            break;
        case PROTOC_STATUS_UPLOAD_DIFFER_CONTACT://同步上传联系人失败
            [[MemAddressBook getInstance] rollback];
			ZBLog(@"%@:同步上传联系人失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
            break;
        case PROTOC_STATUS_SYNC_PROTRAIT://头像摘要同步失败
            ZBLog(@"%@:头像摘要同步失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
            break;
		default:
			ZBLog(@"requestFailed req=%@", [request error]);
			break;
	}
}

#pragma mark // 对Portrait操作失败处理
/*
 *  对Portrait操作失败处理
 */
- (void)procPortraitFailed:(ASIHTTPRequest *)request ErrCode:(int32_t)errCode
{
    memset(&sse, 0, sizeof(sse)); //Added by kevin on June 20,2013
	sse.taskType = request.syncTaskType;
    
	sse.status = Sync_State_Faild;  //存在
	
    sse.reason = errCode;
	ZBLog(@"%@:任务失败。reason=%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
	
    [self syncStatusRefresh:YES];
	
    switch (request.protocStatus)
	{
        case PROTOC_STATUS_DOWNLOAD_PROTRAIT://下载联系人头像失败
			[[MemAddressBook getInstance] rollbackPortraitTask];
            ZBLog(@"%@:下载联系人头像失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
            break;
        case PROTOC_STATUS_UPLOAD_PROTRAIT://上传联系人头像失败
			[[MemAddressBook getInstance] rollbackPortraitTask];
            ZBLog(@"%@:上传联系人头像失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
            break;
        case PROTOC_STATUS_SYNC_PROTRAIT://头像摘要同步失败
			[[MemAddressBook getInstance] rollbackPortraitTask];
            ZBLog(@"%@:头像摘要同步失败(procABFailed). Error Code:%d", [arrayTaskString objectAtIndex:request.syncTaskType], errCode);
            break;
		default:
			ZBLog(@"requestFailed req=%@", [request error]);
			break;
	}
}



#pragma mark init  ASIHTTPRequest
/*
 * 获取配置HTTP请求
 */
- (ASIHTTPRequest *)initConfigRequest{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:configUrl];
    
	request.protocStatus = PROTOC_STATUS_GET_CONFIG;
	
    [request setRequestMethod:@"GET"];
	
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request setTimeOutSeconds:5];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    
    return request;
}

- (void)reAuth{
    NSString *account_key;
    
    NSString *password_key;
    

             // 合法的帐号名密码
        account_key = [NSString stringWithFormat:@"user_name"];
        
        password_key = [NSString stringWithFormat:@"user_psw"];
    
    
    NSString *account = [[ConfigMgr getInstance] getValueForKey:account_key forDomain:nil];    // 从配置文件读取帐号名密码
    
    NSString *password = [[ConfigMgr getInstance] getValueForKey:password_key forDomain:nil];
    
	//ZBLog(@"account:%@ password:%@", account, password);
	
	if ([account length] == 0 || [password length] == 0){
		memset(&sse, 0, sizeof(sse));
        
        sse.taskType = TASK_AUTHEN;
		
        sse.status = Sync_State_Faild; //存在
		
        sse.reason = GENERAL_ERR_NO_USERNAME;
		
        [self syncStatusRefresh:YES];
		
        ZBLog(@"认证失败：帐号名或密码为空");
		return;
	}
	
    NSString *seAccount = [[account SimpleEncryptByOffset:3 bySalt:11] base64];        //加密账号
	
    NSString *snAccount = [[seAccount SimpleEncryptByOffset:4 bySalt:9] md5];           // 对加密后的账号进行签名
    
    NSString *sePassword = [[password SimpleEncryptByOffset:3 bySalt:11] base64];     //加密密码
    // 目前只采用天翼账号认证：AuthMethodCtpassport
	AuthRequest *_authReuest =[[[[[[AuthRequest builder]
								   setMethod:AuthMethodCtpassport]
                                  setAccount:seAccount]
								 setPassword:sePassword]
								setVerifySign:snAccount]
                               build];
	
    NSData *requestData = [_authReuest data];
    
    NSURL *url = [NSURL URLWithString:configResponse.authUrl];
	
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setTimeoutInterval:5];
    [req setHTTPMethod:@"POST"];
    //[req addValue:[NSNumber numberWithInt:requestData.length] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:requestData];
    [req addValue:clientVersion forHTTPHeaderField:@"User-Agent"];
    [req addValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse *httpURLResponse = nil;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&httpURLResponse error:&error];
    
    NSLog(@"reAuth.statusCode:%d", httpURLResponse.statusCode);
    if (httpURLResponse.statusCode == 200) {
       AuthResponse *response = [AuthResponse parseFromData:responseData];
        NSLog(@"token:%@, Userid:%lld", response.token, response.syncUserId);
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        if (response.token) {
            [userDefault setObject:response.token forKey:@"RequestToken"];
        }
        
        if (response.syncUserId) {
            [userDefault setObject:[NSNumber numberWithLongLong:response.syncUserId] forKey:@"RequestUserId"];
        }
        
        [userDefault synchronize];
        
        NSLog(@"-----XXX....");
    }
}

/*
 * 帐号认证HTTP请求
 */
- (ASIHTTPRequest *)initAuthRequest{
    NSURL *url = [NSURL URLWithString:configResponse.authUrl];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:5];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    request.protocStatus = PROTOC_STATUS_AUTHEN;
    
	[request setRequestMethod:@"POST"];
	
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    
	[request setDelegate:self];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return request;
}

/*
 * 获取联系人摘要HTTP请求
 */
- (ASIHTTPRequest *)initGetContactSummaryRequest{
    NSURL *url = [NSURL URLWithString:configResponse.getContactListUrl];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:30];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    request.protocStatus = PROTOC_STATUS_GET_CONTACTLIST_SUM;
    
	[request setRequestMethod:@"GET"];
	
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld", authResponse.token, authResponse.syncUserId];
	
    NSLog(@"------>Cookie: %@", cookie);
    [request addRequestHeader:@"Cookie" value:cookie];
    
	[request setUseCookiePersistence:NO];
	
	[request setDelegate:self];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return request;
}

/*
 * 下载联系人HTTP请求
 */
- (ASIHTTPRequest *)initDownloadContactRequest{
    NSURL *url = [NSURL URLWithString:configResponse.downloadContactUrl];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:30];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    request.protocStatus = PROTOC_STATUS_DOWNLOAD_CONTACT;// 自身状态
    
	[request setRequestMethod:@"POST"];
	
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld", authResponse.token, authResponse.syncUserId];
	
    [request addRequestHeader:@"Cookie" value:cookie];
	
    [request setUseCookiePersistence:NO];
    
	[request setDelegate:self];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return request;
}

/*
 * 获取联系人列表版本号HTTP 请求
 */
- (ASIHTTPRequest *)initGetVersionRequest{
    NSURL *url = [NSURL URLWithString:configResponse.getContactListVersionUrl];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

    [request setTimeOutSeconds:5];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    request.protocStatus = PROTOC_STATUS_GET_VERSION;
    
	[request setRequestMethod:@"GET"];
	
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld", authResponse.token, authResponse.syncUserId];
	
    [request addRequestHeader:@"Cookie" value:cookie];
    
	[request setUseCookiePersistence:NO];
	
	[request setDelegate:self];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return  request;
}

/*
 * 下载头像HTTP请求
 */
- (ASIHTTPRequest *)initDownloadPortraitRequest{
    NSURL *url = [NSURL URLWithString:configResponse.downloadPortraitUrl];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:30];

    [request setNumberOfTimesToRetryOnTimeout:3];
    
    request.protocStatus = PROTOC_STATUS_DOWNLOAD_PROTRAIT;// 自身状态
    
	[request setRequestMethod:@"POST"];
	
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld", authResponse.token, authResponse.syncUserId];
	
    [request addRequestHeader:@"Cookie" value:cookie];
	
    [request setUseCookiePersistence:NO];
    
	[request setDelegate:self];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return request;
}

/*
 * 头像摘要HTTP请求
 */
- (ASIHTTPRequest *)initPortraitSummaryRequest{
    NSURL *url = [NSURL URLWithString:configResponse.syncPortraitUrl];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    request.protocStatus = PROTOC_STATUS_SYNC_PROTRAIT;// 自身状态
    
	[request setRequestMethod:@"POST"];
	
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld", authResponse.token, authResponse.syncUserId];
	
    [request addRequestHeader:@"Cookie" value:cookie];
	
    [request setUseCookiePersistence:NO];
    
	[request setDelegate:self];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return  request;
}

/*
 * 上传头像HTTP请求
 */
- (ASIHTTPRequest *)initUploadPortraitRequest{
    NSURL *url = [NSURL URLWithString:configResponse.uploadPortraitUrl];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:30];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    request.protocStatus = PROTOC_STATUS_UPLOAD_PROTRAIT;// 自身状态
    
	[request setRequestMethod:@"POST"];
	
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld", authResponse.token, authResponse.syncUserId];
	
    [request addRequestHeader:@"Cookie" value:cookie];
	
    [request setUseCookiePersistence:NO];
    
	[request setDelegate:self];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return  request;
}

/*
 * 批量上传所有联系人HTTP请求
 */
- (ASIHTTPRequest *)initBatchUploadAllContactRequest:(NSURL *)url{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:30];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    request.protocStatus = PROTOC_STATUS_UPLOAD_ALL;
    
    [request setRequestMethod:@"POST"];
    
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    
    [request setUseCookiePersistence:NO];
    
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return request;
}

/*
 * 批量下载联系人HTTP请求
 */
- (ASIHTTPRequest *)initBatchDownloadContactRequest{
    NSURL *url = [NSURL URLWithString:configResponse.downloadContactUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:30];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    request.protocStatus = PROTOC_STATUS_DOWNLOAD_CONTACT;// 自身状态
    
    [request setRequestMethod:@"POST"];
    
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld",
                        authResponse.token, authResponse.syncUserId];
    [request addRequestHeader:@"Cookie" value:cookie];
    
    [request setUseCookiePersistence:NO];
    
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return request;
}

/*
 * 上传联系人HTTP请求
 */
- (ASIHTTPRequest *)initUPloadDifferContactRequest{
    NSURL *url = [NSURL URLWithString:configResponse.syncUploadContactUrl];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:30];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    request.protocStatus = PROTOC_STATUS_UPLOAD_DIFFER_CONTACT;
    
	[request setRequestMethod:@"POST"];
	
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld;BatchNo=1;NoMore=True",
						authResponse.token, authResponse.syncUserId];
	
	[request addRequestHeader:@"Cookie" value:cookie];
	
    [request setUseCookiePersistence:NO];
    
	[request setDelegate:self];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return request;
}

/*
 * 上传Consle 日志HTTP请求
 */
- (ASIHTTPRequest *)initPlainClientReportRequest{
    NSURL *url = [NSURL URLWithString:configResponse.plainClientReportUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:15];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    request.syncTaskType = TASK_DEVICE_SIGN;
    
    [request setRequestMethod:@"POST"];
    
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    
    return request;
}

/*
 * 设备签到HTTP请求
 */
- (ASIHTTPRequest *)initDeviceSignRequest{
    NSURL *url = [NSURL URLWithString:configResponse.deviceSignUrl];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:15];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
	request.syncTaskType = TASK_DEVICE_SIGN;
    
	[request setRequestMethod:@"POST"];
	
    [request addRequestHeader:@"User-Agent" value:clientVersion];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    
    return request;
}

/*
 * 保存configUrl
 */
- (void)saveConfigUrl{
    NSArray *configResponseArray = [NSArray arrayWithObjects:[configResponse authUrl],
                                    [configResponse uploadPortraitUrl],
                                    [configResponse downloadPortraitUrl],
                                    [configResponse uploadAllUrl],
                                    [configResponse getContactListUrl],
                                    [configResponse downloadContactUrl],
                                    [configResponse syncUploadContactUrl],
                                    [configResponse getContactListVersionUrl],
                                    [configResponse slowSyncUrl],
                                    [configResponse syncPortraitUrl],
                                    [configResponse clientReportUrl],
                                    [configResponse getUserCloudSummaryUrl],[configResponse getSplashUrl],[configResponse queryPublicInfoUrl],[configResponse queryCommentsUrl],[configResponse getSysMsgUrl],[configResponse deviceTokenReportUrl],[configResponse authByOtaUrl],[configResponse authByQrcodeUrl],[configResponse getContactAdUrl],[configResponse slowSyncAutoUrl],[configResponse syncUploadContactAutoUrl],[configResponse addGetMemberinfoUrlUrl],[configResponse conatctShareUrl],[configResponse isopenMycardUrl],[configResponse addupdateMycardUrl],[configResponse getMemberInfoUrl],[configResponse getMemberModuleUrl],nil];
    NSArray *keyArray = [NSArray arrayWithObjects:@"authUrl",@"uploadPortraitUrl",@"downloadPortraitUrl",@"uploadAllUrl",@"getContactListUrl",@"downloadContactUrl",@"syncUploadContactUrl",@"getContactListVersionUrl",@"slowSyncUrl",@"syncPortraitUrl",@"clientReportUrl",@"userCloudSummaryUrl",@"splashUrl",@"queryPublicInfoUrl",@"queryCommentsUrl",@"getSysMsgUrl",@"deviceTokenReportUrl",@"AuthByOtaUrl",@"authByQrcodeUrl",@"getContactAdUrl",@"slowSyncAutoUrl",@"syncUploadContactAutoUrl",@"addGetMemberinfoUrlUrl",@"conatctShareUrl",@"isopenMycardUrl",@"addupdateMycardUrl",@"getMemberInfoUrl",@"getMemberModuleUrl",nil];
    ZBLog(@"urls: %@",configResponseArray);
    for (int i = 0; i < [keyArray count]; i++) {
        [[ConfigMgr getInstance] setValue:[configResponseArray objectAtIndex:i]
                                   forKey:[keyArray objectAtIndex:i]
                                forDomain:[NSString stringWithFormat:@"SyncServerInfo"]];
    }
    
    [SettingInfo saveConfigUrl:configResponse];
}

#pragma mark // 同步执行的方式获取服务地址列表
/*
 * 获取服务地址列表
 */
- (BOOL)syncGetConfig
{
    ASIHTTPRequest *request = [self initConfigRequest];
	
    [request startSynchronous];
	
    if (currentRequest) {
		[currentRequest release];
	}
	
    currentRequest = request;
	
    [currentRequest retain];
	
    NSError *error = [request error];
	
    if (!error)
	{
		NSData *responseData = [request responseData];
		// retain the server urls
		@try
		{
			configResponse = [GetConfigResponse parseFromData:responseData];
		}
		@catch (NSException * e)
		{
			ZBLog(@"syncGetConfig Failed. NSException:%@", [e name]);
            memset(&sse, 0, sizeof(sse)); //Added by Kevin on June,20 2013
			
            sse.status = Sync_State_Faild; //存在
			
            sse.reason = SYNC_ERR_HANDLE_DATA;
			
            [self syncStatusRefresh:YES];
            
			return NO;
		}
		@finally
		{
		}
		
		[configResponse retain];
        ZBLog(@"syncGetConfig OK.");
		// 将服务地址保存到配置文件 domain:SyncServerInfo
        [self saveConfigUrl];
        
        HBZSAppDelegate * hbAppdelegate = [HBZSAppDelegate getAppdelegate];
        [hbAppdelegate VersionDeal];
        
		return YES;
	}
	
//    memset(&sse, 0, sizeof(sse)); //Added by Kevin on June,13 2013,
    //此处认证失败时，不为see重新分配空间 应保留其数据
	sse.status = Sync_State_Faild; //存在
    
	sse.reason = [error code];
	
    [self syncStatusRefresh:YES];
    
    ZBLog(@"syncGetConfig Failed.reason=%d", [error code]);
	
    return NO;
}

/*
 * 获取归属地信息
 */
- (BOOL)syncGetTpnool
{
    return YES;
}


#pragma mark 帐号认证
/*
 * 帐号认证
 */
- (void)syncAuthen:(SyncTaskType)syncTaskType;
{
    NSString *account_key;
    
    NSString *password_key;
    
    if (syncTaskType == TASK_AUTHEN){            // 新设置的帐号名密码，临时保存在配置文件里。先验证是否合法
        account_key = [NSString stringWithFormat:@"pimaccount"];
        
        password_key = [NSString stringWithFormat:@"pimpassword"];
    }
    else{             // 合法的帐号名密码
        account_key = [NSString stringWithFormat:@"user_name"];
        
        password_key = [NSString stringWithFormat:@"user_psw"];
    }
    
    NSString *account = [[ConfigMgr getInstance] getValueForKey:account_key forDomain:nil];    // 从配置文件读取帐号名密码
    
    NSString *password = [[ConfigMgr getInstance] getValueForKey:password_key forDomain:nil];
    
	//ZBLog(@"account:%@ password:%@", account, password);
	
	if ([account length] == 0 || [password length] == 0){
		memset(&sse, 0, sizeof(sse));
        
        
        sse.taskType = TASK_AUTHEN;
		
        sse.status = Sync_State_Faild; //存在
		
        sse.reason = GENERAL_ERR_NO_USERNAME;
		
        [self syncStatusRefresh:YES];
        
        [SettingInfo setAccountState:NO];
		
        ZBLog(@"认证失败：帐号名或密码为空");
		return;
	}
	
    NSString *seAccount = [[account SimpleEncryptByOffset:3 bySalt:11] base64];        //加密账号
	
    NSString *snAccount = [[seAccount SimpleEncryptByOffset:4 bySalt:9] md5];           // 对加密后的账号进行签名
    
    NSString *sePassword = [[password SimpleEncryptByOffset:3 bySalt:11] base64];     //加密密码
    // 目前只采用天翼账号认证：AuthMethodCtpassport
	AuthRequest *_authReuest =[[[[[[AuthRequest builder]
								   setMethod:AuthMethodCtpassport]
                                  setAccount:seAccount]
								 setPassword:sePassword]
								setVerifySign:snAccount]
                               build];
	
    NSData *requestData = [_authReuest data];
    
    NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]];
	
    ASIHTTPRequest *request = [self initAuthRequest];
    
    request.syncTaskType = syncTaskType;
    
    [request addRequestHeader:@"Content-Length" value:length];
	
    [request appendPostData:requestData];
    
	[request startAsynchronous];
	
    if (currentRequest) {
		[currentRequest release];
	}
	
    currentRequest = request;
	
    [currentRequest retain];
}

#pragma mark  获取联系人列表摘要和组列表摘要
/*
 *  获取联系人列表摘要和组列表摘要
 */
- (void)syncGetContactSummary:(SyncTaskType)syncTaskType;
{
    sse.status=Sync_State_Initiating;
    
    [self syncStatusRefresh:YES];
    
    ASIHTTPRequest *request = [self initGetContactSummaryRequest];
    
    request.syncTaskType = syncTaskType;
    
    [request startAsynchronous];
	
    if (currentRequest) {
		[currentRequest release];
	}
	
    currentRequest = request;
	
    [currentRequest retain];
}

#pragma mark 根据联系人ID列表和分组ID列表下载联系人 // contactSummaryList: 需要下载的联系人ID列表 groupSummaryList: 需要下载的组ID列表
/*
 * 下载联系人
 */
- (void)syncDownloadContact:(NSArray *)contactSummaryList
				GroupIDList:(NSArray *)groupSummaryList
                   TaskType:(SyncTaskType)syncTaskType
{
    SyncDownloadContactRequest *_syncDownloadContactRequest = [[[[[SyncDownloadContactRequest builder]
                                                                  addAllContactId:contactSummaryList]
                                                                 addAllGroupId:groupSummaryList]
                                                                setIsRequestBusinessCard:NO]
                                                               build];
	
    NSData *requestData = [_syncDownloadContactRequest data];
    
    NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
    
    ASIHTTPRequest *request = [self initDownloadContactRequest];
    
    request.syncTaskType = syncTaskType;
    
    [request addRequestHeader:@"Content-Length" value:length];
	
    [request appendPostData:requestData];
    
	[request startAsynchronous];
	
    if (currentRequest) {
		[currentRequest release];
	}
	
    currentRequest = request;
	
    [currentRequest retain];
}

#pragma mark 增量下载、增量上传、双向同步都会调用 // 获取联系人版本号
/*
 * 获取联系人版本号
 */
- (void)syncGetVersion:(SyncTaskType)syncTaskType
{
    ASIHTTPRequest *request = [self initGetVersionRequest];
    
    request.syncTaskType = syncTaskType;
    
	[request startAsynchronous];
	
    if (currentRequest) {
		[currentRequest release];
	}
	
    currentRequest = request;
	
    [currentRequest retain];
}

/*
 * 下载联系人头像
 */
- (void)syncDownloadPortrait:(NSArray *)contactSummaryList
				CardPortrait:(BOOL)IsRequestBusinessCardPortrait
                    TaskType:(SyncTaskType)syncTaskType
{
	DownloadPortraitRequest *_downloadPortraitRequest = [[[[DownloadPortraitRequest builder]
                                                           addAllSid:contactSummaryList]
                                                          setIsRequestBusinessCardPortrait:IsRequestBusinessCardPortrait]
                                                         build];
	ZBLog(@"%@: syncDownloadPortrait:(%d).", [arrayTaskString objectAtIndex:syncTaskType], [contactSummaryList count]);
    
    NSData *requestData = [_downloadPortraitRequest data];
    
    NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
    
    ASIHTTPRequest *request = [self initDownloadPortraitRequest];
    
    request.syncTaskType = syncTaskType;
    
    [request addRequestHeader:@"Content-Length" value:length];
	
    [request appendPostData:requestData];
    
	[request startAsynchronous];
	
    if (currentRequest) {
		[currentRequest release];
	}
	
    currentRequest = request;
	
    [currentRequest retain];
}

// 头像摘要同步：将本地的联系人头像版本号上传到服务器，服务器返回比对结果
// portraitSummary
// businessCardVersion: 名片头像版本号，如果没有，填0
#pragma mark 头像摘要同步：将本地的联系人头像版本号上传到服务器，服务器返回比对结果
/*
 * 联系人头像摘要同步
 */
- (void)syncPortraitSummary:(NSArray *)portraitSummary
        BusinessCardVersion:(int32_t)businessCardVersion
                   TaskType:(SyncTaskType)syncTaskType
{
	SyncPortraitRequest_Builder *_syncPortraitRequest_builder = [SyncPortraitRequest builder];
	
    if (portraitSummary != nil){
		_syncPortraitRequest_builder = [_syncPortraitRequest_builder addAllPortraitSummary:portraitSummary];
	}
	
	if (businessCardVersion > 0){
		_syncPortraitRequest_builder = [_syncPortraitRequest_builder setBusinessCardPortraitVersion:businessCardVersion];
	}
    
	SyncPortraitRequest *_syncPortraitRequest = [_syncPortraitRequest_builder build];
    
    
    ////
    
    
    ///
	
    NSData *requestData = [_syncPortraitRequest data];
    
    NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
    
    ASIHTTPRequest *request = [self initPortraitSummaryRequest];
    
    request.syncTaskType = syncTaskType;
    
    [request addRequestHeader:@"Content-Length" value:length];
	
    [request appendPostData:requestData];
    
	[request startAsynchronous];
	
    if (currentRequest) {
		[currentRequest release];
	}
	
    currentRequest = request;
	
    [currentRequest retain];
}

#pragma mark  // 头像上传
/*
 * 头像上传
 */
- (void)syncUploadPortrait:(NSArray*)mutablePortraitList
      BusinessCardPortrait:(PortraitData*)businessCardPortrait
                  TaskType:(SyncTaskType)syncTaskType
{
	UploadPortraitRequest_Builder *_uploadPortraitRequest_builder = [UploadPortraitRequest builder];
	
    if (mutablePortraitList != nil)
	{
		_uploadPortraitRequest_builder = [_uploadPortraitRequest_builder addAllPortrait:mutablePortraitList];
	}
	
	if (businessCardPortrait != nil)
	{
		_uploadPortraitRequest_builder = [_uploadPortraitRequest_builder setBusinessCardPortrait:businessCardPortrait];
	}
	
	UploadPortraitRequest *_uploadPortraitRequest = [_uploadPortraitRequest_builder build];
    
    memset(&sse, 0, sizeof(sse));
	
    sse.taskType = syncTaskType;
	
    sse.iSendTotalNum = [mutablePortraitList count];
	
    sse.status = Sync_State_Portrait_Uploading;
	
    [self syncStatusRefresh:YES];
	
	ZBLog(@"%@: syncUploadPortrait:(%d).", [arrayTaskString objectAtIndex:syncTaskType], [mutablePortraitList count]);
    
    NSData *requestData = [_uploadPortraitRequest data];
    
    NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
    
    ASIHTTPRequest *request = [self initUploadPortraitRequest];
    
    request.syncTaskType = syncTaskType;
    
    [request addRequestHeader:@"Content-Length" value:length];
	
    [request appendPostData:requestData];
	
    [request startAsynchronous];
	
    if (currentRequest) {
		[currentRequest release];
	}
	
    currentRequest = request;
	
    [currentRequest retain];
}


// 全量上传
// contactList: 联系人信息列表
// groupList: 组信息列表
// batchContactLimit: 分批上传时，每批的联系人数量。若为0，则不分批一次上传。
/*
 * 全量上传
 */
- (void)syncUploadAllContact:(NSArray*)contactList
                   GroupList:(NSArray*)groupList
                BusinessCard:(Contact*)businessCard
                    TaskType:(SyncTaskType)syncTaskType
{
    [self batchUploadAllContact:contactList
                      GroupList:groupList
                   BusinessCard:businessCard
                       TaskType:syncTaskType];
}

#pragma mark // 同步上传联系人
/*
 * 同步上传联系人
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
                       TaskType:(SyncTaskType)syncTaskType

{
	SyncUploadContactRequest_Builder *_syncUploadContactRequest_Builder = [[[[[[[[[SyncUploadContactRequest builder]
																				  addAllContactAdd:contactAddList]
																				 addAllContactUpd:contactUpdList]
																				addAllContactDel:contactDelList]
																			   addAllContactSyncSummary:contactListSummary]
																			  addAllGroupAdd:groupAddList]
																			 addAllGroupUpd:groupUpdList]
																			addAllGroupDel:groupDelList]
																		   addAllGroupSyncSummary:groupListSummary];
	
//	if (businessCardVersion == 0){ // 客户端新增或修改名片,此时需要设置名片,不需设置名片版本
//		[_syncUploadContactRequest_Builder setBusinessCard:businessCard];
//	}
//	else if (businessCardVersion > 0){  	// 客户端名片数据无变化时，上传本地名片版本号。不须上传名片数据.
//		[_syncUploadContactRequest_Builder setBusinessCardVersion:businessCardVersion];
//	}
//	else if (businessCardVersion == -2){ // 客户端没有名片，此时应该设置版本号为0
//		[_syncUploadContactRequest_Builder setBusinessCardVersion:0];
//	}
//	else if (businessCardVersion == -1){ 	// 客户端名片已失效，要求服务端删除名片
//		[_syncUploadContactRequest_Builder setBusinessCardVersion:0];
//	}
    
	SyncUploadContactRequest *_syncUploadContactRequest = [_syncUploadContactRequest_Builder build];
    
    ZBLog(@"%@: contactAddList(%d), contactUpdList(%d), contactDelList(%d), groupAddList(%d), groupUpdList(%d), groupDelList(%d), contactListSummary(%d), groupListSummary(%d).", [arrayTaskString objectAtIndex:syncTaskType], [contactAddList count], [contactUpdList count], [contactDelList count], [groupAddList count], [groupUpdList count], [groupDelList count], [contactListSummary count], [groupListSummary count]);
    
	memset(&sse, 0, sizeof(sse));
	
    sse.taskType = syncTaskType;
	
    sse.status = Sync_State_Uploading;
	
    sse.iSendTotalNum = [contactAddList count] + [contactUpdList count] + [contactDelList count] + [groupAddList count] + [groupUpdList count] + [groupDelList count];
	
    [self syncStatusRefresh:YES];
	
	NSData *requestData = [_syncUploadContactRequest data];
    
    NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
    
    ASIHTTPRequest *request = [self initUPloadDifferContactRequest];
    
    request.syncTaskType = syncTaskType;
    
    [request addRequestHeader:@"Content-Length" value:length];
	
    [request appendPostData:requestData];
    
	[request startAsynchronous];
	
    if (currentRequest) {
		[currentRequest release];
	}
	
    currentRequest = request;
	
    [currentRequest retain];
}


#pragma mark protoc finished handle
/*
 * 认证结束，由protocType决定下一步该干什么
 */
- (void)syncAuthenFinished:(ASIHTTPRequest *)request
{
    NSArray *allGroups;
    
    NSArray *allContacts;
    ZBLog(@"syncAuthenFinished.");
    NSData *responseData = [request responseData];
	@try
	{
		authResponse = [AuthResponse parseFromData:responseData];
	}
	@catch (NSException * e)
	{
		ZBLog(@"%@: syncAuthenFinished. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
		[self requestFinished:request];
        
        return;
	}
	@finally
	{
	}
    // 记录token的超时时间
    tokenExpires = authResponse.tokenExpires;
    NSLog(@"EXPIRES: %d", tokenExpires);
    [authResponse retain];
   
    NSLog(@"### Token:%@, userId:%lld", authResponse.token, authResponse.syncUserId);
    NSUserDefaults * userManger = [NSUserDefaults standardUserDefaults];
    [userManger setObject:[NSNumber numberWithLongLong:authResponse.syncUserId] forKey:@"userID"];
    [userManger setObject:authResponse.token forKey:@"Authtoken"];
    [userManger setObject:authResponse.pUserId forKey:@"pUserId"];
    [userManger setObject:authResponse.mobileNum forKey:@"mobileNum"];
    [userManger synchronize];
    
#pragma mark 提取时光机数据全局model
    HB_MachineDataModel * model = [HB_MachineDataModel getglobalMachineModel];
    
    switch (request.syncTaskType){
        case TASK_AUTHEN:{  //认证
            memset(&sse, 0, sizeof(sse));
            
            sse.taskType = TASK_AUTHEN;
            
            sse.status = Sync_State_Success;
            
            [self syncStatusRefresh:YES];
            break;
        }
        case TASK_USERCLOUDSUMMARY:
        {
            [self syncGetContactSummary:TASK_USERCLOUDSUMMARY];
        }
            break;
        case TASK_ALL_DOWNLOAD:{ // 全量下载
            [self syncGetContactSummary:TASK_ALL_DOWNLOAD]; // 认证完成后，下载联系人和组的摘要信息
#pragma mark 时光机全局对象赋值
            [model getCurrentMachineDataWithSyncTask:request.syncTaskType];
            break;
        }
        case TASK_ALL_UPLOAD:{ // 全量上传
            
            allGroups = [[MemAddressBook getInstance] getAllUploadGroups];  //Group Builder
            
            allContacts = [[MemAddressBook getInstance] getAllUploadContacts];   //Contact Builder
			
            [self syncUploadAllContact:allContacts
							 GroupList:allGroups
						  BusinessCard:nil//名片
							  TaskType:TASK_ALL_UPLOAD];
            break;
        }
        case TASK_SYNC_DOANLOAD:// 同步下载
        case TASK_DIFFER_SYNC:// 双向同步
        case TASK_MERGE_SYNC:// 慢同步
#pragma mark 时光机全局对象赋值
            [model getCurrentMachineDataWithSyncTask:request.syncTaskType];
		case TASK_SYNC_UPLOAD:// 同步上传
			[self syncGetVersion:request.syncTaskType];
			break;
        default:
            break;
    }
}



/*
 *CTPass快速认证时进行同步操作
 */
#pragma mark CTPass快速认证时进行同步操作
-(void)syncTypeByCTPassAuth:(SyncTaskType)syncType
{
    NSArray *allGroups;
    
    NSArray *allContacts;
    
    NSString * token = [[ConfigMgr getInstance] getValueForKey:@"token" forDomain:nil];
    
    int64_t userId = [[[ConfigMgr getInstance] getValueForKey:@"userId" forDomain:nil] longLongValue];
    
    authResponse = [[[[AuthResponse builder] setToken:token]setSyncUserId:userId]build];
    switch (syncType){
        case TASK_AUTHEN:{  //认证
            memset(&sse, 0, sizeof(sse));
            
            sse.taskType = TASK_AUTHEN;
            
            sse.status = Sync_State_Success;
            
            [self syncStatusRefresh:YES];
            break;
        }
            
        case TASK_ALL_DOWNLOAD:{ // 全量下载
            [self syncGetContactSummary:TASK_ALL_DOWNLOAD]; // 认证完成后，下载联系人和组的摘要信息
            break;
        }
        case TASK_ALL_UPLOAD:{ // 全量上传
            
            allGroups = [[MemAddressBook getInstance] getAllUploadGroups];  //Group Builder
            
            allContacts = [[MemAddressBook getInstance] getAllUploadContacts];   //Contact Builder
            
            [self syncUploadAllContact:allContacts
                             GroupList:allGroups
                          BusinessCard:[[MemAddressBook getInstance] myCard]       //名片
                              TaskType:TASK_ALL_UPLOAD];
            break;
        }
        case TASK_SYNC_UPLOAD:// 同步上传
        case TASK_SYNC_DOANLOAD:// 同步下载
        case TASK_DIFFER_SYNC:// 双向同步
        case TASK_MERGE_SYNC:// 慢同步
            [self syncGetVersion:syncType];
            break;
        default:
            break;
    }
}
/**********************************************/






/*
 * 全量下载本地存在的不用下载  客户端存在的联系人、群组和服务端对比(通过ServerId、version)，一样的就不用下载
 */
- (void)deleteUnnecessaryMappingInfoAndRecord{  //删除本地新增的Record、MappingInfo以及删除 Record以及被删除，但是MappingInfo残留
    //addContactArray
    NSMutableArray *tmpAddContactIds = [[NSMutableArray alloc]init];
    
    for (MemRecord *m in [[MemAddressBook getInstance] addContactArray]) {
        [tmpAddContactIds addObject:[NSNumber numberWithInt:m.realABID]];
    }
    
    if ([tmpAddContactIds count] > 0) {
        [[MemAddressBook getInstance]removeContactsFromDb:tmpAddContactIds];
    }
    
    [tmpAddContactIds release];
    //UpdContact
    NSMutableArray *tmpUpdContactIds = [[NSMutableArray alloc]init];
    
    NSMutableArray *tmpUpdContactServerIds = [[NSMutableArray alloc]init];
    
    for (MemRecord *m in [[MemAddressBook getInstance] updContactArray]) {
        [tmpUpdContactIds addObject:[NSNumber numberWithInt:m.realABID]];
    
        [tmpUpdContactServerIds addObject:[NSNumber numberWithInt:m.serverId]];
    }
    
    if ([tmpUpdContactIds count] > 0) {
        [[MemAddressBook getInstance]removeContactsFromDb:tmpUpdContactIds];
    }
    
    [tmpUpdContactIds release];
    
    if (tmpUpdContactServerIds) {
       [[MemAddressBook getInstance]removeContactMappingInfo:tmpUpdContactServerIds];
    }
    
    [tmpUpdContactServerIds release];
    //deleteContact
    NSMutableArray *tmpDelContactIds = [[NSMutableArray alloc]init];
    
    for (MemRecord *m in [[MemAddressBook getInstance] delContactArray]) {
        [tmpDelContactIds addObject:[NSNumber numberWithInt:m.serverId]];
    }
    //删除MappingInfo
    if (tmpDelContactIds) {
        [[MemAddressBook getInstance]removeContactMappingInfo:tmpDelContactIds];
    }
    
    [tmpDelContactIds release];
    //AddGroup
    NSMutableArray *tmpAddGroupIds = [[NSMutableArray alloc]init];
    
    for (MemRecord *m in [[MemAddressBook getInstance] addGroupArray]) {
        [tmpAddGroupIds addObject:[NSNumber numberWithInt:m.realABID]];
    }
    
    if ([tmpAddGroupIds count] > 0) {
        [[MemAddressBook getInstance]removeGroupsFromDb:tmpAddGroupIds];
    }
    
    [tmpAddGroupIds release];
    //UpdGroup
    NSMutableArray *tmpUpdGroupIds = [[NSMutableArray alloc]init];
    
    NSMutableArray *tmpUpdGroupServerIds = [[NSMutableArray alloc]init];
    
    for (MemRecord *m in [[MemAddressBook getInstance] updGroupArray]) {
        [tmpUpdGroupIds addObject:[NSNumber numberWithInt:m.realABID]];
    
        [tmpUpdGroupServerIds addObject:[NSNumber numberWithInt:m.serverId]];
    }
    
    if ([tmpUpdGroupIds count] > 0) {
        [[MemAddressBook getInstance]removeGroupsFromDb:tmpUpdGroupIds];
    }
    
    [tmpUpdGroupIds release];
    
    if ([tmpUpdGroupServerIds count] > 0) {
        [[MemAddressBook getInstance]removeGroupMappingInfo:tmpUpdGroupServerIds];
    }
    
    [tmpUpdGroupServerIds release];
    //deleteGroup
    NSMutableArray *tmpDelGroupIds = [[NSMutableArray alloc]init];
    
    for (MemRecord *m in [[MemAddressBook getInstance] delGroupArray]) {
        [tmpDelGroupIds addObject:[NSNumber numberWithInt:m.serverId]];
    }
    //删除MappingInfo
    if ([tmpDelGroupIds count] > 0) {
        [[MemAddressBook getInstance]removeGroupMappingInfo:tmpDelGroupIds];
    }
    
    [tmpDelGroupIds release];
}

- (NSMutableArray *)getNewContactDownloadSummary:(ContactListSummaryResponse *)_contactListSummaryResponse{
    NSMutableArray *contactSummaryList = [NSMutableArray arrayWithArray:[_contactListSummaryResponse contactSummaryList]];
    
    NSArray *contactVersionList = [_contactListSummaryResponse contactVersionList];
    
    int _index = 0;
    
    NSMutableArray *temp1 = [[NSMutableArray alloc]init];
    
    NSMutableArray *tmpContactIds = [[NSMutableArray alloc]init];
    
    NSMutableArray *tmpContactServerIds = [[NSMutableArray alloc]init];
    
    if ([contactSummaryList count] > [[[MemAddressBook getInstance] arrayData] count]) {
        for (int i = 0; i < [[[MemAddressBook getInstance]arrayData] count]; i++) {
            MemRecord *m = [[[MemAddressBook getInstance]arrayData] objectAtIndex:i];
            
            int _flag = 0;
            for (int j = 0; j < [contactSummaryList count]; j++) {
                if (m.serverId == [[contactSummaryList objectAtIndex:j] intValue]) {
                    ++_flag;
                    
                    if (m.version == [[contactVersionList objectAtIndex:j] intValue]) {
                        [temp1 addObject:[contactSummaryList objectAtIndex:j]];//break;continue
                        break;
                    }
                    else{
                        //serverId一样，version不同，删除本地的数据，以及Mapping
                        [tmpContactIds addObject:[NSNumber numberWithInt:m.realABID]];
                        
                        [tmpContactServerIds addObject:[NSNumber numberWithInt:m.serverId]];
                        break;
                    }
                }
                else{
                    if (j == [contactSummaryList count] -1) {
                        if (_flag == 0 && (m.groupName == nil) && (m.groupName.length < 1)) {//本地要删除的映射
                            [tmpContactServerIds addObject:[NSNumber numberWithInt:m.serverId]];
                            
                            [tmpContactIds addObject:[NSNumber numberWithInt:m.realABID]];//
                        }
                    }
                }
            }
        }

        ///////
        for (NSString *temp in contactSummaryList) {
            MemRecord *m = nil;
            
            m = [[MemAddressBook getInstance]getMemRecordByServerId:[temp intValue]
                                                            IsGroup:NO];
            if (m != nil) {
                int version1 = [[contactVersionList objectAtIndex:_index] intValue];
                
                if (m.version == version1) {
                    [temp1 addObject:[contactSummaryList objectAtIndex:_index]];//不用下载 contactSummaryList中删除该id
                }
                else{
                    //需要下载 ,数据库中删除数据，arrayData删除Mapping
                    [tmpContactIds addObject:[NSNumber numberWithInt:m.realABID]];
                    
                    [tmpContactServerIds addObject:[NSNumber numberWithInt:m.serverId]];
                }
            }
            else{//要删除的
                
            }
            
            ++_index;
        }
    }
    else{
        for (int i = 0; i < [[[MemAddressBook getInstance]arrayData] count]; i++) {
            MemRecord *m = [[[MemAddressBook getInstance]arrayData] objectAtIndex:i];
            
            int _flag = 0;
            for (int j = 0; j < [contactSummaryList count]; j++) {
                if (m.serverId == [[contactSummaryList objectAtIndex:j] intValue]) {
                    ++_flag;
                    
                    if (m.version == [[contactVersionList objectAtIndex:j] intValue]) {
                        [temp1 addObject:[contactSummaryList objectAtIndex:j]];//break;continue
                        break;
                    }
                    else{
                        //serverId一样，version不同，删除本地的数据，以及Mapping
                        [tmpContactIds addObject:[NSNumber numberWithInt:m.realABID]];
                        
                        [tmpContactServerIds addObject:[NSNumber numberWithInt:m.serverId]];
                        break;
                    }
                }
                else{
                    if (j == [contactSummaryList count] -1) {
                        if (_flag == 0 && (m.groupName == nil) && (m.groupName.length < 1)) {//本地要删除的映射
                            [tmpContactServerIds addObject:[NSNumber numberWithInt:m.serverId]];
                            
                            [tmpContactIds addObject:[NSNumber numberWithInt:m.realABID]];//
                        }
                    }
                }
            }
        }
    }
    //数据库中删除联系人,arrayData删除MappingInfo
    if ([tmpContactIds count] > 0) {
        [[MemAddressBook getInstance]removeContactsFromDb:tmpContactIds];
    }
    
    if ([tmpContactServerIds count] > 0) {
        [[MemAddressBook getInstance]removeContactMappingInfo:tmpContactServerIds];
    }
    
    if ([contactSummaryList count] == 0) {//删除本地数据库所有数据，arrayData中联系人的Mapping
        [[MemAddressBook getInstance]removeAllContactFromDb];
        
        [[MemAddressBook getInstance]removeAllContactMappingInfo];
    }
    
    for (NSValue *tmp in temp1) {  //本地存在的联系人就不需要下载
        [contactSummaryList removeObject:tmp];
    }

    [temp1 release];
    
    [tmpContactIds release];
    
    [tmpContactServerIds release];
    return contactSummaryList;
}

- (NSMutableArray *)getNewGroupDownloadSummary:(ContactListSummaryResponse *)_contactListSummaryResponse{
    NSMutableArray *groupSummaryList = [NSMutableArray arrayWithArray: [_contactListSummaryResponse groupSummaryList]];
    
    NSArray *groupVersionList = [_contactListSummaryResponse groupVersionList];
    
    NSMutableArray *temp2 = [[NSMutableArray alloc]init];
    
    int _index = 0;
    
    NSMutableArray *tmpGroupIds = [[NSMutableArray alloc]init];
    
    NSMutableArray *tmpGroupServerIds = [[NSMutableArray alloc]init];
    
    if ([groupSummaryList count] > [[[MemAddressBook getInstance] arrayData] count]) {
        for (int i = 0; i < [[[MemAddressBook getInstance]arrayData] count]; i++) {
            MemRecord *m = [[[MemAddressBook getInstance]arrayData] objectAtIndex:i];
            
            int _flag = 0;
            for (int j = 0; j < [groupSummaryList count]; j++) {
                if (m.serverId == [[groupSummaryList objectAtIndex:j] intValue]) {
                    ++_flag;
                    
                    if (m.version == [[groupVersionList objectAtIndex:j] intValue]) {
                        [temp2 addObject:[groupSummaryList objectAtIndex:j]];//break;continue
                        break;
                    }
                    else{
                        //serverId一样，version不同，删除本地的数据，以及Mapping
                        [tmpGroupIds addObject:[NSNumber numberWithInt:m.realABID]];
                        
                        [tmpGroupServerIds addObject:[NSNumber numberWithInt:m.serverId]];
                        break;
                    }
                }
                else{
                    if (j == [groupSummaryList count] -1) {
                        if (_flag == 0 && (m.groupName != nil) && (m.groupName.length > 0)) {//本地要删除的映射
                            [tmpGroupServerIds addObject:[NSNumber numberWithInt:m.serverId]];
                            
                            [tmpGroupIds addObject:[NSNumber numberWithInt:m.realABID]];//
                        }
                    }
                }
            }
        }

        for (NSString *temp in groupSummaryList) {
            MemRecord *m = nil;
            
            m = [[MemAddressBook getInstance]getMemRecordByServerId:[temp intValue]
                                                            IsGroup:YES];
            if (m != nil) {
                int version1 = [[groupVersionList objectAtIndex:_index] intValue];
                if (m.version == version1) {
                    // [];  //不用下载 contactSummaryList中删除该id
                    [temp2 addObject:[groupSummaryList objectAtIndex:_index]];
                }
                else{
                    //需要下载 ,数据库中删除数据，arrayData删除Mapping
                    [tmpGroupIds addObject:[NSNumber numberWithInt:m.realABID]];
                    
                    [tmpGroupServerIds addObject:[NSNumber numberWithInt:m.serverId]];
                }
            }
            
            ++_index;
        }
    }
    else{
        for (int i = 0; i < [[[MemAddressBook getInstance]arrayData] count]; i++) {
            MemRecord *m = [[[MemAddressBook getInstance]arrayData] objectAtIndex:i];
            
            int _flag = 0;
            for (int j = 0; j < [groupSummaryList count]; j++) {
                if (m.serverId == [[groupSummaryList objectAtIndex:j] intValue]) {
                    ++_flag;
                    
                    if (m.version == [[groupVersionList objectAtIndex:j] intValue]) {
                        [temp2 addObject:[groupSummaryList objectAtIndex:j]];//break;continue
                        break;
                    }
                    else{
                        //serverId一样，version不同，删除本地的数据，以及Mapping
                        [tmpGroupIds addObject:[NSNumber numberWithInt:m.realABID]];
                        
                        [tmpGroupServerIds addObject:[NSNumber numberWithInt:m.serverId]];
                        break;
                    }
                }
                else{
                    if (j == [groupSummaryList count] -1) {
                        if (_flag == 0 && (m.groupName != nil) && (m.groupName.length > 0)) {//本地要删除的映射
                            [tmpGroupServerIds addObject:[NSNumber numberWithInt:m.serverId]];
                            
                            [tmpGroupIds addObject:[NSNumber numberWithInt:m.realABID]];//
                        }
                    }
                }
            }
        }
    }
    
    //数据库中删除数组，arrayData删除MappingInfo
    if ([tmpGroupIds count] > 0) {
        [[MemAddressBook getInstance]removeGroupsFromDb:tmpGroupIds];
    }
    
    if ([tmpGroupServerIds count] > 0) {
        [[MemAddressBook getInstance]removeGroupMappingInfo:tmpGroupServerIds];
    }
    
    if ([groupSummaryList count] == 0) {//删除本地数据库所有数据，arrayData中群组的Mapping
        [[MemAddressBook getInstance]removeAllGroupFromDb];
        
        [[MemAddressBook getInstance]removeAllGroupMappingInfo];
    }
    
    for (NSValue *tmp in temp2) {  //本地存在的群组就不需要下载
        [groupSummaryList removeObject:tmp];
    }
    
    [temp2 release];
    
    [tmpGroupIds release];
    
    [tmpGroupServerIds release];
    
    return groupSummaryList;
}

/*
 * 获取联系人摘要信息结束
 */
- (void)syncGetContactSummaryFinished:(ASIHTTPRequest *)request
{
	ZBLog(@"%@:syncGetContactSummaryFinished.", [arrayTaskString objectAtIndex:request.syncTaskType]);
    NSData *responseData = [request responseData];
    
    ContactListSummaryResponse *_contactListSummaryResponse;
	
	@try
	{
		_contactListSummaryResponse = [ContactListSummaryResponse parseFromData:responseData];
	}
	@catch (NSException * e)
	{
		ZBLog(@"%@: syncGetContactSummaryFinished. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
		[self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
		return;
	}
	@finally
	{
	}
	
    switch (request.syncTaskType)
    {
        case TASK_ALL_DOWNLOAD:
        {
            ZBLog(@"syncGetContactSummaryFinished contactListVersion=%d contact_count=%d group_count=%d", [_contactListSummaryResponse contactListVersion], [[_contactListSummaryResponse contactSummaryList] count], [[_contactListSummaryResponse groupSummaryList] count] );

            // 将联系人版本号保存到配置文件 domain:SyncServerInfo
            [self saveContactListVersion:[_contactListSummaryResponse contactListVersion]];
#pragma mark 2017.8.21 固定覆盖修改
/*-------↓2017.8.21------*/
            
            [[MemAddressBook getInstance] removeAllRecord];//删除本地联系人和群组
            [[MemAddressBook getInstance].arrayData removeAllObjects];//删除本地映射
            
            
            [self batchDownloadContact:[_contactListSummaryResponse contactSummaryList]
                           GroupIDList:[_contactListSummaryResponse groupSummaryList]
                              TaskType:TASK_ALL_DOWNLOAD];
            
            return;
/*-------↑2017.8.21------*/
            
            if ([_contactListSummaryResponse contactSummaryList].count + [_contactListSummaryResponse groupSummaryList].count == 0) {//平台联系人、群组都为空
                    if ([MemAddressBook getInstance].arrayData.count > 0) {
                        [[MemAddressBook getInstance].arrayData removeAllObjects];//删除本地映射
                    }
                    
                    [[MemAddressBook getInstance] removeAllRecord];//删除本地联系人和群组
                    
                    [[MemAddressBook getInstance] commit];
                    
                    if ([SettingInfo getIsSyncHeadimg]){
                        memset(&sse, 0, sizeof(sse));
                        
                        sse.taskType = TASK_ALL_DOWNLOAD;
                        
                        sse.status = Sync_State_Portrait_Downloading;
                        
                        [self syncStatusRefresh:YES];
                        // 通知MemAddressBook开始执行联系人头像全量下载
                        [[MemAddressBook getInstance] startPortraitSyncTask:TASK_ALL_DOWNLOAD];
                        
                        [[MemAddressBook getInstance] delMyPortrait];      // 删除名片头像
                        
                        // 用一个空的摘要信息去与服务端同步,名片版本设为0，表示本地没有名片头像
                        [self syncPortraitSummary:nil BusinessCardVersion:0 TaskType:TASK_ALL_DOWNLOAD];
                    }
                    else{
                        sse.status = Sync_State_Success;
                        
                        [self syncStatusRefresh:YES];
                    }
                    
                    return;
            }
            
       //////Updated on Nov.14, 2013
            if ([_contactListSummaryResponse contactSummaryList].count == 0) {//如果平台联系人为空
                [[MemAddressBook getInstance]removeAllContactMappingInfo];//删除本地联系人映射
              //  [[MemAddressBook getInstance] setupAddressBookRef];
                [[MemAddressBook getInstance] removeAllContactFromDb];//从数据库删除所有联系人
                
                ////end
                if ([[[MemAddressBook getInstance] arrayData] count] == 0) {
                    // 下载完联系人和组的摘要信息后，就可以真正下载联系人
                    [self batchDownloadContact:[_contactListSummaryResponse contactSummaryList]
                                   GroupIDList:[_contactListSummaryResponse groupSummaryList]
                                      TaskType:TASK_ALL_DOWNLOAD];
                }
                else{
                    
                    [[MemAddressBook getInstance]getAddressDbChange];
                    
                    [self deleteUnnecessaryMappingInfoAndRecord];
                    //contactSummaryList和arrayData 比较 1.不存在，下载2.
                    [self batchDownloadContact:[self getNewContactDownloadSummary:_contactListSummaryResponse]GroupIDList:[self getNewGroupDownloadSummary:_contactListSummaryResponse] TaskType:TASK_ALL_DOWNLOAD];
                }

                return;
            }
            
            if ([_contactListSummaryResponse groupSummaryList].count == 0) {//如果平台群组为空
              //  [[MemAddressBook getInstance] setupAddressBookRef];
                [[MemAddressBook getInstance]removeAllGroupFromDb];
                
                [[MemAddressBook getInstance] removeAllGroupMappingInfo];
                
                ////end
                if ([[[MemAddressBook getInstance] arrayData] count] == 0) {
                    // 下载完联系人和组的摘要信息后，就可以真正下载联系人
                    [self batchDownloadContact:[_contactListSummaryResponse contactSummaryList]
                                   GroupIDList:[_contactListSummaryResponse groupSummaryList]
                                      TaskType:TASK_ALL_DOWNLOAD];
                }
                else{
                    
                    [[MemAddressBook getInstance]getAddressDbChange];
                    
                    [self deleteUnnecessaryMappingInfoAndRecord];
                    //contactSummaryList和arrayData 比较 1.不存在，下载2.
                    [self batchDownloadContact:[self getNewContactDownloadSummary:_contactListSummaryResponse]
                                   GroupIDList:[self getNewGroupDownloadSummary:_contactListSummaryResponse]
                                      TaskType:TASK_ALL_DOWNLOAD];
                }

                return;
            }
            
            ////end
            if ([[[MemAddressBook getInstance] arrayData] count] == 0) {
                // 下载完联系人和组的摘要信息后，就可以真正下载联系人
                [self batchDownloadContact:[_contactListSummaryResponse contactSummaryList]
                               GroupIDList:[_contactListSummaryResponse groupSummaryList]
                                  TaskType:TASK_ALL_DOWNLOAD];
            }
            else{
                
                [[MemAddressBook getInstance]getAddressDbChange];

                [self deleteUnnecessaryMappingInfoAndRecord];
                //contactSummaryList和arrayData 比较 1.不存在，下载2.
                [self batchDownloadContact:[self getNewContactDownloadSummary:_contactListSummaryResponse]
                               GroupIDList:[self getNewGroupDownloadSummary:_contactListSummaryResponse]
                                  TaskType:TASK_ALL_DOWNLOAD];
            }
        }
            break;
        case TASK_USERCLOUDSUMMARY:
        {
            
            [[NSUserDefaults standardUserDefaults] setInteger:[_contactListSummaryResponse contactSummaryList].count forKey:@"ServiceContactCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            sse.status = Sync_State_Success;
            
            [self syncStatusRefresh:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark // 下载联系人结束
/*
 * 增量下载联系人结束  Maybe
 */
- (void)syncDownloadContactFinished:(ASIHTTPRequest *)request
{
    ZBLog(@"%@:syncDownloadContactFinished.", [arrayTaskString objectAtIndex:request.syncTaskType]);
    NSData *responseData = [request responseData];
    
    SyncDownloadContactResponse *_syncDownloadContactResponse;
	
	@try
	{
		_syncDownloadContactResponse = [SyncDownloadContactResponse parseFromData:responseData];
	}
	@catch (NSException * e)
	{
		ZBLog(@"%@: syncDownloadContactFinished. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
		[self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
		return;
	}
	@finally{
	}
#if DEBUG
    ZBLog(@"%@: total download %d contact, %d group.", [arrayTaskString objectAtIndex:request.syncTaskType], [[_syncDownloadContactResponse contactList] count], [[_syncDownloadContactResponse groupList] count]);
#endif
    
	int32_t iRecvNum = 0;
    
    NSArray *groupListArray = [_syncDownloadContactResponse groupList];
    //groupList
    for (Group* g in groupListArray){
        int32_t errCode = [[MemAddressBook getInstance] updGroup:[g serverId]
                                                     WithVersion:[g version]
                                                      WithTempID:[g serverId]];
        
        if (errCode != SYNC_ERR_OK){
            [self procABFailed:request ErrCode:errCode];
            return;
        }
        
        errCode = [[MemAddressBook getInstance] updGroup:g];
        
        if (errCode != SYNC_ERR_OK){
            [self procABFailed:request ErrCode:errCode];
            return;
        }
        
        iRecvNum++;
        
        if (iRecvNum % 100 == 0){
            sse.iRecvNum = iRecvNum;
			
            [self syncStatusRefresh:YES];
        }
    }
    
    NSArray *contactListArray = [_syncDownloadContactResponse contactList];
    // contactList
    for (Contact* c in contactListArray){
        int32_t errCode = [[MemAddressBook getInstance] updContact:[c serverId]
                                                       WithVersion:[c version]
                                                        WithTempID:[c serverId]];
        
        if (errCode != SYNC_ERR_OK){
            [self procABFailed:request ErrCode:errCode];
            return;
        }
        
        errCode = [[MemAddressBook getInstance] updContact:c];
        
        if (errCode != SYNC_ERR_OK){
            [self procABFailed:request ErrCode:errCode];
            return;
        }
        
        iRecvNum++;
        
        if (iRecvNum % 100 == 0){
            sse.iRecvNum = iRecvNum;
			
            [self syncStatusRefresh:YES];
        }
    }
    
//    [[MemAddressBook getInstance] updMyCard:[_syncDownloadContactResponse businessCard]];    // 保存我的名片
    
    [[MemAddressBook getInstance] commit];           // 提交修改
    
	sse.iRecvNum = sse.iRecvTotalNum;
    
    if (![SettingInfo getIsSyncHeadimg]){
		sse.status = Sync_State_Success;
    }
    
	[self syncStatusRefresh:YES];
	//Bug 所在点
	ZBLog(@"%@: 入库结束. ", [arrayTaskString objectAtIndex:request.syncTaskType]);
	
    switch (request.syncTaskType)
    {
		case TASK_DIFFER_SYNC:{ // 双向同步
			if ([SettingInfo getIsSyncHeadimg]){ // 上传客户端增量头像数据。需要能够从本地读取客户端增量头像数据
				memset(&sse, 0, sizeof(sse));
                
                sse.taskType = TASK_DIFFER_SYNC;
				
                sse.status = Sync_State_Portrait_Uploading;
				
                [self syncStatusRefresh:YES];
				// 通知MemAddressBook开始执行联系人头像同步
				[[MemAddressBook getInstance] startPortraitSyncTask:TASK_DIFFER_SYNC];
				
//				PortraitData *myPortraitData = [[MemAddressBook getInstance] myPortrait];
//				
//                int32_t myPortraitVersion = [[MemAddressBook getInstance] myPortraitVersion];
				// 读取本地的联系人增量头像信息contactUpdList
				// 客户端更新或删除名片头像时，设置BusinessCardPortrait字段。否则，不设置。
				[self syncUploadPortrait:[[MemAddressBook getInstance] contactUpdList]
					BusinessCardPortrait:nil
								TaskType:TASK_DIFFER_SYNC];
			}
			break;
        }
        case TASK_SYNC_DOANLOAD:{
			if ([SettingInfo getIsSyncHeadimg]){
               
				[[MemAddressBook getInstance] startPortraitSyncTask:TASK_SYNC_DOANLOAD];
				
				memset(&sse, 0, sizeof(sse));
				
                sse.taskType = TASK_SYNC_DOANLOAD;
				
                sse.status = Sync_State_Portrait_Downloading;
				
                [self syncStatusRefresh:YES];
				
				// 名片版本设为0，表示本地没有名片头像
                [self syncPortraitSummary:[[MemAddressBook getInstance] getPortraitSummaryList]
					  BusinessCardVersion:0
								 TaskType:TASK_SYNC_DOANLOAD];
			}
            
            break;
        }
        case TASK_MERGE_SYNC:{     // 慢同步
			if ([SettingInfo getIsSyncHeadimg]){
				memset(&sse, 0, sizeof(sse));
				
                sse.taskType = TASK_MERGE_SYNC;
				
                sse.status = Sync_State_Portrait_Uploading;
				
                [self syncStatusRefresh:YES];
				
				[[MemAddressBook getInstance] startPortraitSyncTask:TASK_MERGE_SYNC];
				
//				PortraitData *myPortraitData = [[MemAddressBook getInstance] myPortrait];
				// 读取本地的所有联系人头像信息contactAddList
				// 客户端更新或删除名片头像时，设置BusinessCardPortrait字段。否则，不设置。
				[self syncUploadPortrait:[[MemAddressBook getInstance] contactAddList]
					BusinessCardPortrait:nil
								TaskType:TASK_MERGE_SYNC];
			}
            break;
        }
            
        default:
            break;
    }
}

#pragma mark 增量下载、增量上传、双向同步都会调用
/*
 * 获取服务端联系人列表版本号
 */
- (void)syncGetVersionFinished:(ASIHTTPRequest *)request // 获取联系人版本号结束
{
    NSArray *allGroups;
    
    NSArray *allContacts;
    
	NSData *responseData = [request responseData];
	
    GetContactListVersionResponse *_getContactListVersionReponse;
	
	@try
	{
		_getContactListVersionReponse = [GetContactListVersionResponse parseFromData:responseData];
	}
	@catch (NSException * e)
	{
		ZBLog(@"%@: syncGetVersionFinished. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
		[self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
		return;
	}
	@finally
	{
	}
    // 读取Response
   // int32_t contactListVersion = _getContactListVersionReponse.contactListVersion;
   // ZBLog(@"%@: syncGetVersionFinished. servre version=%d， local version=%d", [arrayTaskString objectAtIndex:request.syncTaskType], [self],[self getContactListVersion]);
    
	if ([self getContactListVersion] <= 0){       // 本地保存的版本号<=0，直接执行慢同步
        allGroups = [[MemAddressBook getInstance] getAllUploadGroups];  //全部群组信息 (ProtocolBuffer)
        
        allContacts = [[MemAddressBook getInstance] getAllUploadContacts];   //全部联系人信息(ProtocolBuffer)
		
        [self syncUploadAllContact:allContacts GroupList:allGroups BusinessCard:[[MemAddressBook getInstance] myCard]
						  TaskType:TASK_MERGE_SYNC];
        
        ZBLog(@"本地保存的版本号<=0，直接执行慢同步...");
		return;
	}
    
//	int32_t userSetSyncHeadimgOn = [[[ConfigMgr getInstance]
//                                     getValueForKey:[NSString stringWithFormat:@"userSetSyncHeadimgOn"]
//                                     forDomain:[NSString stringWithFormat:@"SyncClientInfo"]] intValue];
	// 获取本地的增删改列表前必须调用diffSnapshot
    switch ([[MemAddressBook getInstance] diffSnapshot])  //检测本地通讯录数据库是否更新
    {
        case 0:{//本地AB没有变化
			ZBLog(@"%@: diffSnapshot==0", [arrayTaskString objectAtIndex:request.syncTaskType]);        
			
            break;
        }
        case -1:{  //本地AB发生错误，所有同步操作都改为慢同步
			ZBLog(@"%@: diffSnapshot==-1", [arrayTaskString objectAtIndex:request.syncTaskType]);
            [[MemAddressBook getInstance] rollback];
			
            request.syncTaskType = TASK_MERGE_SYNC;
            break;
        }
        case 1:{ //本地AB发生了变化
			ZBLog(@"%@: diffSnapshot==1", [arrayTaskString objectAtIndex:request.syncTaskType]);
            break;
        }
        default:
            break;
    }
    
	switch (request.syncTaskType)
	{
		case TASK_DIFFER_SYNC:{  // 双向同步
            [self syncUPloadDifferContact:[[MemAddressBook getInstance] contactAddList]
                           ContactUpdList:[[MemAddressBook getInstance] contactUpdList]
                           ContactDelList:[[MemAddressBook getInstance] contactDelList]
                             GroupAddList:[[MemAddressBook getInstance] groupAddList]
                             GroupUpdList:[[MemAddressBook getInstance] groupUpdList]
                             GroupDelList:[[MemAddressBook getInstance] groupDelList]
                       ContactListSummary:[[MemAddressBook getInstance] contactListSummary]
                         GroupListSummary:[[MemAddressBook getInstance] groupListSummary]
                             BusinessCard:nil
                      BusinessCardVersion:0
                                 TaskType:TASK_DIFFER_SYNC];
			break;
        }
        case TASK_MERGE_SYNC:{   // 慢同步
            allGroups = [[MemAddressBook getInstance] getAllUploadGroups];
            
            allContacts = [[MemAddressBook getInstance] getAllUploadContacts];
            
            [self syncUploadAllContact:allContacts
                             GroupList:allGroups
                          BusinessCard:nil
                              TaskType:TASK_MERGE_SYNC];
            break;
        }
		case TASK_SYNC_UPLOAD:{  //同步上传
#pragma mark 合并上传不上传已删除的联系人
            //增量上传是不删除云端联系人//[[MemAddressBook getInstance] contactDelList]
			[self syncUPloadDifferContact:[[MemAddressBook getInstance] contactAddList]
						   ContactUpdList:[[MemAddressBook getInstance] contactUpdList]
						   ContactDelList:nil
							 GroupAddList:[[MemAddressBook getInstance] groupAddList]
							 GroupUpdList:[[MemAddressBook getInstance] groupUpdList]
							 GroupDelList:[[MemAddressBook getInstance] groupDelList]
					   ContactListSummary:[[MemAddressBook getInstance] contactListSummary]
						 GroupListSummary:[[MemAddressBook getInstance] groupListSummary]
							 BusinessCard:nil
					  BusinessCardVersion:0
								 TaskType:TASK_SYNC_UPLOAD];
			break;
        }
		case TASK_SYNC_DOANLOAD:{ //同步下载（增量下载）
            // 2012-06-21 Modify:增量下载前要求先要执行增量上传
            [self syncUPloadDifferContact:nil
						   ContactUpdList:nil
						   ContactDelList:nil
							 GroupAddList:nil
							 GroupUpdList:nil
							 GroupDelList:nil
					   ContactListSummary:[[MemAddressBook getInstance] contactListSummary]
						 GroupListSummary:[[MemAddressBook getInstance] groupListSummary]
							 BusinessCard:nil
					  BusinessCardVersion:0
								 TaskType:TASK_SYNC_DOANLOAD];
			break;
        }
		default:
			break;
	}
}

/*
 * 下载联系人头像结束
 */
- (void)syncDownloadPortraitFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    
    DownloadPortraitResponse *_downloadPortraitResponse;
	
	@try
	{
		_downloadPortraitResponse = [DownloadPortraitResponse parseFromData:responseData];
	}
	@catch (NSException * e)
	{
		ZBLog(@"%@: syncDownloadPortraitFinished. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
		[self procPortraitFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
		return;
	}
	@finally
	{
	}
	
    NSArray *mutablePortraitList = [_downloadPortraitResponse portraitList];
    
	DownloadPortraitData *businessCardPortrait = [_downloadPortraitResponse businessCardPortrait];
	
    int32_t portraitVersion = [businessCardPortrait portraitVersion];// 联系人版本号
	
    PortraitData* portraitData = [businessCardPortrait portraitData];
	ZBLog(@"%@: syncDownloadPortraitFinished. downloadPortrait:%d, businessCardPortrait Version:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [mutablePortraitList count], portraitVersion);
    
	memset(&sse, 0, sizeof(sse));
	
    sse.taskType = request.syncTaskType;
	
    sse.status = Sync_State_Portrait_Downloading;
	
    sse.iRecvTotalNum = [mutablePortraitList count];
	
    [self syncStatusRefresh:YES];
	
	int32_t iRecvNum = 0;
	
	// 更新联系人头像
    for (DownloadPortraitData *portraitData in mutablePortraitList)
	{
		int32_t errCode = [[MemAddressBook getInstance] updPortrait:portraitData];     //更新Mapping、更新数据库
        
        if (errCode != SYNC_ERR_OK){
			[self procPortraitFailed:request ErrCode:errCode];
			return;
		}
		
        iRecvNum++;
		
        if (iRecvNum % 10 == 0){
			sse.iSendNum = iRecvNum;
            
            [self syncStatusRefresh:YES];
		}
	}
	
	if (portraitVersion > 0){
		[[MemAddressBook getInstance] updMyPortrait:portraitData];    // 更新名片头像
	}
	
    [[MemAddressBook getInstance] commitPortraitTask];   // 提交头像修改
	// 状态信息
	sse.iRecvNum = iRecvNum;
    
    sse.status = Sync_State_Success;
	
    [self syncStatusRefresh:YES];
	
	ZBLog(@"%@: 任务成功. ", [arrayTaskString objectAtIndex:request.syncTaskType]);
}

#pragma mark // 联系人头像摘要同步结束
/*
 * 联系人头像摘要同步
 */
- (void)syncPortraitSummaryFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    
    SyncPortraitResponse *_syncPortraitResponse;
	
	@try
	{
		_syncPortraitResponse = [SyncPortraitResponse parseFromData:responseData];
	}
	@catch (NSException * e)
	{
		ZBLog(@"%@: syncPortraitSummaryFinished. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
		[self procPortraitFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
		return;
	}
	@finally
	{
	}
    
    NSArray *downloadPortraitIdList = [_syncPortraitResponse downloadPortraitIdList];
    
    NSArray *deletedPortraitIdList = [_syncPortraitResponse deletedPortraitIdList];
    NSLog(@"################ syncPortraitSummaryFinished ############");
	ZBLog(@"%@: syncPortraitSummaryFinished. 服务端通知客户端 downloadPortrait:%d,deletedPortrait：%d", [arrayTaskString objectAtIndex:request.syncTaskType], [downloadPortraitIdList count], [deletedPortraitIdList count]);
	// 根据服务端的通知删除头像
	for (id portraitID in deletedPortraitIdList){
		int32_t errCode = [[MemAddressBook getInstance] delPortrait:[portraitID intValue]];   //删除MappingInfo、数据库删除
        
		if (errCode != SYNC_ERR_OK){
			[self procPortraitFailed:request ErrCode:errCode];
			return;
		}
	}
	
	if ([downloadPortraitIdList count] > 0 || [_syncPortraitResponse isNeedToDownloadBusinessCardPortrait]){
		memset(&sse, 0, sizeof(sse));
		
        sse.taskType = request.syncTaskType;
		
        sse.status = Sync_State_Portrait_Downloading;
		
        sse.iRecvTotalNum = [downloadPortraitIdList count];
		
        [self syncStatusRefresh:YES];
		
		[self syncDownloadPortrait:downloadPortraitIdList CardPortrait:[_syncPortraitResponse isNeedToDownloadBusinessCardPortrait]
						  TaskType:request.syncTaskType];
	}
	else{
		memset(&sse, 0, sizeof(sse));
		
        sse.taskType = request.syncTaskType;
		
        sse.status = Sync_State_Success;
		
        [self syncStatusRefresh:YES];
	}
    
    switch (request.syncTaskType)
    {
        case TASK_ALL_DOWNLOAD:// 全量下载
            break;
        case TASK_MERGE_SYNC:// 慢同步
            break;
        case TASK_SYNC_DOANLOAD:// 同步下载
            break;
        case TASK_DIFFER_SYNC:// 双向同步
			[[MemAddressBook getInstance] commitPortraitTask];
            break;
        default:
            break;
    }
}

#pragma mark // 联系人头像上传结束
/*
 *  联系人头像上传结束
 */
- (void)syncUploadPortraitFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    
    UploadPortraitResponse *_uploadPortraitResponse;
	
	@try
	{
		_uploadPortraitResponse = [UploadPortraitResponse parseFromData:responseData];
	}
	@catch (NSException * e)
	{
		ZBLog(@"%@: syncUploadPortraitFinished. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
		[self procPortraitFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
		return;
	}
	@finally
	{
	}
    
#if DEBUG
	ZBLog(@"%@: syncUploadPortraitFinished. 服务端通知客户端 updPortrait:%d, businessCardPortraitVersion:%d", [arrayTaskString objectAtIndex:request.syncTaskType], [[_uploadPortraitResponse portraitSummaryList] count], [_uploadPortraitResponse businessCardPortraitVersion]);
#endif
    
	int32_t iSendNum = 0;
	
	memset(&sse, 0, sizeof(sse));
	
    sse.taskType = request.syncTaskType;
	
    sse.iSendTotalNum = [[_uploadPortraitResponse portraitSummaryList] count];
	
    sse.status = Sync_State_Portrait_Uploading;
	
    [self syncStatusRefresh:YES];
	
	///////////////////////////////////////////	///////////////////////////////////////////
    //                        更新联系人头像版本                      //
    ///////////////////////////////////////////	///////////////////////////////////////////
	for (PortraitSummary *portraitSummary in [_uploadPortraitResponse portraitSummaryList])
	{
		int32_t errCode = [[MemAddressBook getInstance] updPortrait:[portraitSummary sid]
														WithVersion:[portraitSummary portraitVersion]];
		if (errCode != SYNC_ERR_OK)
		{
			[self procPortraitFailed:request ErrCode:errCode];
			return;
		}
		
		iSendNum++;
        
        if (iSendNum % 10 == 0)
		{
			sse.iSendNum = iSendNum;
			[self syncStatusRefresh:YES];
		}
	}
	
	/////////////////////////////////////////////	///////////////////////////////////////////
    //              更新名片头像             //
    ///////////////////////////////////////////	///////////////////////////////////////////
	if ([_uploadPortraitResponse businessCardPortraitVersion] > 0)
	{
		[[MemAddressBook getInstance] updMyPortraitVersion:[_uploadPortraitResponse businessCardPortraitVersion]];
	}
	
    switch (request.syncTaskType)
    {
        case TASK_ALL_UPLOAD:// 全量上传
			// 提交头像修改
			[[MemAddressBook getInstance] commitPortraitTask];
			
			sse.iSendNum = iSendNum;
            
            sse.status = Sync_State_Success;
			
            [self syncStatusRefresh:YES];
            
			ZBLog(@"%@:syncUploadPortraitFinished commit finished. ", [arrayTaskString objectAtIndex:request.syncTaskType]);
            break;
		case TASK_DIFFER_SYNC:// 双向同步
			memset(&sse, 0, sizeof(sse));
			
            sse.taskType = request.syncTaskType;
			
            sse.status = Sync_State_Portrait_Downloading;
			
            [self syncStatusRefresh:YES];
			
			// 名片版本设为0，表示本地没有名片头像
			[self syncPortraitSummary:[[MemAddressBook getInstance] getPortraitSummaryList]
				  BusinessCardVersion:[[MemAddressBook getInstance] myPortraitVersion]
							 TaskType:TASK_DIFFER_SYNC];
			break;
        case TASK_MERGE_SYNC:// 慢同步
			memset(&sse, 0, sizeof(sse));
			
            sse.taskType = request.syncTaskType;
			
            sse.status = Sync_State_Portrait_Downloading;
			
            [self syncStatusRefresh:YES];
			
			// 名片版本设为0，表示本地没有名片头像
			[self syncPortraitSummary:[[MemAddressBook getInstance] getPortraitSummaryList]
				  BusinessCardVersion:[[MemAddressBook getInstance] myPortraitVersion]
							 TaskType:TASK_MERGE_SYNC];
            break;
        case TASK_SYNC_UPLOAD:// 同步上传
            /////////////////////add code here///////////////////
            // 上传完联系人头像，会返回联系人ID和联系人头像版本号mapping关系，需要更新本地的头像版本号
			// 提交头像修改
			[[MemAddressBook getInstance] commitPortraitTask];
			
			sse.iSendNum = iSendNum;
			
            sse.status = Sync_State_Success;
			
            [self syncStatusRefresh:YES];
			
			ZBLog(@"%@:syncUploadPortraitFinished commit finished. ", [arrayTaskString objectAtIndex:request.syncTaskType]);
			
            // 流程结束
            /////////////////////////////////////////////////////
            break;
        default:
            break;
    }
}


/*
 * 同步上传联系人结束  maybe
 */
- (void)syncUPloadDifferContactFinished:(ASIHTTPRequest *)request
{
    int32_t responseStatusCode = [request responseStatusCode];
	ZBLog(@"%@: syncUPloadDifferContactFinished. responseStatusCode:%d", [arrayTaskString objectAtIndex:request.syncTaskType], responseStatusCode);
    
    if (responseStatusCode == 204) // 服务端要求执行慢同步
    {
        // 先清理session,执行rollback
        [[MemAddressBook getInstance] unchanged];
        
        ZBLog(@"%@ change to %@", [arrayTaskString objectAtIndex:request.syncTaskType], [arrayTaskString objectAtIndex:TASK_MERGE_SYNC]);
        
        NSArray *allGroups = [[MemAddressBook getInstance] getAllUploadGroups];
        
        NSArray *allContacts = [[MemAddressBook getInstance] getAllUploadContacts];
		
        [self syncUploadAllContact:allContacts
						 GroupList:allGroups
					  BusinessCard:nil
						  TaskType:TASK_MERGE_SYNC];
		return;
    }
    
	NSData *responseData = [request responseData];
	
    SyncUploadContactResponse *_syncUploadContactResponse;
	
	@try
	{
		_syncUploadContactResponse = [SyncUploadContactResponse parseFromData:responseData];
        NSLog(@"..%@",_syncUploadContactResponse);
	}
	@catch (NSException * e)
	{
		ZBLog(@"%@: syncUPloadDifferContactFinished. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
		[self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
		return;
	}
	@finally
	{
	}
    
    ZBLog(@"Local ContactListVersion: %d", [self getContactListVersion]);
#if DEBUG
	ZBLog(@"%@ 服务端通知客户端: contactListVersion:%d, update group:%d, delete group:%d, download group:%d, update contact:%d, delete contact:%d, download contact:%d",
           [arrayTaskString objectAtIndex:request.syncTaskType],
           [_syncUploadContactResponse contactListVersion],
           [[_syncUploadContactResponse groupMappingInfoList] count],
           [[_syncUploadContactResponse deletedGroupIdList] count],
           [[_syncUploadContactResponse updatedGroupIdList] count],
           [[_syncUploadContactResponse contactMappingInfoList] count],
           [[_syncUploadContactResponse deletedContactIdList] count],
           [[_syncUploadContactResponse updatedContactIdList] count]);
    
#endif
    //更新组ID和版本号
    for (SyncMappingInfo *mappingInfo in [_syncUploadContactResponse groupMappingInfoList])
    {
		int32_t errCode = [[MemAddressBook getInstance] updGroup:[mappingInfo serverId]
													 WithVersion:[mappingInfo version]
													  WithTempID:([mappingInfo tempServerId] == -1 ? [mappingInfo serverId] : [mappingInfo tempServerId])];
		if (errCode != SYNC_ERR_OK)
		{
			[self procABFailed:request ErrCode:errCode];
			return;
		}
    }
    
    
    
    //更新联系人ID和版本号
    for (SyncMappingInfo *mappingInfo in [_syncUploadContactResponse contactMappingInfoList])
    {
		int32_t errCode = [[MemAddressBook getInstance] updContact:[mappingInfo serverId]
													   WithVersion:[mappingInfo version]
														WithTempID:([mappingInfo tempServerId] == -1 ? [mappingInfo serverId] : [mappingInfo tempServerId])];
		if (errCode != SYNC_ERR_OK)
		{
			[self procABFailed:request ErrCode:errCode];
			return;
		}
    }
    
    
    
	ZBLog(@"%@: 更新客户端版本号结束. ", [arrayTaskString objectAtIndex:request.syncTaskType]);
    
    sse.iRecvNum = sse.iRecvTotalNum;
    
    [self syncStatusRefresh:YES];
    
	switch (request.syncTaskType)
	{
		case TASK_SYNC_UPLOAD:// 同步上传
			//更新名片版本号
//			[[MemAddressBook getInstance] updMyCardVersion:[_syncUploadContactResponse businessCardVersion]];
			
            // 提交修改
            [[MemAddressBook getInstance] commit];
            
            //服务端返回的结果里带了需要客户端下载的联系人和组列表，但由于这是同步上传流程，所以不做下载请求。分别是:
            //[_syncUploadContactResponse updatedContactIdList]
            //[_syncUploadContactResponse updatedGroupIdList]
            
            
            // 接下来需要上传联系人头像，要找到增量联系人头像
            /////////////////////////////////////////////////////
			// 判断是否需要同步头像
			if ([SettingInfo getIsSyncHeadimg])
			{
				// 状态信息显示：正在下载联系人头像
				memset(&sse, 0, sizeof(sse));
                
				sse.taskType = TASK_SYNC_UPLOAD;
				
                sse.status = Sync_State_Portrait_Uploading;
				
                [self syncStatusRefresh:YES];
				// 通知MemAddressBook开始执行联系人头像同步
				[[MemAddressBook getInstance] startPortraitSyncTask:TASK_DIFFER_SYNC];
				
//				PortraitData *myPortraitData = [[MemAddressBook getInstance] myPortrait];
//				
//                int32_t myPortraitVersion = [[MemAddressBook getInstance] myPortraitVersion];
				// 读取本地的联系人增量头像信息contactUpdList
				// 客户端更新或删除名片头像时，设置BusinessCardPortrait字段。否则，不设置。
                NSLog(@"portrait: %@", [[MemAddressBook getInstance] contactUpdList]);
				[self syncUploadPortrait:[[MemAddressBook getInstance] contactUpdList]
					BusinessCardPortrait:nil
								TaskType:request.syncTaskType];
			}
            else
            {
                // 通知UI：上传联系人结束
                sse.taskType = request.syncTaskType;
                
                sse.status = Sync_State_Success;
                
                [self syncStatusRefresh:YES];
            }
            
			break;
		case TASK_DIFFER_SYNC:// 双向同步
        {
#pragma mark 只在双向同步时对本地联系人进行删除操作 /2015.11.18
            
            //删除组名(已在服务端删除)
            [self deleteGroup:[_syncUploadContactResponse deletedGroupIdList] request:request];
            
            //删除联系人(已在服务端删除)
            [self deleteContact:[_syncUploadContactResponse deletedContactIdList] request:request];
        }
        case TASK_SYNC_DOANLOAD:// 同步下载
            // 2012-08-07 同步上传功能，不能保存服务端版本号，但是双向同步和同步下载需要保存版本号
            [self saveContactListVersion:[_syncUploadContactResponse contactListVersion]];
            // 正在下载联系人
            memset(&sse, 0, sizeof(sse));
            
            sse.taskType = request.syncTaskType;
            
            sse.status = Sync_State_Downloading;
            
            sse.iRecvTotalNum = [[_syncUploadContactResponse deletedGroupIdList] count] + [[_syncUploadContactResponse updatedGroupIdList] count] + [[_syncUploadContactResponse deletedContactIdList] count] + [[_syncUploadContactResponse updatedContactIdList] count];
            [self syncStatusRefresh:YES];
			// 两种任务状态下都需要根据返回结果下载联系人和组
            ZBLog(@"%@: need download %d contact, %d group", [arrayTaskString objectAtIndex:request.syncTaskType], [[_syncUploadContactResponse updatedContactIdList] count], [[_syncUploadContactResponse updatedGroupIdList] count]);
			[self syncDownloadContact:[_syncUploadContactResponse updatedContactIdList]
						  GroupIDList:[_syncUploadContactResponse updatedGroupIdList]
							 TaskType:request.syncTaskType];
			break;
		default:
			break;
	}
}

#pragma mark 如果没有联系人或者群组下载，则单独下载名片
//Added by kevin on June,21 2013
- (BOOL)downloadBussinessCard:(SyncTaskType)syncTaskType{
    return YES;//新版本在同步过程中不下载名片
    SyncDownloadContactRequest *_syncDownloadContactRequest = [[[[[SyncDownloadContactRequest builder]
                                                                  addAllContactId:nil]
                                                                 addAllGroupId:nil]
                                                                setIsRequestBusinessCard:YES]
                                                               build];
    
    NSData *requestData = [_syncDownloadContactRequest data];
    
    NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
    
    ASIHTTPRequest *request = [self initBatchDownloadContactRequest];
    
    request.syncTaskType = syncTaskType;
    
    [request addRequestHeader:@"Content-Length" value:length];
    
    [request appendPostData:requestData];
    
    [request startSynchronous];
    
    if (currentRequest) {
        [currentRequest release];
    }
    
    currentRequest = request;
    
    [currentRequest retain];
    
    NSError *error = [request error];
    
    BOOL result = NO;
    if (!error)
    {
        NSData *responseData = [request responseData];
        
        SyncDownloadContactResponse *_syncDownloadContactResponse;
        
        @try
        {
            _syncDownloadContactResponse = [SyncDownloadContactResponse parseFromData:responseData];
        }
        @catch (NSException * e)
        {
            ZBLog(@"%@: batchDownloadContact. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
            [self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
            return result;
        }
        @finally
        {
        }
        
        // 保存我的名片
        if ([_syncDownloadContactResponse businessCard] != nil){
            ZBLog(@"%@: 保存名片.businessCard Version=%d", [arrayTaskString objectAtIndex:request.syncTaskType], [[_syncDownloadContactResponse businessCard] version]);
            [[MemAddressBook getInstance] updMyCard:[_syncDownloadContactResponse businessCard]];
            
            result = YES;
        }
    }
    
    return result;
}

#pragma mark batch upload and download
/*
 * // 下载联系人: 同步方式分批下载
 */
- (void)batchDownloadContact:(NSArray *)contactSummaryList
                 GroupIDList:(NSArray *)groupSummaryList
                    TaskType:(SyncTaskType)syncTaskType
{
	ZBLog(@"%@(batch): contactSummaryList(%d), groupSummaryList(%d).", [arrayTaskString objectAtIndex:syncTaskType], [contactSummaryList count], [groupSummaryList count]);
    // 分批处理，每批的数量。如果没有配置，则默认为BATCH_DOWNLOAD_LIMIT(500)
    int32_t batchDownloadLimit = [[[ConfigMgr getInstance]
                                   getValueForKey:[NSString stringWithFormat:@"BatchDownloadContactLimit"]
                                   forDomain:[NSString stringWithFormat:@"ClientSettings"]] intValue];
    if (batchDownloadLimit <= 0){
        batchDownloadLimit = BATCH_DOWNLOAD_LIMIT;
    }
	
    int32_t downloadTotalNum = 0;              // 单独用于下载组或联系人
    
    int32_t remainDownloadNum = 0;             // 单独用于下载组或联系人
	
	int32_t batchNo = 0;       // 当前批次。包括组和联系人
	// 总批次。包括组和联系人
	int32_t totalBatch = ([groupSummaryList count] + batchDownloadLimit - 1)/batchDownloadLimit + ([contactSummaryList count] + batchDownloadLimit - 1)/batchDownloadLimit;
    // 总数量。包括联系人和组.但是不包括名片.名片放在最后一批下载。不计算数量。
	int32_t totalCount = [groupSummaryList count] + [contactSummaryList count];
	
	memset(&sse, 0, sizeof(sse));
	
    sse.taskType = syncTaskType;
	
    sse.status = Sync_State_Downloading;
	
    sse.iRecvTotalNum = totalCount;
	
    [self syncStatusRefresh:YES];
	
	if (totalBatch <= 0){
		if (syncTaskType == TASK_ALL_DOWNLOAD){
//            if ([self downloadBussinessCard:syncTaskType]) {
                if ([SettingInfo getIsSyncHeadimg]){
                    memset(&sse, 0, sizeof(sse));
                    
                    sse.taskType = syncTaskType;
                    
                    sse.status = Sync_State_Portrait_Downloading;
                    
                    [self syncStatusRefresh:YES];
                    // 通知MemAddressBook开始执行联系人头像全量下载
                    [[MemAddressBook getInstance] startPortraitSyncTask:TASK_ALL_DOWNLOAD];
                    
                    [[MemAddressBook getInstance] delMyPortrait];      // 删除名片头像
                    
                    // 用一个空的摘要信息去与服务端同步,名片版本设为0，表示本地没有名片头像
                    [self syncPortraitSummary:nil BusinessCardVersion:0 TaskType:syncTaskType];
                }
                else{
                  sse.status = Sync_State_Success;
                        
                  [self syncStatusRefresh:YES];
                 
                }
//            }
//            else{
//                sse.status = Sync_State_Faild;
//                
//                [self syncStatusRefresh:YES];
//            }
			
		}
        else{
            sse.status = Sync_State_Success;
            
            [self syncStatusRefresh:YES];
        }
		
		return;
	}
	
    //先下载group
	downloadTotalNum = [groupSummaryList count];
    
	remainDownloadNum = downloadTotalNum;
    
	if (syncTaskType == TASK_ALL_DOWNLOAD){
        if ([[[MemAddressBook getInstance]arrayData] count] == 0) {
            [[MemAddressBook getInstance] removeAllRecord];        // 删除所有MappingInfo、数据库所有联系人
        }
	}
    
	int32_t iRecvNum = 0;
	
    while (remainDownloadNum > 0)
    {     // 计算本次需要下载的数量
        int32_t nDownload = remainDownloadNum > batchDownloadLimit ? batchDownloadLimit : remainDownloadNum;
		// 获取本次需要下载的列表
		NSRange range = NSMakeRange(downloadTotalNum - remainDownloadNum, nDownload);
        
        NSArray *nowDownload = [groupSummaryList subarrayWithRange:range];
		
		remainDownloadNum = remainDownloadNum - nDownload;      // 剩余需要下载的group数量
        
		BOOL IsRequestBusinessCard = NO;
        
		if (remainDownloadNum <= 0 && [contactSummaryList count] == 0){ //最后一批,并且判断后续需要下载的联系人为0，则申请下载名片.
			IsRequestBusinessCard = YES;
		}
		
		SyncDownloadContactRequest *_syncDownloadContactRequest = [[[[[SyncDownloadContactRequest builder]
																	  addAllContactId:nil]
																	 addAllGroupId:nowDownload]
																	setIsRequestBusinessCard:NO]
																   build];
		
		NSData *requestData = [_syncDownloadContactRequest data];
        
		NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
        
        ASIHTTPRequest *request = [self initBatchDownloadContactRequest];
        
        request.syncTaskType = syncTaskType;
        
        [request addRequestHeader:@"Content-Length" value:length];
		
		[request appendPostData:requestData];
        
		[request startSynchronous];          // 开始同步下载
		
        if (currentRequest) {
			[currentRequest release];
		}
		
        currentRequest = request;
		
        [currentRequest retain];
		
        NSError *error = [request error];
		
        if (!error){
			batchNo++;        // 递增当前批次
            
            iRecvNum += nDownload;
			
            sse.iRecvNum = iRecvNum;
			
            [self syncStatusRefresh:YES];
			
			ZBLog(@"%@:batchDownloadContact(groups): %d/%d [%d/%d].", [arrayTaskString objectAtIndex:request.syncTaskType], batchNo, totalBatch, iRecvNum, totalCount);
			NSData *responseData = [request responseData];
			
            SyncDownloadContactResponse *_syncDownloadContactResponse;
            
			@try
			{
				_syncDownloadContactResponse = [SyncDownloadContactResponse parseFromData:responseData];
			}
			@catch (NSException * e)
			{
				ZBLog(@"%@: batchDownloadContact. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
				[self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
				return;
			}
			@finally
			{
			}
			
			if (request.syncTaskType == TASK_ALL_DOWNLOAD)         //全量下载
			{
				// 全量下载时用addGroup保存组信息
				for (Group* g in [_syncDownloadContactResponse groupList]){
					int32_t errCode = [[MemAddressBook getInstance] addGroup:g];    //添加新群组到数据库、添加新MappingInfo
                    
                    if (errCode != SYNC_ERR_OK){
						[self procABFailed:request ErrCode:errCode];
						return;
					}
				}
			}
			else
			{
				for (Group* g in [_syncDownloadContactResponse groupList]){ // 非全量下载时用updGroup保存组信息
					int32_t errCode = [[MemAddressBook getInstance] updGroup:[g serverId]
                                                                 WithVersion:[g version] WithTempID:[g serverId]];
					if (errCode != SYNC_ERR_OK){
						[self procABFailed:request ErrCode:errCode];
						return;
					}
					
                    errCode = [[MemAddressBook getInstance] updGroup:g];
					
                    if (errCode != SYNC_ERR_OK){
						[self procABFailed:request ErrCode:errCode];
						return;
					}
				}
			}
            // 如果有名片，则保存
//			if ([_syncDownloadContactResponse businessCard] != nil && IsRequestBusinessCard == YES){
//				[[MemAddressBook getInstance] updMyCard:[_syncDownloadContactResponse businessCard]];
//			}
		}
		else
		{
			ZBLog(@"batchDownloadContact Failed.reason=%d", [error code]);
			[self procABFailed:request ErrCode:[error code]];

			return;
		}
    }
    
    //后下载contact
	downloadTotalNum = [contactSummaryList count];
    
	remainDownloadNum = downloadTotalNum;
	
	while (remainDownloadNum > 0)
	{    // 计算本次需要下载的数量
        int32_t nDownload = remainDownloadNum > batchDownloadLimit ? batchDownloadLimit : remainDownloadNum;
		// 获取本次需要下载的列表
		NSRange range = NSMakeRange(downloadTotalNum - remainDownloadNum, nDownload);
        
        NSArray *nowDownload = [contactSummaryList subarrayWithRange:range];
        
		remainDownloadNum = remainDownloadNum - nDownload;         // 剩余需要下载的contact数量
        
		BOOL IsRequestBusinessCard = NO;
		
		if (remainDownloadNum <= 0){ // 最后一批，申请下载名片
			IsRequestBusinessCard = YES;
		}
		// businessCard放在最后下载,所以设为No
		SyncDownloadContactRequest *_syncDownloadContactRequest = [[[[[SyncDownloadContactRequest builder]
																	  addAllContactId:nowDownload]
																	 addAllGroupId:nil]
																	setIsRequestBusinessCard:NO]
																   build];
		
		NSData *requestData = [_syncDownloadContactRequest data];
		
        NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
        
        ASIHTTPRequest *request = [self initBatchDownloadContactRequest];
        
        request.syncTaskType = syncTaskType;
        
        [request addRequestHeader:@"Content-Length" value:length];
		
		[request appendPostData:requestData];
        
		[request startSynchronous];
		
        if (currentRequest) {
			[currentRequest release];
		}
		
        currentRequest = request;
		
        [currentRequest retain];
		
        NSError *error = [request error];
		
        if (!error)
		{
			batchNo++;             // 递增当前批次
            
            iRecvNum += nDownload;
			
            sse.iRecvNum = iRecvNum;
			
            [self syncStatusRefresh:YES];
			
			ZBLog(@"%@:batchDownloadContact(contacts): %d/%d [%d/%d].", [arrayTaskString objectAtIndex:request.syncTaskType], batchNo, totalBatch, iRecvNum, totalCount);
			NSData *responseData = [request responseData];
			
            SyncDownloadContactResponse *_syncDownloadContactResponse;
			
			@try
			{
				_syncDownloadContactResponse = [SyncDownloadContactResponse parseFromData:responseData];
			}
			@catch (NSException * e)
			{
				ZBLog(@"%@: batchDownloadContact 2. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
				[self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
				return;
			}
			@finally
			{
			}
			
			if (request.syncTaskType == TASK_ALL_DOWNLOAD)      //全量下载
			{   // 全量下载时用addContact保存联系人信息
				for (Contact* c in [_syncDownloadContactResponse contactList]){
                  //  NSLog(@"######name:%@, email:%@", c.name.familyName,c.comEmail.emailValue);
					int32_t errCode = [[MemAddressBook getInstance] addContact:c];
                    
                    if (errCode != SYNC_ERR_OK){
						[self procABFailed:request ErrCode:errCode];
						return;
					}
				}
			}
			else
			{    	// 非全量下载时用updContact保存联系人信息
				for (Contact* c in [_syncDownloadContactResponse contactList]){
					int32_t errCode = [[MemAddressBook getInstance] updContact:[c serverId]
                                                                   WithVersion:[c version] WithTempID:[c serverId]];
					
                    if (errCode != SYNC_ERR_OK){
						[self procABFailed:request ErrCode:errCode];
                        
                        return;
					}
                    
					errCode = [[MemAddressBook getInstance] updContact:c];
					
                    if (errCode != SYNC_ERR_OK){
						[self procABFailed:request ErrCode:errCode];
						return;
					}
				}
			}
            // 保存我的名片
//			if ([_syncDownloadContactResponse businessCard] != nil && IsRequestBusinessCard == YES){
//				ZBLog(@"%@: 保存名片.businessCard Version=%d", [arrayTaskString objectAtIndex:request.syncTaskType], [[_syncDownloadContactResponse businessCard] version]);
//				[[MemAddressBook getInstance] updMyCard:[_syncDownloadContactResponse businessCard]];
//			}
		}
		else
		{
			ZBLog(@"batchDownloadContact Failed.reason=%d", [error code]);
			[self procABFailed:request ErrCode:[error code]];

			return;
		}
	}
    
	[[MemAddressBook getInstance] commit];     //提交修改
    
	if (![SettingInfo getIsSyncHeadimg]){
		sse.status = Sync_State_Success;
        
		[self syncStatusRefresh:YES];
	}
    else{
        memset(&sse, 0, sizeof(sse));
        
        sse.taskType = syncTaskType;
        
        sse.status = Sync_State_Portrait_Downloading;
        
        [self syncStatusRefresh:YES];
        // 通知MemAddressBook开始执行联系人头像全量下载
        [[MemAddressBook getInstance] startPortraitSyncTask:TASK_ALL_DOWNLOAD];
        
        [[MemAddressBook getInstance] delMyPortrait];  // 删除名片头像
        // 用一个空的摘要信息去与服务端同步,名片版本设为0，表示本地没有名片头像
        [self syncPortraitSummary:nil BusinessCardVersion:0 TaskType:syncTaskType];
    }
}

#pragma mark    // 全量上传: 同步方式分批上传
/*
 * 全量上传: 同步方式分批上传
 */
- (void)batchUploadAllContact:(NSArray*)contactList
                    GroupList:(NSArray*)groupList
                 BusinessCard:(Contact*)businessCard
                     TaskType:(SyncTaskType)syncTaskType
{
	ZBLog(@"%@(batch): addAllContactInfo(%d), addAllGroupInfo(%d).", [arrayTaskString objectAtIndex:syncTaskType], [contactList count], [groupList count]);
	// 分批处理，每批的数量。如果没有配置，则默认为BATCH_UPLOAD_LIMIT(500)
    int32_t batchUploadLimit = [[[ConfigMgr getInstance]
                                 getValueForKey:[NSString stringWithFormat:@"BatchUploadContactLimit"]
                                 forDomain:[NSString stringWithFormat:@"ClientSettings"]] intValue];
    if (batchUploadLimit <= 0){
        batchUploadLimit = BATCH_UPLOAD_LIMIT;
    }
	
    int32_t uploadTotalNum = 0;
    
    int32_t remainUploadNum = 0;
	
	int32_t batchNo = 0;      // 当前批次。包括组和联系人
	// 总批次。包括组和联系人 /////////////////////////////////////////////////////////
	int32_t totalBatch = ([contactList count] + [groupList count] + batchUploadLimit - 1)/batchUploadLimit;
    // 总数量。包括联系人和组.但是不包括名片.名片放在最后一批下载。不计算数量。
	int32_t totalCount = [groupList count] + [contactList count];
	
    int32_t totalGroup = [groupList count];
    
    int32_t totalContact = [contactList count];
    
    uploadTotalNum = totalCount;
	
    remainUploadNum = uploadTotalNum;
	
	memset(&sse, 0, sizeof(sse));
	
    sse.taskType = syncTaskType;
	
    sse.status = Sync_State_Uploading;
	
    sse.iSendTotalNum = totalCount;
	
    [self syncStatusRefresh:YES];          //更新UI
	
	int32_t iSendNum = 0;
	
    NSString *sessionID = nil;
	
    UploadContactInfoResponse *_uploadContactInfoResponse;
	
    SyncUploadContactResponse *_syncUploadContactResponse;
    
	while (remainUploadNum > 0 || (remainUploadNum == 0 && batchNo == 0))
    {
        batchNo++;         // 递增当前批次
        
        int32_t nUpload = remainUploadNum > batchUploadLimit ? batchUploadLimit : remainUploadNum; // 计算本次需要上传的数量
        
        int32_t startPos = uploadTotalNum - remainUploadNum;       // 获取本次需要上传的列表
        
        int32_t startPos_g = startPos > totalGroup ? totalGroup : startPos;
        
        int32_t nUpload_g = (totalGroup - startPos_g) > nUpload ? nUpload : (totalGroup - startPos_g);
		
        NSRange rangeGroup = NSMakeRange(startPos_g, nUpload_g);
        
        NSArray *groupsUpload = [groupList subarrayWithRange:rangeGroup];
        
        int32_t startPos_c = (startPos - totalGroup) > 0 ? (startPos - totalGroup) : 0;
        
        int32_t nUpload_c = (nUpload - nUpload_g) > (totalContact - startPos_c) ? (totalContact - startPos_c) : (nUpload - nUpload_g);
        
        NSRange rangeContact = NSMakeRange(startPos_c, nUpload_c);
        
        NSArray *contactsUpload = [contactList subarrayWithRange:rangeContact];
        
        ZBLog(@"%@(batch): batchNo=%d, groupsUpload=%d, contactsUpload=%d.", [arrayTaskString objectAtIndex:syncTaskType], batchNo, nUpload_g, nUpload_c);
        
		remainUploadNum = remainUploadNum - nUpload;      // 剩余需要上传的group数量
		
		UploadContactInfoRequest *_uploadContactInfoRequest;
        
        if (batchNo >= totalBatch){     // 最后一批
            _uploadContactInfoRequest = [[[[UploadContactInfoRequest builder]
											addAllContactInfo:(nUpload_c > 0 ? contactsUpload : nil)]
										   addAllGroupInfo:(nUpload_g > 0 ? groupsUpload : nil)] build];
        }
		else{
			_uploadContactInfoRequest = [[[[UploadContactInfoRequest builder]
											addAllContactInfo:(nUpload_c > 0 ? contactsUpload : nil)]
										   addAllGroupInfo:(nUpload_g > 0 ? groupsUpload : nil)] build];
		}
        
		NSData *requestData = [_uploadContactInfoRequest data];
		
        NSString *length = [NSString stringWithFormat:@"%d", [requestData length]];
		// 如果是慢同步，则采用[慢同步URL + 全量上传信号]
		// 需要注意的是，如果慢同步，返回信号不是UploadContactInfoResponse，而是SyncUploadContactResponse
		NSURL *url = [NSURL URLWithString:((syncTaskType == TASK_MERGE_SYNC) ? configResponse.slowSyncUrl : configResponse.uploadAllUrl)];
#warning uploadAllUrl------------------------------------------↑
        
        ASIHTTPRequest *request = [self initBatchUploadAllContactRequest:url];
        
        request.syncTaskType = syncTaskType;
        
        NSString *cookie;
		
		if (batchNo == 1)    // 第一批
		{
			if (totalBatch <= batchNo){
                // 最后一批
				cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld;BatchNo=%d;NoMore=True",
                          authResponse.token, authResponse.syncUserId, batchNo];
				
			}
			else{
				// 非最后一批
				cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld;BatchNo=%d;NoMore=False",
						  authResponse.token, authResponse.syncUserId, batchNo];
			}
		}
		else// 非第一批
		{
			if (totalBatch <= batchNo){
				// 最后一批
				cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld;SessionID=%@;BatchNo=%d;NoMore=True",
						  authResponse.token, authResponse.syncUserId, sessionID, batchNo];
			}
			else{
				// 非最后一批
				cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld;SessionID=%@;BatchNo=%d;NoMore=False",
                          authResponse.token, authResponse.syncUserId, sessionID, batchNo];
			}
		}
		
		[request addRequestHeader:@"Cookie" value:cookie];
		
        [request addRequestHeader:@"Content-Length" value:length];
		
		[request appendPostData:requestData];
		
		[request startSynchronous];
		
        if (currentRequest) {
			[currentRequest release];
		}
		
        currentRequest = request;
		
        [currentRequest retain];
		
        NSError *error = [request error];
		
		if (!error)
		{
			iSendNum += nUpload;
            sse.iRecvNum = iSendNum;
			
            [self syncStatusRefresh:YES];
			
			ZBLog(@"%@:batchUploadContact(groups:%d, contacts:%d): %d/%d [%d/%d].", [arrayTaskString objectAtIndex:request.syncTaskType], nUpload_g, nUpload_c, batchNo, totalBatch, iSendNum, totalCount);
			
			NSData *responseData = [request responseData];
            
			switch (request.syncTaskType)  //分全量上传、慢同步
			{
				case TASK_ALL_UPLOAD:// 全量上传
					@try
                {
                    _uploadContactInfoResponse = [UploadContactInfoResponse parseFromData:responseData];
                }
					@catch (NSException * e)
                {
                    ZBLog(@"%@: batchUploadAllContact. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
                    [self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
                    return;
                }
					@finally
                {
                }
					
                    if (batchNo == 1 && batchNo < totalBatch){
                        sessionID = [NSString stringWithString:[_uploadContactInfoResponse sessionId]];
                    }
					//更新联系人总版本号
					[self saveContactListVersion:[_uploadContactInfoResponse contactListVersion]];
                    //更新群组MappingInfo
                    [self updateGroupMappingInfo:[_uploadContactInfoResponse groupMappingInfoList]
                                         request:request];
                    //更新联系人MappingInfo
                    [self updateContactMappingInfo:[_uploadContactInfoResponse contactMappingInfoList]
                                           request:request];
                    
					if (totalBatch <= batchNo){  // 在最后一片结束时处理入库
                        //更新名片版本号
//						[[MemAddressBook getInstance] updMyCardVersion:[_uploadContactInfoResponse businessCardVersion]];
//                        
                        [[MemAddressBook getInstance] commit];         //提交修改
                        
                        NSLog(@"%@:batchUploadContact commit finished. ", [arrayTaskString objectAtIndex:syncTaskType]);
                        
						if ([SettingInfo getIsSyncHeadimg]){  //头像同步
							memset(&sse, 0, sizeof(sse));
                            
							sse.taskType = TASK_ALL_UPLOAD;
							
                            sse.status = Sync_State_Portrait_Uploading;
							
                            [self syncStatusRefresh:YES];
							// 通知MemAddressBook开始执行头像上传
							[[MemAddressBook getInstance] startPortraitSyncTask:TASK_ALL_UPLOAD];
							//contactAddList 存储UploadPortraitData Builder
							[self syncUploadPortrait:[[MemAddressBook getInstance] contactAddList]
								BusinessCardPortrait:nil
											TaskType:(SyncTaskType)syncTaskType];
						}
						else{
							sse.status = Sync_State_Success;
							
                            [self syncStatusRefresh:YES];
						}
					}
					break;
				case TASK_MERGE_SYNC:// 慢同步
					@try
                {
                    _syncUploadContactResponse = [SyncUploadContactResponse parseFromData:responseData];
                }
					@catch (NSException * e)
                {
                    ZBLog(@"%@: batchUploadAllContact 2. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
                    [self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
                    
                    return;
                }
					@finally
                {
                }
                    
                    if (batchNo == 1 && batchNo < totalBatch){
                        sessionID = [NSString stringWithString:[_syncUploadContactResponse sessionId]];
                    }
                    ZBLog(@"%@(batch) 服务端通知客户端: contactListVersion:%d, update group:%d, delete group:%d, download group:%d, update contact:%d, delete contact:%d, download contact:%d",
                           [arrayTaskString objectAtIndex:request.syncTaskType],
                           [_syncUploadContactResponse contactListVersion],
                           [[_syncUploadContactResponse groupMappingInfoList] count],
                           [[_syncUploadContactResponse deletedGroupIdList] count],
                           [[_syncUploadContactResponse updatedGroupIdList] count],
                           [[_syncUploadContactResponse contactMappingInfoList] count],
                           [[_syncUploadContactResponse deletedContactIdList] count],
                           [[_syncUploadContactResponse updatedContactIdList] count]);
                    
                    //更新联系人总版本号
                    [self saveContactListVersion:[_syncUploadContactResponse contactListVersion]];
                    //更新组ID和版本号
                    for (SyncMappingInfo *mappingInfo in [_syncUploadContactResponse groupMappingInfoList]){
                        int32_t errCode = [[MemAddressBook getInstance] updGroup:[mappingInfo serverId]
                                                                     WithVersion:[mappingInfo version]
                                                                      WithTempID:([mappingInfo tempServerId] == -1 ? [mappingInfo serverId] : [mappingInfo tempServerId])];
                        if (errCode != SYNC_ERR_OK){
                            [self procABFailed:request ErrCode:errCode];
                            return;
                        }
                    }
                    //删除组名(已在服务端删除)
                    [self deleteGroup:[_syncUploadContactResponse deletedGroupIdList] request:request];
                    
                    //更新联系人ID和版本号
                    for (SyncMappingInfo *mappingInfo in [_syncUploadContactResponse contactMappingInfoList]){
                        
                        int32_t errCode = [[MemAddressBook getInstance] updContact:[mappingInfo serverId]
                                                                       WithVersion:[mappingInfo version]
                                                                        WithTempID:([mappingInfo tempServerId] == -1 ? [mappingInfo serverId] : [mappingInfo tempServerId])];
                        if (errCode != SYNC_ERR_OK){
                            [self procABFailed:request ErrCode:errCode];
                            return;
                        }
                    }
                    //删除联系人(已在服务端删除)
                    [self deleteContact:[_syncUploadContactResponse deletedContactIdList] request:request];
                    
                    // 在最后一片结束时处理入库
					if (totalBatch <= batchNo){
                        //更新名片版本号
//                        [[MemAddressBook getInstance] updMyCardVersion:[_syncUploadContactResponse businessCardVersion]];
                        
                        ZBLog(@"%@(batch): 已保存服务端通知的更新，还没有commit，因为后续需要下载. ", [arrayTaskString objectAtIndex:request.syncTaskType]);
                        
                        memset(&sse, 0, sizeof(sse));
                        
                        sse.taskType = request.syncTaskType;
                        
                        sse.status = Sync_State_Downloading;
                        
                        sse.iRecvTotalNum = [[_syncUploadContactResponse deletedGroupIdList] count] + [[_syncUploadContactResponse updatedGroupIdList] count] + [[_syncUploadContactResponse deletedContactIdList] count] + [[_syncUploadContactResponse updatedContactIdList] count];
                        
                        [self syncStatusRefresh:YES];
                        // 根据返回结果确定需要下载的联系人和组
                        // 仍使用原有的不分批次下载方式
                        ZBLog(@"%@(batch): need download %d contact, %d group", [arrayTaskString objectAtIndex:request.syncTaskType], [[_syncUploadContactResponse updatedContactIdList] count], [[_syncUploadContactResponse updatedGroupIdList] count]);
                        [self syncDownloadContact:[_syncUploadContactResponse updatedContactIdList]
                                      GroupIDList:[_syncUploadContactResponse updatedGroupIdList]
                                         TaskType:TASK_MERGE_SYNC];
                    }
                    break;
				default:
					break;
			}
		}
		else
		{
			ZBLog(@"batchUploadContact Failed.reason=%d", [error code]);
			[self procABFailed:request ErrCode:[error code]];

			return;
		}
	}
}

#pragma mark jumpToPortraitSync

// 客户端判断不需要做联系人各种同步，但是需要进行头像同步时，可由以下方法跳转
// 包括：双向同步、慢同步、同步上传、同步下载
/*
 * 头像同步
 */
- (void)jumpToPortraitSync:(SyncTaskType)syncTaskType
{
    if (![SettingInfo getIsSyncHeadimg])
    {
        memset(&sse, 0, sizeof(sse));
        
        sse.taskType = syncTaskType;
        
        sse.status = Sync_State_Faild; //存在
        
        [self syncStatusRefresh:YES];
        
        ZBLog(@"%@: jumpToPortraitSync Failed. [SettingInfo getIsSyncHeadimg] is not true.", [arrayTaskString objectAtIndex:syncTaskType]);
        return;
    }
    
    PortraitData *myPortraitData;
    
    int32_t myPortraitVersion;
    
    switch (syncTaskType)
    {
		case TASK_DIFFER_SYNC:// 双向同步
			// 状态信息显示：正在上传联系人头像
            memset(&sse, 0, sizeof(sse));
            
            sse.taskType = TASK_DIFFER_SYNC;
            
            sse.status = Sync_State_Portrait_Uploading;
            
            [self syncStatusRefresh:YES];
            
            // 通知MemAddressBook开始执行联系人头像同步
            [[MemAddressBook getInstance] startPortraitSyncTask:TASK_DIFFER_SYNC];
            
            myPortraitData = [[MemAddressBook getInstance] myPortrait];
            
            myPortraitVersion = [[MemAddressBook getInstance] myPortraitVersion];
            // 读取本地的联系人增量头像信息contactUpdList
            // 客户端更新或删除名片头像时，设置BusinessCardPortrait字段。否则，不设置。
            [self syncUploadPortrait:[[MemAddressBook getInstance] contactUpdList]
                BusinessCardPortrait:(myPortraitVersion > 0 ? nil : myPortraitData)
                            TaskType:TASK_DIFFER_SYNC];
			break;
        case TASK_SYNC_DOANLOAD:// 同步下载，下载完联系人和组信息，需要下载联系人头像
            // 状态信息显示：正在下载联系人头像
            memset(&sse, 0, sizeof(sse));
            
            sse.taskType = TASK_SYNC_DOANLOAD;
            
            sse.status = Sync_State_Portrait_Downloading;
            
            [self syncStatusRefresh:YES];
            
            // 通知MemAddressBook开始执行联系人头像同步
            [[MemAddressBook getInstance] startPortraitSyncTask:TASK_SYNC_DOANLOAD];
            
            // 名片版本设为0，表示本地没有名片头像
            [self syncPortraitSummary:[[MemAddressBook getInstance] getPortraitSummaryList]
                  BusinessCardVersion:[[MemAddressBook getInstance] myPortraitVersion]
                             TaskType:TASK_SYNC_DOANLOAD];
            break;
        case TASK_MERGE_SYNC:// 慢同步
			// 状态信息显示：正在上传联系人头像
            memset(&sse, 0, sizeof(sse));
            
            sse.taskType = TASK_MERGE_SYNC;
            
            sse.status = Sync_State_Portrait_Uploading;
            
            [self syncStatusRefresh:YES];
            
            // 通知MemAddressBook开始执行联系人头像同步
            [[MemAddressBook getInstance] startPortraitSyncTask:TASK_MERGE_SYNC];
            
            myPortraitData = [[MemAddressBook getInstance] myPortrait];
            // 读取本地的所有联系人头像信息contactAddList
            // 客户端更新或删除名片头像时，设置BusinessCardPortrait字段。否则，不设置。
            [self syncUploadPortrait:[[MemAddressBook getInstance] contactAddList]
                BusinessCardPortrait:myPortraitData
                            TaskType:TASK_MERGE_SYNC];
            break;
        case TASK_SYNC_UPLOAD:// 同步上传
            // 状态信息显示：正在上传联系人头像
            memset(&sse, 0, sizeof(sse));
            
            sse.taskType = TASK_SYNC_UPLOAD;
            
            sse.status = Sync_State_Portrait_Uploading;
            
            [self syncStatusRefresh:YES];
            
            // 通知MemAddressBook开始执行联系人头像同步
            [[MemAddressBook getInstance] startPortraitSyncTask:TASK_DIFFER_SYNC];
            
            myPortraitData = [[MemAddressBook getInstance] myPortrait];
            
            myPortraitVersion = [[MemAddressBook getInstance] myPortraitVersion];
            // 读取本地的联系人增量头像信息contactUpdList
            // 客户端更新或删除名片头像时，设置BusinessCardPortrait字段。否则，不设置。
            [self syncUploadPortrait:[[MemAddressBook getInstance] contactUpdList]
                BusinessCardPortrait:(myPortraitVersion > 0 ? nil : myPortraitData)
                            TaskType:TASK_SYNC_UPLOAD];
            break;
        default:
            break;
    }
    
}

#pragma mark 删除群组
/*
 * 删除群组
 */
- (void)deleteGroup:(NSArray *)deletedGroupIdList request:(ASIHTTPRequest *)request{
    for (id groupID in deletedGroupIdList){
        int32_t errCode = [[MemAddressBook getInstance] delGroup:[groupID intValue]];
        
        if (errCode != SYNC_ERR_OK){
//            [self procABFailed:request ErrCode:errCode];
//            return;
        }
    }
}

#pragma mark 删除联系人
/*
 * 删除联系人
 */
- (void)deleteContact:(NSArray *)deletedContactIdList request:(ASIHTTPRequest *)request{
    for (id contactID in deletedContactIdList){
        int32_t errCode = [[MemAddressBook getInstance] delContact:[contactID intValue]];
        
        if (errCode != SYNC_ERR_OK){
//            [self procABFailed:request ErrCode:errCode];
//            return;
        }
    }
}

#pragma mark 更新群组 MappingInfo
/*
 *更新群组 MappingInfo
 */
- (void)updateGroupMappingInfo:(NSArray *)groupMappingInfoList request:(ASIHTTPRequest *)request{
    for (SyncMappingInfo *mappingInfo in groupMappingInfoList){
        int32_t errCode = [[MemAddressBook getInstance] updGroup:[mappingInfo serverId]
                                                     WithVersion:[mappingInfo version]
                                                      WithTempID:[mappingInfo tempServerId]];
        if (errCode != SYNC_ERR_OK){
            [self procABFailed:request ErrCode:errCode];
            return;
        }
    }
}

#pragma mark 更新联系人 MappingInfo
/*
 *更新联系人 MappingInfo
 */
- (void)updateContactMappingInfo:(NSArray *)contactMappingInfoList request:(ASIHTTPRequest *)request{
    // 更新联系人ID和版本号
    for (SyncMappingInfo *mappingInfo in contactMappingInfoList){
        int32_t errCode = [[MemAddressBook getInstance] updContact:[mappingInfo serverId]
                                                       WithVersion:[mappingInfo version]
                                                        WithTempID:[mappingInfo tempServerId]];
        if (errCode != SYNC_ERR_OK){
            [self procABFailed:request ErrCode:errCode];
            return;
        }
    }
}

#pragma mark 
+ (void)setSyncStatusEvent{
    SyncTaskType taskType = sse.taskType;
    memset(&sse, 0, sizeof(sse)); //Added by Kevin on June,20 2013
    sse.taskType = taskType;
    sse.status = Sync_State_Faild; //存在
    sse.reason = SYNC_ERR_HANDLE_DATA;
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate syncStatusRefresh];
}

#if 0

#pragma mark // 全量上传联系人结束
/*
 *  全量上传联系人结束
 */
- (void)syncUploadAllContactFinished:(ASIHTTPRequest *)request
{
	NSData *responseData = [request responseData];
	
    UploadContactInfoResponse *_uploadContactInfoResponse;
    
    SyncUploadContactResponse *_syncUploadContactResponse;
	
    ZBLog(@"%@: syncUploadAllContactFinished. ", [arrayTaskString objectAtIndex:request.syncTaskType]);
	
	int32_t iSendNum = 0;
	
    switch (request.syncTaskType)
	{
		case TASK_ALL_UPLOAD:// 全量上传
			@try
        {
            _uploadContactInfoResponse = [UploadContactInfoResponse parseFromData:responseData];
        }
			@catch (NSException * e)
        {
            ZBLog(@"%@: syncUploadAllContactFinished. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
            [self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
            return;
        }
			@finally
        {
        }
			
			// 刷新状态信息
			memset(&sse, 0, sizeof(sse));
            
            sse.taskType = TASK_ALL_UPLOAD;
			
            sse.status = Sync_State_Uploading;
			
            sse.iSendTotalNum = [[_uploadContactInfoResponse contactMappingInfoList] count];// + [[_uploadContactInfoResponse groupMappingInfoList] count];
			
            //更新联系人总版本号
            [self saveContactListVersion:[_uploadContactInfoResponse contactListVersion]];
            
            //更新群组ID和版本号
            for (SyncMappingInfo *mappingInfo in [_uploadContactInfoResponse groupMappingInfoList]){
				int32_t errCode = [[MemAddressBook getInstance] updGroup:[mappingInfo serverId]
															 WithVersion:[mappingInfo version]
															  WithTempID:[mappingInfo tempServerId]];
				if (errCode != SYNC_ERR_OK){
					[self procABFailed:request ErrCode:errCode];
					return;
				}
                
				iSendNum++;
                
                if (iSendNum % 100 == 0){
					sse.iSendNum = iSendNum;
                    
                    [self syncStatusRefresh:YES];
				}
            }
            //更新联系人ID和版本号
            for (SyncMappingInfo *mappingInfo in [_uploadContactInfoResponse contactMappingInfoList]){
				int32_t errCode = [[MemAddressBook getInstance] updContact:[mappingInfo serverId]
															   WithVersion:[mappingInfo version]
																WithTempID:[mappingInfo tempServerId]];
				if (errCode != SYNC_ERR_OK){
					[self procABFailed:request ErrCode:errCode];
					return;
				}
                
				iSendNum++;
				
                if (iSendNum % 100 == 0){
					sse.iSendNum = iSendNum;
                    
                    [self syncStatusRefresh:YES];
				}
            }
            //更新名片版本号
            [[MemAddressBook getInstance] updMyCardVersion:[_uploadContactInfoResponse businessCardVersion]];
            
			[[MemAddressBook getInstance] commit];       // 提交修改
            
			sse.iSendNum = iSendNum;
			
            sse.status = Sync_State_Success;
			
            [self syncStatusRefresh:YES];
			
			ZBLog(@"%@: 结束. ", [arrayTaskString objectAtIndex:request.syncTaskType]);
            /////////////////////add code here///////////////////
            // 下面开始上传头像，需要从本地读取所有联系人头像信息mutablePortraitList，以及名片信息businessCardPortrait
            /////////////////////////////////////////////////////
            
            //[self syncUploadPortrait:];
			break;
		case TASK_MERGE_SYNC:{ // 慢同步
			@try
			{
				_syncUploadContactResponse = [SyncUploadContactResponse parseFromData:responseData];
			}
			@catch (NSException * e)
			{
				ZBLog(@"%@: syncUploadAllContactFinished 2. NSException:%@", [arrayTaskString objectAtIndex:request.syncTaskType], [e name]);
				[self procABFailed:request ErrCode:SYNC_STATE_RESPONSE_BAD_GATEWAY];
                
                return;
			}
			@finally
			{
			}
			
			ZBLog(@"%@ 服务端通知客户端: contactListVersion:%d, update group:%d, delete group:%d, download group:%d, update contact:%d, delete contact:%d, download contact:%d",
				   [arrayTaskString objectAtIndex:request.syncTaskType],
				   [_syncUploadContactResponse contactListVersion],
				   [[_syncUploadContactResponse groupMappingInfoList] count],
				   [[_syncUploadContactResponse deletedGroupIdList] count],
				   [[_syncUploadContactResponse updatedGroupIdList] count],
				   [[_syncUploadContactResponse contactMappingInfoList] count],
				   [[_syncUploadContactResponse deletedContactIdList] count],
				   [[_syncUploadContactResponse updatedContactIdList] count]);
			
            //更新联系人总版本号
            [self saveContactListVersion:[_syncUploadContactResponse contactListVersion]];
            // 更新群组ID和版本
            for (SyncMappingInfo *mappingInfo in [_syncUploadContactResponse groupMappingInfoList]){
				int32_t errCode = [[MemAddressBook getInstance] updGroup:[mappingInfo serverId]
															 WithVersion:[mappingInfo version]
															  WithTempID:([mappingInfo tempServerId] == -1 ? [mappingInfo serverId] : [mappingInfo tempServerId])];
				if (errCode != SYNC_ERR_OK){
					[self procABFailed:request ErrCode:errCode];
					return;
				}
            }
            
            //删除组名(已在服务端删除)///////////////////////////////////////////////////
            for (id groupID in [_syncUploadContactResponse deletedGroupIdList]){
				int32_t errCode = [[MemAddressBook getInstance] delGroup:[groupID intValue]];
                
				if (errCode != SYNC_ERR_OK){
					[self procABFailed:request ErrCode:errCode];
					return;
				}
            }
            //更新联系人ID和版本号 ///////////////////////////////////////////
            for (SyncMappingInfo *mappingInfo in [_syncUploadContactResponse contactMappingInfoList]){
                
				int32_t errCode = [[MemAddressBook getInstance] updContact:[mappingInfo serverId]
															   WithVersion:[mappingInfo version]
																WithTempID:([mappingInfo tempServerId] == -1 ? [mappingInfo serverId] : [mappingInfo tempServerId])];
				if (errCode != SYNC_ERR_OK){
					[self procABFailed:request ErrCode:errCode];
					return;
				}
            }
            
            //删除联系人(已在服务端删除) ////////////////////////////////////
            for (id contactID in [_syncUploadContactResponse deletedContactIdList]){
				int32_t errCode = [[MemAddressBook getInstance] delContact:[contactID intValue]];
                
				if (errCode != SYNC_ERR_OK){
					[self procABFailed:request ErrCode:errCode];
					return;
				}
            }
            //更新名片版本号
            [[MemAddressBook getInstance] updMyCardVersion:[_syncUploadContactResponse businessCardVersion]];
            
			ZBLog(@"%@: 更新客户端版本号结束. ", [arrayTaskString objectAtIndex:request.syncTaskType]);
			
            memset(&sse, 0, sizeof(sse));
            
            sse.taskType = request.syncTaskType;
            
            sse.status = Sync_State_Downloading;
            
            sse.iRecvTotalNum = [[_syncUploadContactResponse deletedGroupIdList] count] + [[_syncUploadContactResponse updatedGroupIdList] count] + [[_syncUploadContactResponse deletedContactIdList] count] + [[_syncUploadContactResponse updatedContactIdList] count];
            
            [self syncStatusRefresh:YES];
            
            ////////////////////////////////////////////////////////////////////////////
			//            根据返回结果确定需要下载的联系人和组
            ///////////////////////////////////////////////////////////////////////////
			ZBLog(@"%@: need download %d contact, %d group", [arrayTaskString objectAtIndex:request.syncTaskType], [[_syncUploadContactResponse updatedContactIdList] count], [[_syncUploadContactResponse updatedGroupIdList] count]);
			[self syncDownloadContact:[_syncUploadContactResponse updatedContactIdList]
						  GroupIDList:[_syncUploadContactResponse updatedGroupIdList]
							 TaskType:TASK_MERGE_SYNC];
            break;
        }
		default:
			break;
	}
}


#endif

@end











