// 联系人、群组(实体类)
//  ContactItems.h
//  HBZS_IOS
//
//  Created by Kevin Zhang、yingxin on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark 群组Item类
@interface GroupItem : NSObject {
    
}

@property (nonatomic, retain) NSString *groupName;

@property (nonatomic, assign) NSInteger groupID;

+ (GroupItem*)groupItemAlloc;

@end

#pragma mark 拨号记录Item类
@interface DialItem : NSObject{
 
}

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *phone;

@property (nonatomic, retain) NSMutableArray *times;

@property (nonatomic,assign) NSInteger contactID;

+ (DialItem*)dialItemAlloc;

@end

#pragma mark ContactMember
@interface ContactMember : NSObject {
  
}

@property (nonatomic, retain)NSString *name;

@property (nonatomic, retain)NSString *phone;

@property (nonatomic) NSUInteger ID;

+ (ContactMember*)contactMemberAlloc;

@end

#pragma mark 联系人信息
@interface ContactInfoItem : NSObject {

}

@property (nonatomic, retain) NSString *typeName;

@property (nonatomic, retain) NSString *content;

@property (nonatomic) NSInteger count;

+ (ContactInfoItem*)contaceInfoItemAlloc;

@end

#pragma mark 自定义IP  item
@interface CustomIPItem : NSObject {
 
}

@property (nonatomic, retain) NSString* number;

@property (nonatomic, retain) NSString* name;

+ (CustomIPItem*)customIPItemAlloc;

@end

#pragma mark  CustomServiceItem
@interface CustomServiceItem : NSObject {

}

@property (nonatomic, retain) NSString* ID;

@property (nonatomic, retain) NSString* nickname;

@property (nonatomic, retain) NSString* content;

@property (nonatomic, retain) NSString* time;

@property (nonatomic) NSInteger replycontentid;

@property (nonatomic) NSInteger userreplysatisfactory;

@property (nonatomic, retain) NSString* satisfactorydate;

+ (CustomServiceItem*)customServiceItemAlloc;

@end



@interface ContactItems : NSObject

@end
