//
//  GroupData.m
//  CTPIM
//
//  Created by  Kevin Zhang、 scanmac on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GroupData.h"
#import "HBZSAppDelegate.h"

#import "GobalSettings.h"

@implementation GroupData

#pragma mark  获取所有通讯录中群组的数量
+ (NSInteger)getAllGroupsCount{
    NSInteger result = 0;
    
	HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (nil == addressBookRef) {
        vosLog(@"getAllGroupsCount, addressBookRef == nil.......");
        return result;
    }
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    if (nil == allGroups) {
        vosLog(@"getAllGroupsCount, allGroups == nil.......");
        
        return result;
    }
    
    result = (NSUInteger)CFArrayGetCount(allGroups);
    
    if (nil != allGroups){
        CFRelease(allGroups);
        allGroups = nil;
    }
    
    return result;
}


#pragma mark 获取所有群组的id和名称
+ (NSMutableArray*)getAllGroupIDAndGroupNameArray{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    NSMutableArray *mutableArray = nil;
    
    if (nil == addressBookRef) {
        vosLog(@"getGroupIDAndGroupNameArray addressBookRef is nil");
        return nil;
    }
    
    ABRecordRef groupRecord = ABPersonCreate();
    
    if (nil == groupRecord){
        vosLog(@"getGroupIDAndGroupNameArray groupRecord is nil");

        return nil;
    }
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    if (nil == allGroups) {
        vosLog(@"getAllGroupIDAndGroupNameArray allGroups is nil");
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
        GroupItem *groupItem = [[GroupItem alloc]init];
        
        NSString *temp = (NSString*)ABRecordCopyValue(group,kABGroupNameProperty);
        
        groupItem.groupName = temp;//[NSString stringWithFormat:@"%@",temp];
        
        if (temp) {
            [temp release];
        }
        
        groupItem.groupID = ABRecordGetRecordID(group);
        
        [mutableArray addObject:groupItem];
        
        [groupItem release];
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

#pragma mark 增加新群组
+ (BOOL) addNewGroup:(NSString*) groupName{
    ABRecordRef groupRecord = nil;
    
    BOOL bReturn = NO;
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (nil == addressBookRef) {
        vosLog(@"addNewGroup addressBookRef is nil");
        goto ERROR;
    }
    
    if (nil == groupName) {
        vosLog(@"addNewGroup groupName is nil");
       
        return NO;
    }
    
    groupRecord = ABGroupCreate();
    
    if (nil == groupRecord) {
        vosLog(@"addNewGroup groupRecord is nil");
        
        return NO;
    }
    
    ABRecordSetValue(groupRecord, kABGroupNameProperty, groupName, nil);
    
    bReturn = ABAddressBookAddRecord(addressBookRef, groupRecord, nil);
    
    ABAddressBookSave(addressBookRef, nil);
    
    
ERROR:
    
    if (nil != groupRecord) {
        CFRelease(groupRecord);
    }
    
    return  bReturn;
}

#pragma mark ///////  deleteGroupMemberByGroupID   ////////
+ (BOOL) deleteGroupMemberByGroupID:(NSInteger) groupID{
    ABRecordRef groupRecord = nil;
    
    BOOL bReturn = NO;
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (nil == addressBookRef) {
        vosLog(@"deleteGroupMemberByGroupID addressBookRef is nil");
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

#pragma mark ///////// editGroupNameByGroupID /////////////
+ (BOOL)editGroupNameByGroupID:(GroupItem*) groupItem{
    ABRecordRef groupRecord = nil;
    
    BOOL bReturn = NO;
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (nil == addressBookRef) {
        vosLog(@"editGroupNameByGroupID addressBookRef is nil");
        return bReturn;
    }
    
    groupRecord = ABAddressBookGetGroupWithRecordID(addressBookRef, groupItem.groupID);
    
    bReturn = ABRecordSetValue(groupRecord, kABGroupNameProperty, groupItem.groupName,nil);
    
    ABAddressBookSave(addressBookRef, nil);
    
    return bReturn;
}

#pragma mark ///////// getGroupIDByGroupName  ///////
+ (NSInteger) getGroupIDByGroupName:(NSString*) groupStrName{
    NSInteger ret = -1;
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;

    if (nil == addressBookRef) {
        vosLog(@"getGroupIDByGroupName addressBookRef is nil");
        return -1;
    }
    
    if (nil == groupStrName) {
        vosLog(@"getGroupIDByGroupName groupStrName is nil");
        //goto ERROR;
        return -1;
    }
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    if (allGroups == nil) {
        vosLog(@"getGroupIDByGroupName allGroups is nil");
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

#pragma mark //////////  isGroupNameExist  /////////
+ (BOOL) isGroupNameExist:(NSString*) groupStrName{
    BOOL bReturn = YES;
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (nil == addressBookRef) {
        vosLog(@"isGroupNameExist addressBookRef is nil");
        return YES;
    }
    
    if (nil == groupStrName) {
        vosLog(@"isGroupNameExist groupStrName is nil");
        return YES;
    }
    
    ABRecordRef groupRecord = ABPersonCreate();
    
    if (nil == groupRecord){
        vosLog(@"isGroupNameExist groupRecord is nil");
        return YES;
    }
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    if (nil == allGroups) {
        vosLog(@"isGroupNameExist allGroups is nil");
        
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

+ (BOOL)isGroupNameExistExceptOwn:(GroupItem*) groupItem{
    BOOL bReturn = YES;
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (nil == addressBookRef) {
        vosLog(@"isGroupNameExistExceptOwn addressBookRef is nil");
        return YES;
    }
    
    if (nil == groupItem) {
        vosLog(@"isGroupNameExistExceptOwn groupItem is nil");
      
        return YES;
    }
    
    ABRecordRef groupRecord = ABPersonCreate();
    
    if (nil == groupRecord){
        vosLog(@"isGroupNameExist groupRecord is nil");
      
        return YES;
    }
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    
    if (nil == allGroups) {
        vosLog(@"isGroupNameExist allGroups is nil");
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

#pragma mark /////////////  getAllGroupsByContactID  ///////////////
+ (NSMutableArray*)getAllGroupsByContactID:(NSInteger) contactID{
    NSMutableArray *strArray = [[[NSMutableArray alloc]init]autorelease];
    
    CFArrayRef allGroup = nil;
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(delegate == nil){
        vosLog(@"getAllGroupsByContactID,delegate == nil");
        return nil;
    }
    
    ABAddressBookRef addressBook = delegate.getAddressBookRef;

    if(addressBook == nil){
        vosLog(@"getAllGroupsByContactID,addressBook == nil");
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
                
                if(nil != value){
                    [strArray addObject:value];
                    
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

#pragma mark //// getGroupAllContactIDByID  //////
+ (NSMutableArray*) getGroupAllContactIDByID:(NSInteger) groupID{
    HBZSAppDelegate *delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(delegate == nil){
        return nil;
    }
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (nil == addressBookRef) {
        return  nil;
    }
    
    ABRecordRef groupRecord = ABAddressBookGetGroupWithRecordID(addressBookRef, groupID);
    
    if (nil == groupRecord){
        vosLog(@"getGroupAllContactIDByID groupRecord is nil");
     
        return  nil;
    }
    
    CFArrayRef recordArray = ABGroupCopyArrayOfAllMembers(groupRecord);
    
    if (nil == recordArray){
        vosLog(@"getGroupAllContactIDByID recordArray is nil");
     
        return nil;
    }
    
    NSUInteger recordCount = CFArrayGetCount(recordArray);
    
    for (NSInteger i = 0; i < recordCount; i ++) {
        ABRecordRef record = CFArrayGetValueAtIndex(recordArray, i);
        
        NSInteger contactID = (NSInteger)ABRecordGetRecordID(record);
        
        NSString* str = [[NSString alloc]initWithFormat:@"%d", contactID];
        
        [array addObject:str];
        
        [str release];
    }
    
    if (recordArray) {
        CFRelease(recordArray);
    }
    
    return array;
}


@end
