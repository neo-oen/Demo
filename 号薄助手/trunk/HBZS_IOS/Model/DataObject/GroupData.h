//  群组Data
//  GroupData.h
//  CTPIM
//
//  Created by  Kevin Zhang、 scanmac on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactItems.h"



@interface GroupData : NSObject {
  
}

+ (NSMutableArray*)getAllGroupIDAndGroupNameArray;  //获取通讯录中所有的群组ID和群组名称

+ (BOOL) deleteGroupMemberByGroupID:(NSInteger) groupID; //通过群组ID 删除群组

+ (BOOL)editGroupNameByGroupID:(GroupItem*) groupItem;  //修改群组名称

+ (BOOL) addNewGroup:(NSString*) groupName;  //添加新群组

+ (NSInteger) getGroupIDByGroupName:(NSString*) groupStrName;  //通过群组名称获取群组ID

+ (BOOL) isGroupNameExist:(NSString*) groupStrName;  //判断群组名称是否存在

+ (BOOL) isGroupNameExistExceptOwn:(GroupItem*) groupItem;

+ (NSMutableArray*)getAllGroupsByContactID:(NSInteger) contactID;  //读取联系人所在的所有群组

+ (NSMutableArray*) getGroupAllContactIDByID:(NSInteger) groupID; //读取群组中所有的联系人ID

+ (NSInteger)getAllGroupsCount;  //读取群组个数

@end
