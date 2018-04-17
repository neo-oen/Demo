//
//  GroupData.m
//  CTPIM
//
//  Created by  Kevin Zhang、 scanmac on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GroupData.h"
#import "GobalSettings.h"
#import "HBZSAppDelegate.h"

@implementation GroupData
-(void)dealloc{
    [super dealloc];
}
#pragma mark - 获取通讯录句柄
/** 获取通讯录句柄 */
+(ABAddressBookRef)getAddressBook{
    HBZSAppDelegate * appDelegate = (HBZSAppDelegate *)[UIApplication sharedApplication].delegate;
    return [appDelegate getAddressBookRef];
}
#pragma mark  - 获取所有通讯录中群组的数量
+ (NSInteger)getAllGroupsCount{
    NSInteger result = 0;
    
    ABAddressBookRef addressBookRef = [self getAddressBook];
    
    if (nil == addressBookRef) {
        ZBLog(@"getAllGroupsCount, addressBookRef == nil.......");
        return result;
    }
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    if (nil == allGroups) {
        ZBLog(@"getAllGroupsCount, allGroups == nil.......");
        
        return result;
    }
    
    result = (NSUInteger)CFArrayGetCount(allGroups);
    
    if (nil != allGroups){
        CFRelease(allGroups);
        allGroups = nil;
    }
    return result;
}


#pragma mark - 获取所有群组的id和名称
+ (NSMutableArray*)getAllGroupIDAndGroupNameArray{
    
    ABAddressBookRef addressBookRef = [self getAddressBook];
    
    NSMutableArray *mutableArray = nil;

    if (nil == addressBookRef) {
        ZBLog(@"getGroupIDAndGroupNameArray addressBookRef is nil");
        return nil;
    }
    
    ABRecordRef groupRecord = ABPersonCreate();
    
    if (nil == groupRecord){
        ZBLog(@"getGroupIDAndGroupNameArray groupRecord is nil");

        return nil;
    }
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    if (nil == allGroups) {
        ZBLog(@"getAllGroupIDAndGroupNameArray allGroups is nil");
        if (nil != allGroups){
            CFRelease(allGroups);
            
            allGroups = nil;
        }
        
        if (groupRecord != nil) {
            CFRelease(groupRecord);
            
            groupRecord = nil;
        }
    
        return nil;
    }
    
    mutableArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (id group in (NSArray *) allGroups)
    {
        
        NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
        
        NSString *name = (NSString*)ABRecordCopyValue(group,kABGroupNameProperty);
        
        if (name) {
            [dict setObject:name forKey:@"groupName"];
        }
        [name release];

        NSInteger groupID = ABRecordGetRecordID(group);
        [dict setObject:[NSNumber numberWithInteger:groupID] forKey:@"groupID"];
        
        [mutableArray addObject:dict];
        
        [dict release];
    }
    
    if (nil != allGroups){
        CFRelease(allGroups);
        
        allGroups = nil;
    }
    
    if (nil != groupRecord){
        CFRelease(groupRecord);
        
        groupRecord = nil;
    }
    return mutableArray;
}

#pragma mark - 增加新群组
+ (BOOL) addNewGroupWithGroupName:(NSString*) groupName{
    BOOL bReturn = NO;
    
    ABAddressBookRef addressBookRef = [self getAddressBook];
    
    if (nil == groupName) {
        ZBLog(@"addNewGroup groupName is nil");
        return NO;
    }
    
    ABRecordRef groupRecord = ABGroupCreate();
    
    if (nil == groupRecord) {
        ZBLog(@"addNewGroup groupRecord is nil");
        return NO;
    }
    
    ABRecordSetValue(groupRecord, kABGroupNameProperty, groupName, nil);
    
    bReturn = ABAddressBookAddRecord(addressBookRef, groupRecord, nil);
    
    ABAddressBookSave(addressBookRef, nil);
    
    if (nil != groupRecord) {
        CFRelease(groupRecord);
    }
    
    return  bReturn;
}

#pragma mark - deleteGroupMemberByGroupID
+ (BOOL) deleteGroupMemberByGroupID:(NSInteger) groupID{
    ABRecordRef groupRecord = nil;
    
    BOOL bReturn = NO;
    
    ABAddressBookRef addressBookRef = [self getAddressBook];

    if (nil == addressBookRef) {
        ZBLog(@"deleteGroupMemberByGroupID addressBookRef is nil");
        return bReturn;
    }
    
    groupRecord = ABAddressBookGetGroupWithRecordID(addressBookRef, groupID);
    
    if (groupRecord == nil) {
        return bReturn;
    }
    
    bReturn = ABAddressBookRemoveRecord(addressBookRef, groupRecord, nil);
    
    ABAddressBookSave(addressBookRef, nil);
    
    return bReturn;
}

#pragma mark - 根据分组id 编辑分组名字
+ (BOOL)editGroupNameByGroupID:(NSInteger)groupID withNewGroupName:(NSString *)groupName{
    BOOL bReturn = NO;
    
    ABAddressBookRef addressBookRef = [self getAddressBook];

    ABRecordRef groupRecord = ABAddressBookGetGroupWithRecordID(addressBookRef, groupID);
    bReturn = ABRecordSetValue(groupRecord, kABGroupNameProperty, groupName,nil);
    
    ABAddressBookSave(addressBookRef, nil);
    
    return bReturn;
}

#pragma mark - getGroupIDByGroupName
+ (NSInteger) getGroupIDByGroupName:(NSString*) groupStrName{
    NSInteger ret = -1;
    
    ABAddressBookRef addressBookRef = [self getAddressBook];

    if (nil == addressBookRef) {
        ZBLog(@"getGroupIDByGroupName addressBookRef is nil");
        return -1;
    }
    
    if (nil == groupStrName) {
        ZBLog(@"getGroupIDByGroupName groupStrName is nil");
        //goto ERROR;
        return -1;
    }
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    if (allGroups == nil) {
        ZBLog(@"getGroupIDByGroupName allGroups is nil");
        if (allGroups){
            CFRelease(allGroups);
            
            allGroups = nil;
        }
        
        return -1;
    }
    
    NSString *name;
    
    ABRecordID recId;
    
    for (id group in (NSArray *) allGroups)
    {
        name = (NSString*)ABRecordCopyValue(group, kABGroupNameProperty);
        
        recId = ABRecordGetRecordID(group);
        
        if ([name compare:groupStrName] == NSOrderedSame){
            
            ret = recId;
            
            if (name) {
                [name release];
                
                name = nil;
            }
            
            break;
        }
        
        if (name) {
            [name release];
            
            name = nil;
        }
    }
    
    if (allGroups){
        CFRelease(allGroups);
        
        allGroups = nil;
    }
    return ret;
}
#pragma mark - 通过群组ID获取群组名称
+(NSString *)getGroupNameByGroupID:(NSInteger)groupID{
    NSString * groupName=nil;
    ABAddressBookRef addressBookRef = [self getAddressBook];
    if (addressBookRef) {
        ABRecordRef group=ABAddressBookGetGroupWithRecordID(addressBookRef, groupID);
        groupName=(NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
    }
    return [groupName autorelease];
}

#pragma mark - isGroupNameExist
+ (BOOL) isGroupNameExist:(NSString*) groupStrName{
    BOOL bReturn = YES;
    
    ABAddressBookRef addressBookRef = [self getAddressBook];
    
    if (nil == addressBookRef) {
        ZBLog(@"isGroupNameExist addressBookRef is nil");
        return YES;
    }
    
    if (nil == groupStrName) {
        ZBLog(@"isGroupNameExist groupStrName is nil");
        return YES;
    }
    
    ABRecordRef groupRecord = ABPersonCreate();
    
    if (nil == groupRecord){
        ZBLog(@"isGroupNameExist groupRecord is nil");
        return YES;
    }
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    if (nil == allGroups) {
        ZBLog(@"isGroupNameExist allGroups is nil");
        
        if (nil != groupRecord) {
            CFRelease(groupRecord);
        }

        return YES;
    }
    
    NSString *name = @"";
    
    for (id group in (NSArray *) allGroups)
    {
        name = (NSString*)ABRecordCopyValue(group,kABGroupNameProperty);
        
        if ([name compare:groupStrName] == NSOrderedSame){
            bReturn = YES;
            
            if (nil != allGroups) {
                CFRelease(allGroups);
            }
            
            if (nil != groupRecord) {
                CFRelease(groupRecord);
            }
            
            if (name) {
                [name release];
                
                name = nil;
            }
            
            return bReturn;
        }
        
        if (name) {
            [name release];
            
            name = nil;
        }
    }
    
    if (nil != allGroups) {
        CFRelease(allGroups);
    }
    
    if (nil != groupRecord) {
        CFRelease(groupRecord);
    }
    
    bReturn = NO;
    
    return bReturn;
}

+ (BOOL)isGroupNameExistExceptOwn:(HB_GroupModel*) groupItem{
    BOOL bReturn = YES;
    
    ABAddressBookRef addressBookRef = [self getAddressBook];
    
    if (nil == addressBookRef) {
        ZBLog(@"isGroupNameExistExceptOwn addressBookRef is nil");
        return YES;
    }
    
    if (nil == groupItem) {
        ZBLog(@"isGroupNameExistExceptOwn groupItem is nil");
      
        return YES;
    }
    
    ABRecordRef groupRecord = ABPersonCreate();
    
    if (nil == groupRecord){
        ZBLog(@"isGroupNameExist groupRecord is nil");
      
        return YES;
    }
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    if (nil == allGroups) {
        ZBLog(@"isGroupNameExist allGroups is nil");
        if (groupRecord) {
            CFRelease(groupRecord);
        }
        
        return YES;
    }
    
    NSString *name;
    
    ABRecordID recId;
    
    for (id group in (NSArray *) allGroups)
    {
        name = (NSString*)ABRecordCopyValue(group,kABGroupNameProperty);
        
        recId = ABRecordGetRecordID(group);
        
        if ([name compare:groupItem.groupName] == NSOrderedSame && recId != groupItem.groupID)
        {
            bReturn = YES;
            
            if (groupRecord) {
                CFRelease(groupRecord);
            }
            
            if (allGroups) {
                CFRelease(allGroups);
            }
            
            if (name) {
                [name release];
                
                name = nil;
            }
            
            return bReturn;
        }
        
        if (name) {
            [name release];
            
            name = nil;
        }
    }
    
    bReturn = NO;
    
    if (groupRecord) {
        CFRelease(groupRecord);
    }
    
    if (allGroups) {
        CFRelease(allGroups);
    }
    return bReturn;
}

#pragma mark - getAllGroupsByContactID
+ (NSMutableArray*)getAllGroupsIDByContactID:(NSInteger) contactID{
    NSMutableArray *strArray = [[[NSMutableArray alloc]init]autorelease];
    
    CFArrayRef allGroup = nil;
    
    ABAddressBookRef addressBook = [self getAddressBook];

    if(addressBook == nil){
        ZBLog(@"getAllGroupsByContactID,addressBook == nil");
        return nil;
    }
    
	CFIndex count = ABAddressBookGetGroupCount(addressBook);
    
    if(count <= 0) {
        goto ERROR;
    }
    
    allGroup = ABAddressBookCopyArrayOfAllGroups(addressBook);
    
    CFIndex groupCount = CFArrayGetCount(allGroup);
    
    if(groupCount <= 0) {
        goto ERROR;
    }
    
    CFIndex groupIndex = 0;
    
    CFIndex myGroupNameCount = 0;
    
	while(groupIndex < groupCount)
	{
		ABRecordRef group = CFArrayGetValueAtIndex(allGroup, groupIndex);

        if(group == nil){
            groupIndex++;
            continue;
        }
        
        CFArrayRef person = ABGroupCopyArrayOfAllMembers(group);
        
        if(person == nil){
            groupIndex++;
            
            continue;
        }
        
        CFIndex personCount = CFArrayGetCount(person);
        
        if(personCount <= 0){
            CFRelease(person);
            
            groupIndex++;
            
            continue;
        }
        
        CFIndex personIndex = 0;
        
        while(personIndex < personCount)
        {
            ABRecordRef oneperson = CFArrayGetValueAtIndex(person, personIndex);
            
            if(oneperson == nil){
                personIndex++;
                
                continue;
            }
            
            ABRecordID onepersonId = ABRecordGetRecordID(oneperson);
            
            if(onepersonId == contactID)
            {
                NSString *value = (NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
                NSInteger groupID = (NSInteger)ABRecordGetRecordID(group);
                
                if(nil != value){
                    [strArray addObject:[NSNumber numberWithInteger:groupID]];
                    
                    myGroupNameCount++;
                    
                    [value release];
                    
                    value = nil;
                }
                
                break;
            }
            
            personIndex++;
        }
        
        CFRelease(person);
        groupIndex++;
	}
    
ERROR:
    
    if (nil != allGroup) {
        CFRelease(allGroup);
    }
    
    return strArray;
}

#pragma mark - getGroupAllContactIDByID
+ (NSMutableArray*) getGroupAllContactIDByID:(NSInteger) groupID{
    
    ABAddressBookRef addressBookRef = [self getAddressBook];
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (nil == addressBookRef) {
        return  nil;
    }
    
    ABRecordRef groupRecord = ABAddressBookGetGroupWithRecordID(addressBookRef, groupID);
    
    if (nil == groupRecord){
        ZBLog(@"getGroupAllContactIDByID groupRecord is nil");
     
        return  nil;
    }
    
    CFArrayRef recordArray = ABGroupCopyArrayOfAllMembers(groupRecord);
    
    if (nil == recordArray){
        ZBLog(@"getGroupAllContactIDByID recordArray is nil");
     
        return nil;
    }
    
    NSUInteger recordCount = CFArrayGetCount(recordArray);
    
    for (NSInteger i = 0; i < recordCount; i ++) {
        ABRecordRef record = CFArrayGetValueAtIndex(recordArray, i);
        
        NSInteger contactID = (NSInteger)ABRecordGetRecordID(record);
        
        NSString* str = [[NSString alloc]initWithFormat:@"%ld", contactID];
        
        [array addObject:str];
        
        [str release];
    }
    
    if (recordArray) {
        CFRelease(recordArray);
    }
    
    return array;
}
#pragma mark -  把联系人添加到指定的组中
/**
 *  把联系人添加到指定的组中
 */
+ (BOOL)addPerson:(ABRecordID)personID toGroup:(ABRecordID)groupID{
    ABAddressBookRef book=[self getAddressBook];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(book, personID);
    ABRecordRef group = ABAddressBookGetGroupWithRecordID(book, groupID);
    
    BOOL result = ABGroupAddMember(group,person,NULL);
    if (result == NO){
        ZBLog(@"错误，不能添加联系人到群组");
        return result;
    }
    if (ABAddressBookHasUnsavedChanges(book)){
        BOOL couldSaveAddressBook = NO;
        couldSaveAddressBook = ABAddressBookSave(book, NULL);
        if (couldSaveAddressBook==NO) {
            ZBLog(@"保存更改出错了。");
        }
    } else {
        ZBLog(@"没有需要保存的修改");
    }
    return result;
}
#pragma mark - 从分组中移出联系人
/**
 *  从分组中移出联系人
 */
+(BOOL)removePerson:(ABRecordID)personID fromGroup:(ABRecordID)groupID{
    ABAddressBookRef book=[self getAddressBook];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(book, personID);
    ABRecordRef group = ABAddressBookGetGroupWithRecordID(book, groupID);
    
    BOOL result = ABGroupRemoveMember(group, person, NULL);
    if (result == NO){
        ZBLog(@"错误，不能移出");
        return result;
    }
    if (ABAddressBookHasUnsavedChanges(book)){
        BOOL couldSaveAddressBook = NO;
        couldSaveAddressBook = ABAddressBookSave(book, NULL);
        if (couldSaveAddressBook==NO) {
            ZBLog(@"保存更改出错了。");
        }
    } else {
        ZBLog(@"没有需要保存的修改");
    }
    return result;
}


@end
