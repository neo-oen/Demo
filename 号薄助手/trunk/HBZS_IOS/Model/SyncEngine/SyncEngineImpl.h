//
//  SyncEngineImpl.m
//  PIMIOS
//
//  Created by rentao on 05/25/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncEngine.h"
#import "SyncEngineImpl.h"
#import "syncHttpProtoc.h"

@interface SyncEngineImpl : NSObject{
	NSThread* syncThread;
 
    syncHttpProtoc *_syncHttpProtoc;
}

//@public
- (id)init;

- (void)notifyAction:(SEL)aSelector;

- (SyncStatusEvent*)getEvent;

//@private
- (void)syncEngineStart;

- (void)syncTimeout;

- (void)startSyncAction;               //同步

- (void)startAuthen;

- (void)startAllUploadAction;          //全量上传

- (void)startAllDownloadAction;       //全量下载

- (void)startSyncUploadAction;       //同步上传

- (void)startSyncDownloadAction;    //同步下载

- (void)startSlowSyncAction;       //慢同步

- (void)cancelAction;             //取消任务

- (void)deviceSign;              //设备签到

@end
