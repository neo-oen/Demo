//
//  MemAddressBook.h
//  HBZS_IOS
//
//  Created by RenTao (tour_ren@163.com) on 4/21/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "SyncEngine.h"
#import "ContactProto.pb.h"
#import "ContactProto.pb.h"
#import "DownloadPortraitProto.pb.h"
#import "SyncUploadContactProto.pb.h"

//通讯录的快照
@interface MemRecord : NSObject{
    int32_t serverId;   //保存在服务器端的Unique ID。
    
    int32_t version;    //保存在服务器端的版本号。
    
	int32_t realABID;    //本地的AddressBook的纪录号。
    
	ABRecordRef record; //本地的AddressBook的纪录引用，临时变量，只在同一个同步动作Session中有效。
    
	NSDate* lastCheckCreateDate;    //本地的AddressBook的纪录的创建时间（when call create）。
    
	NSDate* lastCheckModifyDate;   //本地的AddressBook的纪录的修改时间（when call save）。

    NSString* groupName;            //本地的group name，用来做比对，因为group没有时间标签。
    
    int32_t portraitVersion;
    
    NSString* portraitMD5;
}

@property (assign) int32_t serverId;

@property (assign) int32_t version;

@property (assign) int32_t realABID;

@property (assign) ABRecordRef record;

@property (assign)int accessFlag;  //访问标记,为了得出删除增量

@property (retain) NSDate* lastCheckCreateDate;

@property (retain) NSDate* lastCheckModifyDate;

@property (nonatomic,retain) NSString* groupName;

@property (assign) int32_t portraitVersion;

@property (retain) NSString* portraitMD5;


- (BOOL)isGroup;

@end

// Person与Group的从属关系记录
@interface Person2Group : NSObject {
    ABRecordRef person;
    
    ABRecordRef group;
}

@property (assign) ABRecordRef person;

@property (assign) ABRecordRef group;

@end

//通讯录的管理类
@interface MemAddressBook : NSObject {
	NSMutableArray* arrayData;  // 快照列表，array of MemRecord*  存储快照,用于判断是否更新了

    NSMutableArray* oriArrayData;   // 原有的快照列表，同步事务开始后，备份原有的快照列表，以备rollback。
	
    ABAddressBookRef abRef;
    
    SyncTaskType curTask;
    
    // 临时的Contact和Group的从属关系。同步事务开始时创建，同步事务结束时销毁。
    NSMutableDictionary* contactBelongToGroupDict;  // 以Contact的serverId为Key，保存该Contact从属的组的serverId的列表。
    
    NSMutableArray* contactBelongToGroupArray;  // 保存PG新增关系，以便commit的时候保存该关系。
    
    NSMutableArray* contactRemoveFromGroupArray;// 保存PG移除关系，以便commit的时候保存该关系。

    // 临时的比较结果数组，由diffSnapshot生成。
    NSMutableArray* addContactArray;
    
    NSMutableArray* updContactArray;
    
    NSMutableArray* delContactArray;
    
    NSMutableArray* contactSummaryArray;

    NSMutableArray* addGroupArray;
    
    NSMutableArray* updGroupArray;
    
    NSMutableArray* delGroupArray;
    
    NSMutableArray* groupSummaryArray;

    NSMutableIndexSet* toBeUpdMemRecordIndexSet;          //本地快照需要被更新的索引号集合。
    
    NSMutableIndexSet* toBeDelMemRecordIndexSet;         //本地快照需要被删除的索引号集合。

    NSMutableDictionary* abRecordFullContentMD5Dict;  // 以ABRecord的ID为key，内容是当前Record的全量内容的MD5Contact的serverId为Key。
}

@property (nonatomic,retain) NSMutableArray *arrayData;

@property (nonatomic,retain) NSMutableArray* addContactArray;
@property (nonatomic,retain) NSMutableArray* updContactArray;
@property (nonatomic,retain) NSMutableArray* delContactArray;

@property (nonatomic,retain) NSMutableArray* addGroupArray;
@property (nonatomic,retain) NSMutableArray* updGroupArray;
@property (nonatomic,retain) NSMutableArray* delGroupArray;

@property (nonatomic,retain) NSMutableArray * topAbRecods;


/**
  * 取得MemAddressBook的对象实例。
 **/
+ (MemAddressBook*)getInstance;

/*
 * 初始化实例
 */
- (id)init;

#pragma mark - 同步事务结束时调用的方法
/*
 * 确认刚刚所作的所有更新，所有操作都完成后调用。
 */
- (void)commit;

/*
 * 回退刚刚所作的所有更新，操作出现异常时候调用，取消本次更新
 */
- (void)rollback;

/*
 * 没有执行任何更新操作的时候调用，以便清除一些临时变量
 */
- (void)unchanged;

/*
 * 用于检测变化数量
 */
- (NSInteger)getContactChangesCount;

#pragma mark - 同步事务开始时调用的方法
- (int32_t)startSyncTask:(SyncTaskType)task;

/*
 * 根据群组ServerId 删除群组MappingInfo
 */
- (void)removeGroupMappingInfo:(NSArray *)serverIds;
/*
 * 根据联系人serverId 删除联系人MappingInfo
 */
- (void)removeContactMappingInfo:(NSArray *)serverIds;

/*
 * 根据联系人Id从通讯录中删除联系人
 */
- (void)removeContactsFromDb:(NSArray *)recordIds;

/*
 * 根据groupId从通讯录中删除群组
 */
- (void)removeGroupsFromDb:(NSArray *)groupIds;

/*
 * 从通讯录中删除所有联系人
 */
- (void)removeAllContactFromDb;

/*
 * 从通讯录中删除所有群组
 */
- (void)removeAllGroupFromDb;

/*
 * 删除所有联系人MappingInfo
 */
- (void)removeAllContactMappingInfo;
/*
 * 删除所有群组MappingInfo
 */
- (void)removeAllGroupMappingInfo;

/*
 * 删除所有本地的通讯录，在全量下载的开始时候调用
 */
- (void)removeAllRecord;

/*根据id获取多个联系人  主要用于上传云分享*/
-(NSArray *)getContactsByContactIds:(NSArray *)contactIdArr;

/*
 * 获取本地全部的Contact／Group的详细信息集合。全量上次时候需要调用
 */
- (NSArray*)getAllUploadGroups;      //(array of Group*)

- (NSArray*)getAllUploadContacts;    //(array of Contact*)

- (int)getAddressDbChange; //全量下载时用

/*
 *  对比当前的AB与上次同步后状态，从而得到增删改的列表。
 *
 *  返回：0表示没有改变；1表示有变化；－1表示出错，需要慢同步；
 *
 *  如果从未执行过同步操作，例如新安装客户端，那需要返回-1，执行慢同步
 */
- (int)diffSnapshot;

#pragma mark - 同步事务进行中的增删改方法
/*
 * 添加／修改／删除 联系人的方法。先调用Group相关的更新操作方法，再调用Contact相关的更新操作方法。
 */
- (int32_t)addContact:(Contact*)c;

- (int32_t)updContact:(Contact*)theContact;

- (int32_t)delContact:(int32_t)contactID;

/*
 * 添加／修改／删除 分组的方法。先调用Group相关的更新操作方法，再调用Contact相关的更新操作方法
 */
- (int32_t)addGroup:(Group*)g;

- (int32_t)updGroup:(Group*)theGroup;

- (int32_t)delGroup:(int32_t)groupID;

#pragma mark - 同步事务进行中的获取本地通讯录的摘要列表信息方法
/*
 * 获取需要更新的（不包括新增和删除的）联系人/分组摘要列表。（array of SyncSummary）
 */
- (NSArray*)contactListSummary;

- (NSArray*)groupListSummary;

#pragma mark - 同步事务进行中的获取本地通讯录的详细信息列表方法
/*
 * 获取新增的联系人／分组的集合。（array of Contact/Group）
 */
- (NSArray*)contactAddList;

- (NSArray*)groupAddList;

/*
 * 获取修改的联系人／分组的集合。（array of Contact/Group）
 */
- (NSArray*)contactUpdList;

- (NSArray*)groupUpdList;

/*
 * 获取删除的联系人／分组的集合。（array of NSNumber=serverId）
 */
- (NSArray*)contactDelList;

- (NSArray*)groupDelList;

#pragma mark - 同步事务进行中的关于个人名片的方法
/*
 *  获取我的名片数据,如果没有名片，返回nil
 */
- (Contact*)myCard;

/*
 * 获取我的名片版本
 *
 * 名片版本的定义：-1表示已失效，0表示客户端修改了名片，>0表示名片从服务端下载后未修改
 */
- (int32_t)myCardVersion;

/*
 * 更新我的名片
 */
- (int32_t)updMyCard:(Contact*)varCard;

/*
 * 删除我的名片
 */
- (int32_t)delMyCard;

/*
 *  更新我的名片版本号
 *
 *  cardVersion>0：服务器端根据同步请求更新了名片数据和版本号，客户端只需要更新名片版本号。
 *
 *  cardVersion=0：服务器端没有用户名片数据。
 *  
 *  cardVersion=-1：服务器端要求客户端删除本地名片数据。
 */
- (int32_t)updMyCardVersion:(int32_t)cardVersion;

/*
 * 获取我的头像
 */
- (PortraitData*)myPortrait;

/*
 * 获取我的头像版本
 */
- (int32_t)myPortraitVersion;

/*
 *  更新我的头像
 */
- (int32_t)updMyPortrait:(PortraitData*)varPortrait;

/*
 *  删除我的头像
 */
- (int32_t)delMyPortrait;

/*
 * 更新我的名片版本号
 */
- (int32_t)updMyPortraitVersion:(int32_t)portraitVersion;

#pragma mark - 同步事务中更新ServerID和Version的方法，用来构建本地快照。
- (int32_t)_updRecord:(int32_t)serverId WithVersion:(int32_t)version WithTempID:(int32_t)tempID IsGroup:(BOOL)isGroup;

/*
 * 根据临时ID找到联系人，更新其正式ID和版本号
 */
- (int32_t)updContact:(int32_t)contactID WithVersion:(int32_t)version WithTempID:(int32_t)tempID;

/*
 * 根据临时ID找到组，更新其正式ID和版本号
 */
- (int32_t)updGroup:(int32_t)groupID WithVersion:(int32_t)version WithTempID:(int32_t)tempID;

#pragma mark - 同步事务中关于用户头像的方法。
- (int32_t)startPortraitSyncTask:(SyncTaskType)task;

- (void)commitPortraitTask;

- (void)rollbackPortraitTask;

- (void)unchangedPortraitTask;

/*
 * 对比当前的AB的头像与上次同步后的头像变化，从而得到变更的列表。
 *
 * 返回：0表示没有改变；1表示有变化；
 */
- (int32_t)diffPortrait;

- (int32_t)getAllPortraits;

- (int32_t)updPortrait:(int32_t)portraitID WithVersion:(int32_t)version;

- (int32_t)updPortrait:(DownloadPortraitData*)portrait;

- (int32_t)delPortrait:(int32_t)portraitID;

- (NSArray*)getPortraitSummaryList;


#pragma mark - PimPhbAdapter需要用到的内部方法
/*
 * 根据group serverId获取当前的AddressBook的group信息。
 */
- (ABRecordRef)getGroupBySID:(int32_t)groupSID;

- (MemRecord*)getMemRecordByABRecordID:(int32_t)abRecordID;

- (MemRecord*)getMemRecordByServerId:(int32_t)serverId IsGroup:(BOOL)isGroup;

- (int32_t)getMemRecordIndexByServerId:(int32_t)serverId IsGroup:(BOOL)isGroup;

/*
 * 比较快照记录和本地通讯录记录
 */
- (int)compareGroup:(ABRecordRef)group ToMemRecord:(MemRecord*)mRec;

- (int)compareContact:(ABRecordRef)contact ToMemRecord:(MemRecord*)mRec;

/*
 * 初始化diffSnapshot的临时生成的记录列表
 */
- (void)initTempResultList;

/*
 * 清除diffSnapshot的临时生成的记录列表
 */
- (void)clearTempResultList;

/*
 * 创建person和Group的关系列表，addContact的时候调用
 */
- (void)addPGRelationship:(Contact *)c abPerson:(ABRecordRef)person;

/*
 * 更新Person和Group的关系列表，updContact的时候调用。
 */
- (void)updPGRelationship:(Contact *)c abPerson:(ABRecordRef)person;

- (void)setupAddressBookRef;
/*
 *  创建全量的快照，以备iCloud等应用刷新了AB记录修改时间后做内容比对。
 */
- (void)buildFullSnapshot;

- (void)saveFullSnapshot;

- (void)loadFullSanpshot;



#pragma mark - 原来的方法，待修改。

- (void)saveToFile;

- (void)loadFromFile;

- (void)initArrayData;

@end


