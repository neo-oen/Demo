//
//  SyncEngine.h
//  PIMIOS
//
//  Created by rentao on 05/25/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#define Ret_t short
#define INT8 char
#define INT32 long int
#define UINT32 unsigned long int

#define BATCH_DOWNLOAD_LIMIT    500
#define BATCH_UPLOAD_LIMIT      500

//任务类型
typedef enum _SyncTaskType
{
    TASK_ALL_UPLOAD = 1,        //全量上传
    TASK_ALL_DOWNLOAD = 2,      //全量下载
    TASK_SYNC_UPLOAD = 3,       //同步上传
    TASK_SYNC_DOANLOAD = 4,     //同步下载（增量下载）
    TASK_DIFFER_SYNC = 5,       //同步（双向同步）
	TASK_MERGE_SYNC = 6,		//慢同步（合并同步）
    TASK_AUTHEN = 7,            //认证
    TASK_DEVICE_SIGN = 8,        //设备签到
    TASK_USERCLOUDSUMMARY = 9     //用户云端查询
}SyncTaskType;

// 同步操作类型
typedef enum
{
	Sync_State_Initiating,	// 初始化中
	Sync_State_Connecting,	// 连接服务器中
	Sync_State_Uploading,	// 上传中（在上传和同步操作中都会出现）
	Sync_State_Downloading,	// 下载中（在下载和同步操作中都会出现）
	Sync_State_Portrait_Uploading,		// 头像上传中（在上传和同步操作中都会出现）
	Sync_State_Portrait_Downloading,	// 头像下载中（在下载和同步操作中都会出现）
	Sync_State_Terminating,	// 当前操作取消中
	Sync_State_Success,		// 操作完成
	Sync_State_Faild		// 操作失败
}SyncState_t;

// 同步状态详细信息
typedef struct _SyncStatusEvent
{
    SyncTaskType taskType;      // 任务类型
	SyncState_t status;			// 当前操作类型
	INT32 iSendNum;				// 当前已经上传的记录条数
	INT32 iRecvNum;		     	// 当前已经下载的记录条数
	INT32 iSendTotalNum;	 	// 当前需要上传的总记录条数
	INT32 iRecvTotalNum;		// 当前需要下载的总记录条数
	Ret_t reason;	       		// 操作失败的原因代号，在SyncErr.h中定义。SYNC_ERR_OK / SYNC_ERR_UNKNOWN / GENERAL_ERR_*
} *SyncStatusEventPtr, SyncStatusEvent;

/*
 * 初始化同步引擎
 */
extern void InitSyncEngine();

/*
 * 开始同步操作
 */
extern void StartSync(SyncTaskType _syncTaskType);
/*
 * 取消当前操作
 */
extern void CancelSyncTask();
/*
 *  获取当前状态信息
 */
extern SyncStatusEvent* GetSyncStatus();

/*
// 暂停当前操作
extern void Pause();
// 恢复当前操作
extern void Resume();
*/

#define PIM_MAX_LEN_ADDRESS		(256 + 1)
#define PIM_MAX_LEN_PORT			(8 + 1)
#define PIM_MAX_LEN_USERNAME		(32 + 1)
#define PIM_MAX_LEN_PASSWORD		(32 + 1)
#define PIM_MAX_LEN_DBNAME		(32 + 1)
#define PIM_MAX_LEN_PROXYIP		(15 + 1)


typedef enum
{
	CONNECT_TYPE_PROXY,        	//”–¥˙¿Ì£¨»Ácmwap,uniwap,tdwap,ctwap,3gwap
	CONNECT_TYPE_NON_PROXY   	//√ª”–¥˙¿Ì£¨»Ácmnet,uninet,tdnet,ctnet,3gnet
}ConnectType_t;

typedef enum
{
	PROTOCOL_UNDEFINED=0,
	PROTOCOL_HTTP,								//"http"
	PROTOCOL_OBEX,
	PROTOCOL_WSP								//"wsp"
}Protocol_t;


typedef enum
{
	TASK_CLIENT_2WAY_SYNC = 0,		//syn"sync",À´œÚøÏÕ¨≤Ω
	TASK_CLIENT_2WAY_SLOW_SYNC,		//"slow sync",À´œÚ¬˝Õ¨≤Ω
	TASK_CLIENT_1WAY_SYNC,	   		// "publish",µ•œÚøÏÕ¨≤Ω(÷’∂À)
	TASK_REFLASH_SYNC_FROM_CLIENT,	//backup"upload",µ•œÚ¬˝Õ¨≤Ω(÷’∂À)
	TASK_SERVER_1WAY_SYNC,	   		// ignore,µ•œÚøÏÕ¨≤Ω(∑˛ŒÒ∆˜)
	TASK_REFLASH_SYNC_FROM_SERVER,	//recover"download",µ•œÚ¬˝Õ¨≤Ω(∑˛ŒÒ∆˜)
	TASK_SERVER_ALERTED_SYNC   		// Ignore,∑˛ŒÒ∆˜Õ®÷™Õ¨≤Ω
}SyncTask_t;

typedef struct UI_USERSETTING_S
{	
	INT8 szServer[PIM_MAX_LEN_ADDRESS];		//Õ¨≤Ω∑˛ŒÒ∆˜µÿ÷∑
	INT8 szPort[PIM_MAX_LEN_PORT];				//Õ¨≤Ω∑˛ŒÒ∆˜∂Àø⁄
	INT8 szUserName[PIM_MAX_LEN_USERNAME];  //”√ªß√˚
	INT8 szPassword[PIM_MAX_LEN_PASSWORD];  //√‹¬Î
	INT8 szContact[PIM_MAX_LEN_DBNAME];		//∆’Õ®Õ®–≈¬º
	BOOL bContactSync;							//∫∫«∞Õ¨≤Ω «∑ÒŒ™±‰Õ®Õ®–≈¬º
	SyncTask_t SyncType;							//Õ¨≤Ω¿‡–Õ
	Protocol_t Protocol;						//1
	ConnectType_t connecttype;						//¡¨Ω”¿‡–Õ
	INT8 proxy_ip[PIM_MAX_LEN_PROXYIP];		//10.0.0.172»Áπ˚¡¨Ω”¿‡–ÕŒ™¥˙¿Ì∑Ω Ω,‘Ú–Ë¥˙¿ÌIP£¨»Á10.0.0.172,10.0.0.200
	INT8 proxy_port[PIM_MAX_LEN_PORT];			//80»Áπ˚¡¨Ω”¿‡–ÕŒ™¥˙¿Ì∑Ω Ω,‘Ú–Ë¥˙¿Ì∂Àø⁄,»Á80
}UiUserSettings_t,*UiUserSettingsPtr_t;


typedef struct PIMEvent_tag
{
	SyncState_t status;  				//sync status
//	PIM_PROCESS_STATUS proStatus;
	INT32 iSendNum;		     			//current sent records number
	INT32 iRecvNum;		     			//current received records number
	INT32 iSendTotalNum;	 		//current sync sent total records number
	INT32 iRecvTotalNum;	 		//current sync received total records number
	INT32 iConflictNum;	   			//current sync occur conflict number
	INT32 iErrorNum;		   			//current sync process occur error records number
	INT32 iCurTotalNum;		 		//current contacts(phonebook)'s records number
	Ret_t reason;	       			//sync fail's reason,the reason's value was defined smlerr.h file,if reason's value is not SYNC_ERR_OK,status must be Sync_State_Faild
	INT32 iServerUpdateNum;			//reserve
	INT32 iServerAddNum;			//reserve
	INT32 iServerDelNum;			//reserve
	INT32 iClientUpdateNum;			//reserve
	INT32 iClientAddNum;				//reserve
	INT32 iClientDelNum;				//reserve
}PIMEvent;

typedef struct sync_log_list_s 
{
	PIMEvent event;
  INT8 sTime[20]; //YYYY-MM-DD HH-MM-SS
  INT8 eTime[20]; //YYYY-MM-DD HH-MM-SS
  SyncTask_t SyncType;
  
	struct sync_log_list_s *next;
} *SyncLogListPtr_t,SyncLogList_t;
