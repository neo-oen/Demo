//
//  HB_ContactModel.m
//  HBZS_iOS
//
//  Created by zimbean on 15/7/8.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//

#import "HB_ContactModel.h"
#import "HB_ContactDetailListModel.h"//联系人编辑（创建）界面的列表内容模型
#import "HB_ConvertPhoneNumArrTool.h"//系统电话号码类型转化为号簿助手的电话号码类型
#import "HB_ConvertEmailArrTool.h"//系统邮箱类型转化为号簿助手的邮箱类型
#import "GroupData.h"//分组管理
#import "HB_ContactDataTool.h"

#import "HB_AddressModel.h"
#import "HB_PhoneNumModel.h"
#import "HB_EmailModel.h"
#import "HB_UrlModel.h"
#import "HB_InstantMessageModel.h"

@interface HB_ContactModel ()<NSCoding>

@end

@implementation HB_ContactModel

-(void)dealloc{
    [_IMArr release];
    [_urlArr release];
    [_phoneArr release];
    [_addressArr release];
    [_dateArr release];
    [_emailArr release];
    [_iconData_original release];
    [_iconData_thumbnail release];
    [_kind release];
    [_note release];
    [_modificationDate release];
    [_creationDate release];
    [_birthday release];
    [_department release];
    [_jobTitle release];
    [_organization release];
    [_middleNamePhonetic release];
    [_firstNamePhonetic release];
    [_lastNamePhonetic release];
    [_nickName release];
    [_suffix release];
    [_prefix release];
    [_middleName release];
    [_firstName release];
    [_lastName release];
    [_contactID release];
    [super dealloc];
}

/**
 *  解档
 */
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        self.IMArr= [aDecoder decodeObjectForKey:@"IMArr"];
        self.urlArr= [aDecoder decodeObjectForKey:@"urlArr"];
        self.phoneArr= [aDecoder decodeObjectForKey:@"phoneArr"];
        self.addressArr= [aDecoder decodeObjectForKey:@"addressArr"];
        self.dateArr= [aDecoder decodeObjectForKey:@"dateArr"];
        self.emailArr= [aDecoder decodeObjectForKey:@"emailArr"];
        self.iconData_original= [aDecoder decodeObjectForKey:@"iconData_original"];
        self.iconData_thumbnail= [aDecoder decodeObjectForKey:@"iconData_thumbnail"];
        self.kind= [aDecoder decodeObjectForKey:@"kind"];
        self.note= [aDecoder decodeObjectForKey:@"note"];
        self.modificationDate= [aDecoder decodeObjectForKey:@"modificationDate"];
        self.creationDate= [aDecoder decodeObjectForKey:@"creationDate"];
        self.birthday= [aDecoder decodeObjectForKey:@"birthday"];
        self.department= [aDecoder decodeObjectForKey:@"department"];
        self.jobTitle= [aDecoder decodeObjectForKey:@"jobTitle"];
        self.organization= [aDecoder decodeObjectForKey:@"organization"];
        self.middleNamePhonetic= [aDecoder decodeObjectForKey:@"middleNamePhonetic"];
        self.firstNamePhonetic= [aDecoder decodeObjectForKey:@"firstNamePhonetic"];
        self.lastNamePhonetic= [aDecoder decodeObjectForKey:@"lastNamePhonetic"];
        self.nickName= [aDecoder decodeObjectForKey:@"nickName"];
        self.suffix= [aDecoder decodeObjectForKey:@"suffix"];
        self.prefix= [aDecoder decodeObjectForKey:@"prefix"];
        self.middleName= [aDecoder decodeObjectForKey:@"middleName"];
        self.firstName= [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName= [aDecoder decodeObjectForKey:@"lastName"];
        self.contactID= [aDecoder decodeObjectForKey:@"contactID"];
        
        self.cardName = [aDecoder decodeObjectForKey:@"cardName"];
        self.cardid = [aDecoder decodeIntForKey:@"cardid"];
        
        self.timestamp = [aDecoder decodeIntegerForKey:@"timestamp"];
    }
    return self;
}
/**
 *  归档
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.IMArr forKey:@"IMArr"];
    [aCoder encodeObject:self.urlArr forKey:@"urlArr"];
    [aCoder encodeObject:self.phoneArr forKey:@"phoneArr"];
    [aCoder encodeObject:self.addressArr forKey:@"addressArr"];
    [aCoder encodeObject:self.dateArr forKey:@"dateArr"];
    [aCoder encodeObject:self.emailArr forKey:@"emailArr"];
    [aCoder encodeObject:self.iconData_original forKey:@"iconData_original"];
    [aCoder encodeObject:self.iconData_thumbnail forKey:@"iconData_thumbnail"];
    [aCoder encodeObject:self.kind forKey:@"kind"];
    [aCoder encodeObject:self.note forKey:@"note"];
    [aCoder encodeObject:self.modificationDate forKey:@"modificationDate"];
    [aCoder encodeObject:self.creationDate forKey:@"creationDate"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.department forKey:@"department"];
    [aCoder encodeObject:self.jobTitle forKey:@"jobTitle"];
    [aCoder encodeObject:self.organization forKey:@"organization"];
    [aCoder encodeObject:self.middleNamePhonetic forKey:@"middleNamePhonetic"];
    [aCoder encodeObject:self.firstNamePhonetic forKey:@"firstNamePhonetic"];
    [aCoder encodeObject:self.lastNamePhonetic forKey:@"lastNamePhonetic"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.suffix forKey:@"suffix"];
    [aCoder encodeObject:self.prefix forKey:@"prefix"];
    [aCoder encodeObject:self.middleName forKey:@"middleName"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.contactID forKey:@"contactID"];
    
    [aCoder encodeInteger:self.timestamp forKey:@"timestamp"];
    [aCoder encodeInt:self.cardid forKey:@"cardid"];
    [aCoder encodeObject:self.cardName forKey:@"cardName"];
    
}

/** 根据id创建一个联系人模型 */
+(instancetype)modelWithRecordID:(int)recordID{
    HB_ContactModel *modle = [[[self alloc]init] autorelease];
    NSDictionary * dict = [HB_ContactDataTool contactPropertyArrWithRecordID:recordID];
    [modle setValuesForKeysWithDictionary:dict];
    return modle;
}

@end
