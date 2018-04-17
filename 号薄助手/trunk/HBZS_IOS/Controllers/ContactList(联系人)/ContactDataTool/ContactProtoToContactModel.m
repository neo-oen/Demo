//
//  ContactProtoToContactModel.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/3/1.
//
//

#import "ContactProtoToContactModel.h"
#import "HB_InstantMessageModel.h"
#import "HB_UrlModel.h"
#import "HB_AddressModel.h"
@implementation ContactProtoToContactModel

@class ContactProtoToContactModel;
static ContactProtoToContactModel * manager;
+(ContactProtoToContactModel *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager  = [[ContactProtoToContactModel alloc] init];
    });
    return manager;
}

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(Contact*)ContactModelmemMycard:(HB_ContactModel *)model
{
    Contact_Builder * memContactbfbd = [[Contact_Builder alloc] init];
    //版本号
    [memContactbfbd setVersion:model.version];
    
    //名字
    Name_Builder * namebuilder = [[Name_Builder alloc] init];
    [namebuilder setFamilyName:model.lastName];
    [namebuilder setNickName:model.nickName];
    [memContactbfbd setName:[namebuilder build]];
    [namebuilder release];
    
    //公司
    Employed_Builder * empBd = [[Employed_Builder alloc] init];
    [empBd setEmpCompany:model.organization];
    [empBd setEmpTitle:model.jobTitle];
    [empBd setEmpDept:model.department];

    [memContactbfbd setEmployed:[empBd build]];
    [empBd release];
    
    /*-号码多值-*/
    NSArray * phoneArr = model.phoneArr;
    NSMutableArray * tempPhonearr = [NSMutableArray arrayWithCapacity:0];
    for (HB_PhoneNumModel * pnModel in phoneArr) {
        
        Phone_Builder * phoneBd = [[Phone_Builder alloc] init];
        [phoneBd setPhoneValue:pnModel.phoneNum];
        Phone * phone = [phoneBd build];
        
        if([pnModel.phoneType isEqualToString:(NSString *)kABPersonPhoneMobileLabel] &&!memContactbfbd.mobilePhone.phoneValue.length){//_$!<Mobile>!$_
            [memContactbfbd setMobilePhone:phone];
        }
        else if([pnModel.phoneType isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel]&&!memContactbfbd.workMobilePhone.phoneValue.length){//iPhone
            
            [memContactbfbd setWorkMobilePhone:phone];
        }
        else if([pnModel.phoneType isEqualToString:(NSString *)kABPersonPhoneMainLabel] && !memContactbfbd.homeTelephone.phoneValue.length){//_$!<Main>!$_
            [memContactbfbd setHomeTelephone:phone];
        }
        else if([pnModel.phoneType isEqualToString:(NSString *)kABPersonPhoneHomeFAXLabel]&&!memContactbfbd.homeFax.phoneValue.length){//_$!<HomeFAX>!$_
            [memContactbfbd setHomeFax:phone];
        }
        else if([pnModel.phoneType isEqualToString:(NSString *)kABPersonPhoneWorkFAXLabel]&&!memContactbfbd.workFax.phoneValue.length){//_$!<WorkFAX>!$_
            [memContactbfbd setWorkFax:phone];
        }
        else if([pnModel.phoneType isEqualToString:(NSString *)kABPersonPhonePagerLabel]&&!memContactbfbd.fax.phoneValue.length)
        { //_$!<Pager>!$_
            [memContactbfbd setFax:phone];
        }
        else if([pnModel.phoneType isEqualToString:(NSString *)kABWorkLabel]&&!memContactbfbd.workTelephone.phoneValue.length){//_$!<Work>!$_
            [memContactbfbd setWorkTelephone:phone];
        }
        else if([pnModel.phoneType isEqualToString:(NSString *)kABHomeLabel]&&!memContactbfbd.telephone.phoneValue.length){//_$!<Home>!$_
            [memContactbfbd setTelephone:phone];
        }
        else if([pnModel.phoneType isEqualToString:(NSString *)kABOtherLabel]&&!memContactbfbd.vpn.phoneValue.length){
            [memContactbfbd setVpn:phone];
        }
        else{
            
            [tempPhonearr addObject:phone];
            
        }
        
        [phoneBd release];
    }
    //号码其他标签处理
    for (Phone * phone in tempPhonearr) {
        if (!memContactbfbd.mobilePhone.phoneValue.length) {
            [memContactbfbd setMobilePhone:phone];
        }
        else if (!memContactbfbd.workMobilePhone.phoneValue.length)
        {
            [memContactbfbd setWorkMobilePhone:phone];
        }
        else if (!memContactbfbd.telephone.phoneValue.length)
        {
            [memContactbfbd setTelephone:phone];
        }
        else if (!memContactbfbd.workTelephone.phoneValue.length)
        {
            [memContactbfbd setWorkTelephone:phone];
            
        }
        else if (!memContactbfbd.homeTelephone.phoneValue.length)
        {
            [memContactbfbd setHomeTelephone:phone];
            
        }
        else if (!memContactbfbd.fax.phoneValue.length)
        {
            [memContactbfbd setFax:phone];
        }
        else if (!memContactbfbd.homeFax.phoneValue.length)
        {
            [memContactbfbd setHomeFax:phone];
        }
        else if (!memContactbfbd.workFax.phoneValue.length)
        {
            [memContactbfbd setWorkFax:phone];
        }
        else if (!memContactbfbd.vpn.phoneValue.length)
        {
            [memContactbfbd setVpn:phone];
        }
    }
    /*------*/
    
    
    //邮箱多值
    
    NSArray * Emailarr = model.emailArr;
    NSMutableArray * EmailTempArr = [NSMutableArray arrayWithCapacity:0];
    for (HB_EmailModel * emailmodel in Emailarr) {
        Email_Builder * EmailBd = [[Email_Builder alloc] init];
        [EmailBd setEmailValue:emailmodel.emailAddress];
        Email * email = [EmailBd build];
        if ([emailmodel.emailType isEqualToString:@"_$!<Home>!$_"] && !memContactbfbd.email.emailValue.length) {
            [memContactbfbd setEmail:email];
        }
        else if ([emailmodel.emailType isEqualToString:@"_$!<Work>!$_"] && !memContactbfbd.workEmail.emailValue.length) {
            [memContactbfbd setWorkEmail:email];
        }
        else if ([emailmodel.emailType isEqualToString:@"_$!<Other>!$_"] && !memContactbfbd.comEmail.emailValue.length) {
            [memContactbfbd setComEmail:email];
        }
        else if ([emailmodel.emailType isEqualToString:kSABMSNLabel] && !memContactbfbd.msn.imValue.length) {
            [memContactbfbd setMsn:[[[InstantMessage builder] setImValue:email.emailValue]build]];
        }
        else if([emailmodel.emailType isEqualToString:@"iCloud"] && !memContactbfbd.ePhone.phoneValue.length)
        {
            Phone *phone = [[[Phone builder] setPhoneValue:email.emailValue] build];
            [memContactbfbd setEPhone:phone];
        }
        else
        {
            [EmailTempArr addObject:emailmodel];
        }
        
    }
    //邮箱重复标签处理
    for (HB_EmailModel * model in EmailTempArr) {
        Email_Builder * EmailBd = [[Email_Builder alloc] init];
        [EmailBd setEmailValue:model.emailAddress];
        Email * email = [EmailBd build];
        if (!memContactbfbd.email.emailValue.length) {
            [memContactbfbd setEmail:email];
        }
        else if (!memContactbfbd.workEmail.emailValue.length) {
            [memContactbfbd setWorkEmail:email];
        }
        else if (!memContactbfbd.comEmail.emailValue.length) {
            [memContactbfbd setComEmail:email];
        }
        else if (!memContactbfbd.msn.imValue.length) {
            [memContactbfbd setMsn:[[[InstantMessage builder] setImValue:email.emailValue]build]];
        }
        else if(!memContactbfbd.ePhone.phoneValue.length)
        {
            Phone *phone = [[[Phone builder] setPhoneValue:email.emailValue] build];
            [memContactbfbd setEPhone:phone];
        }
        
    }
    
    
    [memContactbfbd setBirthday:model.birthday];
    
    //社交工具多值
    NSArray * arr = model.IMArr;
    for (HB_InstantMessageModel * IMmodel in arr) {
        
        InstantMessage * im = [[[InstantMessage builder] setImValue:IMmodel.account] build];
        if ([IMmodel.type isEqualToString:(NSString *)kABPersonInstantMessageServiceQQ]) {
            [memContactbfbd setQq:im];
        }
        else if ([IMmodel.type isEqualToString:kSABYiXin]) {
            [memContactbfbd setYixin:im];
        }
        else if ([IMmodel.type isEqualToString:kSABWeiXin]) {
            [memContactbfbd setWeixin:im];
        }
    }
    
    //url多值
    NSArray * Urlarr = model.urlArr;
    for (HB_UrlModel * urlModel in Urlarr) {
        Website * website = [[[Website builder] setPageValue:urlModel.url] build];
        if ([urlModel.type isEqualToString:(NSString *)kABWorkLabel]) {
            [memContactbfbd setComPage:website];
        }
        else if ([urlModel.type isEqualToString:(NSString *)kABPersonHomePageLabel])
        {
            [memContactbfbd setPersonPage:website];
        }
    }
    
    //地址
    NSArray * addressArr = model.addressArr;
    for (HB_AddressModel * addressModel in addressArr) {
        Address_Builder * address_bu = [Address builder];
        [address_bu setAddrValue:addressModel.street];
        [address_bu setAddrPostal:addressModel.zip];
        Address * address = [address_bu build];
        if ([addressModel.type isEqualToString:@"_$!<Work>!$_"]) {
            [memContactbfbd setWorkAddr:address];
        }
        else if ([addressModel.type isEqualToString:@"_$!<Home>!$_"])
        {
            [memContactbfbd setHomeAddr:address];
        }
    }
    
    //备注
    [memContactbfbd setComment:model.note];
    
    //多名片属性
    //名片名称
    [memContactbfbd setCardName:model.cardName];
    //时间戳
    [memContactbfbd setTimestamp:model.timestamp];
    //id
    [memContactbfbd setCardSid:abs(model.cardid)];
    
    
    
    
    Contact * contact = [memContactbfbd build];
    return contact;
}

-(HB_ContactModel *)memMycardToContactModel:(Contact *)memContact
{
    
    HB_ContactModel * model = [[[HB_ContactModel alloc] init]autorelease];
    model.lastName = memContact.name.familyName;
    model.firstName = memContact.name.givenName;
    model.nickName = memContact.name.nickName;
    model.organization = memContact.employed.empCompany;
    model.jobTitle = memContact.employed.empTitle;
    model.department = memContact.employed.empDept;
    model.birthday = memContact.birthday;
    model.iconData_original = [[MemAddressBook getInstance] myPortrait].imageData;
    model.iconData_thumbnail = [[MemAddressBook getInstance] myPortrait].imageData;
    model.note = memContact.comment;
    model.phoneArr = [self MemContactToContactModelPhoneArr:memContact];
    
    model.emailArr = [self MemContactToContactModelEmailArr:memContact];
    
    model.IMArr = [self MemContactToContactModelIMArr:memContact];
    
    model.urlArr = [self MemContactToContactModelUrlArr:memContact];
    
    model.addressArr = [self MemContactToContactModelAddressArr:memContact];
    
    model.version = memContact.version;
    //多名片属性
    model.cardid = memContact.cardSid;
    model.timestamp = memContact.timestamp;
    model.cardName = memContact.cardName;
    
    return model;
}
-(NSMutableArray *)MemContactToContactModelAddressArr:(Contact *)memContact
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    if (memContact.homeAddr.addrValue.length||memContact.homeAddr.addrPostal.length) {
        HB_AddressModel * HomeAddrModel = [[HB_AddressModel alloc] init];
        HomeAddrModel.type = @"_$!<Home>!$_";
        HomeAddrModel.street = memContact.homeAddr.addrValue;
        HomeAddrModel.zip = memContact.homeAddr.addrPostal;
        [arr addObject:HomeAddrModel];
        [HomeAddrModel release];
    }
    if (memContact.workAddr.addrValue.length||memContact.workAddr.addrPostal.length) {
        HB_AddressModel * AddrModel = [[HB_AddressModel alloc] init];
        AddrModel.type = @"_$!<Work>!$_";
        AddrModel.street = memContact.workAddr.addrValue;
        AddrModel.zip = memContact.workAddr.addrPostal;
        [arr addObject:AddrModel];
        [AddrModel release];
    }
    
    return  arr;
}
-(NSMutableArray *)MemContactToContactModelIMArr:(Contact *)memContact
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    if (memContact.qq.imValue.length>0) {
        HB_InstantMessageModel * model = [[HB_InstantMessageModel alloc] init];
        model.type = (NSString *)kABPersonInstantMessageServiceQQ;
        model.account = memContact.qq.imValue;
        [arr addObject:model];
        [model release];
    }
    if (memContact.weixin.imValue.length>0) {
        HB_InstantMessageModel * model = [[HB_InstantMessageModel alloc] init];
        model.type = kSABWeiXin;
        model.account = memContact.weixin.imValue;
        [arr addObject:model];
        [model release];
    }
    if (memContact.yixin.imValue.length>0) {
        HB_InstantMessageModel * model = [[HB_InstantMessageModel alloc] init];
        model.type = kSABYiXin;
        model.account = memContact.yixin.imValue;
        [arr addObject:model];
        [model release];
    }
    return arr;

}

-(NSMutableArray *)MemContactToContactModelUrlArr:(Contact *)memContact
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    if (memContact.personPage.pageValue.length>0) {
        HB_UrlModel * model = [[HB_UrlModel alloc] init];
        model.url = memContact.personPage.pageValue;
        model.type = (NSString *)kABPersonHomePageLabel;
        [arr addObject:model];
        [model release];
    }
    if (memContact.comPage.pageValue.length>0) {
        HB_UrlModel * model = [[HB_UrlModel alloc] init];
        model.url = memContact.comPage.pageValue;
        model.type = (NSString *)kABWorkLabel;
        [arr addObject:model];
        [model release];
    }

    return arr;
}

#pragma mark 名片号码转换
-(NSMutableArray *)MemContactToContactModelPhoneArr:(Contact *)memContact
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    if (memContact.mobilePhone.phoneValue.length>0) {
        [arr addObject:[self PhoneWithTypeString:@"_$!<Mobile>!$_" AndPhoneSting:memContact.mobilePhone.phoneValue]];
    }
    if (memContact.homeTelephone.phoneValue.length>0) {
        [arr addObject:[self PhoneWithTypeString:@"_$!<Main>!$_" AndPhoneSting:memContact.homeTelephone.phoneValue]];
    }
    if (memContact.workTelephone.phoneValue.length>0) {
        [arr addObject:[self PhoneWithTypeString:@"_$!<Work>!$_" AndPhoneSting:memContact.workTelephone.phoneValue]];
    }
    if (memContact.telephone.phoneValue.length>0) {
        [arr addObject:[self PhoneWithTypeString:@"_$!<Home>!$_" AndPhoneSting:memContact.telephone.phoneValue]];
    }
    if (memContact.workMobilePhone.phoneValue.length>0) {
        [arr addObject:[self PhoneWithTypeString:@"iPhone" AndPhoneSting:memContact.workMobilePhone.phoneValue]];
    }
    if (memContact.ePhone.phoneValue.length>0) {
        [arr addObject:[self PhoneWithTypeString:@"iCloud" AndPhoneSting:memContact.ePhone.phoneValue]];
    }
    if (memContact.fax.phoneValue.length>0) {
        [arr addObject:[self PhoneWithTypeString:@"_$!<Pager>!$_" AndPhoneSting:memContact.fax.phoneValue]];
    }
    if (memContact.homeFax.phoneValue.length>0) {
        [arr addObject:[self PhoneWithTypeString:@"_$!<HomeFAX>!$_" AndPhoneSting:memContact.homeFax.phoneValue]];
    }
    if (memContact.workFax.phoneValue.length>0) {
        [arr addObject:[self PhoneWithTypeString:@"_$!<WorkFAX>!$_" AndPhoneSting:memContact.workFax.phoneValue]];
    }
    if(memContact.vpn.phoneValue.length >0)
    {
        [arr addObject:[self PhoneWithTypeString:(NSString *)kABOtherLabel AndPhoneSting:memContact.vpn.phoneValue]];//kSABVPNLabel
    }
    
    return arr;
}
-(HB_PhoneNumModel*)PhoneWithTypeString:(NSString *)typeString AndPhoneSting:(NSString *)Phone
{
    HB_PhoneNumModel *phoneModel = [[[HB_PhoneNumModel alloc]init] autorelease];
    //    phoneModel.index =
    phoneModel.phoneType = typeString;
    phoneModel.phoneNum = Phone;
    return phoneModel;
}


#pragma mark 名片邮箱转换

-(NSMutableArray * )MemContactToContactModelEmailArr:(Contact *)memContact
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    if (memContact.comEmail.emailValue.length>0) {
        [arr addObject:[self EmailWithTypeString:@"_$!<Other>!$_" AndPhoneSting:memContact.comEmail.emailValue]];
        
    }
    if (memContact.workEmail.emailValue.length>0) {
        [arr addObject:[self EmailWithTypeString:@"_$!<Work>!$_" AndPhoneSting:memContact.workEmail.emailValue]];
    }
    if (memContact.email.emailValue.length>0) {
        [arr addObject:[self EmailWithTypeString:@"_$!<Home>!$_" AndPhoneSting:memContact.email.emailValue]];
    }
    if (memContact.msn.imValue.length>0) {
        [arr addObject:[self EmailWithTypeString:kSABMSNLabel AndPhoneSting:memContact.msn.imValue]];
    }
    if (memContact.ePhone.phoneValue.length>0) {
        [arr addObject:[self EmailWithTypeString:@"iCloud" AndPhoneSting:memContact.ePhone.phoneValue]];
    }
    return arr;
}

-(HB_EmailModel*)EmailWithTypeString:(NSString *)typeString AndPhoneSting:(NSString *)email
{
    HB_EmailModel *emailModel = [[HB_EmailModel alloc]init];
    emailModel.emailType = typeString;
    emailModel.emailAddress = email;
    //    emailModel.index = i;
    return emailModel;
}

@end
