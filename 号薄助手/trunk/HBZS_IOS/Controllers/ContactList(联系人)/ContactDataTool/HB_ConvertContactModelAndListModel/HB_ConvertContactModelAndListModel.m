//
//  HB_ConvertContactModelAndListModel.m
//  HBZS_IOS
//
//  Created by zimbean on 16/1/25.
//
//

#import "HB_ConvertContactModelAndListModel.h"
#import "HB_ContactDataTool.h"
#import "HB_ConvertPhoneNumArrTool.h"
#import "HB_ConvertEmailArrTool.h"
#import "GroupData.h"
#import "HB_PhoneNumModel.h"
#import "HB_EmailModel.h"
#import "HB_UrlModel.h"
#import "HB_AddressModel.h"
#import "HB_InstantMessageModel.h"

@implementation HB_ConvertContactModelAndListModel

+(void)convertContactModel:(HB_ContactModel *)contactModel toListModel:(HB_ContactDetailListModel *)listModel{
    listModel.iconData_original = contactModel.iconData_original;

    //姓名
    listModel.name = [HB_ContactDataTool contactGetFullNameWithModel:contactModel];
    //电话
    listModel.phoneArr =[HB_ConvertPhoneNumArrTool convertPhoneTypeWithPhoneArrSystemToHBZS:contactModel.phoneArr andContactRecordID:contactModel.contactID.integerValue];
    
    //邮件
    listModel.eMailArr =[HB_ConvertEmailArrTool convertEmailTypeWithArraySystemToHBZS:contactModel.emailArr];
    
    //公司
    listModel.organization = contactModel.organization;
    //职务
    listModel.jobTitle = contactModel.jobTitle;
    //在职部门
    listModel.department = contactModel.department;
    //称谓
    listModel.nickName = contactModel.nickName;
    //当前所在的所有分组名字
    NSMutableString * groupsNameStr=[[NSMutableString alloc]init];
    NSArray * groupIDArr = [GroupData getAllGroupsIDByContactID:contactModel.contactID.integerValue];
    for (int i=0; i<groupIDArr.count ; i++) {
        NSNumber * groupID = groupIDArr[i];
        NSString * groupName = [GroupData getGroupNameByGroupID:groupID.integerValue];
        if (i == groupIDArr.count-1) {//最后一个
            [groupsNameStr appendFormat:@"%@",groupName];
        }else{
            [groupsNameStr appendFormat:@"%@,",groupName];
        }
    }
    listModel.groupsName=groupsNameStr;
    [groupsNameStr release];
    
    //QQ、易信、微信
    for (HB_InstantMessageModel * imModel in contactModel.IMArr) {
        if ([imModel.type isEqualToString:(NSString *)kABPersonInstantMessageServiceQQ]) {
            if (imModel.account.length) {
                listModel.QQ = imModel.account;
            }
        }else if ([imModel.type isEqualToString:kSABYiXin]) {
            if (imModel.account.length) {
                listModel.yiXin = imModel.account;
            }
        }else if ([imModel.type isEqualToString:kSABWeiXin]){
            if (imModel.account.length) {
                listModel.weiXin = imModel.account;
            }
        }
    }
    
    //***************************公司地址、家庭地址、公司邮编、家庭邮编****************************
    HB_AddressModel *companyAddressModel = nil;
    HB_AddressModel *homeAddressModel = nil;
    //从联系人模型中查询出标签为_$!<Work>!$_ 和 "_$!<Home>!$_ 的地址模型，分别赋值给‘公司地址’‘家庭地址’
    for (HB_AddressModel *addressModel in contactModel.addressArr) {
        if ([addressModel.type isEqualToString:@"_$!<Work>!$_"]) {
            companyAddressModel = addressModel;
        }else if ([addressModel.type isEqualToString:@"_$!<Home>!$_"]){
            homeAddressModel = addressModel;
        }
    }
    if (homeAddressModel) {
        //把街道中的'\n'换行符，转换为“,”
        NSArray * streetArr = [homeAddressModel.street componentsSeparatedByString:@"\n"];
        homeAddressModel.street = [streetArr componentsJoinedByString:@","];
        //拼接地址
        NSMutableString *homeAddressStr = [NSMutableString string];
        if (homeAddressModel.country) {
            [homeAddressStr appendString:homeAddressModel.country];
        }
        if (homeAddressModel.state) {
            [homeAddressStr appendString:homeAddressModel.state];
        }
        if (homeAddressModel.city) {
            [homeAddressStr appendString:homeAddressModel.city];
        }
        if (homeAddressModel.street) {
            [homeAddressStr appendString:homeAddressModel.street];
        }
        
        listModel.address_family = homeAddressStr;
        listModel.postcode_family = homeAddressModel.zip;
    }
    if (companyAddressModel) {
        //把街道中的'\n'换行符，转换为“,”
        NSArray * streetArr = [companyAddressModel.street componentsSeparatedByString:@"\n"];
        companyAddressModel.street = [streetArr componentsJoinedByString:@","];
        //拼接地址
        NSMutableString *companyAddressStr = [NSMutableString string];
        if (companyAddressModel.country) {
            [companyAddressStr appendString:companyAddressModel.country];
        }
        if (companyAddressModel.state) {
            [companyAddressStr appendString:companyAddressModel.state];
        }
        if (companyAddressModel.city) {
            [companyAddressStr appendString:companyAddressModel.city];
        }
        if (companyAddressModel.street) {
            [companyAddressStr appendString:companyAddressModel.street];
        }
        listModel.address_company = companyAddressStr;
        listModel.postcode_company = companyAddressModel.zip;
    }
    
    //公司主页地址 、 个人主页地址
    HB_UrlModel *companyUrlModel = nil;
    HB_UrlModel *persionalUrlModel = nil;
    for (HB_UrlModel *urlModel in contactModel.urlArr) {
        NSLog(@"%@",urlModel.url);
        if ([urlModel.type isEqualToString:(NSString *)kABWorkLabel]) {
            companyUrlModel = urlModel;
        }else if ([urlModel.type isEqualToString:(NSString *)kABPersonHomePageLabel]){
            persionalUrlModel = urlModel;
        }
    }
    if (companyUrlModel) {
        listModel.url_company = companyUrlModel.url;
    }
    if (persionalUrlModel) {
        listModel.url_person = persionalUrlModel.url;
    }
    
    //生日
    if (contactModel.birthday.length>0) {
        NSString * birthdayStr=[NSString stringWithFormat:@"%@",contactModel.birthday];
        //birthday=1992-11-04 12:00:00 +0000
        birthdayStr=[birthdayStr substringToIndex:10];
        listModel.birthday = birthdayStr;
    }
    //备注
    if (contactModel.note) {
        listModel.note = contactModel.note;
    }
    if (contactModel.cardName.length) {
        listModel.cardName = contactModel.cardName;
    }
}
+(void)convertListModel:(HB_ContactDetailListModel *)listModel toContactModel:(HB_ContactModel *)contactModel{
    //头像
    contactModel.iconData_original = listModel.iconData_original;
    //姓名
    contactModel.lastName = listModel.name;
    contactModel.middleName=nil;
    contactModel.firstName=nil;
    //电话
    contactModel.phoneArr = [HB_ConvertPhoneNumArrTool convertPhoneTypeWithPhoneArrHBZSToSystem:listModel.phoneArr];
    //邮件
    contactModel.emailArr = [HB_ConvertEmailArrTool convertEmailTypeWithArrayHBZSToSystem:listModel.eMailArr];
    //公司
    contactModel.organization=listModel.organization;
    //职务
    contactModel.jobTitle=listModel.jobTitle;
    //在职部门
    contactModel.department=listModel.department;
    //称谓
    contactModel.nickName=listModel.nickName;
    //生日
    contactModel.birthday=listModel.birthday;
    //备注
    contactModel.note=listModel.note;
    //别名
    contactModel.cardName = listModel.cardName;
    //社交工具数组赋值
    NSMutableArray * mutableArrIM=[NSMutableArray array];
    if (listModel.QQ.length) {
        HB_InstantMessageModel *qqModel = [[HB_InstantMessageModel alloc]init];
        qqModel.type = (NSString *)kABPersonInstantMessageServiceQQ;
        qqModel.account = listModel.QQ;
        [mutableArrIM addObject:qqModel];
        [qqModel release];
    }
    if (listModel.yiXin.length) {
        HB_InstantMessageModel *yiXinModel = [[HB_InstantMessageModel alloc]init];
        yiXinModel.type = kSABYiXin;
        yiXinModel.account = listModel.yiXin;
        [mutableArrIM addObject:yiXinModel];
        [yiXinModel release];
    }
    if (listModel.weiXin.length) {
        HB_InstantMessageModel *weiXinModel = [[HB_InstantMessageModel alloc]init];
        weiXinModel.type = kSABWeiXin;
        weiXinModel.account = listModel.weiXin;
        [mutableArrIM addObject:weiXinModel];
        [weiXinModel release];
    }
    contactModel.IMArr=mutableArrIM;
    //地址
    NSMutableArray * mutableArrAddress=[NSMutableArray array];
    if (listModel.address_company) {
        HB_AddressModel *companyAdrModel = [[HB_AddressModel alloc]init];
        companyAdrModel.type = @"_$!<Work>!$_";
        companyAdrModel.street = listModel.address_company;
        companyAdrModel.zip = listModel.postcode_company;
        
        [mutableArrAddress addObject:companyAdrModel];
        [companyAdrModel release];
    }
    if (listModel.address_family) {
        HB_AddressModel *homeAdrModel = [[HB_AddressModel alloc]init];
        homeAdrModel.type = @"_$!<Home>!$_";
        homeAdrModel.street = listModel.address_family;
        homeAdrModel.zip = listModel.postcode_family;
        
        [mutableArrAddress addObject:homeAdrModel];
        [homeAdrModel release];
    }
    contactModel.addressArr=mutableArrAddress;
    //url数组
    NSMutableArray * mutableArrUrl=[NSMutableArray array];
    if (listModel.url_company) {
        HB_UrlModel *companyUrlModel = [[HB_UrlModel alloc]init];
        companyUrlModel.type = (NSString *)kABWorkLabel;
        companyUrlModel.url = listModel.url_company;
        [mutableArrUrl addObject:companyUrlModel];
        [companyUrlModel release];
    }
    if (listModel.url_person) {
        HB_UrlModel *personUrlModel = [[HB_UrlModel alloc]init];
        personUrlModel.type = (NSString *)kABPersonHomePageLabel;
        personUrlModel.url = listModel.url_person;
        [mutableArrUrl addObject:personUrlModel];
        [personUrlModel release];
    }
    contactModel.urlArr=mutableArrUrl;
}

@end
