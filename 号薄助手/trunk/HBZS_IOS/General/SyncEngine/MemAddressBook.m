//
//  MemAddressBook.m
//  HBZS_IOS
//
//  Created by RenTao (tour_ren@163.com) on 5/25/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MemAddressBook.h"
#import "GobalSettings.h"
#import "PimPhbAdapter.h"
#import "SyncErr.h"
#import "SyncUploadContactProto.pb.h"
#import "UploadPortraitProto.pb.h"
#import "Public.h"
#import "HBZSAppDelegate.h"
#import "syncHttpProtoc.h"
#import "HB_ContactSendTopTool.h"

#define MR_BASE_INDEX	0x1000000

// tempId=TEMPID_BASE - (Id in Array<MemRecord>)
#define TEMPID_BASE     -100
#define RECORD_ACCESSED (ABRecordRef)1

//MemRecord
@implementation MemRecord

@synthesize serverId;

@synthesize version;

@synthesize realABID;

@synthesize record;

@synthesize accessFlag;  // 0 未访问过， 1访问过

@synthesize lastCheckCreateDate;;

@synthesize lastCheckModifyDate;

@synthesize groupName;

@synthesize portraitVersion;

@synthesize portraitMD5;

- (void)dealloc{
    if (groupName) {
        [groupName release];
        
        groupName = nil;
    }
    
    if (portraitMD5) {
        [portraitMD5 release];
        
        portraitMD5 = nil;
    }
    
    if (lastCheckCreateDate) {
        [lastCheckCreateDate release];
        
        lastCheckCreateDate = nil;
    }
    
    if (lastCheckModifyDate) {
        [lastCheckModifyDate release];
        
        lastCheckModifyDate = nil;
    }
    
    [super dealloc];
}

- (BOOL)isGroup
{
    return (groupName!=nil);
}

@end

//Person2Group
@implementation Person2Group

@synthesize person;

@synthesize group;

@end

//MemAddressBook
@implementation MemAddressBook

@synthesize arrayData;

@synthesize addContactArray;

@synthesize updContactArray;

@synthesize delContactArray;

@synthesize addGroupArray;

@synthesize updGroupArray;

@synthesize delGroupArray;

static MemAddressBook* theMAB;

- (void)dealloc{
    if (arrayData) {
        [arrayData release];
        
        arrayData = nil;
    }
    
    [super dealloc];
}

+ (MemAddressBook*)getInstance
{
	return theMAB;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    
    if(!initialized)
    {
        initialized = YES;
        
        theMAB = [[MemAddressBook alloc] init];
        
		ZBLog(@"MemAddressBook instance=%@", theMAB);
    }
}

- (id)init {
  self = [super init];
    
    if (self) {
        [self initArrayData];      //读取存储的MappingInfo
        
        [self loadFullSanpshot];   //从沙盒路径 读取 abRecordFullContentMD5Dict
        
        self.topAbRecods =  [NSMutableArray arrayWithCapacity:0];
    }
   
    return self;
}

#pragma mark - 同步事务结束时调用的方法
/*
 * commit
 */
- (void)commit
{
    NSLog(@"MemAB::commit");
    CFErrorRef error = nil;

    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    abRef = delegate.getAddressBookRef;
    
    ABAddressBookSave(abRef, &error);    //保存修改过的通讯录
    NSLog(@"addressbooksave..");
    
    //置顶联系人处理
    
    for (int i= 0; i<self.topAbRecods.count; i++) {
        ABRecordRef person = self.topAbRecods[i];
        
        NSInteger cid = ABRecordGetRecordID(person);
        
        [HB_ContactSendTopTool contactSendTopWithRecordID:cid];
    }
    [self.topAbRecods removeAllObjects];
    
    
    // 保存person和group的从属关系。
    abRef = delegate.getAddressBookRef;
    NSArray *allGroup = (NSArray *)ABAddressBookCopyArrayOfAllGroups(abRef);
    
    if (allGroup.count != 0) {
        for (Person2Group *pg in contactBelongToGroupArray){
            if (pg.group && pg.person){
                @try {
                
                    ABGroupAddMember(pg.group, pg.person, &error);//联系人添加到相应的群组
                   // NSLog(@"error: %@", error);
                }
                @catch (NSException *exception) {
                    ZBLog(@"ABGroupAddMember Failed. NSException:%@", [exception name]);
                    // break;
                }
                @finally {
                    
                }
            }
        }
        
        for (Person2Group* pg in contactRemoveFromGroupArray) {
            if (pg.group && pg.person) {
                @try {
                    ABGroupRemoveMember(pg.group, pg.person, &error);       //从群组中删除相应的person
                }
                @catch (NSException *exception) {
                    //[syncHttpProtoc setSyncStatusEvent];
                    break;
                }
                @finally {
                    
                }
            }
        }
    }
    
    if (nil != contactRemoveFromGroupArray || nil != contactBelongToGroupArray){
        ABAddressBookSave(abRef, &error);
    }
    
    // /////////////////////////////////////////////////////
           //    删除临时Person和Group的关系表。    //
    ////////////////////////////////////////////////////////
    if (contactBelongToGroupArray){
        [contactBelongToGroupArray release];
        contactBelongToGroupArray = nil;
    }
    
    if (contactRemoveFromGroupArray) {
        [contactRemoveFromGroupArray release];
        contactRemoveFromGroupArray = nil;
    }
    
    if (contactBelongToGroupDict) {
        [contactBelongToGroupDict release];
        contactBelongToGroupDict = nil;
    }
    
   ////// // /////////////////////////////////////////////////////////////////////////
    //     通讯录保存后，更新快照列表，因为ID和时间标签都会变化    //
   // /////////////////////////////////////////////////////////////////////////////////

    ABRecordRef abRec = NULL;
    
    int32_t index=-1;
    
    for (MemRecord* mRec in arrayData){
        index ++;
        
        if (curTask == TASK_SYNC_DOANLOAD) // 增量下载的时候，只会对更新的记录进行commit。
        {
            if ([toBeUpdMemRecordIndexSet containsIndex:index]){
                continue;
            }
        }
        
        if (mRec.record != NULL) {
            abRec = mRec.record;
        }
        else{
            abRec = ABAddressBookGetGroupWithRecordID(abRef, mRec.realABID);
            
            if (abRec == NULL) abRec = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);
       }
        
        if (abRec != NULL){
            ABRecordType type = ABRecordGetRecordType(abRec);
            
            if (type == kABGroupType){
                NSString *groupname = (NSString*)ABRecordCopyValue(abRec, kABGroupNameProperty);
                
                mRec.groupName = groupname;  // Group保持组名，以便下次比对。
                
                [groupname release];
            }
            else if (type == kABPersonType){
                // Contact保存时间标签，以便下次比对。
                NSDate *lastCreateDate = (NSDate*)ABRecordCopyValue(abRec, kABPersonCreationDateProperty);
                
                mRec.lastCheckCreateDate = lastCreateDate;
                
                [lastCreateDate release];
                
                NSDate *lastModifyDate = (NSDate*)ABRecordCopyValue(abRec,kABPersonModificationDateProperty);
            
                mRec.lastCheckModifyDate = lastModifyDate;
                
                [lastModifyDate release];
            }
            
            if (mRec.realABID <= 0){
                mRec.realABID = ABRecordGetRecordID(abRec);  //ABRecordId
                
                
            }
            
            mRec.record = NULL;
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
        //      删除之前分析出来的本地快照记录。        //
    ///////////////////////////////////////////////////////////////////////
	if ([toBeDelMemRecordIndexSet count] > 0){
		[arrayData removeObjectsAtIndexes:toBeDelMemRecordIndexSet];
	}
    
    [self clearTempResultList];
    
    [self saveToFile];      //MappingInfo 存储到沙盒路径
    
    if (oriArrayData){     // 删除备份的快照列表。
        [oriArrayData release];
        
        oriArrayData = nil;
    }

    curTask = TASK_AUTHEN;       // 复位任务状态

    [self buildFullSnapshot];       // 创建全量快照。
}

#pragma mark //////// rollback   //////////
/*
 * 回退刚刚所作的所有更新，操作出现异常时候调用，取消本次更新
 */
- (void)rollback
{
    ZBLog(@"MemAB::rollback");
    ABAddressBookRevert(abRef);
    
    [self clearTempResultList];
    
    if (contactBelongToGroupArray){ // 删除临时Person和Group的关系表。
        [contactBelongToGroupArray release];
        
        contactBelongToGroupArray = nil;
    }
    
    if (contactRemoveFromGroupArray){
        [contactRemoveFromGroupArray release];
        
        contactRemoveFromGroupArray = nil;
    }
    
    if (contactBelongToGroupDict){
        [contactBelongToGroupDict release];
        
        contactBelongToGroupDict = nil;
    }
    
    if (arrayData){
        [arrayData release];
    }
    
    arrayData = oriArrayData;   // 恢复备份的快照列表。
    
    oriArrayData = nil;
    // 复位任务状态
    curTask = TASK_AUTHEN;
}

#pragma mark unchanged
- (void)unchanged
{
    ZBLog(@"MemAB::unchanged");
    [self clearTempResultList];
    
    // 删除临时Person和Group的关系表。
    if (contactBelongToGroupArray){
        [contactBelongToGroupArray release];
        
        contactBelongToGroupArray = nil;
    }
    
    if (contactRemoveFromGroupArray){
        [contactRemoveFromGroupArray release];
        
        contactRemoveFromGroupArray = nil;
    }
    
    if (contactBelongToGroupDict){
        [contactBelongToGroupDict release];
        
        contactBelongToGroupDict = nil;
    }
    
    if (oriArrayData){ // 清除备份的快照列表。
        [oriArrayData release];
        
        oriArrayData = nil;
    }
    
    curTask = TASK_AUTHEN;     // 复位任务状态
}


#pragma mark - 同步事务开始时调用的方法
- (int32_t)startSyncTask:(SyncTaskType)task
{
    curTask=task;
    switch (task) {
        case TASK_ALL_UPLOAD://全量上传
            break;
        case TASK_ALL_DOWNLOAD://全量下载
            break;
        case TASK_SYNC_UPLOAD://同步上传（增量上传）
            break;
        case TASK_SYNC_DOANLOAD://同步下载（增量下载）
            break;
        case TASK_DIFFER_SYNC://同步（双向同步）
            break;
        case TASK_MERGE_SYNC://慢同步（合并同步）
            break;
            
        default:
            return -1;
    }
    
    return 0;
}

#pragma mark 删除联系人MappingInfo
/*
 * 根据联系人ServerId 删除联系人MappingInfo
 */
- (void)removeContactMappingInfo:(NSArray *)serverIds{
    for (NSNumber *num in serverIds) {
        MemRecord *mRec = [self getMemRecordByServerId:(ABRecordID)[num intValue] IsGroup:NO];
        
        if (mRec) {
            [arrayData removeObject:mRec];
        }
    }
}

#pragma mark  删除群组MappingInfo
/*
 * 根据群组  serverId 删除群组MappingInfo
 */
- (void)removeGroupMappingInfo:(NSArray *)serverIds{
    for (NSNumber * num in serverIds) {//ABRecordID
        MemRecord *mRec = [self getMemRecordByServerId:(ABRecordID)[num intValue] IsGroup:YES];
    
        if (mRec) {
            [arrayData removeObject:mRec];
        }
    }
}

#pragma mark 根据联系人id 从通讯录中删除联系人
/*
 * 根据联系人id 从通讯录中删除联系人
 */
- (void)removeContactsFromDb:(NSArray *)recordIds{
    PimPhb_DeleteContact(abRef, recordIds);
    [HB_ContactSendTopTool clearTopidsWithArr:recordIds];
}

#pragma mark 根据groupId 从通讯录 删除群组
/*
 * 根据groupId 从通讯录 删除群组
 */
- (void)removeGroupsFromDb:(NSArray *)groupIds{
    PimPhb_DeleteGroup(abRef, groupIds);
}

#pragma mark 从通讯录中删除所有联系人
/*
 * 从通讯录中删除所有联系人
 */
- (void)removeAllContactFromDb{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    abRef = delegate.getAddressBookRef;
    PimPhb_DeleteAllContact(abRef);
    [HB_ContactSendTopTool clearAllTopid];
}

#pragma mark 从通讯录中删除所有群组
/*
 * 从通讯录中删除所有群组
 */
- (void)removeAllGroupFromDb{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    abRef = delegate.getAddressBookRef;
    PimPhb_DeleteAllGroup(abRef);
}

#pragma mark 删除所有群组MappingInfo
/*
 * 删除所有群组MappingInfo
 */
- (void)removeAllGroupMappingInfo{
    if (arrayData != nil && [arrayData count] != 0)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for (MemRecord *m in arrayData) {
            if (m.groupName != nil && m.groupName.length > 0) {
                [temp addObject:m];
            }
        }
        
        for (MemRecord *m in temp) {
            [arrayData removeObject:m];
        }
    }
}

#pragma mark 删除所有联系人MappingInfo
/*
 * 删除所有联系人MappingInfo
 */
- (void)removeAllContactMappingInfo{
    if (arrayData != nil && [arrayData count] != 0)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for (MemRecord *m in arrayData) {
            if (m.groupName == nil && m.groupName.length < 1) {
                [temp addObject:m];
            }
        }
        
        for (MemRecord *m in temp) {
            [arrayData removeObject:m];
        }
    }
}


///Added on Nov.14 2013


///end

#pragma mark //全量下载的开始方法。
/*
 *  删除所有联系人、群组以及MappingInfo
 */
- (void)removeAllRecord
{
    if (oriArrayData != nil){   // 备份之前的快照，并创建空白的快照。
        [oriArrayData release];
    }
    
    oriArrayData = arrayData;
    
    arrayData = [[NSMutableArray alloc] init];
    
    [self initTempResultList];         // 初始化临时变量
    
   // [self setupAddressBookRef];
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    abRef = delegate.getAddressBookRef;
    
    PimPhb_DeleteAllGroup(abRef);      // 清除所有的AddressBook记录。
    
    PimPhb_DeleteAllContact(abRef);
    [HB_ContactSendTopTool clearAllTopid];
}

#pragma mark //全量上传的开始方法
// 获取本地全部的Contact／Group的详细信息集合。
// 先调用Group相关的获取方法，再调用Contact相关的获取方法。
// 都采用本地的AB记录号作为serverID，保存到Contact和Group中。

#pragma mark /////// getAllUploadGroups  ////////
/*
 *  创建所有群组MappingInfo以及GroupBuilder
 */
- (NSArray*)getAllUploadGroups
{
    MemRecord* mRec;
    
    if (oriArrayData != nil){
        [oriArrayData release];
    }
    
    oriArrayData = arrayData;    // 备份之前的快照，并创建空白的快照。
    
    arrayData = [[NSMutableArray alloc] init];
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
   // [self setupAddressBookRef]; // 重新获取AddressBook，否则有些修改无法得到。
    abRef = delegate.getAddressBookRef;
    [self initTempResultList];  // 初始化临时变量
    
    NSMutableArray* retGroups;
    
    ABRecordID gID;
    
    Group_Builder* gb;
    
    CFIndex i, count=0;
    
    CFArrayRef all = ABAddressBookCopyArrayOfAllGroups(abRef);     //allGroups
    
    if (all) {
        count = CFArrayGetCount(all);
    }
    
    
    retGroups = [NSMutableArray arrayWithCapacity:count];
    
    contactBelongToGroupDict = [[NSMutableDictionary alloc] init];
    
    for(i = 0; i < count; i++ )
    {
        ABRecordRef group = CFArrayGetValueAtIndex(all, i);
        
        gID = ABRecordGetRecordID(group);
        // 生成快照记录
        mRec = [[MemRecord alloc] init];
        
        mRec.serverId = -1;
        
        mRec.version = -1;
        
        mRec.realABID = gID;
        
        mRec.record = group;
        
        NSString *groupname = (NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
        
        mRec.groupName = groupname;
        
        [groupname release];
        
        [arrayData addObject:mRec];
        // 创建Group
        gb = [Group builder];
        
        [[gb setServerId:TEMPID_BASE-[arrayData count]] setVersion:(-1)];
        //必须先设置serverId才能调用PimPhb_ABRecord2Group
        //contat2groupDict  联系人和所属群组的关系
        PimPhb_ABRecord2Group(group, gb, contactBelongToGroupDict, nil);//(序列化group、联系人属于哪个群组)
        
        [retGroups addObject:[gb build]];
        
        gb = nil;
        
        [mRec release];
    }
    if (all) {
        CFRelease(all);
        
        all = nil;
    }
    
    
    return retGroups;
}

#pragma mark getAllUploadContacts /////////////////
/*
 * 创建所有联系人MappingInfo、 Contact Builder
 */
- (NSArray*)getAllUploadContacts         
{
    MemRecord* mRec;
    
    ABRecordID cID;
    
    NSMutableArray* retContacts;
    
    Contact_Builder* cb;
    
    CFIndex i, count=0;
    
    CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(abRef); //所有联系人
    if (all) {
        count = CFArrayGetCount(all);
    }
    
    
    retContacts = [NSMutableArray arrayWithCapacity:count];
    
    for(i = 0; i < count; i++ )
    {
        ABRecordRef person = CFArrayGetValueAtIndex(all, i);
        
        cID = ABRecordGetRecordID(person);
        // 生成快照记录
        mRec = [[MemRecord alloc] init];
        
        mRec.serverId = -1;
        
        mRec.version = -1;
        
        mRec.realABID = cID;
        
        mRec.record = person;
        
        mRec.groupName = nil;
        
        [arrayData addObject:mRec];
        // 创建Contact
        cb = [Contact builder];
        
        [[cb setServerId:TEMPID_BASE-[arrayData count]] setVersion:(-1)];
        //contactBelongToGroupDict 联系人所属群组关系
        PimPhb_ABRecord2Contact(person, cb, contactBelongToGroupDict);
        
        [retContacts addObject:[cb build]];
        
        cb = nil;
        
        [mRec release];
    }
    if (all) {
        CFRelease(all);
        
        all = nil;
    }
    
    
    return retContacts;
}

/*根据id获取多个联系人  主要用于上传云分享*/
-(NSArray *)getContactsByContactIds:(NSArray *)contactIdArr
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (NSString * contactId in contactIdArr) {
        
        ABRecordRef person =ABAddressBookGetPersonWithRecordID([[HBZSAppDelegate getAppdelegate] getAddressBookRef], contactId.intValue);
        
        Contact * contact = Just_ABRecord2Contact(person);
        [arr addObject:contact];
    }
    
    return arr;
    
}

#pragma mark 全量下载时用
- (void)getGroupChangeMappingInfo:(CFIndex)groupNum{
    CFArrayRef allGroup = ABAddressBookCopyArrayOfAllGroups(abRef);
    
    ABRecordID gID;
    
    Group_Builder* gb;
    
    MemRecord *mRec;
    
	for(int i = 0; i < groupNum; i++ ){
		ABRecordRef group = CFArrayGetValueAtIndex(allGroup, i);
        
        gb = [Group builder];
        
        gID = ABRecordGetRecordID(group);
        
        mRec = [self getMemRecordByABRecordID:gID];
        
        if (mRec == nil){    //addGroupArray  新增群组
            // 生成快照记录
            mRec = [[MemRecord alloc] init];
            
            mRec.serverId = -1;
            
            mRec.version = -1;
            
            mRec.realABID = gID;
            
            mRec.record = group;
            
            NSString *groupname = (NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
           
            mRec.groupName = groupname;//(NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
            
            mRec.accessFlag = 1;  //1 代表已经访问过  //Added by Kevin on May 31;
            
          //  [[gb setServerId:TEMPID_BASE-[arrayData count]] setVersion:(-1)];
            
      //      PimPhb_ABRecord2Group(group, gb, contactBelongToGroupDict, mRec);
            
            [addGroupArray addObject:mRec];
            
            [groupname release];
            
            [mRec release];
        }
        else{
            if (0 != [self compareGroup:group ToMemRecord:mRec]){ //updGroupArray 更新的群组
                [updGroupArray addObject:mRec];
            }
            
            [[gb setServerId:mRec.serverId] setVersion:mRec.version];
            
            PimPhb_ABRecord2Group(group, gb, contactBelongToGroupDict, mRec);
            
            mRec.accessFlag = 1;//RECORD_ACCESSED;   //为了得出删除的 群组和联系人
        }
	}
    
    if (allGroup) {
        CFRelease(allGroup);
    }
}

- (void)getContactChangeMappingInfo:(CFIndex)contactNum{
    ABRecordID cID;
    
    CFArrayRef allContact = ABAddressBookCopyArrayOfAllPeople(abRef);
    
    Contact_Builder* cb;
    
    MemRecord *mRec;
    
	for(int i = 0; i < contactNum; i++ ){
		ABRecordRef person = CFArrayGetValueAtIndex(allContact, i);
        
        cID = ABRecordGetRecordID(person);
        
        cb = [Contact builder];
        
        mRec = [self getMemRecordByABRecordID:cID];
        
        if (mRec == nil){//addContactArray 新增的联系人
            mRec = [[MemRecord alloc] init];   // 生成快照记录
            
            mRec.serverId = -1;
            
            mRec.version = -1;
            
            mRec.realABID = cID;
            
            mRec.record = person;
            
            mRec.groupName = nil;
            
            mRec.accessFlag = 1;   //Added by Kevin on May 31;
            
          //  [arrayData addObject:mRec];
           // [[cb setServerId:TEMPID_BASE-[arrayData count]] setVersion:(-1)];
            
            //PimPhb_ABRecord2Contact(person, cb, contactBelongToGroupDict);
            
            [addContactArray addObject:mRec];
            
            [mRec release];
        }
        else{
            if (0 != [self compareContact:person ToMemRecord:mRec]){  //更新了的联系人
                [updContactArray addObject:mRec];
            }
   
            [[cb setServerId:mRec.serverId] setVersion:mRec.version];
            
            PimPhb_ABRecord2Contact(person, cb, contactBelongToGroupDict);
            
            mRec.accessFlag = 1;    // and at the end, the un-marked mRec is the to-be-deleted record.
        }
	}
    
    if (allContact) {
        CFRelease(allContact);
    }
}


- (void)getDeleteMappingInfoList{
    MemRecord *mRec;
    
    for (int i = 0; i < [arrayData count]; i++){ //delGroupArray  删除的群组 //delContactArray 删除的联系人
        mRec = [arrayData objectAtIndex:i];
        
        if (mRec.accessFlag == 1){
            mRec.accessFlag = 0;
            
            continue;
        }
        
        [toBeDelMemRecordIndexSet addIndex:i];
        
        if ([mRec isGroup]){
            [delGroupArray addObject:[NSNumber numberWithInt:mRec.serverId]];
        }
        else{
            [delContactArray addObject:[NSNumber numberWithInt:mRec.serverId]];
        }
    }
}

- (int)getAddressDbChange{
    CFIndex groupNum, contactNum, recordNum, i;
    
    //[self setupAddressBookRef];  // 重新获取AddressBook，否则有些修改无法得到。
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    abRef = delegate.getAddressBookRef;
    
    groupNum = ABAddressBookGetGroupCount(abRef);
    
    contactNum = ABAddressBookGetPersonCount(abRef);
    
    if (arrayData == nil){
        return -1;
    }
    
    recordNum = [arrayData count];
    
    if (groupNum == 0 && contactNum == 0 && recordNum == 0){
        return 0;
    }
    
    if (oriArrayData){
        [oriArrayData release];
    }
    
    oriArrayData = [[NSMutableArray alloc] initWithArray:arrayData];   // backup arrayData.
  
    [self initTempResultList];          // 初始化临时变量
    
    contactBelongToGroupDict = [[NSMutableDictionary alloc] init];
    
    [self getGroupChangeMappingInfo:groupNum];        //获取群组变化情况
    
    [self getContactChangeMappingInfo:contactNum];   //获取联系人变化情况
   
    for (i = 0; i < [arrayData count]; i++) {          // get to-be-deleted record list.
        MemRecord *mRec = [arrayData objectAtIndex:i];
        
        if (mRec.accessFlag == 1){
            mRec.accessFlag = 0;
            
            continue;
        }
        
        if ([mRec isGroup]){
            [delGroupArray addObject:mRec];
        }
        else{
            [delContactArray addObject:mRec];
        }
    }
    
    ZBLog(@"MemAB:diffSnapshot: ag=%d ac=%d ug=%d uc=%d dg=%d dc=%d ssg=%d ssc=%d", [addGroupArray count], [addContactArray count], [updGroupArray count], [updContactArray count], [delGroupArray count], [delContactArray count], [groupSummaryArray count], [contactSummaryArray count]);
   // [contactBelongToGroupDict release];
    
    if ([addGroupArray count] == 0 && [addContactArray count] == 0 && [updGroupArray count] == 0 && [updContactArray count] == 0 && [delGroupArray count] == 0 && [delContactArray count] == 0) {
        return 0;
    }
    
    return 1;
}

#pragma mark //同步操作的开始方法
- (void)getGroupChange:(CFIndex)groupNum{   //获取群组变化情况
    CFArrayRef allGroup = ABAddressBookCopyArrayOfAllGroups(abRef);
    
    Group_Builder* gb;
    
    ABRecordID gID;
    
    MemRecord *mRec;
    
	for(int i = 0; i < groupNum; i++ ){
		ABRecordRef group = CFArrayGetValueAtIndex(allGroup, i);
        
        gb = [Group builder];
        
        gID = ABRecordGetRecordID(group);
        
        mRec = [self getMemRecordByABRecordID:gID];
        
        if (mRec == nil){    //addGroupArray  新增群组
            // 生成快照记录
            mRec = [[MemRecord alloc] init];
            
            mRec.serverId = -1;
            
            mRec.version = -1;
            
            mRec.realABID = gID;
            
            mRec.record = group;
            
            NSString *groupname = (NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
            
            mRec.groupName = groupname;
            
            [groupname release];
            
            mRec.accessFlag = 1;  //1 代表已经访问过  //Added by Kevin on May 31;
            
            [arrayData addObject:mRec];
            // 创建Group
            [[gb setServerId:TEMPID_BASE-[arrayData count]] setVersion:(-1)];
            
            PimPhb_ABRecord2Group(group, gb, contactBelongToGroupDict, mRec);
            
            [addGroupArray addObject:[gb build]];
            
            [mRec release];
        }
        else{
            if (0 != [self compareGroup:group ToMemRecord:mRec]){ //updGroupArray 更新的群组
                [[gb setServerId:mRec.serverId] setVersion:mRec.version];
                
                PimPhb_ABRecord2Group(group, gb, contactBelongToGroupDict, mRec);
                
                [updGroupArray addObject:[gb build]];
            }
            else{ // 创建contactBelongToGroupDict（PG从属关系），以便下面的Contact使用。
                [[gb setServerId:mRec.serverId] setVersion:mRec.version];
                
                PimPhb_ABRecord2Group(group, gb, contactBelongToGroupDict, mRec);
            }
            // changed or unchanged record need add SS.
            [groupSummaryArray addObject:[[[[SyncSummary builder] setId:mRec.serverId] setVersion:mRec.version] build]];
            
            mRec.accessFlag = 1;//RECORD_ACCESSED;   //为了得出删除的 群组和联系人
        }
	}
    
    if (allGroup) {
        CFRelease(allGroup);
    }
}

- (NSInteger)getContactChangesCount
{
    [self initTempResultList];          // 初始化临时变量
    NSInteger ContactChangers =0;
    if(arrayData.count==0)
    {
        return -1;
    }
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    abRef = delegate.getAddressBookRef;
    
    
    NSInteger contactNum = ABAddressBookGetPersonCount(abRef);
    
    NSInteger groupNum = ABAddressBookGetGroupCount(abRef);
    
    CFArrayRef allContact = ABAddressBookCopyArrayOfAllPeople(abRef);
    
#pragma mark 组变化
/***/
    
    contactBelongToGroupDict = [[NSMutableDictionary alloc] init];
    
    [self getGroupChange:groupNum];      //获取群组变化情况

    
/*组变化**/
    
    MemRecord * mRec;
    for (NSInteger i = 0; i<contactNum; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(allContact, i);
        ABRecordID cid = ABRecordGetRecordID(person);
        mRec = [self getMemRecordByABRecordID:cid];
        if (mRec == nil) {//新增联系人
            ContactChangers++;
            
        }
        else //联系人更新了
        {
            if ([self compareContact:person ToMemRecord:mRec] !=0)
            {
                ContactChangers++;
            }
            mRec.accessFlag = 1; //标记为1说明存在
            
        }
    }
    for (int i = 0; i < [arrayData count]; i++){
        mRec = [arrayData objectAtIndex:i];
        
        if (mRec.accessFlag ==0 )//标记为0时为删除的 上面遍历中将存在的本地的号码的快照accessFlag属性设为1； 如果还有 0 的说明本地已删除
        {
            
            ContactChangers++;
        }
        else if (mRec.accessFlag ==1)
        {
            mRec.accessFlag = 0;//重新置回0;
        }
    }
    
    CFRelease(allContact);
    return ContactChangers;
}

- (void)getContactChange:(CFIndex)contactNum{ //获取联系人变化情况
    Contact_Builder* cb;
    
    ABRecordID cID;
    
    CFArrayRef allContact = ABAddressBookCopyArrayOfAllPeople(abRef);
    
    MemRecord *mRec;
    
	for(int i = 0; i < contactNum; i++ ){
		ABRecordRef person = CFArrayGetValueAtIndex(allContact, i);
        
        cb = [Contact builder];
        
        cID = ABRecordGetRecordID(person);
        
        mRec = [self getMemRecordByABRecordID:cID];
        
        if (mRec == nil){//addContactArray 新增的联系人
            mRec = [[MemRecord alloc] init];   // 生成快照记录
            
            mRec.serverId = -1;
            
            mRec.version = -1;
            
            mRec.realABID = cID;
            
            mRec.record = person;
            
            mRec.groupName = nil;
            
            mRec.accessFlag = 1;   //Added by Kevin on May 31;
            
            [arrayData addObject:mRec];
            // 创建Contact Builder
            [[cb setServerId:TEMPID_BASE-[arrayData count]] setVersion:(-1)];
            
            PimPhb_ABRecord2Contact(person, cb, contactBelongToGroupDict);
            
            [addContactArray addObject:[cb build]];
            
            [mRec release];
        }
        else{
            if (0 != [self compareContact:person ToMemRecord:mRec]){  //更新了的联系人
                [[cb setServerId:mRec.serverId] setVersion:mRec.version];
                
                PimPhb_ABRecord2Contact(person, cb, contactBelongToGroupDict);  // 创建Contact Builder
                
                [updContactArray addObject:[cb build]];
            }
            // changed or unchanged record need add SS.
            [contactSummaryArray addObject:[[[[SyncSummary builder] setId:mRec.serverId] setVersion:mRec.version] build]];
            mRec.accessFlag = 1;    // and at the end, the un-marked mRec is the to-be-deleted record.
        }
	}
    
    CFRelease(allContact);
}

#pragma mark //// diffSnapshot  获取增量群组、联系人，删除群组、联系人，更新群组、联系人////////////////////////////////////
//对比当前的AB与上次同步后状态，从而得到增删改的列表。
//返回：0表示没有改变；1表示有变化；－1表示出错，需要慢同步；
/*
 * 获取增量群组、联系人
 */
- (int)diffSnapshot{
    CFIndex groupNum, contactNum, recordNum;

//    [self setupAddressBookRef];   // 重新获取AddressBook，否则有些修改无法得到。
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    abRef = delegate.getAddressBookRef;

    groupNum = ABAddressBookGetGroupCount(abRef);
    
    contactNum = ABAddressBookGetPersonCount(abRef);

    if (arrayData == nil){
        return -1;
    }
    
    recordNum = [arrayData count];

    if (groupNum == 0 && contactNum == 0 && recordNum == 0){
        return 0;
    }

    if (oriArrayData){
        [oriArrayData release];
    }
    
    oriArrayData = [[NSMutableArray alloc] initWithArray:arrayData];     // backup arrayData.
    
    [self initTempResultList];          // 初始化临时变量

    //比较群组，得出增量
    contactBelongToGroupDict = [[NSMutableDictionary alloc] init];
    
    [self getGroupChange:groupNum];      //获取群组变化情况

    [self getContactChange:contactNum];    //获取联系人变化情况
    
    [self getDeleteMappingInfoList];      //delGroupArray  删除的群组 //delContactArray 删除的联系人 get to-be-deleted record list.


    ZBLog(@"MemAB:diffSnapshot: ag=%d ac=%d ug=%d uc=%d dg=%d dc=%d ssg=%d ssc=%d", [addGroupArray count], [addContactArray count], [updGroupArray count], [updContactArray count], [delGroupArray count], [delContactArray count], [groupSummaryArray count], [contactSummaryArray count]);
    
    if ([addGroupArray count] == 0 && [addContactArray count] == 0 && [updGroupArray count] == 0 && [updContactArray count] == 0 && [delGroupArray count] == 0 && [delContactArray count] == 0) {
        return 0;
    }
    
    return 1;
}


#pragma mark - 同步事务进行中的增删改方法
/*
 * 设置Group  groupName属性以及 添加群组MappingInfo
 */
- (int32_t)addGroup:(Group*)g {

    ABRecordRef group = ABGroupCreate();
    
    if(group == nil){
        ZBLog(@"MemAB::addGroup, create group == nil");
        return DATA_ERR_FAIL_ADD_RECORD;
    }
    
	CFErrorRef error = nil;
    
    PimPhb_Group2ABRecord(g, group);
	
    ABAddressBookAddRecord(abRef, group, &error);        //添加新的群组
    
    //生成快照记录(MappingInfo)
  
    MemRecord* mRec;
    
    mRec = [[MemRecord alloc] init];
    
    mRec.serverId = [g serverId];
    
    mRec.version = [g version];
    
    mRec.realABID = -1;   //not save no id.
    
    mRec.record = group;
    
    NSString *groupname = (NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
    
    mRec.groupName = groupname;

    [groupname release];
    
    [arrayData addObject:mRec];            //arrayData 存储MappingInfo
    
    [mRec release];
 
    if (group) {
        CFRelease(group);
    }
    
    return SYNC_ERR_OK;
}

/*
 * 添加新联系人
 */
- (int32_t)addContact:(Contact*)c
{
    ABRecordRef person = ABPersonCreate();

    if(person == nil){
        ZBLog(@"MemAB::addContact,person == nil");
        return DATA_ERR_FAIL_ADD_RECORD;
    }
	// Add person to AB
	CFErrorRef error = nil;
    
    PimPhb_Contact2ABRecord(c, person);     //设置Person   name、job等属性
    
	ABAddressBookAddRecord(abRef, person, &error);       //添加联系人
    
   // NSLog(@"Contact.groupIdlist---name:%@,groupIdlist: %@",c.name.familyName, c.groupIdList);
    [self addPGRelationship:c abPerson:person];   // 创建person和Group的关系列表([c groupIdlist])
    //生成快照记录(MappingInfo)
    MemRecord* mRec;
    
    mRec = [[MemRecord alloc] init];
    
    mRec.serverId = [c serverId];
    
    mRec.version = [c version];
    
    mRec.realABID = -1;   //not save no id.
    
    mRec.record = person;
    
    mRec.groupName = nil;
    
    [arrayData addObject:mRec];
    
    [mRec release];
    
    if (c.favorite) {
        [self.topAbRecods addObject:person];
    }
    
    CFRelease(person);
    
    return SYNC_ERR_OK;
}

- (int32_t)updGroup:(Group*)g
{
    int32_t gID = [g serverId];
    
    ZBLog(@"MemAB:updGroup sid=%d", gID);
    
    MemRecord* mRec;
    
    ABRecordRef group;
    
    int32_t mrIndex = [self getMemRecordIndexByServerId:gID IsGroup:TRUE];
    
    if (mrIndex < 0){
        ZBLog(@"MemAB:updGroup memRecord not found.gID=%d", gID);
        return DATA_ERR_FAIL_REPLACE_RECORD;
    }
    
    mRec = [arrayData objectAtIndex:mrIndex];

    group = ABAddressBookGetGroupWithRecordID(abRef, mRec.realABID);//Added by Kevin on May,30 2013
    
    if (group == NULL){//if (group == nil)
        group = ABGroupCreate();
        
        mRec.record = group;
    }
    
	CFErrorRef error = nil;
    
    PimPhb_Group2ABRecord(g, group);
    
    NSString *groupname = (NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
    
    mRec.groupName = groupname;

	[groupname release];
    
    ABAddressBookAddRecord(abRef, group, &error);
    // remove mrIndex from the tobedelete list.
    [toBeDelMemRecordIndexSet removeIndex:mrIndex];
    
    if (group) {
        CFRelease(group);
    }
    return SYNC_ERR_OK;
}

#pragma mark 修改联系人
/*
 * 修改联系人
 */
- (int32_t)updContact:(Contact*)c
{
    int32_t cID=[c serverId];     // 根据serverId定位MemRecord
    
    MemRecord* mRec;
    
    ABRecordRef person;
    
    int32_t mrIndex = [self getMemRecordIndexByServerId:cID IsGroup:FALSE];
    
    if (mrIndex < 0) {
        ZBLog(@"MemAB:updContact memRecord not found.cID=%d", cID);
        return DATA_ERR_FAIL_REPLACE_RECORD;
    }
    
    mRec = [arrayData objectAtIndex:mrIndex];

    person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID); //Added by Kevin on May 31,2013
    
    
    
    if (person == NULL){//nil
        person = ABPersonCreate();
        
        mRec.record = person;
    }
    
    mRec.groupName = nil;
	
    CFErrorRef error = nil;
    
	if (PimPhb_Contact2ABRecord(c, person) == SYNC_ERR_OK){
		ABAddressBookAddRecord(abRef, person, &error);
		
		[self updPGRelationship:c abPerson:person];       	// add person to related groups.
    
        [toBeDelMemRecordIndexSet removeIndex:mrIndex];         // remove mrIndex from the tobedelete list.
	}
    if (person) {
        CFRelease(person);

    }
    return SYNC_ERR_OK;
}

#pragma mark delGroup
/*
 * 删除Group
 */
- (int32_t)delGroup:(int32_t)gID
{
    MemRecord* mRec;
    
    ABRecordRef group;
    
    int32_t mrIndex = [self getMemRecordIndexByServerId:gID IsGroup:TRUE];
    
    if (mrIndex < 0) {
        ZBLog(@"MemAB:delGroup memRecord not found.gID=%d", gID);
        return DATA_ERR_FAIL_REPLACE_RECORD;
    }
    
    mRec = [arrayData objectAtIndex:mrIndex];
#if 0
    group = mRec.record;
#endif
    group = ABAddressBookGetGroupWithRecordID(abRef, mRec.realABID); //Added by kevin
    
    if (group == nil && mRec.realABID > 0){
        group = ABAddressBookGetGroupWithRecordID(abRef, mRec.realABID);
    }
    
	CFErrorRef error = nil;
    
    if (group){
        ABAddressBookRemoveRecord(abRef, group, &error);
        
        mRec.record = nil;
        
        mRec.realABID=-1;
    }
    
    [toBeDelMemRecordIndexSet addIndex:mrIndex];
    
    return SYNC_ERR_OK;
}

#pragma mark delContact
/*
 * 删除联系人
 */
- (int32_t)delContact:(int32_t)cID
{
    MemRecord* mRec;
    
    ABRecordRef person;
    
    int32_t mrIndex = [self getMemRecordIndexByServerId:cID IsGroup:FALSE];
    
    if (mrIndex < 0){
        ZBLog(@"MemAB:delContact memRecord not found.cID=%d", cID);
        return DATA_ERR_FAIL_REPLACE_RECORD;
    }
    
    mRec = [arrayData objectAtIndex:mrIndex];
#if 0
    person = mRec.record;
#endif
    person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID); //added by kevin
    
    if (person == nil && mRec.realABID > 0) {
        person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);
    }
    
	CFErrorRef error = nil;
    
    if (person) {
        ABAddressBookRemoveRecord(abRef, person, &error);
        
        [HB_ContactSendTopTool contactCancelBackWithRecordID:ABRecordGetRecordID(person)];
        
        mRec.record = nil;
        
        mRec.realABID = -1;
    }
    
    [toBeDelMemRecordIndexSet addIndex:mrIndex];
    
    ;
    
    return SYNC_ERR_OK;
}

#pragma mark - 同步事务进行中的获取本地通讯录的摘要列表信息方法
//获取需要更新的（不包括新增和删除的）联系人/分组摘要列表。（array of SyncSummary）
- (NSArray*)contactListSummary
{
    return contactSummaryArray;
}

- (NSArray*)groupListSummary
{
    return groupSummaryArray;
}

#pragma mark - 同步事务进行中的获取本地通讯录的详细信息列表方法
//获取新增的联系人／分组的集合。（array of Contact/Group）
- (NSArray*)contactAddList
{
    return addContactArray;
}

- (NSArray*)groupAddList
{
    return addGroupArray;
}

//获取修改的联系人／分组的集合。（array of Contact/Group）
- (NSArray*)contactUpdList
{
    return updContactArray;
}

- (NSArray*)groupUpdList
{
    return updGroupArray;
}

//获取删除的联系人／分组的集合。（array of Contact/Group）
- (NSArray*)contactDelList
{
    return delContactArray;
}

- (NSArray*)groupDelList
{
    return delGroupArray;
}


#pragma mark - 同步事务进行中的关于个人名片的方法
// 名片版本的定义：-1表示已失效，0表示客户端修改了名片，>0表示名片从服务端下载后未修改
// 获取我的名片数据
// 如果没有名片，返回nil

/*
 *  获取我的名片
 */
- (Contact*)myCard{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/BusinessCard"];
	ZBLog(@"load BusinessCard from file: %@", documentsDirectory);
	
    NSData* cardData=[NSData dataWithContentsOfFile:documentsDirectory];
	
	if ([cardData length] > 0){
		Contact * varCard = [Contact parseFromData:cardData];
		
		if ([varCard version] >= 0) { // 版本号为-1时名片无效
			return varCard;
		}
	}
	
    return nil;
}

// 获取我的名片版本
// 名片版本的定义：-1表示已失效，0表示客户端修改了名片，>0表示名片从服务端下载后未修改
// 如果没有名片，则返回-2
- (int32_t)myCardVersion
{
	Contact *varCard = [self myCard];
    
	if (varCard != nil)
	{
		// 版本号为-1时，说明名片处于失效状态
		// 版本号为0时，说明名片处于新增或修改状态
		return [varCard version];
	}
    
    return -2;
}

/*
 *   更新我的名片
 */
- (int32_t)updMyCard:(Contact*)varCard;
{
	if (varCard != nil){
		NSData *cardData = [varCard data];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
		
        documentsDirectory = [documentsDirectory stringByAppendingString:@"/BusinessCard"];
		
        ZBLog(@"save to BusinessCard file: %@", documentsDirectory);
		
        [cardData writeToFile:documentsDirectory atomically:YES];
	}
	
    return SYNC_ERR_OK;
}


// cardVersion>0：服务器端根据同步请求更新了名片数据和版本号，客户端只需要更新名片版本号。
// cardVersion=0：服务器端没有用户名片数据。
// cardVersion=-1：服务器端要求客户端删除本地名片数据。
#pragma mark //更新我的名片版本号
/*
 * 更新名片版本号
 */
- (int32_t)updMyCardVersion:(int32_t)cardVersion;
{
	Contact *varCard = [self myCard];
    
	if (varCard != nil)
	{
		Contact *newCard = [[[[Contact builder] mergeFrom:varCard] setVersion:cardVersion] build];
		
        [self updMyCard:newCard];
		
		return SYNC_ERR_OK;
	}
    
    return VCARD_ERR_FAIL_INIT;
}

#pragma mark // 删除我的名片
/*
 * 删除我的名片
 */
- (int32_t)delMyCard
{
	return [self updMyCardVersion:-1];
}

#pragma mark  获取我的头像

/*
 *  获取我的头像
 */
- (PortraitData*)myPortrait
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/BusinessCardPortrait"];
	
    ZBLog(@"load BusinessCardPortrait from file: %@", documentsDirectory);
	
    NSData* cardData=[NSData dataWithContentsOfFile:documentsDirectory];
	
	if ([cardData length] > 0)
	{
		PortraitData *varCard = [PortraitData parseFromData:cardData];
		// 版本号为-1时名片无效
		if ([varCard sid] >= 0) {
			return varCard;
		}
	}
	
    return nil;
}
// 获取我的头像版本
- (int32_t)myPortraitVersion
{
	PortraitData *varCard = [self myPortrait];
    
	if (varCard != nil)
	{
		// 版本号为-1时，说明名片处于失效状态
		// 版本号为0时，说明名片处于新增或修改状态
		return [varCard sid];
	}
    
    return -2;
}

// 更新我的头像
- (int32_t)updMyPortrait:(PortraitData*)varPortrait
{
	if (varPortrait != nil)
	{
		NSData *cardData = [varPortrait data];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
		
        documentsDirectory = [documentsDirectory stringByAppendingString:@"/BusinessCardPortrait"];
		
        ZBLog(@"save to BusinessCardPortrait file: %@", documentsDirectory);
		
        [cardData writeToFile:documentsDirectory atomically:YES];
	}
	
    return SYNC_ERR_OK;
}

#pragma mark // 删除我的头像
/*
 *  删除我的名片
 */
- (int32_t)delMyPortrait
{
	return [self updMyPortraitVersion:-1];
}

#pragma mark // 更新我的名片版本号
/*
 *  更新我的名片版本号
 */
- (int32_t)updMyPortraitVersion:(int32_t)portraitVersion
{
	PortraitData *varCard = [self myPortrait];
    
	if (varCard != nil)
	{
		PortraitData *newCard = [[[[PortraitData builder] mergeFrom:varCard] setSid:portraitVersion] build];
		
        [self updMyPortrait:newCard];
		
		return SYNC_ERR_OK;
	}
    
    return VCARD_ERR_FAIL_INIT;
}

#pragma mark - 同步事务中更新ServerID和Version的方法，用来构建本地快照。
/*
 * 更新MappingInfo 中的serverID、Version
 */
- (int32_t)_updRecord:(int32_t)serverId WithVersion:(int32_t)version WithTempID:(int32_t)tempID IsGroup:(BOOL)isGroup
{
    int32_t index, count;
    
    MemRecord* mRec;
    
    index = [self getMemRecordIndexByServerId:tempID IsGroup:isGroup]; //根据tempId找出要修改MappingInfo在arrayData的位置
    
    count = [arrayData count];
    
    if (index >= count){
        // 下标越界
        ZBLog(@"updContact error index=%d", tempID);
        return SYNC_ERR_WRONG_PARAM;
    }
    
    if (index < 0){
        mRec = [[MemRecord alloc] init];
        
        mRec.realABID = -1;// need to create ABRecord while updContact/updGroup later.
        
        if (isGroup){
            mRec.groupName = @"";
        }
        
        index = count;
        
        mRec.serverId = serverId;
        
        mRec.version = version;
        
        [toBeUpdMemRecordIndexSet addIndex:index];       // 记录需要更新的索引号。
        
        [arrayData addObject:mRec];
        
        [mRec release];
    }
    else{
        mRec = [arrayData objectAtIndex:(index)];
        
        mRec.serverId = serverId;
        
        mRec.version = version;
        
        [toBeUpdMemRecordIndexSet addIndex:index];       // 记录需要更新的索引号。
    }
    
    return SYNC_ERR_OK;
}

#pragma mark // 根据临时ID找到联系人，更新其正式ID和版本号
/*
 * 根据临时ID找到联系人，更新MappingInfo正式ID和版本号
 */
- (int32_t)updContact:(int32_t)contactID WithVersion:(int32_t)version WithTempID:(int32_t)tempID
{
    return [self _updRecord:contactID WithVersion:version WithTempID:tempID IsGroup:FALSE];
}

#pragma mark // 根据临时ID找到组，更新其正式ID和版本号
/*
 *  根据临时ID找到组，更新MappingInfo 其正式ID和版本号
 */
- (int32_t)updGroup:(int32_t)groupID WithVersion:(int32_t)version WithTempID:(int32_t)tempID
{
    return [self _updRecord:groupID WithVersion:version WithTempID:tempID IsGroup:TRUE];
}

#pragma mark - 同步事务中关于用户头像的方法。
- (int32_t)startPortraitSyncTask:(SyncTaskType)task{
    ZBLog(@"MemAB::startPortraitSyncTask task=%d", task);
    int32_t ret = 0;
    
    curTask = task;
    
    //[self setupAddressBookRef];
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    abRef = delegate.getAddressBookRef;
    
    if (oriArrayData){
        [oriArrayData release];
    }
    
    oriArrayData = [[NSMutableArray alloc] initWithArray:arrayData];// backup arrayData.
    
    switch (task) {
        case TASK_MERGE_SYNC:{ //慢同步（合并同步）
            ret = [self getAllPortraits];
            break;
        }
        case TASK_ALL_UPLOAD:{ //全量上传
            ret = [self getAllPortraits];      //获取所有联系人头像
            break;
        }
        case TASK_ALL_DOWNLOAD://全量下载
            [self initTempResultList];  //added on 7,18 
            break;
        case TASK_DIFFER_SYNC://同步（双向同步）
            ret = [self diffPortrait];       //获取联系人头像 增量
            
            break;
        case TASK_SYNC_UPLOAD://同步上传（增量上传）
        case TASK_SYNC_DOANLOAD://同步下载（增量下载）
            [self initTempResultList];  //added on 7,18
            return -1;
        default:
            [self initTempResultList];  //added on 7,18 
            return -1;
    }
    
    return ret;
}

#pragma mark  commitPortraitTask
/*
 *  提交头像修改
 */
- (void)commitPortraitTask
{
    ZBLog(@"MemAB::commitPortraitTask");
    
    CFDataRef imageData=nil;
    
    CFErrorRef error = nil;
    
    ABAddressBookSave(abRef, &error);
    
    ABRecordRef abRec;
    
    int32_t index=-1;
    
    for (MemRecord* mRec in arrayData)
    {
        index ++;
        
        abRec = ABAddressBookGetGroupWithRecordID(abRef, mRec.realABID);
        
        if (abRec == nil){
            abRec = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);
        }
        
        if (abRec)
        {
            ABRecordType type = ABRecordGetRecordType(abRec);
            
            if (type == kABGroupType){   //Group  没有头像
                // Group不需要更新。
                continue;
            }
            else if (type == kABPersonType){
                // Contact保存时间标签，以便下次比对。
                NSDate *lastCreateDate = (NSDate*)ABRecordCopyValue(abRec, kABPersonCreationDateProperty);
                
                mRec.lastCheckCreateDate = lastCreateDate;
                
                [lastCreateDate release];
                
                NSDate *lastModifyDate = (NSDate*)ABRecordCopyValue(abRec,kABPersonModificationDateProperty);
                
                mRec.lastCheckModifyDate = lastModifyDate;
                
                [lastModifyDate release];
                
                imageData = ABPersonCopyImageData(abRec);
                
                if (imageData == nil){
                    mRec.portraitMD5=nil;
                }
                else{
                    mRec.portraitMD5 = [(NSData *)imageData md5];//[[[NSString alloc] initWithString:[(NSData*)imageData md5]] autorelease];
                }
                
                if (imageData) {
                    CFRelease(imageData);
                }
            }
        }
        
        mRec.record = nil;
    }
    
    // 复位任务状态
    curTask = TASK_AUTHEN;
    
    [self clearTempResultList];
    
    [self saveToFile];
    // 删除备份的快照列表。
    if (oriArrayData){
        [oriArrayData release];
        
        oriArrayData = nil;
    }
}

#pragma mark rollbackPortraitTask
- (void)rollbackPortraitTask
{
    ZBLog(@"MemAB::rollbackPortraitTask");
    ABAddressBookRevert(abRef);
    
    [self clearTempResultList];
    // 恢复备份的快照列表。
    if (arrayData)
    {
        [arrayData release];
    }
    
    arrayData = oriArrayData;
    
    oriArrayData = nil;
    // 复位任务状态
    curTask = TASK_AUTHEN;
}

#pragma mark  unchangedPortraitTask
- (void)unchangedPortraitTask
{
    ZBLog(@"MemAB::unchangedPortraitTask");
    [self clearTempResultList];
    // 恢复备份的快照列表。
    if (arrayData)
    {
        [arrayData release];
    }
    
    arrayData = oriArrayData;
    
    oriArrayData = nil;
    // 复位任务状态
    curTask = TASK_AUTHEN;
}

#pragma mark  getPortraitSummaryList
- (NSArray*)getPortraitSummaryList
{
    [contactSummaryArray removeAllObjects];
    
    for (MemRecord* mRec in arrayData)
    {
        if ([mRec isGroup]){
            continue;
        }
        // 添加记录的头像摘要信息。
        [contactSummaryArray addObject:[[[[PortraitSummary builder] setSid:mRec.serverId] setPortraitVersion:mRec.portraitVersion] build]];
    }
    
    return contactSummaryArray;
}

#pragma mark  diffPortrait
/*
 * 获取增量头像
 */
- (int32_t)diffPortrait
{
    CFDataRef imageData = nil;
    
    PortraitData_Builder* pdb;
    
    int nChanged=0;
    
    [self initTempResultList];  // 初始化临时变量
    
    for (MemRecord* mRec in arrayData)
    {
        if ([mRec isGroup]){
            continue;
        }
        
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);//mRec.record;
     
        if (person == nil && mRec.realABID > 0){
            person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);
        }
        
        imageData = ABPersonCopyImageData(person);
      
        // 比较本地通讯录和本地快照，如果头像没有变化的话，则继续下一条记录。
        if (imageData ==nil && mRec.portraitMD5==nil){
            continue;// same no portrait.
        }
        
        if (imageData && mRec.portraitMD5){
            if (NSOrderedSame == [mRec.portraitMD5 compare:[(NSData*)imageData md5]]){
                CFRelease(imageData);
                continue;// same portrait.
            }
        }
        // 头像有更改。
        if (imageData != nil)
        {
            // 本地通讯录有头像记录。
            pdb = [[[[PortraitData builder] setImageData:(NSData*)imageData] setImageType:ImageTypeJpg] setSid:mRec.serverId];
            
            [updContactArray addObject:[[[UploadPortraitData builder] setPortraitData:[pdb build]] build]];
        }
        else
        {      // 本地通讯录没有头像记录。
            pdb = [[[PortraitData builder] setImageType:ImageTypeJpg] setSid:mRec.serverId];
            
            [updContactArray addObject:[[[UploadPortraitData builder] setPortraitData:[pdb build]] build]];
        }
        
        nChanged ++;
        
        if (imageData) {
            CFRelease(imageData);
        }
    }
    
    return nChanged;
}

#pragma mark getAllPortraits
/*
 * 获取所有头像
 */
- (int32_t)getAllPortraits
{
    CFDataRef imageData = nil;
    
    [self initTempResultList];  // 初始化临时变量
    
    for (MemRecord* mRec in arrayData){
        if ([mRec isGroup]){ //群组没有头像
            continue;
        }
        
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);//mRec.record;
        
        if (person == nil){
            person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);
        }
        
        if (person == nil){
            ZBLog(@"MemAB:getAllPortraits can not load record:%d, %d, %d, %d, %@", mRec.realABID, mRec.serverId, mRec.version, mRec.portraitVersion, mRec.portraitMD5);
            continue;
        }
        
        imageData = ABPersonCopyImageData(person);
        
        if (imageData != nil){//ImageType 0
            [addContactArray addObject:[[[UploadPortraitData builder] setPortraitData:[[[[[PortraitData builder] setImageData:(NSData*)imageData] setImageType:1] setSid:mRec.serverId] build]] build]];
            
            CFRelease(imageData);
        }
    }
    
    return SYNC_ERR_OK;
}

#pragma mark  updPortrait
/*
 * 更新MappingInfo portraitVersion
 */
- (int32_t)updPortrait:(int32_t)portraitID WithVersion:(int32_t)version
{
    MemRecord* mRec;
    
    mRec = [self getMemRecordByServerId:portraitID IsGroup:FALSE];
    
    if (mRec != nil){
        mRec.portraitVersion = version;
    }
    
	return SYNC_ERR_OK;
}

#pragma updPortrait
- (int32_t)updPortrait:(DownloadPortraitData*)portrait
{
    int32_t sid;
    
    MemRecord* mRec;
    
    NSData* imageData;
    
    CFErrorRef error = nil;
    
    sid = [[portrait portraitData] sid];    // 根据sid获取相应的MemAB record。
    
    if (![portrait hasPortraitData])
    {
        ZBLog(@"MemAB:updPortrait can not find portrait. %d", sid);
        return SYNC_ERR_WRONG_PARAM;
    }
    
    mRec = [self getMemRecordByServerId:sid IsGroup:FALSE];
    
    if (mRec == nil)
    {
        ZBLog(@"MemAB:updPortrait can not find memAB record by %d", sid);
        return SYNC_ERR_WRONG_PARAM;
    }
    
    // 设置相应的数据到本地通讯录和快照纪录。
    mRec.portraitVersion = [portrait portraitVersion];
    
    imageData = [[portrait portraitData] imageData];
    
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);//mRec.record;
    
    if (person == nil && mRec.realABID>0)
    {
        person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);
    }
    
    if (person == nil)
    {
        ZBLog(@"MemAB:updPortrait can not find AB person record by %d, %d.", sid, mRec.realABID);
        return SYNC_ERR_WRONG_PARAM;
    }
    
    ABPersonSetImageData(person, (CFDataRef)imageData, &error);
    
    return SYNC_ERR_OK;
}

#pragma delPortrait  删除联系人头像
- (int32_t)delPortrait:(int32_t)serverId
{
    MemRecord* mRec;
    
    mRec = [self getMemRecordByServerId:serverId IsGroup:FALSE];
    
    if (mRec == nil){
        ZBLog(@"MemAB:delPortrait can not find memAB record by %d", serverId);
        return SYNC_ERR_WRONG_PARAM;
    }
    
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);///mRec.record;
    
    if (person == nil && mRec.realABID>0){
        person = ABAddressBookGetPersonWithRecordID(abRef, mRec.realABID);
    }
    
    if (person==nil)
    {
        ZBLog(@"MemAB:delPortrait can't load record:%d, %d, %d", mRec.realABID, mRec.serverId, mRec.version);
        return SYNC_ERR_WRONG_PARAM;
    }
    
    CFErrorRef error = nil;
    
    ABPersonRemoveImageData(person, &error);
    
    return SYNC_ERR_OK;
}

#pragma mark - PimPhbAdapter需要用到的内部方法

#pragma mark  getGroupBySID
/*
 * 根据group serverId获取当前的AddressBook的group信息。
 */
- (ABRecordRef)getGroupBySID:(int32_t)groupSID
{
    for (MemRecord* mRec in arrayData)
    {
        if (mRec.serverId == groupSID)
        {
            if (mRec.record)
            {
                return mRec.record;
            }
            
            return ABAddressBookGetGroupWithRecordID(abRef, mRec.realABID);
        }
    }
    
    return nil;
}

#pragma mark getMemRecordByABRecordID  查询MappingInfo  中是否存在该记录
/*
 * 查询MappingInfo 是否存在该记录
 */
- (MemRecord*)getMemRecordByABRecordID:(int32_t)abRecordID
{
    for (MemRecord* mRec in arrayData)
    {
        if (mRec.realABID == abRecordID){
            return mRec;
        }
    }
    
    return nil;
}

#pragma mark getMemRecordByServerId
- (MemRecord*)getMemRecordByServerId:(int32_t)serverId IsGroup:(BOOL)isGroup
{
    for (MemRecord* mRec in arrayData)
    {
        if (isGroup!=[mRec isGroup])
        {
            continue;
        }
        
        if (mRec.serverId==serverId)
        {
            return mRec;
        }
    }
    
    return nil;
}

#pragma mark getMemRecordIndexByServerId
- (int32_t)getMemRecordIndexByServerId:(int32_t)serverId IsGroup:(BOOL)isGroup
{
    int32_t index = -1;
    
    if (serverId < TEMPID_BASE)
    {
        return TEMPID_BASE-serverId-1;
    }
    
    for (MemRecord* mRec in arrayData)
    {
        index ++;
        
        if (isGroup != [mRec isGroup])
        {
            continue;
        }
        
        if (mRec.serverId == serverId)
        {
            return index;
        }
    }
    
    return -1;
}

//初始化diffSnapshot的临时生成的记录列表
- (void)initTempResultList
{
    [self clearTempResultList];
    
    addContactArray = [[NSMutableArray alloc] init];
    
    updContactArray = [[NSMutableArray alloc] init];
    
    delContactArray = [[NSMutableArray alloc] init];
    
    contactSummaryArray = [[NSMutableArray alloc] init];
    
    addGroupArray = [[NSMutableArray alloc] init];
    
    updGroupArray = [[NSMutableArray alloc] init];
    
    delGroupArray = [[NSMutableArray alloc] init];
    
    groupSummaryArray = [[NSMutableArray alloc] init];
    
    toBeUpdMemRecordIndexSet = [[NSMutableIndexSet alloc] init];
    
    toBeDelMemRecordIndexSet = [[NSMutableIndexSet alloc] init];
}
//清除diffSnapshot的临时生成的记录列表
- (void)clearTempResultList
{
    if (addContactArray)
    {
        [addContactArray release];
    }
    
    if (updContactArray)
    {
        [updContactArray release];
    }
    
    if (delContactArray)
    {
        [delContactArray release];
    }
    
    if (contactSummaryArray)
    {
        [contactSummaryArray release];
    }
    
    if (addGroupArray)
    {
        [addGroupArray release];
    }
    
    if (updGroupArray)
    {
        [updGroupArray release];
    }
    
    if (delGroupArray)
    {
        [delGroupArray release];
    }
    
    if (groupSummaryArray)
    {
        [groupSummaryArray release];
    }
    
    if (toBeUpdMemRecordIndexSet)
    {
        [toBeUpdMemRecordIndexSet release];
    }
    
    if (toBeDelMemRecordIndexSet)
    {
        [toBeDelMemRecordIndexSet release];
    }
    
    addContactArray = nil;
    
    updContactArray = nil;
    
    delContactArray = nil;
    
    contactSummaryArray = nil;
    
    addGroupArray = nil;
    
    updGroupArray = nil;
    
    delGroupArray = nil;
    
    groupSummaryArray = nil;
    
    toBeUpdMemRecordIndexSet = nil;
    
    toBeDelMemRecordIndexSet = nil;
}

#pragma mark  compareGroup
- (int)compareGroup:(ABRecordRef)group ToMemRecord:(MemRecord*)mRec
{
    int ret = 0;
    
    NSString* gName = @"";//(NSString*)ABRecordCopyValue(group, kABGroupNameProperty);
    
    gName = (NSString*)ABRecordCopyValue(group, kABGroupNameProperty);
    
    if (NSOrderedSame != [mRec.groupName compare:gName])
    {
        ret = 1;
    }
    
    [gName release];
    
    return ret;
}

#pragma mark  compareContact
/*
 * 比对该联系人是否发生了变化  利用MD5  比较联系人是否变化了
 */
- (int)compareContact:(ABRecordRef)contact ToMemRecord:(MemRecord*)mRec
{
    ABRecordID cID = ABRecordGetRecordID(contact);
    
    NSString* key = [[NSString alloc] initWithFormat:@"realID=%d", cID];
    
    NSString* fullContentMD5 = [abRecordFullContentMD5Dict valueForKey:key];
    
    if (fullContentMD5 != nil){
        Contact_Builder* cb;
        
        Contact* c;
        
        cb = [Contact builder];
        
        PimPhb_ABRecord2Contact(contact, cb, contactBelongToGroupDict);
        
        c = [cb build];
        
        NSString* newFullContentMD5=[[c data] md5];
        
        if (NSOrderedSame == [fullContentMD5 compare:newFullContentMD5]) {
            [key release];
            return 0;
        }
        ZBLog(@"MemAB::compareContact recordID=%@ oldMD5=%@ newMD5=%@ c=%@", key, fullContentMD5, newFullContentMD5, [c data]);
        [key release];
        return 1;
    }
    
    NSDate* date;
    
    date = (NSDate *)ABRecordCopyValue(contact, kABPersonModificationDateProperty);
    
    if (date == nil)
    {
         [key release];
        
        return 1;
    }
    
    if (NSOrderedSame != [date compare:mRec.lastCheckModifyDate])
    {
		ZBLog(@"修改时间：ABRecordDate=%@, lastCheckModifyDate=%@", date, mRec.lastCheckModifyDate);
        CFRelease(date);
         [key release];
        
        return 1;
    }
    
    CFRelease(date);
    
    date = (NSDate *)ABRecordCopyValue(contact, kABPersonCreationDateProperty);
    
    if (date == nil)
    {
         [key release];
        return 1;
    }
    
    if (NSOrderedSame != [date compare:mRec.lastCheckCreateDate])
    {
		ZBLog(@"创建时间：ABRecordDate=%@, lastCheckCreateDate=%@", date, mRec.lastCheckCreateDate);
        CFRelease(date);
         [key release];
        return 1;
    }
    
    [key release];
    
    CFRelease(date);
    
    return 0;
}

/*
 *  创建person和Group的关系列表(Person 属于哪些Group)
 */
- (void)addPGRelationship:(Contact *)c abPerson:(ABRecordRef)person
{
    // 创建person和Group的关系列表，如果是第一次调用addContact。
    if (contactBelongToGroupArray == nil){
        contactBelongToGroupArray = [[NSMutableArray alloc] init];
    }
    
    int groupCount = [[c groupIdList] count];        // add person to related groups.
    
    if (groupCount > 0)
    {
        Person2Group* pg;
        
        for (int i = 0; i < groupCount; i++)
        {
            pg = [[Person2Group alloc] init];
            
            int32_t groupSID = [c groupIdAtIndex:i];
            
            ABRecordRef group = [self getGroupBySID:groupSID];
            
            pg.person = person;
            
            pg.group = group;
            
            [contactBelongToGroupArray addObject:pg];
            
            [pg release];
        }
    }
}

#pragma mark updPGRelationship
- (void)updPGRelationship:(Contact *)c abPerson:(ABRecordRef)person
{
    // 创建person和Group的关系列表，如果是第一次调用addContact。
    if (contactBelongToGroupArray == nil)
    {
        contactBelongToGroupArray = [[NSMutableArray alloc] init];
    }
    
    if (contactRemoveFromGroupArray==nil)
    {
        contactRemoveFromGroupArray = [[NSMutableArray alloc] init];
    }
    
    // 获取当前的contact的PG关系。
    Person2Group* pg;
    
    NSMutableSet* newGroupSet=nil;
    
    int groupCount=[[c groupIdList] count];
    
    if (groupCount>0)
    {
        newGroupSet=[[[NSMutableSet alloc] initWithCapacity:groupCount] autorelease];
        
        for (int i=0; i<groupCount; i++)
        {
            int32_t groupSID = [c groupIdAtIndex:i];
            
            MemRecord* groupMR = [self getMemRecordByServerId:groupSID IsGroup:TRUE];
            
            [newGroupSet addObject:groupMR];
        }
    }
    // 获取之前分析的原有的PG关系。
    ABRecordID cID=ABRecordGetRecordID(person);
    
    NSString* strPersonID = [[NSString alloc] initWithFormat:@"MR:%d", cID];
    
    NSArray* oriGroupSet = [contactBelongToGroupDict objectForKey:strPersonID];
    
    [strPersonID release];
    
	// compare Contact.groupList to previous local PG Dict.
    for (MemRecord* oriMR in oriGroupSet)
    {
        if ([newGroupSet member:oriMR])
        {
            [newGroupSet removeObject:oriMR];
            continue;
        }
        else
        {
            pg = [[Person2Group alloc] init];
            
            pg.person = person;
            
            pg.group = oriMR.record;
            
            if (pg.group==nil && oriMR.realABID>0)
            {
                pg.group = ABAddressBookGetGroupWithRecordID(abRef, oriMR.realABID);
            }
            
            [contactRemoveFromGroupArray addObject:pg];
            
            [pg release];
        }
    }
    
    for (MemRecord* newMR in newGroupSet)
    {
        pg = [[Person2Group alloc] init];
        
        pg.person = person;
        
        pg.group = newMR.record;
        
        if (pg.group==nil && newMR.realABID>0)
        {
            pg.group = ABAddressBookGetGroupWithRecordID(abRef, newMR.realABID);
        }
        
        [contactBelongToGroupArray addObject:pg];
        
        [pg release];
    }
}

- (void)setupAddressBookRef
{
    if (abRef) {
        CFRelease(abRef);
        
        abRef = nil;
    }
        abRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(abRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);
}

- (void)buildFullSnapshot{
    NSLog(@"buildFullSnapshot......1...");
    CFIndex i, count=0;
    
   // [self setupAddressBookRef];
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    abRef = delegate.getAddressBookRef;
    
    CFArrayRef all = ABAddressBookCopyArrayOfAllGroups(abRef);         //allGroups
    if (all) {
         count = CFArrayGetCount(all);
    }
   
    
    NSMutableDictionary *contactGroupDict;
    
    contactGroupDict = [[NSMutableDictionary alloc] init];
    
    for(i = 0; i < count; i++ )   //contactGroupDict    value: 群组Id数组  key: personId
    {
        ABRecordRef group = CFArrayGetValueAtIndex(all, i);
        
        PimPhb_FindContactsInGroup(group, contactGroupDict);
    }
    
    if (all) {
        CFRelease(all);
        all = nil;
    }
    
    [abRecordFullContentMD5Dict removeAllObjects];
////////
    ABRecordID cID;
    
    Contact_Builder* cb;
    
    Contact* c;
    
    all = ABAddressBookCopyArrayOfAllPeople(abRef);     //所有联系人
    if (all) {
        count = CFArrayGetCount(all);
    }
    

    for(i = 0; i < count; i++ ){//在这里面有问题
        ABRecordRef person = CFArrayGetValueAtIndex(all, i);
        
        cID = ABRecordGetRecordID(person);
        
        cb = [Contact builder];
      
        PimPhb_ABRecord2Contact(person, cb, contactGroupDict);
       
        c = [cb build];
        
        NSString* fullContentMD5 = [[c data] md5];
        
        NSString* key = [[NSString alloc]initWithFormat:@"realID=%d", cID];

        [abRecordFullContentMD5Dict setValue:fullContentMD5 forKey:key];

        [key release];
    }

    
    if (all) {
        CFRelease(all);
        all = nil;
    }
    
    if (contactGroupDict) {
        [contactGroupDict release];
        contactGroupDict = nil;
    }
    
    NSLog(@"buildFullSnapshot......3...");
    [self saveFullSnapshot];
    NSLog(@"buildFullSnapshot......4...");
}

/*
 * 存储 abRecordFullContentMD5Dict 到沙盒路径  ,MD5 比较联系人、群组增量
 */
- (void)saveFullSnapshot
{
	NSFileManager *fileManager = [NSFileManager defaultManager];  //创建文件管理器
	//参数NSDocumentDirectory要获取那种路径
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
	//更改到待操作的目录下
	[fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	//创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
	//获取文件路径
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"memAB.plist"];
    // write to file.
    NSData *xmlData;
    
    NSString *error;

    xmlData = [NSPropertyListSerialization dataFromPropertyList:abRecordFullContentMD5Dict
                                                         format:kCFPropertyListBinaryFormat_v1_0
                                               errorDescription:&error];

    if(xmlData)
    {
        [xmlData writeToFile:path atomically:YES];
    }
    else
    {
        [error release];
    }
}

#pragma mark loadFullSanpshot
/*
 * 从沙盒路径 读取 abRecordFullContentMD5Dict
 */
- (void)loadFullSanpshot
{
    NSFileManager *fileManager = [NSFileManager defaultManager]; //创建文件管理器

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];  //去处需要的路径
   
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    //获取文件路径
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"memAB.plist"];
    
    // read from file.
    NSData *plistData = [NSData dataWithContentsOfFile:path];
    
    NSPropertyListFormat format;
    //  NSMutableDictionary* md;
    NSString *error;
    
    abRecordFullContentMD5Dict = [[NSMutableDictionary alloc] initWithDictionary:[NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error]];
    
    if(!abRecordFullContentMD5Dict)
    {
        [error release];
    }
}

- (void)makeTempSnapshot
{
    MemRecord* mRec;
    
    ABRecordID cID;
    
  //  NSMutableArray* retContacts;
    
    CFIndex i, count=0;
    
    CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(abRef);
    if (all) {
        count = CFArrayGetCount(all);
    }
    
    
   // retContacts = [NSMutableArray arrayWithCapacity:count];
    
    for(i = 0; i < count; i++ )
    {
        ABRecordRef person = CFArrayGetValueAtIndex(all, i);
        
        cID = ABRecordGetRecordID(person);
        
        // 生成快照记录
        mRec = [[MemRecord alloc] init];
        
        mRec.serverId = -1;
        
        mRec.version = -1;
        
        mRec.realABID = cID;
        
        mRec.record = person;
        
        mRec.portraitVersion = -1;
        
        mRec.groupName = @"groupName";//[[[NSString alloc] initWithString:@"groupName"] autorelease];
        
        mRec.portraitMD5 = @"md5";[[[NSString alloc] initWithString:@"md5"] autorelease];
        
        [arrayData addObject:mRec];
        
        [mRec release];
    }
    if (all) {
        CFRelease(all);
        
        all = nil;
    }
    
}


#pragma mark - the old methods.
- (void)initArrayData {
	if (arrayData == nil){
		arrayData = [[NSMutableArray alloc] init];
        
		[self loadFromFile];        //读取存储的MappingInfo
	}
}

#pragma mark saveToFile
/*
 * 保存 MappingInfo 到沙盒路径
 */
- (void)saveToFile  //保存 MappingInfo 到沙盒路径
{
	NSFileManager *fileManager = [NSFileManager defaultManager];  //创建文件管理器

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
	//更改到待操作的目录下
	[fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	//创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
	//获取文件路径
	[fileManager removeItemAtPath:@"memAB.log" error:nil];
    
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"memAB.log"];

	NSMutableData *writer = [[NSMutableData alloc] init]; 	//创建数据缓冲
	
	UInt32 nArrayCount = [arrayData count];
    
	MemRecord* memRecord;
    
	for (CFIndex i = 0; i < nArrayCount; i++){   //将所有MemRecord 写入writer
		memRecord = [arrayData objectAtIndex:i];
        
        NSTimeInterval createDate = [memRecord.lastCheckCreateDate timeIntervalSince1970];
        
        NSTimeInterval modifyDate = [memRecord.lastCheckModifyDate timeIntervalSince1970];
        
		NSString *value = [[NSString alloc]initWithFormat:@"%d,%d,%d,%.6lf,%.6lf,%@,%d,%@,", memRecord.realABID, memRecord.serverId, memRecord.version,              createDate, modifyDate, memRecord.groupName, memRecord.portraitVersion, memRecord.portraitMD5];
        
		[writer appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        
        [value release];
	}
    
	//将其他数据添加到缓冲中
	//将缓冲的数据写入到文件中
	[writer writeToFile:path atomically:YES];
    
	[writer release];
}

- (void)allocMemRecord:(NSString *)string1 string2:(NSString *)string2 string3:(NSString *)string3 string4:(NSString *)string4
               string5:(NSString *)string5 string6:(NSString *)string6 string7:(NSString *)string7 string8:(NSString *)string8{
    
    MemRecord *memRecord = [[MemRecord alloc]init];
  
    memRecord.realABID = [string1 intValue];
    
    memRecord.serverId = [string2 intValue];
    
    memRecord.version = [string3 intValue];
    
    NSTimeInterval createDate = [string4 doubleValue];
    
    NSTimeInterval modifyDate = [string5 doubleValue];
    
    if (createDate == 0){
        memRecord.lastCheckCreateDate = nil;
    }
    else{
        NSDate *tmp = [[NSDate alloc] initWithTimeIntervalSince1970:createDate];
        
        memRecord.lastCheckCreateDate = tmp;
        
        [tmp release];
    }
    
    if (modifyDate == 0){
        memRecord.lastCheckModifyDate = nil;
    }
    else{
        NSDate *tmp = [[NSDate alloc] initWithTimeIntervalSince1970:modifyDate];
        
        memRecord.lastCheckModifyDate = tmp;
        
        [tmp release];
    }
    
    if ([string6 compare:@"(null)"]==NSOrderedSame){
        memRecord.groupName = nil;
    }
    else{
        memRecord.groupName = string6;//[[[NSString alloc] initWithString:string6] autorelease];
    }
    
    memRecord.portraitVersion = [string7 intValue];
    
    if ([string8 compare:@"(null)"] == NSOrderedSame){
        memRecord.portraitMD5 = nil;
    }
    else{
        memRecord.portraitMD5 = string8;//[[[NSString alloc] initWithString:string8] autorelease];
    }
    
    [arrayData addObject:memRecord];
    
    [memRecord release];
}

#pragma mark loadFromFile
/*
 * 从沙盒路径中读取存储的MappingInfo
 */
- (void)loadFromFile   //读取存储的MappingInfo
{
	NSFileManager *fileManager = [NSFileManager defaultManager];  //创建文件管理器
	//参数NSDocumentDirectory要获取那种路径
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
	//更改到待操作的目录下
	[fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	//获取文件路径
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"memAB.log"];
	
	if ([fileManager fileExistsAtPath:path] == NO){
        return;
	}
    
	NSData *reader = [NSData dataWithContentsOfFile:path];
    
	NSString *value = [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
    
	NSArray *array = [value componentsSeparatedByString:@","];  //从字符串分割到数组－ componentsSeparatedByString:
	
    [arrayData removeAllObjects];
    
	UInt32 nArrayCount = [array count];//-1
    
    /////************* Updated by Kevin Zhang on Feb,25 2013*****************************************///
    int counts = (nArrayCount%8) == 0 ? (nArrayCount/8) : (nArrayCount/8+1);
    
    int j = 0;
    
    for (int i = 0; i < counts; i++) {    //读取存储的MappingInfo    
        NSString *string1 = @"";
        
        if (j > nArrayCount-1) {
            break;
        }
        else{
            string1 = [array objectAtIndex:j];
            
            ++j;
        }
        
        NSString *string2 = @"";
        
        if (j > nArrayCount-1) {
            break;
            string2 = @"";
        }
        else{
            string2 = [array objectAtIndex:j];
            
            ++j;
        }
        
        NSString *string3 = @"";
        
        if (j > nArrayCount-1) {
            break;
            string3 = @"";
        }
        else{
            string3 = [array objectAtIndex:j];
            
            ++j;
        }
        
        NSString *string4 = @"";
        
        if (j > nArrayCount-1) {
            break;
            string4 = @"";
        }
        else{
            string4 = [array objectAtIndex:j];
            
            ++j;
        }
        
        NSString *string5 = @"";
        
        if (j > nArrayCount-1) {
            break;
            string5 = @"";
        }
        else{
            string5 = [array objectAtIndex:j];
            
            ++j;
        }
        
        NSString *string6 = @"";
        
        if (j > nArrayCount-1) {
            break;
            string6 = @"";
        }
        else{
            string6 = [array objectAtIndex:j];
            
            ++j;
        }
        
        NSString *string7 = @"";
        
        if (j > nArrayCount-1) {
            break;
            string7 = @"";
        }
        else{
            string7 = [array objectAtIndex:j];
            
            ++j;
        }
        
        NSString *string8 = @"";
        
        if (j > nArrayCount-1) {
            break;
            string8 = @"";
        }
        else{
            string8 = [array objectAtIndex:j];
            
            ++j;
        }
       
       [self allocMemRecord:string1 string2:string2 string3:string3 string4:string4 string5:string5 string6:string6 string7:string7 string8:string8];
    }
    
	[value release];
}



@end
