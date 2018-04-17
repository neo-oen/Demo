//
//  HB_ContactDetailListModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/9/15.
//
//
/*
 思路：
 HB_ContactDetailListModel这个模型是当前页面展示的列表内容的数据源。
 它可以由HB_ContactModel这个最初的联系人模型转化而来。
 与之对应的是，HB_ContactDetailListModel也可以转化为HB_ContactModel模型，用来保存改变的数据。
 
 在HB_ContactModel中           号码和邮箱Type 统一存系统类型字段
 HB_ContactDetailListModel    号码和邮箱Type 统一存号簿助手规定类型字段
 */

#import <Foundation/Foundation.h>
@class HB_ContactModel;//联系人模型

@interface HB_ContactDetailListModel : NSObject

/** 头像 */
@property(nonatomic,retain)NSData * iconData_original;
/** 姓名 */
@property(nonatomic,retain)NSString *name;
/** 电话（数组） */
@property(nonatomic,retain)NSMutableArray  *phoneArr;
/** 邮件（数组） */
@property(nonatomic,retain)NSMutableArray  *eMailArr;
/** 公司 */
@property(nonatomic,retain)NSString *organization;
/** 职务 */
@property(nonatomic,retain)NSString *jobTitle;
/** 在职部门 */
@property(nonatomic,retain)NSString *department;
/** 称谓 */
@property(nonatomic,retain)NSString *nickName;
/** 当前所在的所有分组 */
@property(nonatomic,retain)NSString *groupsName;
/** QQ--编辑/新建联系人 */
@property(nonatomic,retain)NSString * QQ;
/** 易信--编辑/新建联系人 */
@property(nonatomic,retain)NSString * yiXin;
/** 微信--编辑/新建联系人 */
@property(nonatomic,retain)NSString * weiXin;
/** 公司地址--编辑/新建联系人 */
@property(nonatomic,retain)NSString * address_company;
/** 公司邮编--编辑/新建联系人 */
@property(nonatomic,retain)NSString * postcode_company;
/** 公司主页地址--编辑/新建联系人 */
@property(nonatomic,retain)NSString * url_company;
/** 家庭地址--编辑/新建联系人 */
@property(nonatomic,retain)NSString * address_family;
/** 家庭邮编--编辑/新建联系人 */
@property(nonatomic,retain)NSString * postcode_family;
/** 个人主页地址--编辑/新建联系人 */
@property(nonatomic,retain)NSString * url_person;
/** 生日 */
@property(nonatomic,retain)NSString * birthday;
/** 备注 */
@property(nonatomic,retain)NSString * note;
/** 名片别名---多名片版本 */
@property(nonatomic,retain)NSString * cardName;



@end
