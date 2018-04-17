//
//  SyncEngine.m
//  PIMIOS
//
//  Created by rentao on 05/25/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "HBZSAppDelegate.h"
#import "GobalSettings.h"
#import "SyncErr.h"
#import "SyncEngine.h"
#import "SyncEngineImpl.h"

static SyncEngineImpl* _impl=nil;

#pragma mark 初始化同步引擎
void InitSyncEngine()
{
	// start routine thread.
	if (_impl == nil) {
		_impl = [[[SyncEngineImpl alloc] init] autorelease];
		//ZBLog(@"InitSyncEngine done.");
	}
}


#pragma mark added on 25,6

void reAuth(){
    [_impl reAuth];
}

#pragma mark // 开始同步操作
void StartSync(SyncTaskType _syncTaskType)
{
    if (_syncTaskType == TASK_USERCLOUDSUMMARY) {
        [_impl notifyAction:@selector(userCloudSummary)];
        return;
    }
    
    switch (_syncTaskType)
    {
        case TASK_AUTHEN://认证
            [_impl notifyAction:@selector(startAuthen)];
            break;
        case TASK_ALL_UPLOAD://全量上传
            [_impl notifyAction:@selector(startAllUploadAction)];
            break;
        case TASK_ALL_DOWNLOAD://全量下载
            [_impl notifyAction:@selector(startAllDownloadAction)];
            break;
        case TASK_SYNC_UPLOAD://同步上传
            [_impl notifyAction:@selector(startSyncUploadAction)];
            break;
        case TASK_SYNC_DOANLOAD://同步下载（增量下载）
            [_impl notifyAction:@selector(startSyncDownloadAction)];
            break;
        case TASK_DIFFER_SYNC://同步（双向同步）
            [_impl notifyAction:@selector(startSyncAction)];
            break;
        case TASK_MERGE_SYNC://慢同步（合并同步）
            [_impl notifyAction:@selector(startSlowSyncAction)];
            break;
        case TASK_DEVICE_SIGN:
            [_impl notifyAction:@selector(deviceSign)];
            break;
        default:
            break;
    }
}

/*
// 暂停当前操作
void Pause()
{
	[_impl notifyAction:@selector( pauseAction )];
}

// 恢复当前操作
void Resume()
{
	[_impl notifyAction:@selector( resumeAction )];
}
*/

// 取消当前操作
void CancelSyncTask()
{
	[_impl notifyAction:@selector(cancelAction)];
}

// 获取当前状态信息
SyncStatusEvent* GetSyncStatus()
{
	return [_impl getEvent];
}


