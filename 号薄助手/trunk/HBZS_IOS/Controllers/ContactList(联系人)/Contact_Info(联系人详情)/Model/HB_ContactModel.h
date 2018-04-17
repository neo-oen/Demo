//
//  HB_ContactModel.h
//  HBZS_iOS
//
//  Created by zimbean on 15/7/8.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HB_ContactDetailListModel.h"//联系人编辑(新建)页面内容模型


@interface HB_ContactModel : NSObject
#pragma mark - 单值属性
/** version */
@property(nonatomic,assign)int32_t version;
/** 联系人的ID */
@property(nonatomic,copy)NSString * contactID;
/** 姓 */
@property(nonatomic,copy)NSString * lastName;
/** 名 */
@property(nonatomic,copy)NSString * firstName;
/** 中间名 */
@property(nonatomic,copy)NSString * middleName;
/** 前缀 */
@property(nonatomic,copy)NSString * prefix;
/** 后缀 */
@property(nonatomic,copy)NSString * suffix;
/** 昵称（称谓） */
@property(nonatomic,copy)NSString * nickName;
/** 姓的拼音或音标 */
@property(nonatomic,copy)NSString * lastNamePhonetic;
/** 名的拼音或音标 */
@property(nonatomic,copy)NSString * firstNamePhonetic;
/** 中间名的拼音或音标 */
@property(nonatomic,copy)NSString * middleNamePhonetic;
/** 公司 */
@property(nonatomic,copy)NSString * organization;
/** 职务 */
@property(nonatomic,copy)NSString * jobTitle;
/** 部门 */
@property(nonatomic,copy)NSString * department;
/** 生日 */
@property(nonatomic,copy)NSString * birthday;
/** 第一次创建 */
@property(nonatomic,copy)NSString * creationDate;
/** 最后一次保存 */
@property(nonatomic,copy)NSString * modificationDate;
/** 备注 */
@property(nonatomic,copy)NSString * note;
/** kind属性 */
@property(nonatomic,copy)NSString * kind;
/** 头像(缩略图) */
@property(nonatomic,retain)NSData * iconData_thumbnail;
/** 头像(原图) */
@property(nonatomic,retain)NSData * iconData_original;

#pragma mark - 多值属性
/** 邮箱数组 */
@property(nonatomic,retain)NSMutableArray *emailArr;
/** 日期数组 */
@property(nonatomic,retain)NSMutableArray *dateArr;
/** 地址数组 */
@property(nonatomic,retain)NSMutableArray *addressArr;
/** 电话数组 */
@property(nonatomic,retain)NSMutableArray *phoneArr;
/** url数组 */
@property(nonatomic,retain)NSMutableArray *urlArr;
/** IM数组 */
@property(nonatomic,retain)NSMutableArray *IMArr;

#pragma mark - 多名片属性
/** 更新或者创建时间戳 */
@property(nonatomic,assign)NSInteger timestamp;
/** cardid */
@property(nonatomic,assign)int32_t cardid;
/** cardName */
@property(nonatomic,retain)NSString *cardName;

#pragma mark - api

/** 根据联系人id返回一个联系人模型 */
+(instancetype)modelWithRecordID:(int)recordID;

@end
