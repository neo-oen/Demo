//
//  SyncEngineImpl.h
//  PIMIOS
//
//  Created by rentao on 05/25/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GobalSettings.h"
#import "HBZSAppDelegate.h"
#import "SyncErr.h"
#import "SyncEngineImpl.h"
#import "MemAddressBook.h"

SyncStatusEvent sse;

@implementation SyncEngineImpl

- (SyncStatusEvent*)getEvent {
	return &sse;
}

- (id)init {
	self = [super init];
	// init local Sync Status Event.
	sse.status = Sync_State_Initiating;
    
	sse.iSendNum = 0;
	
    sse.iRecvNum = 0;
	
    sse.iSendTotalNum = 0;
	
    sse.iRecvTotalNum = 0;
	
    sse.reason = SYNC_ERR_OK;
	
	if (_syncHttpProtoc == nil)
	{
        http://219.143.33.51:8001/uabconfig.uab
		// 测试平台
		//_syncHttpProtoc = [[syncHttpProtoc alloc] initWithURLString:@"http://219.143.33.51:8000/UabSyncService/uabconfig"];
		// 生产平台
		_syncHttpProtoc = [[syncHttpProtoc alloc] initWithURLString:@"http://sync.189.cn/UabSyncService/uabconfig.uab"];
        //不稳定的测试平台
       // _syncHttpProtoc = [[syncHttpProtoc alloc] initWithURLString:@"http://219.143.33.51:8001/uabconfig.uab"];
	}
    
	// start routine thread.
	syncThread = [[NSThread alloc] initWithTarget:self selector:@selector(syncEngineStart) object:nil];
    
	//vosLog(@"SyncEngineImpl: sync thread created.");
	[syncThread start];
	return self;
}

- (void)dealloc
{
	[_syncHttpProtoc release];
    [super dealloc];
}

-(void)syncTimeout {
	vosLog(@"SyncEngineImpl: syncTimeout called.");
//    [[MemAddressBook getInstance] test];
}

// sync engine thread routine method.
-(void)syncEngineStart {
	//vosLog(@"SyncEngineImpl: sync engine routine start.");
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	[NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(syncTimeout) userInfo:nil repeats:YES];
//    [self syncTimeout];
	while (TRUE) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		//vosLog(@"SyncEngineImpl: next step within runloop.");
	}
exit:
	[pool release];
	//vosLog(@"SyncEngineImpl: sync engine routine quit.");
}

- (void)notifyAction:(SEL)aSelector {
	[self performSelector:aSelector onThread:syncThread withObject:nil waitUntilDone:NO];
	//vosLog(@"SyncEngineImpl:  notifyAction.");
}

#pragma mark ///// startSyncAction (双向同步) //////
- (void)startSyncAction
{
	//vosLog(@"SyncEngineImpl: startSyncAction.");
    if (_syncHttpProtoc != nil) {
        [_syncHttpProtoc startTaskRequest:TASK_DIFFER_SYNC];
    }
}

#pragma mark ////////  startAuthen (认证) ////////
- (void)startAuthen//认证
{
    if (_syncHttpProtoc != nil) {
        [_syncHttpProtoc startTaskRequest:TASK_AUTHEN];
    }
}

#pragma mark /////// startAllUploadAction（全量上传）  ///////
- (void)startAllUploadAction//全量上传
{
    if (_syncHttpProtoc != nil) {
        [_syncHttpProtoc startTaskRequest:TASK_ALL_UPLOAD];
    }
}

#pragma mark /// startAllDownloadAction (全量下载) ///////
- (void)startAllDownloadAction//全量下载
{
    if (_syncHttpProtoc != nil) {
        [_syncHttpProtoc startTaskRequest:TASK_ALL_DOWNLOAD];
    }
}

#pragma mark //// startSyncUploadAction(增量上传) //////
- (void)startSyncUploadAction//同步上传
{
    if (_syncHttpProtoc != nil) {
        [_syncHttpProtoc startTaskRequest:TASK_SYNC_UPLOAD];
    }
}

#pragma mark ///// startSyncDownloadAction(增量下载)  ///////
- (void)startSyncDownloadAction//同步下载
{
    if (_syncHttpProtoc != nil) {
        [_syncHttpProtoc startTaskRequest:TASK_SYNC_DOANLOAD];
    }
}

#pragma mark ////// startSlowSyncAction(慢同步)  //////
- (void)startSlowSyncAction//慢同步
{
    if (_syncHttpProtoc != nil) {
        [_syncHttpProtoc startTaskRequest:TASK_MERGE_SYNC];
    }
}

- (void)cancelAction//取消任务
{
	if (_syncHttpProtoc != nil) {
        [_syncHttpProtoc cancelCurrentTask];
    }
}


#pragma mark 设备签到
- (void)deviceSign//设备签到
{
    if (_syncHttpProtoc != nil) {
        [_syncHttpProtoc startTaskRequest:TASK_DEVICE_SIGN];
    }
}

@end