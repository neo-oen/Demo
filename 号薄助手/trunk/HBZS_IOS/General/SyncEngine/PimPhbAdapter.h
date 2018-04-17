//
//  PimPhbAdapter.h
//  HBZS_IOS
//
//  Created by RenTao (tour_ren@163.com) on 1/6/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

// (kABPersonPhoneProperty)号码类：
// (kABPersonPhoneMobileLabel)移动电话——常用手机(mobilePhone)
// (kABPersonPhoneIPhoneLabel)iphone——商务手机(workMobilePhone)
// (kABHomeLabel)住宅——常用固话(telephone)
// (kABWorkLabel)工作——商务固话(workTelephone)
// (kABPersonPhoneMainLabel)主要——家庭固话(homeTelephone)
// (kABPersonPhoneHomeFAXLabel)住宅传真——家庭传真(homefax)
// (kABPersonPhoneWorkFAXLabel)工作传真——常用传真(fax)
// (kSABFaxLabel) 传真——商务传真(workfax)

// phones
// (kABPersonPhoneProperty)号码类：
// (kABPersonPhoneMobileLabel)移动电话——常用手机(mobilePhone)
// (kABPersonPhoneIPhoneLabel)iphone——商务手机(workMobilePhone)
// (kABHomeLabel)住宅——常用固话(telephone)
// (kABWorkLabel)工作——商务固话(workTelephone)
// (kABPersonPhoneMainLabel)主要——家庭固话(homeTelephone)
// (kABPersonPhoneHomeFAXLabel)住宅传真——家庭传真(homefax)
// (kABPersonPhoneWorkFAXLabel)工作传真——常用传真(fax)
// (kSABFaxLabel) 传真——商务传真(workfax)

NSString* addKeyValue2Comment(NSString* key, NSString* value, NSString* comment);

/*
 * 删除通讯录中联系人
 */
UInt32 PimPhb_DeleteContact(ABAddressBookRef abRef,NSArray *recordIdList);

/*
 * 删除本地通讯录中的所有联系人。
 */
UInt32 PimPhb_DeleteAllContact(ABAddressBookRef abRef);

/*
 * 根据群组ID删除通讯录中的群组
 */
UInt32 PimPhb_DeleteGroup(ABAddressBookRef abRef,NSArray *groupIdList);
/*
 * 删除通讯录中所有群组
 */
UInt32 PimPhb_DeleteAllGroup(ABAddressBookRef abRef);

//将服务器返回的日期的字符串转换成本地的Date数据。
NSDate* String2Date(NSString* strDate);

NSString* Date2String(NSDate* date);

/*
 * 根据ABRecordRef来构造相应的Group和Contact，以便和服务器交互。
 * 必须先设置完gb的serverId才能调用PimPhb_ABRecord2Group。
 * contact2groupDict：保存PG（person‘s abID－》group serverId）关系的字典；
 * groupMR：保存相应的MemRecord（person’s abID－》group‘s MemRecord）到PG关系字典。
 */
UInt32 PimPhb_ABRecord2Group(ABRecordRef record, Group_Builder* gb, NSMutableDictionary* contact2groupDict, MemRecord* groupMR);
/*
 * contact2groupDict：之前的PG关系字典，用来构造Contact里面的groupList。
 */
UInt32 PimPhb_ABRecord2Contact(ABRecordRef record, Contact_Builder* cb, NSMutableDictionary* contact2groupDict);

/*
 * 根据record 单纯构建db 不考虑其他属性
 */
Contact * Just_ABRecord2Contact(ABRecordRef record);


/*
 * 根据Group和Contact来构建本地的通讯录记录。
 */
UInt32 PimPhb_Group2ABRecord(Group* pGroup, ABRecordRef group);

UInt32 PimPhb_Contact2ABRecord(Contact* pContact, ABRecordRef person);

/*
 *  根据Contact／Group添加记录到本地的通讯录数据库，已经没有使用。
 */
UInt32 PimPhb_AddContact(ABAddressBookRef abRef, Contact* pContact);

UInt32 PimPhb_AddGroup(ABAddressBookRef abRef, Group* pGroup);

/*
 * 获取当前组的成员信息
 */
UInt32 PimPhb_FindContactsInGroup(ABRecordRef group, NSMutableDictionary* contat2groupDict);

/*
 * 性别代号转换成中文
 */
NSString *covertGender(NSString *str);

/*
 * 星座代号转换成中文
 */
NSString *covertConstellation(NSString *str);

/*
 * 血型代号转换成中文
 */
NSString *covertBlood(NSString *str);
