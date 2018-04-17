//  群组Data
//  GroupData.h
//  CTPIM
//
//  Created by  Kevin Zhang、 scanmac on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "HB_GroupModel.h"

@interface GroupData : NSObject {
  
}
/** 获取通讯录中所有的群组ID和群组名称 */
+ (NSMutableArray*)getAllGroupIDAndGroupNameArray;
/** 通过群组ID 删除群组 */
+ (BOOL) deleteGroupMemberByGroupID:(NSInteger) groupID;
/**  修改群组名称 */
+ (BOOL)editGroupNameByGroupID:(NSInteger)groupID withNewGroupName:(NSString *)groupName;
/**  添加新群组 */
+ (BOOL) addNewGroupWithGroupName:(NSString*) groupName;
/**  通过群组名称获取群组ID */
+ (NSInteger) getGroupIDByGroupName:(NSString*) groupStrName;
/**  通过群组ID获取群组名称 */
+(NSString *)getGroupNameByGroupID:(NSInteger)groupID;
/**  判断群组名称是否存在 */
+ (BOOL) isGroupNameExist:(NSString*) groupStrName;
+ (BOOL) isGroupNameExistExceptOwn:(HB_GroupModel*) groupItem;

/**  读取联系人所在的所有群组（groupID数组） */
+ (NSMutableArray*)getAllGroupsIDByContactID:(NSInteger) contactID;
/**  读取群组中所有的联系人ID (string数组) */
+ (NSMutableArray*) getGroupAllContactIDByID:(NSInteger) groupID;
/**  读取群组个数 */
+ (NSInteger)getAllGroupsCount;
/**  添加联系人到某一个群组中 */
+ (BOOL)addPerson:(ABRecordID)personID toGroup:(ABRecordID)groupID;
/**  从群组中移出某一联系人 */
+ (BOOL)removePerson:(ABRecordID)personID fromGroup:(ABRecordID)groupID;

@end
