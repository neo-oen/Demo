//
//  HB_ContactDataTool.h
//  HBZS_iOS
//
//  Created by zimbean on 15/7/7.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//
// 这个类用ARC，编译，


#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "HB_ContactModel.h"

@interface HB_ContactDataTool : NSObject

+(ABAddressBookRef)getAddressBook;

/**
 *  获取所有联系人的ID
 */
+(NSArray *)contactGetAllContactID;
/**
 *  获取所有联系人的名字，ID，头像  (HB_ContactSimpleModel)
 */
+(NSArray *)contactGetAllContactSimpleProperty;
/**
 *  获取某一个联系人的所有属性
 */
+(NSDictionary *)contactPropertyArrWithRecordID:(ABRecordID)recordID;
/**
 *  根据ID获取一个联系人的部分属性（name,id,icon）
 */
+(NSDictionary *)contactSimplePropertyArrWithRecordID:(ABRecordID)recordID;
/**
 *  获取所有联系人的全部属性模型（HB_contactModel）
 */
+(NSArray *)contactGetAllContactAllProperty;

/**
 *  更新、添加 一个联系人(自动识别是更新，还是添加)
 */
+(NSInteger)contactAddPeopleByModel:(HB_ContactModel *)model;
/**
 *  添加联系人（不做识别，新添加）
 */
+(BOOL)contactAddPeopleWhileTimeMachineByModel:(HB_ContactModel *)model;

/**
 *  删除联系人
 */
+ (BOOL)contactDeleteContactByID:(int)recordID;

/**
 *  批量删除联系人
 */
+ (void)contactBatchDeleteByArr:(NSArray *)simModelArr;

/**
 *  根据模型中的lastName,middleName,FirstName拼凑完整的名字
 */
+(NSString *)contactGetFullNameWithModel:(HB_ContactModel*)model;

#pragma mark - 联系人头像相关
/**
 *  设置联系人头像
 */
+(BOOL)contactUpdateIcon:(UIImage *)icon withRecordID:(int)recordID;
/**
 *  该联系人是否有头像
 */
+(BOOL)contactIsHasIconWithRecordID:(int)recordID;
/**
 *  删除联系人头像
 */
+(BOOL)contactRemoveIconWithRecordID:(int)recordID;


@end
