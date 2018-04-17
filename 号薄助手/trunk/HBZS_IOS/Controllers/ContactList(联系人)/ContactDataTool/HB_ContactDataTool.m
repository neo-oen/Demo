//
//  HB_ContactDataTool.m
//  HBZS_iOS
//
//  Created by zimbean on 15/7/7.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//
//
//

#import "HB_ContactDataTool.h"
#import <UIKit/UIKit.h>
#import "HBZSAppDelegate.h"

#import "HB_ContactSendTopTool.h"
#import "HB_AddressModel.h"
#import "HB_PhoneNumModel.h"
#import "HB_EmailModel.h"
#import "HB_UrlModel.h"
#import "HB_InstantMessageModel.h"
#import "SettingInfo.h"

#import "HB_ConvertEmailArrTool.h"
#import "HB_ConvertPhoneNumArrTool.h"


#import "MainViewCtrl.h"
#import "HB_ContactSimpleModel.h"
#import "HB_NameToPinyin.h"
@implementation HB_ContactDataTool

-(void)dealloc{
    [super dealloc];
}
#pragma mark - 获取通讯录句柄
/** 获取通讯录句柄 */
+(ABAddressBookRef)getAddressBook{
    HBZSAppDelegate * appDelegate = (HBZSAppDelegate *)[UIApplication sharedApplication].delegate;

    return [appDelegate getAddressBookRef];
}
+(ABAddressBookRef)reloadAddressBook
{
    HBZSAppDelegate * appDelegate = (HBZSAppDelegate *)[UIApplication sharedApplication].delegate;
   
    
    return [appDelegate ReLoadAddressBookRef];
}

#pragma mark - 根据recordID获取一个联系人的所有属性，返回一个字典
+(NSDictionary *)contactPropertyArrWithRecordID:(ABRecordID)recordID{
    HB_ContactDataTool * tool=[[HB_ContactDataTool alloc]init];
    NSDictionary * dict = [tool contactPropertyWithRecordID:recordID];
    [tool release];
    return dict;
}
-(NSDictionary *)contactPropertyWithRecordID:(ABRecordID)recordID{
    ABAddressBookRef book =  [self.class getAddressBook];
    ABRecordRef people=ABAddressBookGetPersonWithRecordID(book, recordID);
    NSMutableDictionary * mutableDict=[[[NSMutableDictionary alloc]init] autorelease];
    //**********************1、获取单值属性**********************
    NSString * contactID=[[NSString alloc]initWithFormat:@"%d",ABRecordGetRecordID(people)];
    if (contactID) {
        [mutableDict setObject:contactID forKey:@"contactID"];
    }
    [contactID release];
    
    NSString * lastName= ( NSString*)ABRecordCopyValue(people, kABPersonLastNameProperty);
    if (lastName) {
        [mutableDict setObject:lastName forKey:@"lastName"];
    }
    [lastName release];
    
    NSString *firstName = ( NSString*)ABRecordCopyValue(people, kABPersonFirstNameProperty);
    if (firstName) {
        [mutableDict setObject:firstName forKey:@"firstName"];
    }
    [firstName release];
    
    NSString *middleName = (NSString*)ABRecordCopyValue(people, kABPersonMiddleNameProperty);
    if (middleName) {
        [mutableDict setObject:middleName forKey:@"middleName"];
    }
    [middleName release];
    
    NSString *prefix = (NSString*)ABRecordCopyValue(people, kABPersonPrefixProperty);
    if (prefix) {
        [mutableDict setObject:prefix forKey:@"prefix"];
    }
    [prefix release];
    
    NSString *suffix = ( NSString*)ABRecordCopyValue(people, kABPersonSuffixProperty);
    if (suffix) {
        [mutableDict setObject:suffix forKey:@"suffix"];
    }
    [suffix release];
    
    NSString *nickName = ( NSString*)ABRecordCopyValue(people, kABPersonNicknameProperty);
    if (nickName) {
        [mutableDict setObject:nickName forKey:@"nickName"];
    }
    [nickName release];
    
    NSString *firstNamePhonetic = ( NSString*)ABRecordCopyValue(people, kABPersonFirstNamePhoneticProperty);
    if (firstNamePhonetic) {
        [mutableDict setObject:firstNamePhonetic forKey:@"firstNamePhonetic"];
    }
    [firstNamePhonetic release];
    
    NSString *lastNamePhonetic = ( NSString*)ABRecordCopyValue(people, kABPersonLastNamePhoneticProperty);
    if (lastNamePhonetic) {
        [mutableDict setObject:lastNamePhonetic forKey:@"lastNamePhonetic"];
    }
    [lastNamePhonetic release];
    
    NSString *middleNamePhonetic = ( NSString*)ABRecordCopyValue(people, kABPersonMiddleNamePhoneticProperty);
    if (middleNamePhonetic) {
        [mutableDict setObject:middleNamePhonetic forKey:@"middleNamePhonetic"];
    }
    [middleNamePhonetic release];
    
    NSString *organization = ( NSString*)ABRecordCopyValue(people, kABPersonOrganizationProperty);
    if (organization) {
        [mutableDict setObject:organization forKey:@"organization"];
    }
    [organization release];
    
    NSString *jobTitle = ( NSString*)ABRecordCopyValue(people, kABPersonJobTitleProperty);
    if (jobTitle) {
        [mutableDict setObject:jobTitle forKey:@"jobTitle"];
    }
    [jobTitle release];
    
    NSString *department = ( NSString*)ABRecordCopyValue(people, kABPersonDepartmentProperty);
    if (department) {
        [mutableDict setObject:department forKey:@"department"];
    }
    [department release];
    
    NSDate * birthday_date = (NSDate*)ABRecordCopyValue(people, kABPersonBirthdayProperty);
    if (birthday_date) {
        NSString * birthday_str=[NSString stringWithFormat:@"%@",birthday_date];
        NSString *birthday=[[NSString alloc]initWithFormat:@"%@",[birthday_str substringToIndex:10]];
        [mutableDict setObject:birthday forKey:@"birthday"];
        [birthday release];
    }
    
    NSString *note = ( NSString*)ABRecordCopyValue(people, kABPersonNoteProperty);
    if (note) {
        [mutableDict setObject:note forKey:@"note"];
    }
    [note release];
    
    NSString *creationDate = ( NSString*)ABRecordCopyValue(people, kABPersonCreationDateProperty);
    if (creationDate) {
        [mutableDict setObject:creationDate forKey:@"creationDate"];
    }
    [creationDate release];
    
    NSString *modificationDate = ( NSString*)ABRecordCopyValue(people, kABPersonModificationDateProperty);
    if (modificationDate) {
        [mutableDict setObject:modificationDate forKey:@"modificationDate"];
    }
    [modificationDate release];
    
    NSString *kind = ( NSString*)ABRecordCopyValue(people, kABPersonKindProperty);
    if (kind) {
        [mutableDict setObject:kind forKey:@"kind"];
    }
    [kind release];
    
    NSData *icon_thumbnail = ( NSData*)ABPersonCopyImageDataWithFormat(people, kABPersonImageFormatThumbnail);
    if (icon_thumbnail) {
        [mutableDict setObject:icon_thumbnail forKey:@"iconData_thumbnail"];
    }
    [icon_thumbnail release];
    
    NSData *icon_original = ( NSData*)ABPersonCopyImageDataWithFormat(people, kABPersonImageFormatOriginalSize);
    if (icon_original) {
        [mutableDict setObject:icon_original forKey:@"iconData_original"];
    }
    [icon_original release];
    
    //**********************2、获取多值属性**********************
    //获取email多值
    ABMultiValueRef email = ABRecordCopyValue(people, kABPersonEmailProperty);
    NSMutableArray * emailArr=[[NSMutableArray alloc]init];
    int emailArrCount = (int)ABMultiValueGetCount(email);
    for (int i = 0; i < emailArrCount; i++)
    {
        HB_EmailModel *emailModel = [[HB_EmailModel alloc]init];
        NSString *type = (NSString *)ABMultiValueCopyLabelAtIndex(email, i);
        NSString* value = ( NSString*)ABMultiValueCopyValueAtIndex(email, i);
        emailModel.emailType = type;
        emailModel.emailAddress = value;
        emailModel.index = i;
        [emailArr addObject:emailModel];
        [type release];
        [value release];
        [emailModel release];
    }
    [mutableDict setObject:emailArr forKey:@"emailArr"];
    CFRelease(email);
    [emailArr release];
    
    //读取地址多值
    ABMultiValueRef address = ABRecordCopyValue(people, kABPersonAddressProperty);
    NSMutableArray *addressArr = [NSMutableArray array];
    int addressArrCount = (int)ABMultiValueGetCount(address);
    for(int j = 0; j < addressArrCount; j++)
    {
        HB_AddressModel *model = [[HB_AddressModel alloc]init];
        //获取地址 名字
        NSString *addressType = (NSString *)ABMultiValueCopyLabelAtIndex(address, j);
        //1.地址的类型
        model.type = addressType;
        //获取該 地址名字 下的6个地址属性
        NSDictionary* personaddress =(NSDictionary *) ABMultiValueCopyValueAtIndex(address, j);
        //2.国家
        model.country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
        //3.城市
        model.city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
        //4.省
        model.state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
        //5.街道
        model.street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
        //6.邮编
        model.zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
        //7.国家编码
        model.countryCode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
        //8.第几个地址
        model.index = j;
                
        [addressArr addObject:model];
        [addressType release];
        [personaddress release];
        [model release];
    }
    [mutableDict setObject:addressArr forKey:@"addressArr"];
    CFRelease(address);
    
    //获取date多值
    ABMultiValueRef dates = ABRecordCopyValue(people, kABPersonDateProperty);
    NSMutableArray * dateArr=[[NSMutableArray alloc]init];
    int dateArrCount = (int)ABMultiValueGetCount(dates);
    for (int y = 0; y < dateArrCount; y++)
    {
        //获取dates 名字
        CFStringRef labelRef=ABMultiValueCopyLabelAtIndex(dates, y);
        NSString* dateLabel = ( NSString*)ABAddressBookCopyLocalizedLabel(labelRef);
        //获取dates值
        NSString* dateContent = ( NSString*)ABMultiValueCopyValueAtIndex(dates, y);
        [dateArr addObject:[NSString stringWithFormat:@"%@:%@",dateLabel,dateContent]];
        CFRelease(labelRef);
        [dateLabel release];
        [dateContent release];
    }
    [mutableDict setObject:dateArr forKey:@"dateArr"];
    CFRelease(dates);
    [dateArr release];
    
    //获取IM多值
    ABMultiValueRef instantMessage = ABRecordCopyValue(people, kABPersonInstantMessageProperty);
    NSMutableArray * IMArr=[NSMutableArray array];
    for (int i = 0; i < ABMultiValueGetCount(instantMessage); i++)
    {
        NSDictionary *imDict = (NSDictionary *)ABMultiValueCopyValueAtIndex(instantMessage, i);
        //构建HB_InstantMessageModel模型
        HB_InstantMessageModel *imModel = [[HB_InstantMessageModel alloc]init];
        imModel.type = [imDict objectForKey:(NSString *)kABPersonInstantMessageServiceKey];
        imModel.account = [imDict objectForKey:(NSString *)kABPersonInstantMessageUsernameKey];
        [IMArr addObject:imModel];
        [imModel release];
        [imDict release];
    }
    [mutableDict setObject:IMArr forKey:@"IMArr"];
    CFRelease(instantMessage);
    
    //读取电话多值
    ABMultiValueRef phone = ABRecordCopyValue(people, kABPersonPhoneProperty);
    NSMutableArray * phoneArr=[[NSMutableArray alloc]init];
    for (int k = 0; k<ABMultiValueGetCount(phone); k++)
    {
        //获取电话类型 示例：_$!<Home>!$_
        NSString *type = (NSString *)ABMultiValueCopyLabelAtIndex(phone, k);
        //获取电话值  示例：13722224444
        NSString *value = (NSString *)ABMultiValueCopyValueAtIndex(phone, k);
        
        HB_PhoneNumModel *phoneModel = [[HB_PhoneNumModel alloc]init];
        phoneModel.index = k;
        phoneModel.phoneType = type;
        phoneModel.phoneNum = value;
        [phoneArr addObject:phoneModel];
        
        [type release];
        [value release];
        [phoneModel release];
    }
    [mutableDict setObject:phoneArr forKey:@"phoneArr"];
    CFRelease(phone);
    [phoneArr release];
    
    //获取URL多值
    ABMultiValueRef url = ABRecordCopyValue(people, kABPersonURLProperty);
    NSMutableArray *urlArr = [[NSMutableArray alloc]init];
    for (int m = 0; m < ABMultiValueGetCount(url); m++)
    {
        //获取网址 名字
        NSString *type = (NSString *)ABMultiValueCopyLabelAtIndex(url, m);
        //获取該 名字 下的网址
        NSString * value = (NSString*)ABMultiValueCopyValueAtIndex(url,m);
        
        HB_UrlModel *model = [[HB_UrlModel alloc]init];
        model.type = type;
        model.url = value;
        [urlArr addObject:model];
        [type release];
        [value release];
        [model release];
    }
    [mutableDict setObject:urlArr forKey:@"urlArr"];
    CFRelease(url);
    [urlArr release];
    
    return mutableDict;
}
#pragma mark - 获取所有联系人的id
+(NSArray *)contactGetAllContactID{
    NSMutableArray * mutableArr=[[[NSMutableArray alloc]init] autorelease];
    ABAddressBookRef book = [self getAddressBook];
    ABRecordRef source =ABAddressBookCopyDefaultSource(book);
    NSArray * peopleArr = ( NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(book, source, kABPersonSortByLastName);
    
    BOOL isShowNonumberContact = [SettingInfo getIsShowNoNumberContact];
    
    for (int i=0; i<peopleArr.count; i++) {
        ABRecordRef people = peopleArr[i];
        //recordID
        ABMultiValueRef phone = ABRecordCopyValue(people, kABPersonPhoneProperty);
        if (ABMultiValueGetCount(phone) == 0) {
            if (isShowNonumberContact == NO) {
                //不显示无号码联系人
                continue;
            }
        }
        
        NSInteger recordID=(NSInteger)ABRecordGetRecordID(people);
        [mutableArr addObject:[NSNumber numberWithInteger:recordID]];
        
        
    }
    if (source) {
        CFRelease(source);
    }
    
    [peopleArr release];
    return mutableArr;
}
#pragma mark - 获取所有联系人的名字，ID，头像  (HB_ContactSimpleModel)
+(NSArray *)contactGetAllContactSimpleProperty{
    NSMutableArray * mutableArr=[[[NSMutableArray alloc]init] autorelease];
    ABAddressBookRef book =  [self getAddressBook];
    ABRecordRef source =ABAddressBookCopyDefaultSource(book);
    NSArray * peopleArr = ( NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(book, source, kABPersonSortByLastName);
    
    BOOL isShowNonumberContact = [SettingInfo getIsShowNoNumberContact];

    for (int i=0; i<peopleArr.count; i++) {
        ABRecordRef people = peopleArr[i];
#pragma mark 判断是否显示无号码联系人
        ABMultiValueRef phone = ABRecordCopyValue(people, kABPersonPhoneProperty);
        if (ABMultiValueGetCount(phone) == 0) {
            if (isShowNonumberContact == NO) {
                //不显示无号码联系人
                continue;
            }
        }
/*****/
        
        
        NSMutableDictionary * mutableDict=[[NSMutableDictionary alloc]init];
        //仅仅取出3个属性，头像，recordID，名字
        //1.头像
        NSData * icon_thumbnail_data = ( NSData*)ABPersonCopyImageDataWithFormat(people, kABPersonImageFormatThumbnail);
        if (icon_thumbnail_data) {
            [mutableDict setObject:icon_thumbnail_data forKey:@"iconData_thumbnail"];
        }
        [icon_thumbnail_data release];
        //2.recordID
        ABRecordID recordID=ABRecordGetRecordID(people);
        NSString * contactID=[NSString stringWithFormat:@"%d",recordID];
        if (contactID) {
            [mutableDict setObject:contactID forKey:@"contactID"];
        }
        //3.名字
        NSMutableString * nameStr=[[NSMutableString alloc]init];
        NSString * lastName= (NSString*)ABRecordCopyValue(people, kABPersonLastNameProperty);
        if (lastName) {
            [nameStr appendString:lastName];
        }
        [lastName release];

        NSString * middleName = (NSString*)ABRecordCopyValue(people, kABPersonMiddleNameProperty);
        if (middleName) {
            [nameStr appendString:middleName];
        }
        [middleName release];

        NSString * firstName = (NSString*)ABRecordCopyValue(people, kABPersonFirstNameProperty);
        if (firstName) {
            [nameStr appendString:firstName];
        }
        [firstName release];
        
        if (nameStr.length==0) {//没有名字
            [nameStr setString:@"#无名字"];
        }
        [mutableDict setObject:nameStr forKey:@"name"];
        
        //名字拼音
        NSString * namePinyin = [[[HB_NameToPinyin sharedInstance] nameTopinyin:nameStr] uppercaseString];
        
        [mutableDict setObject:namePinyin forKey:@"PinyinName"];

        [mutableArr addObject:mutableDict];
        [mutableDict release];
    }
    if (source) {
        CFRelease(source);
    }
    
    [peopleArr release];
    return mutableArr;
}
#pragma mark - 根据recordID获取一个联系人的部分属性(name,id,icon)
+(NSDictionary *)contactSimplePropertyArrWithRecordID:(ABRecordID)recordID{
    ABAddressBookRef book =  [self getAddressBook];
    ABRecordRef people=ABAddressBookGetPersonWithRecordID(book, recordID);
    NSMutableDictionary * mutableDict=[[[NSMutableDictionary alloc]init] autorelease];
    //1.获取名字
    NSString * name=[[NSString alloc]init];
    
    NSString * lastName= ( NSString*)ABRecordCopyValue(people, kABPersonLastNameProperty);
    if (lastName) {
        name = [name stringByAppendingString:lastName];
    }
    [lastName release];
    
    NSString * middleName = ( NSString*)ABRecordCopyValue(people, kABPersonMiddleNameProperty);
    if (middleName) {
        name =[name stringByAppendingString:middleName];
    }
    [middleName release];

    NSString * firstName = ( NSString*)ABRecordCopyValue(people, kABPersonFirstNameProperty);
    if (firstName) {
        name=[name stringByAppendingString:firstName];
    }
    [firstName release];
    if (name.length==0) {//没有名字
        name=@"#无名字";
    }
    [mutableDict setObject:name forKey:@"name"];
    
    //拼音名字
    NSString * pinyinName = [[[HB_NameToPinyin sharedInstance] nameTopinyin:name] uppercaseString];
    [mutableDict setObject:pinyinName forKey:@"PinyinName"];
    //2.获取头像
    NSData * icon_thumbnail = (NSData*)ABPersonCopyImageDataWithFormat(people, kABPersonImageFormatThumbnail);
    if (icon_thumbnail) {
        [mutableDict setObject:icon_thumbnail forKey:@"iconData_thumbnail"];
    }
    //3.添加recordID
    [mutableDict setObject:[NSString stringWithFormat:@"%d",recordID] forKey:@"contactID"];
    
    return mutableDict;
}
#pragma mark - 获取所有联系人的全部属性(HB_contactModel)
+(NSArray *)contactGetAllContactAllProperty{
    //1.获取所有联系人ID
    NSArray *recordIDArr = [self contactGetAllContactID];
    //2.循环获取每一个联系人的所有属性
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (NSNumber *recordID in recordIDArr) {
        NSDictionary *propertyDict = [self contactPropertyArrWithRecordID:recordID.intValue];
        HB_ContactModel *contactModel = [[HB_ContactModel alloc]init];
        [contactModel setValuesForKeysWithDictionary:propertyDict];
        [mutableArr addObject:contactModel];
        [contactModel release];
    }
    return mutableArr;
}
#pragma mark - 添加联系人到通讯录
+(NSInteger)contactAddPeopleByModel:(HB_ContactModel *)model{

    [SettingInfo setListenAppChangedAddressbook:YES];//编辑联系人的时候就打开监听如果联系人变化 需要更新数据
    ABAddressBookRef book =  [HB_ContactDataTool getAddressBook];
    //1.创建一个新的联系人
    ABRecordRef newPerson;
    newPerson=ABAddressBookGetPersonWithRecordID(book, model.contactID.intValue);
    if(!newPerson) {
        newPerson=ABPersonCreate();
    }
    //2.设置属性*************************
    //名字属性
    ABRecordSetValue(newPerson,kABPersonFirstNameProperty,(CFTypeRef)model.firstName,NULL);
    ABRecordSetValue(newPerson,kABPersonMiddleNameProperty,(CFTypeRef)model.middleName,NULL);
    ABRecordSetValue(newPerson,kABPersonLastNameProperty,(CFTypeRef)model.lastName,NULL);
    //昵称
    ABRecordSetValue(newPerson,kABPersonNicknameProperty,(CFTypeRef)model.nickName,NULL);
    //公司
    ABRecordSetValue(newPerson,kABPersonOrganizationProperty,(CFTypeRef)model.organization,NULL);
    //职务
    ABRecordSetValue(newPerson,kABPersonJobTitleProperty,(CFTypeRef)model.jobTitle,NULL);
    //部门
    ABRecordSetValue(newPerson,kABPersonDepartmentProperty,(CFTypeRef)model.department,NULL);
    //生日(需要字符串转日期)
    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthdayDate=[dateFormatter dateFromString:model.birthday];
    ABRecordSetValue(newPerson,kABPersonBirthdayProperty,(CFDateRef)birthdayDate,NULL);
    [dateFormatter release];
    //备注
    ABRecordSetValue(newPerson,kABPersonNoteProperty,(CFTypeRef)model.note,NULL);
    //头像
    
    NSData * dataRef = UIImagePNGRepresentation([UIImage imageWithData:model.iconData_original]);
    ABPersonSetImageData(newPerson, (CFDataRef)dataRef, NULL);
    
    //电话********************多值属性*****
    ABMutableMultiValueRef multiValue_phone=ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (int i=0; i<model.phoneArr.count; i++) {
        HB_PhoneNumModel *phoneModel = model.phoneArr[i];
        if (phoneModel.phoneNum.length) {
            ABMultiValueAddValueAndLabel(multiValue_phone, (CFTypeRef)phoneModel.phoneNum,(CFStringRef)phoneModel.phoneType, NULL);
            NSLog(@"%@",phoneModel.phoneType);
        }
    }
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiValue_phone, NULL);
    CFRelease(multiValue_phone);
    //邮箱
    ABMutableMultiValueRef multiValue_email=ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (int i=0; i<model.emailArr.count; i++) {
        HB_EmailModel *emailModel = model.emailArr[i];
        if (emailModel.emailAddress.length) {
            ABMultiValueAddValueAndLabel(multiValue_email, (CFTypeRef)emailModel.emailAddress,(CFStringRef)emailModel.emailType, NULL);
        }
    }
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiValue_email, NULL);
    CFRelease(multiValue_email);
    //地址
    ABMutableMultiValueRef multiValue_address = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //地址数组  家庭地址:中国:郑州:河南:街道1\n街道2:450000:cn
    for (int i=0; i<model.addressArr.count; i++) {
        HB_AddressModel *addressModel = model.addressArr[i];
        
        NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionary];
        if (addressModel.country) {
            [addressDictionary setObject:addressModel.country forKey:(NSString *)kABPersonAddressCountryKey];
        }
        if (addressModel.state) {
            [addressDictionary setObject:addressModel.state forKey:(NSString *)kABPersonAddressStateKey];
        }
        if (addressModel.city) {
            [addressDictionary setObject:addressModel.city forKey:(NSString *)kABPersonAddressCityKey];
        }
        if (addressModel.street) {
            [addressDictionary setObject:addressModel.street forKey:(NSString *)kABPersonAddressStreetKey];
        }
        if (addressModel.zip) {
            [addressDictionary setObject:addressModel.zip forKey:(NSString *)kABPersonAddressZIPKey];
        }
        if (addressModel.countryCode) {
            [addressDictionary setObject:addressModel.countryCode forKey:(NSString *)kABPersonAddressCountryCodeKey];
        }

        ABMultiValueAddValueAndLabel(multiValue_address, (CFDictionaryRef)addressDictionary,(CFStringRef)addressModel.type, NULL);
    }
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiValue_address, NULL);
    CFRelease(multiValue_address);
    //url数组
    ABMutableMultiValueRef multiValue_url=ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (int i=0; i<model.urlArr.count; i++) {
        HB_UrlModel *urlModel = model.urlArr[i];
        ABMultiValueAddValueAndLabel(multiValue_url, (CFTypeRef)urlModel.url,(CFStringRef)urlModel.type, NULL);
    }
    ABRecordSetValue(newPerson, kABPersonURLProperty, multiValue_url, NULL);
    CFRelease(multiValue_url);
    //IM数组
    ABMutableMultiValueRef multiValue_IM=ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (int i=0; i<model.IMArr.count; i++) {
        NSMutableDictionary *imDictionary = [NSMutableDictionary dictionary];
        HB_InstantMessageModel *imModel = model.IMArr[i];
        if (imModel.type.length) {
            [imDictionary setObject:imModel.type forKey:(NSString *)kABPersonInstantMessageServiceKey];
        }
        if (imModel.account.length) {
            [imDictionary setObject:imModel.account forKey:(NSString *)kABPersonInstantMessageUsernameKey];
        }
        ABMultiValueAddValueAndLabel(multiValue_IM, (CFDictionaryRef)imDictionary ,(CFStringRef)imModel.type, NULL);
    }
    ABRecordSetValue(newPerson, kABPersonInstantMessageProperty, multiValue_IM, NULL);
    CFRelease(multiValue_IM);
    //3.添加*****************************
    ABAddressBookAddRecord(book, newPerson,NULL);
    //4.更新通讯录

    
    
    if (ABAddressBookHasUnsavedChanges(book)) {
        BOOL ret = ABAddressBookSave(book, NULL);
        NSInteger rid3 = ABRecordGetRecordID(newPerson);
        if (!model.contactID.length) {
            CFRelease(newPerson);
        }
        if (ret) {
            return rid3;
        }
        else
        {
            return NO;
        }
    }else{
        if (!model.contactID.length) {
            CFRelease(newPerson);
        }
        return NO;
    }
}

#pragma mark 时光机联系人插入
+(BOOL)contactAddPeopleWhileTimeMachineByModel:(HB_ContactModel *)model
{
    ABAddressBookRef book =  [self getAddressBook];

    ABRecordRef newPerson=ABPersonCreate();
    //2.设置属性*************************
    //名字属性
    ABRecordSetValue(newPerson,kABPersonFirstNameProperty,(CFTypeRef)model.firstName,NULL);
    ABRecordSetValue(newPerson,kABPersonMiddleNameProperty,(CFTypeRef)model.middleName,NULL);
    ABRecordSetValue(newPerson,kABPersonLastNameProperty,(CFTypeRef)model.lastName,NULL);
    //昵称
    ABRecordSetValue(newPerson,kABPersonNicknameProperty,(CFTypeRef)model.nickName,NULL);
    //公司
    ABRecordSetValue(newPerson,kABPersonOrganizationProperty,(CFTypeRef)model.organization,NULL);
    //职务
    ABRecordSetValue(newPerson,kABPersonJobTitleProperty,(CFTypeRef)model.jobTitle,NULL);
    //部门
    ABRecordSetValue(newPerson,kABPersonDepartmentProperty,(CFTypeRef)model.department,NULL);
    //生日(需要字符串转日期)
    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthdayDate=[dateFormatter dateFromString:model.birthday];
    ABRecordSetValue(newPerson,kABPersonBirthdayProperty,(CFDateRef)birthdayDate,NULL);
    [dateFormatter release];
    //备注
    ABRecordSetValue(newPerson,kABPersonNoteProperty,(CFTypeRef)model.note,NULL);
    //头像
    [self contactUpdateIcon:[UIImage imageWithData:model.iconData_original] withRecordID:model.contactID.intValue];
    //电话********************多值属性*****
    ABMutableMultiValueRef multiValue_phone=ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (int i=0; i<model.phoneArr.count; i++) {
        HB_PhoneNumModel *phoneModel = model.phoneArr[i];
        if (phoneModel.phoneNum.length) {
            ABMultiValueAddValueAndLabel(multiValue_phone, (CFTypeRef)phoneModel.phoneNum,(CFStringRef)phoneModel.phoneType, NULL);
        }
    }
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiValue_phone, NULL);
    CFRelease(multiValue_phone);
    //邮箱
    ABMutableMultiValueRef multiValue_email=ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (int i=0; i<model.emailArr.count; i++) {
        HB_EmailModel *emailModel = model.emailArr[i];
        if (emailModel.emailAddress.length) {
            ABMultiValueAddValueAndLabel(multiValue_email, (CFTypeRef)emailModel.emailAddress,(CFStringRef)emailModel.emailType, NULL);
        }
    }
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiValue_email, NULL);
    CFRelease(multiValue_email);
    //地址
    ABMutableMultiValueRef multiValue_address = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //地址数组  家庭地址:中国:郑州:河南:街道1\n街道2:450000:cn
    for (int i=0; i<model.addressArr.count; i++) {
        HB_AddressModel *addressModel = model.addressArr[i];
        
        NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionary];
        if (addressModel.country) {
            [addressDictionary setObject:addressModel.country forKey:(NSString *)kABPersonAddressCountryKey];
        }
        if (addressModel.state) {
            [addressDictionary setObject:addressModel.state forKey:(NSString *)kABPersonAddressStateKey];
        }
        if (addressModel.city) {
            [addressDictionary setObject:addressModel.city forKey:(NSString *)kABPersonAddressCityKey];
        }
        if (addressModel.street) {
            [addressDictionary setObject:addressModel.street forKey:(NSString *)kABPersonAddressStreetKey];
        }
        if (addressModel.zip) {
            [addressDictionary setObject:addressModel.zip forKey:(NSString *)kABPersonAddressZIPKey];
        }
        if (addressModel.countryCode) {
            [addressDictionary setObject:addressModel.countryCode forKey:(NSString *)kABPersonAddressCountryCodeKey];
        }
        
        ABMultiValueAddValueAndLabel(multiValue_address, (CFDictionaryRef)addressDictionary,(CFStringRef)addressModel.type, NULL);
    }
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiValue_address, NULL);
    CFRelease(multiValue_address);
    //url数组
    ABMutableMultiValueRef multiValue_url=ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (int i=0; i<model.urlArr.count; i++) {
        HB_UrlModel *urlModel = model.urlArr[i];
        ABMultiValueAddValueAndLabel(multiValue_url, (CFTypeRef)urlModel.url,(CFStringRef)urlModel.type, NULL);
    }
    ABRecordSetValue(newPerson, kABPersonURLProperty, multiValue_url, NULL);
    CFRelease(multiValue_url);
    //IM数组
    ABMutableMultiValueRef multiValue_IM=ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (int i=0; i<model.IMArr.count; i++) {
        NSMutableDictionary *imDictionary = [NSMutableDictionary dictionary];
        HB_InstantMessageModel *imModel = model.IMArr[i];
        if (imModel.type.length) {
            [imDictionary setObject:imModel.type forKey:(NSString *)kABPersonInstantMessageServiceKey];
        }
        if (imModel.account.length) {
            [imDictionary setObject:imModel.account forKey:(NSString *)kABPersonInstantMessageUsernameKey];
        }
        ABMultiValueAddValueAndLabel(multiValue_IM, (CFDictionaryRef)imDictionary ,(CFStringRef)imModel.type, NULL);
    }
    ABRecordSetValue(newPerson, kABPersonInstantMessageProperty, multiValue_IM, NULL);
    CFRelease(multiValue_IM);
    //3.添加*****************************
    ABAddressBookAddRecord(book, newPerson,NULL);
    CFRelease(newPerson);

    return YES;
}


/**
 *  删除联系人
 */
+ (BOOL)contactDeleteContactByID:(int)recordID{
    
    [SettingInfo setListenAppChangedAddressbook:YES];
    ABAddressBookRef addressBookRef = [HB_ContactDataTool reloadAddressBook];
    ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef,recordID);
    BOOL isSuccess = ABAddressBookRemoveRecord(addressBookRef, personRef, NULL);
    
    BOOL isSuccess1 =  ABAddressBookSave(addressBookRef, NULL);
    [HB_ContactSendTopTool contactCancelBackWithRecordID:recordID];
    return isSuccess;
}
/**
 *  批量删除联系人
 */
+ (void)contactBatchDeleteByArr:(NSArray *)simModelArr
{
    [SettingInfo setListenAppChangedAddressbook:YES];
    ABAddressBookRef addressBookRef = [HB_ContactDataTool reloadAddressBook];
    for (HB_ContactSimpleModel * model in simModelArr) {
        ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef,model.contactID.intValue);
        BOOL isSuccess = ABAddressBookRemoveRecord(addressBookRef, personRef, NULL);
        if (isSuccess) {
            [HB_ContactSendTopTool contactCancelBackWithRecordID:model.contactID.intValue];
        }
        
    }
    
    
    BOOL isSuccess1 =  ABAddressBookSave(addressBookRef, NULL);
    
    
}
/**
 *  根据模型中的lastName,middleName,FirstName拼凑完整的名字
 *
 */
+(NSString *)contactGetFullNameWithModel:(HB_ContactModel*)model{
    NSMutableString * nameStr=[[[NSMutableString alloc]init] autorelease];
    if (model.lastName) {
        [nameStr appendString:model.lastName];
    }
    if (model.middleName) {
        [nameStr appendString:model.middleName];
    }
    if (model.firstName) {
        [nameStr appendString:model.firstName];
    }
    NSArray *separateArr = [nameStr componentsSeparatedByString:@" "];
    NSString *finalName = [separateArr componentsJoinedByString:@""];
    return finalName;
}

#pragma mark - 联系人的头像相关
/**
 *  设置头像
 */
+(BOOL)contactUpdateIcon:(UIImage *)icon withRecordID:(int)recordID{
//    if (icon==nil) {
//        return NO;
//    }
    //获取通讯录
    ABAddressBookRef addressBook=[self getAddressBook];
    //获取对应的联系人
    ABRecordRef personRef=ABAddressBookGetPersonWithRecordID(addressBook, recordID);
    //更改头像
    NSData * iconDataOriginal=UIImagePNGRepresentation(icon);
    CFErrorRef errorOriginal=NULL;
    BOOL flag_originalIcon = ABPersonSetImageData(personRef, (CFDataRef)iconDataOriginal, &errorOriginal);
    //写入联系人
    CFErrorRef errorUpdate=NULL;
    BOOL flag_updatePerson = ABAddressBookAddRecord(addressBook, personRef, &errorUpdate);
    //保存通讯录
    CFErrorRef errorSaveABook=NULL;
    BOOL flag_saveAddressBook = ABAddressBookSave(addressBook, &errorSaveABook);
    
    //最终返回的bool值为所有过程中的bool值的&运算
    BOOL flag = flag_originalIcon && flag_updatePerson && flag_saveAddressBook;
    return flag;
}
/**
 *  该联系人是否有头像
 */
+(BOOL)contactIsHasIconWithRecordID:(int)recordID{
    ABAddressBookRef addressBook=[self getAddressBook];
    //获取对应的联系人
    ABRecordRef personRef=ABAddressBookGetPersonWithRecordID(addressBook, recordID);
    return ABPersonHasImageData(personRef);
}
/**
 *  删除联系人头像
 */
+(BOOL)contactRemoveIconWithRecordID:(int)recordID{
    ABAddressBookRef addressBook=[self getAddressBook];
    //获取对应的联系人
    ABRecordRef personRef=ABAddressBookGetPersonWithRecordID(addressBook, recordID);
    //如果有头像就删除
    BOOL isRemoved;
    if (ABPersonHasImageData(personRef)) {
        CFErrorRef errorRemoveImageData;
        isRemoved = ABPersonRemoveImageData(personRef, &errorRemoveImageData);
    }
    return isRemoved;
}
@end
