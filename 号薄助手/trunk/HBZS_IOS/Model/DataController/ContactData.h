//
//  ContactData.h
//  CTPIM
//
//  Created by  Kevin Zhang、 scanmac on 11-9-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "PinYinToT9Number.h"
#import "SearchItem.h"
#import "contactItems.h"

@interface ContactData : NSObject {
    
}

/* 
 *  获取通讯录中所有联系人的信息
 */
+ (NSMutableArray*) getAllContactMembers;

/*
 * 获取群组中所有联系人
 */
+ (NSMutableArray*) getGroupAllContactMembers:(NSUInteger) groupID;

+ (ABRecordRef)getRecordByID:(NSUInteger) recordID; //bug

+ (CFDataRef) getPersonImageByID:(NSUInteger) personID;

+ (NSString*) getPersonNameByID:(NSUInteger) personID;

+ (NSInteger) getRecordIDByPhone:(NSString*) phoneStr;

+ (NSString*) getRecordPhoneByID:(NSInteger) personID;

+ (NSString*) getRecordEmailByID:(NSInteger) personID;

+ (NSString*) getRecordCompnyByID:(NSInteger) personID;

+ (NSMutableArray*) getAllRecordOnePhone;

+ (NSMutableArray*) getAllRecordOneEmail;

+ (BOOL) deleteContactByID:(NSInteger) personID;

//仅联系人选择用，且NSMutableArray的元素为NSString
+ (BOOL) deleteContacts:(NSMutableArray*) mutableArray;

+ (BOOL) addGroupContacts:(NSInteger) groupID array:(NSMutableArray*) mutableArray;

+ (BOOL) removeGroupContacts:(NSInteger) groupID array:(NSMutableArray*) mutableArray;

+ (NSMutableArray*) searchContactStrByNameOrPhone:(NSString*) str;

+ (NSMutableArray*) searchContactStrByPhone:(NSString*) str;

+ (CFArrayRef) getSearchRecordArray:(NSString*) str;

+ (NSMutableArray*) getSearchAllContact;

+ (SearchItem*) getRecordSearchItemByID:(NSInteger) personID;

+ (SearchItem *)getSearchItemByRecordId:(NSInteger)recordId;

+ (SearchItem*) getSearchItemByRecord:(ABRecordRef) person;

+ (BOOL)IsExistContact:(NSInteger)contactId;

+ (BOOL)IsAddressBookChange;

+ (NSMutableArray*) getPersonAllID;

//personIDArray为NSString
+ (NSMutableArray*) getPersonSaveLastTime:(NSArray*) personIDArray;

+ (NSMutableArray*) getSearchByArrayID:(NSMutableArray*) arrayID;

//判断号码是否在指定联系人中
+ (BOOL)IsPhoneExistRecordContact:(NSUInteger) recordID phoneStr:(NSString*) phoneStr;

+ (NSInteger)getAllContactsCount;

@end
