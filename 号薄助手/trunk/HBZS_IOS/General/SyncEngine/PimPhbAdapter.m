//
//  PimPhbAdapter.m
//  HBZS_IOS
//
//  Created by RenTao (tour_ren@163.com) on 1/6/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "ContactProto.pb.h"
#import "MemAddressBook.h"
#import "GobalSettings.h"
#import "SyncErr.h"

#import "Public.h"
#import "HB_ContactSendTopTool.h"

#pragma mark addKeyValue2Comment  (拼接 comment)
NSString* addKeyValue2Comment(NSString* key, NSString* value, NSString* comment)
{
    if (key != nil && value != nil){
        NSString* kvString = [NSString stringWithFormat:@"%@:%@;", key, value];
        
        NSRange range = [comment rangeOfString:kvString];
        
        if (range.length <= 0){
            comment = [comment stringByAppendingString:kvString];
        }
    }
    
    return comment;
}

#pragma mark ////// addPropertyKeyValue2Comment
NSString* addPropertyKeyValue2Comment(NSString* key, NSString* value, NSString* comment)
{
    if (key != nil)
    {
      //  NSString* newkeyString = [NSString stringWithFormat:@"%d.%@", property, key];
        
        return addKeyValue2Comment(key, value, comment);
    }
    
    return comment;
}

#pragma mark  addPropertyLabelKeyValue2Comment  ////////////////
NSString* addPropertyLabelKeyValue2Comment(ABPropertyID property, NSString* label, NSString* key, NSString* value, NSString* comment)
{
    if (label != nil && key != nil)
    {
        NSString* newkeyString = [NSString stringWithFormat:@"%d.%@.%@", property, label, key];
        
        return addKeyValue2Comment(newkeyString, value, comment);
    }
    
    return comment;
}

#pragma mark String2Date
NSDate* String2Date(NSString* strDate)
{
	NSDateFormatter *inputFormat = [[NSDateFormatter alloc] init];
    
	[inputFormat setDateFormat:@"yyyy-MM-dd"]; //2012-06-06 09:53:43
    
	//将NSString转换为NSDate
	NSDate *date  = [inputFormat dateFromString:strDate];
    
    [inputFormat release];
    
	return date;
}

#pragma mark Date2String
NSString* Date2String(NSDate* date)
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    [dateFormatter release];
    //[dateString autorelease];
    return dateString;
}

#pragma mark 血型 转换 血型 代号

int bloodTypeToCode(NSString *blood){
    int code = 0;
    
    if ([blood isEqualToString:@"A型"]) {
        code = 1;
    }
    else  if ([blood isEqualToString:@"B型"]) {
        code = 2;
    }
    else  if ([blood isEqualToString:@"0型"]) {
        code = 3;
    }
    else  if ([blood isEqualToString:@"AB型"]) {
        code = 4;
    }
    
    return code;
}

#pragma mark 星座 转换成 星座 代号
int constellationToCode(NSString *constellation){
    int code = 0;
    
    if ([constellation isEqualToString:@"摩羯座"]) {
        code = 1;
    }
    else if ([constellation isEqualToString:@"水瓶座"]) {
        code = 2;
    }
    else if ([constellation isEqualToString:@"双鱼座"]) {
        code = 3;
    }
    else if ([constellation isEqualToString:@"白羊座"]) {
        code = 4;
    }
    else if ([constellation isEqualToString:@"金牛座"]) {
        code = 5;
    }
    else if ([constellation isEqualToString:@"双子座"]) {
        code = 6;
    }
    else if ([constellation isEqualToString:@"巨蟹座"]) {
        code = 7;
    }
    else if ([constellation isEqualToString:@"狮子座"]) {
        code = 8;
    }
    else if ([constellation isEqualToString:@"处女座"]) {
        code = 9;
    }
    else if ([constellation isEqualToString:@"天枰座"]) {
        code = 10;
    }
    else if ([constellation isEqualToString:@"天蝎座"]) {
        code = 11;
    }
    else if ([constellation isEqualToString:@"射手座"]) {
        code = 12;
    }
    
    return code;
}

int genderToCode(NSString *gender){
    int code = 0;
    
    if ([gender isEqualToString:@"男"]) {
        code = 1;
    }
    else if([gender isEqualToString:@"女"]){
        code = 2;
    }
    
    return code;
}

//FamilyName Builder
void setFamilyNameBuilder(ABRecordRef record, Contact_Builder* cb){
    NSString* value;
    
    NSString* lable;
    
    Name_Builder* nameBD = [[Name_Builder alloc] init]; // name
    // “姓”和“名”组合在一起，放到服务器的“姓”字段中。
    value = (NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
    
    lable = (NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
    
    NSString* fullName;  //全名
    
    if (nil == value){
        fullName = [NSString stringWithFormat:@"%@", (nil == lable) ? @"" : lable];
    }
    else if (nil == lable){
        fullName = [NSString stringWithFormat:@"%@", value];
    }
    else{
        fullName = [NSString stringWithFormat:@"%@%@", value, lable];
    }
    
    if ([fullName length] > 0){
        CFErrorRef error = nil;
        
        [nameBD setFamilyName:fullName];
        
        if (nil != lable){
            //如果本地“名”字段不为空，则需要更新本地数据：删掉“名”字段，重新设置“姓”字段。
            ABRecordSetValue(record, kABPersonFirstNameProperty, nil, &error);
            
            ABRecordSetValue(record, kABPersonLastNameProperty, fullName, &error);
        }
    }
    
    if (value) {
        [value release];
    }
    
    if (lable) {
        [lable release];
    }
    
    //NickName
    value = (NSString *)ABRecordCopyValue(record, kABPersonNicknameProperty);
    
    if (nil != value){
        [nameBD setNickName:value];
        
        [value release];
    }
    
    [cb setName:[nameBD build]];
    
    [nameBD release];
}

void setEmployBuilder(ABRecordRef record, Contact_Builder* cb){
    NSString *value;
    
    Employed_Builder* employedBD = [[Employed_Builder alloc] init];
    
    value = (NSString *)ABRecordCopyValue(record, kABPersonJobTitleProperty);
    
    if (nil != value){
        [employedBD setEmpTitle:value];
        
        [value release];
    }
    
    //Department
    value = (NSString *)ABRecordCopyValue(record, kABPersonDepartmentProperty);
    
    if (nil != value){
        [employedBD setEmpDept:value];
        
        [value release];
    }
    //Organization
    value = (NSString *)ABRecordCopyValue(record, kABPersonOrganizationProperty);
    
    if (nil != value){
        [employedBD setEmpCompany:value];
        
        [value release];
    }
    
    [cb setEmployed:[employedBD build]];
    
    [employedBD release];
}

void setBirthdayBuilder(ABRecordRef record, Contact_Builder *cb){
    NSDate *date = (NSDate *)ABRecordCopyValue(record, kABPersonBirthdayProperty);
    
    if (nil != date){
        [cb setBirthday:Date2String(date)];
        
        [date release];
    }
}


void setCustomTypePhoneBuilder(NSArray * arr, Contact_Builder *cb)
{
    
//    mobilePhone
//    workMobilePhone
//    telephone
//    workTelephone
//    homeTelephone;
//    fax
//    homeFax
//    workFax
//    vpn
    for (NSString * phone in arr) {
        if (!cb.mobilePhone.phoneValue.length) {
            [cb setMobilePhone:[[[Phone builder] setPhoneValue:phone] build]];
        }
        else if (!cb.workMobilePhone.phoneValue.length)
        {
            [cb setWorkMobilePhone:[[[Phone builder] setPhoneValue:phone] build]];
        }
        else if (!cb.telephone.phoneValue.length)
        {
            [cb setTelephone:[[[Phone builder] setPhoneValue:phone] build]];
        }
        else if (!cb.workTelephone.phoneValue.length)
        {
            [cb setWorkTelephone:[[[Phone builder] setPhoneValue:phone] build]];
            
        }
        else if (!cb.homeTelephone.phoneValue.length)
        {
            [cb setHomeTelephone:[[[Phone builder] setPhoneValue:phone] build]];
            
        }
        else if (!cb.fax.phoneValue.length)
        {
            [cb setFax:[[[Phone builder] setPhoneValue:phone] build]];
        }
        else if (!cb.homeFax.phoneValue.length)
        {
            [cb setHomeFax:[[[Phone builder] setPhoneValue:phone] build]];
        }
        else if (!cb.workFax.phoneValue.length)
        {
            [cb setWorkFax:[[[Phone builder] setPhoneValue:phone] build]];
        }
        else if (!cb.vpn.phoneValue.length)
        {
            [cb setVpn:[[[Phone builder] setPhoneValue:phone] build]];
        }
    }
}

NSArray * setPhoneBuilder(ABRecordRef record, Contact_Builder *cb){
    NSString *value;
    
    NSString *lable;
    
    ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(record, kABPersonPhoneProperty);
    
    NSMutableArray *comment = [NSMutableArray arrayWithCapacity:0];
    
	NSInteger nCount = ABMultiValueGetCount(phones);
    
    NSInteger _index = 1;

	//Phone
    for(int i = 0 ;i < nCount; i++){
		value = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        
        if(value == nil){
            continue;
        }
        
        if ([value rangeOfString:@"-"].length > 0) {
            value = [value stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        
		lable = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
       // NSLog(@"lable: %@, number: %@", lable, value);
        if([lable isEqualToString:(NSString *)kABPersonPhoneMobileLabel] &&!cb.mobilePhone.phoneValue.length){//_$!<Mobile>!$_
            [cb setMobilePhone:[[[Phone builder] setPhoneValue:value] build]];
		}
		else if([lable isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel]&&!cb.workMobilePhone.phoneValue.length){//iPhone
            
            [cb setWorkMobilePhone:[[[Phone builder] setPhoneValue:value] build]];
		}
		else if([lable isEqualToString:(NSString *)kABPersonPhoneMainLabel] && !cb.homeTelephone.phoneValue.length){//_$!<Main>!$_
            [cb setHomeTelephone:[[[Phone builder] setPhoneValue:value] build]];
		}
		else if([lable isEqualToString:(NSString *)kABPersonPhoneHomeFAXLabel]&&!cb.homeFax.phoneValue.length){//_$!<HomeFAX>!$_
            [cb setHomeFax:[[[Phone builder] setPhoneValue:value] build]];
		}
		else if([lable isEqualToString:(NSString *)kABPersonPhoneWorkFAXLabel]&&!cb.workFax.phoneValue.length){//_$!<WorkFAX>!$_
            [cb setWorkFax:[[[Phone builder] setPhoneValue:value] build]];
		}
        else if([lable isEqualToString:(NSString *)kABPersonPhonePagerLabel]&&!cb.fax.phoneValue.length)
        { //_$!<Pager>!$_
            [cb setFax:[[[Phone builder] setPhoneValue:value] build]];
        }
		else if([lable isEqualToString:(NSString *)kABWorkLabel]&&!cb.workTelephone.phoneValue.length){//_$!<Work>!$_
            [cb setWorkTelephone:[[[Phone builder] setPhoneValue:value] build]];
		}
		else if([lable isEqualToString:(NSString *)kABHomeLabel]&&!cb.telephone.phoneValue.length){//_$!<Home>!$_
            [cb setTelephone:[[[Phone builder] setPhoneValue:value] build]];
		}
		else if([lable isEqualToString:(NSString *)kABOtherLabel]&&!cb.vpn.phoneValue.length){
            [cb setVpn:[[[Phone builder] setPhoneValue:value] build]];
		}
        else{
            
            [comment addObject:value];
            
//            NSString *key = [NSString stringWithFormat:@"其它电话%d",_index];
//            
//            comment = addPropertyKeyValue2Comment(key, value, comment);
//            
//            ++_index;
        }
        
		if (lable) {
            [lable release];
            lable = nil;
        }
	}
	
    if (phones) {
        CFRelease(phones);
        phones = nil;
    }
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *str = [userDefaults objectForKey:@"otherEmail1"];
    
//    if (str != nil && str.length > 0) {
//        [cb setWorkFax:[[[Phone builder] setPhoneValue:str] build]];
//        [userDefaults removeObjectForKey:@"otherEmail1"];
//        [userDefaults synchronize];
//    }
    
//    str = [userDefaults objectForKey:@"otherEmail2"];
//    
//    if (str != nil && str.length > 0) {
//        [cb setEPhone:[[[Phone builder] setPhoneValue:str] build]];
//        [userDefaults removeObjectForKey:@"otherEmail2"];
//        [userDefaults synchronize];
//    }
    
    return comment;
}


void setCustomTypeEmailBuilder(NSArray * CustomTypeEmails,Contact_Builder *cb)
{
    for (NSString * EmailValue in CustomTypeEmails) {
        if(!cb.email.emailValue.length){
            [cb setEmail:[[[Email builder] setEmailValue:EmailValue] build]];
        }
        else if(!cb.workEmail.emailValue.length){
            [cb setWorkEmail:[[[Email builder] setEmailValue:EmailValue] build]];
        }
        else if(!cb.comEmail.emailValue.length){
            [cb setComEmail:[[[Email builder] setEmailValue:EmailValue] build]];
        }
        else if (!cb.ePhone.phoneValue.length)
        {
            [cb setEPhone:[[[Phone builder] setPhoneValue:EmailValue] build]];
        }
        else if(!cb.msn.imValue.length){
            [cb setMsn:[[[InstantMessage builder] setImValue:EmailValue] build]];
        }
    }
}

NSArray* setEmailBuilder(ABRecordRef record, Contact_Builder *cb){
   int _index = 1;
    // mails
    
    ABMultiValueRef mails = (ABMultiValueRef) ABRecordCopyValue(record, kABPersonEmailProperty);
    
   NSInteger nCount = ABMultiValueGetCount(mails);

    NSString *value;
    
    NSString *lable;
    
    NSMutableArray *comment = [NSMutableArray arrayWithCapacity:0];//[NSString string];
    
    for(int i = 0 ;i < nCount; i++){
		value = (NSString *)ABMultiValueCopyValueAtIndex(mails, i);
        
        if(value == nil){
            continue;
        }
        
		lable = (NSString *)ABMultiValueCopyLabelAtIndex(mails, i);
        
        if([lable isEqualToString:(NSString *)kABHomeLabel]&&!cb.email.emailValue.length){
            [cb setEmail:[[[Email builder] setEmailValue:value] build]];
		}
		else if([lable isEqualToString:(NSString *)kABWorkLabel]&&!cb.workEmail.emailValue.length){
            [cb setWorkEmail:[[[Email builder] setEmailValue:value] build]];
		}
		else if([lable isEqualToString:(NSString *)kABOtherLabel]&&!cb.comEmail.emailValue.length){
            [cb setComEmail:[[[Email builder] setEmailValue:value] build]];
		}
        else if ([lable isEqualToString:@"iCloud"]&&!cb.ePhone.phoneValue.length)
        {
            [cb setEPhone:[[[Phone builder] setPhoneValue:value] build]];
        }
		else if([lable isEqualToString:(NSString *)kSABMSNLabel]&&!cb.msn.imValue.length){
            [cb setMsn:[[[InstantMessage builder] setImValue:value] build]];
		}
//      else if([lable isEqualToString:@"其它邮箱1"]){
//            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//            [userDefault setObject:value forKey:@"otherEmail1"];
//            [userDefault synchronize];
//		}

//		else if([lable isEqualToString:(NSString *)kSABLunarBirthdayLabel]){
//            [cb setLunarBirthday:value];
//		}
//		else if([lable isEqualToString:(NSString *)kSABGenderLabel]){
//            if ([value length] > 0){
//                [cb setGender:genderToCode(value)];
//            }
//		}
//		else if([lable isEqualToString:(NSString *)kSABConstellationLabel]){
//            if ([value length] > 0){
//                [cb setConstellation:constellationToCode(value)];
//            }
//		}
//		else if([lable isEqualToString:(NSString *)kSABBloodTypeLabel]){
//            if ([value length]>0){
//                [cb setBloodType:bloodTypeToCode(value)];
//            }
//		}
        else{
//            NSString *key = [NSString stringWithFormat:@"其它邮箱%d",_index];
            
//            comment = addPropertyKeyValue2Comment(key, value, comment);
            
//            ++_index;
            [comment addObject:value];
        }
		
        if (value) {
            [value release];
            value = nil;
        }
        
		if (lable) {
            [lable release];
            lable = nil;
        }
	}
	
    if (mails) {
        CFRelease(mails);
        
        mails = nil;
    }
    
    return comment;
}

NSString* setDateBuilder(ABRecordRef record){
    int _index = 1;
    
    ABMultiValueRef dates = (ABMultiValueRef) ABRecordCopyValue(record, kABPersonDateProperty);
    
    
	NSInteger nCount = ABMultiValueGetCount(dates);
    
    NSString *lable;
    
    NSString *comment = @"";
	
    for(NSInteger i = 0; i < nCount; i++){
		NSDate* dateValue = (NSDate *)ABMultiValueCopyValueAtIndex(dates, i);
        
        if(dateValue == nil){
            continue;
		}
        
        lable = (NSString *)ABMultiValueCopyLabelAtIndex(dates, i);
        
        NSString *key = [NSString stringWithFormat:@"其它日期%d",_index];
        
	    comment = addPropertyKeyValue2Comment(key, Date2String(dateValue), comment);
        
        ++_index;
        
		if (dateValue) {
            [dateValue release];
            dateValue = nil;
        }
        
		if (lable) {
            [lable release];
            lable = nil;
        }
	}
    
	if (dates) {
        CFRelease(dates);
        dates = nil;
    }
    
    return comment;
}

NSString* setIMBuilder(ABRecordRef record, Contact_Builder *cb){
    ABMultiValueRef ims = (ABMultiValueRef) ABRecordCopyValue(record, kABPersonInstantMessageProperty);
    
	int nCount = ABMultiValueGetCount(ims);
	
    int _index = 1;
    
    NSString *comment = @"";
    
    for(int i = 0; i < nCount; i++){
		NSString *imsLable = (NSString *)ABMultiValueCopyLabelAtIndex(ims, i);
      
        if(imsLable == nil || [imsLable length] <= 0){
            if(imsLable){
                [imsLable release];
                
                imsLable = nil;
            }
            
            continue;
        }
        
		NSDictionary *imc = (NSDictionary *) ABMultiValueCopyValueAtIndex(ims, i);
        
        if(imc == nil || imc.count <= 0){
            if (imsLable) {
                [imsLable release];
                imsLable = nil;
            }
            
            continue;
        }
        
        NSString* service = [imc valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
        
        if(service == nil || [service length] <= 0){
            if (imsLable) {
                [imsLable release];
                imsLable = nil;
            }
            
            continue;
        }
        
        NSString* uvalue = [imc valueForKey:(NSString*)kABPersonInstantMessageUsernameKey];
        
        if(uvalue == nil || [uvalue length] <= 0){
            if (imsLable) {
                [imsLable release];
                imsLable = nil;
            }
            
            if (service) {
                [service release];
                service = nil;
            }
            
            continue;
        }
        
      //  NSLog(@"service: %@", service);
//        if([service isEqualToString:(NSString *)kABPersonInstantMessageServiceMSN]){
//            [cb setMsn:[[[InstantMessage builder] setImValue:uvalue] build]];
//        }
//        else if([service isEqualToString:(NSString *)kABPersonInstantMessageServiceICQ]){
//            [cb setQq:[[[InstantMessage builder] setImValue:uvalue] build]];
//        }
//        else{
//            NSString *key = [NSString stringWithFormat:@"其它即时通信方式%d",_index];
//            
//            comment = addKeyValue2Comment(key,uvalue, comment);
//            
//            ++_index;
//        }
        
        if([service isEqualToString:kSABWeiXin]){
            [cb setWeixin:[[[InstantMessage builder] setImValue:uvalue] build]];
        }
        else if ([service isEqualToString:kSABYiXin]) {
            [cb setYixin:[[[InstantMessage builder] setImValue:uvalue] build]];
        }
        else if([service isEqualToString:(NSString *)kABPersonInstantMessageServiceQQ]){
            [cb setQq:[[[InstantMessage builder] setImValue:uvalue] build]];
        }
        else{
            NSString *key = [NSString stringWithFormat:@"其它即时通信方式%d",_index];
            
            comment = addKeyValue2Comment(key,uvalue, comment);
            
            ++_index;
        }
        
		if (imc) {
            [imc release];
            imc = nil;
        }
        
		if (imsLable) {
            [imsLable release];
            imsLable = nil;
        }
	}
    
	if (ims) {
        CFRelease(ims);
        ims = nil;
    }
    
    return comment;
}

NSString* setUrlBuilder(ABRecordRef record,Contact_Builder *cb){
    ABMultiValueRef urls = (ABMultiValueRef) ABRecordCopyValue(record, kABPersonURLProperty);
    
	int nCount = ABMultiValueGetCount(urls);
    
    int _index = 1;
    
    NSString *value;
    
    NSString *lable;
    
    NSString *comment = @"";
	
    for(int i = 0; i < nCount; i++){
		value = (NSString *)ABMultiValueCopyValueAtIndex(urls, i);
        
        if (value == nil){
            continue;
        }
        
		lable = (NSString *)ABMultiValueCopyLabelAtIndex(urls, i);
		
        if([lable isEqualToString:(NSString *)kABWorkLabel]){
            [cb setComPage:[[[Website builder] setPageValue:value] build]];
		}
		else if([lable isEqualToString:(NSString *)kABPersonHomePageLabel]){
            [cb setPersonPage:[[[Website builder] setPageValue:value] build]];
		}
        else{
            NSString *key = [NSString stringWithFormat:@"其它网址%d",_index];
            
            comment = addPropertyKeyValue2Comment(key, value, comment);
            
            ++_index;
        }
		
		if (value) {
            [value release];
            value = nil;
        }
        
		if (lable) {
            [lable release];
            lable = nil;
        }
	}
    
	if (urls) {
        CFRelease(urls);
        urls = nil;
    }
    
    return comment;
}

NSString * setReleateNameBuilder(ABRecordRef record){
   int _index = 1;
    
    ABMultiValueRef rNames = (ABMultiValueRef) ABRecordCopyValue(record, kABPersonRelatedNamesProperty);
    
	int nCount = ABMultiValueGetCount(rNames);
    
    NSString *value;
    
    NSString *lable;
    
    NSString *comment = @"";
	
    for(int i = 0; i < nCount; i++){
		value = (NSString *)ABMultiValueCopyValueAtIndex(rNames, i);
        
        if (value == nil){
            continue;
        }
        
        lable = (NSString *)ABMultiValueCopyLabelAtIndex(rNames, i);
        
        NSString *key = [NSString stringWithFormat:@"其它相关联系人%d",_index];
        
        comment = addPropertyKeyValue2Comment(key, value, comment);
        
        ++_index;
        
		if (value) {
            [value release];
            value = nil;
        }
        
		if (lable) {
            [lable release];
            lable = nil;
        }
	}
	
    if (rNames) {
        CFRelease(rNames);
        rNames = nil;
    }
    
    return comment;
}

NSString* setAddressBuilder(ABRecordRef record, Contact_Builder *cb){
    ABMultiValueRef addresses = (ABMultiValueRef)ABRecordCopyValue(record, kABPersonAddressProperty);
    
	int nCount = ABMultiValueGetCount(addresses);
    
    int _index = 1;
    
    NSString *lable;
    NSString *value;
    NSString *comment = @"";
	
    for(int i = 0; i < nCount; i++){
		CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(addresses, i);
        
        if (dict == nil){
            continue;
		}
        
        lable = (NSString *)ABMultiValueCopyLabelAtIndex(addresses, i);
        
        Address_Builder* address_Builder = [Address builder];
        
        NSMutableString *pValue = [[NSMutableString alloc]init];
        
        value = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressCountryKey);
        
        if(value){
            [pValue appendFormat:@"%@",value];
        }
        
        value = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressStateKey);
        
        if(value){
            [pValue appendFormat:@"%@",value];
        }
        
        value = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressCityKey);
        
        if(value){
            [pValue appendFormat:@"%@",value];
        }
        
        value = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressStreetKey);
        
        if(value){
            [pValue appendFormat:@"%@",value];
        }
        
        if(pValue != nil && [pValue length] > 0) {
            [address_Builder setAddrValue:pValue];
        }
        
        value = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressZIPKey);
        
        if(value){
            [address_Builder setAddrPostal:value];
        }

        if([lable isEqualToString:(NSString *)kABWorkLabel]){
             [cb setWorkAddr:[address_Builder build]];
        }
        else if([lable isEqualToString:(NSString *)kABHomeLabel]){
             [cb setHomeAddr:[address_Builder build]]; 
        }
        else{
            NSString *key = [NSString stringWithFormat:@"其它地址%d",_index];
            
            comment = addPropertyKeyValue2Comment(key, pValue, comment);
            
            ++_index;
        }
        
        if (pValue) {
            [pValue release];
        }
        
        if (lable) {
           [lable release];
           lable = nil;
        }
        
        if (dict) {
            CFRelease(dict);
            dict = nil;
        }
    }
	
    if (addresses) {
        CFRelease(addresses);
        addresses = nil;
    }
    
    return comment;
}

/*
 * 根据record 单纯构建db 不考虑其他属性
 */
Contact * Just_ABRecord2Contact(ABRecordRef record)
{
    NSString* comment = @"";
    
    NSString* value;
    
    Contact_Builder * cb = [Contact builder];
    
//    ABRecordID cID = ABRecordGetRecordID(record);
    //Note
    value = (NSString *)ABRecordCopyValue(record, kABPersonNoteProperty);// note(备注)
    
    if(nil != value){
        comment = [comment stringByAppendingString:value];
        [value release];
    }
    
    setFamilyNameBuilder(record, cb);         //FamilyName Builder
    
    setEmployBuilder(record, cb);            //Employ Builder
    
    setBirthdayBuilder(record, cb);              //Birthday Builder
    
    NSArray  * temp1 = setEmailBuilder(record, cb);//Email Builder
    if (temp1.count) {
        setCustomTypeEmailBuilder(temp1, cb);
    }
    
    NSArray * customTypePhones = setPhoneBuilder(record, cb);
    if (customTypePhones.count) {
        setCustomTypePhoneBuilder(customTypePhones, cb);
    }
    
    NSString *temp3 = setDateBuilder(record);
    if (temp3 != nil) {
        comment = [comment stringByAppendingString:temp3];          //Date Builder
    }
    
    NSString *temp4 = setIMBuilder(record, cb);
    if (temp4 != nil) {
        comment = [comment stringByAppendingString:temp4];     //IM Builder
    }
    
    NSString *temp5 = setUrlBuilder(record, cb);
    if (temp5 != nil) {
        comment = [comment stringByAppendingString:temp5];         //Url Builder
    }
    
    NSString *temp6 = setReleateNameBuilder(record);
    if (temp6 != nil) {
        comment = [comment stringByAppendingString:temp6];     //ReleateName Builder
    }
    
    NSString *temp7 = setAddressBuilder(record, cb);
    if (temp7 != nil) {
        comment = [comment stringByAppendingString:temp7];         //Address Builder
    }
    
    // 提交备注
    [cb setComment:comment];
    
    
    
    // build group list
//    NSString* strPersonID = [[NSString alloc] initWithFormat:@"%d", cID];
    
//    NSArray* groupIdArray = [contat2groupDict valueForKey:strPersonID];
    
//    for (NSNumber *gid in groupIdArray){
//        [cb addGroupId:[gid intValue]];
//    }
    
//    [strPersonID release];
    return [cb build];
}

#pragma mark ///// PimPhb_ABRecord2Contact
/*
 * 根据record 构建cb、contat2groupDict
 */
UInt32 PimPhb_ABRecord2Contact(ABRecordRef record, Contact_Builder* cb, NSMutableDictionary* contat2groupDict)
{
    NSString* comment = @"";
    
    NSString* value;
    
    ABRecordID cID = ABRecordGetRecordID(record);
    
    BOOL istop = [HB_ContactSendTopTool contactIsSendTopWithRecordID:(NSInteger)cID];
    if (istop) {
        [cb setFavorite:istop];
    }
    //Note
	value = (NSString *)ABRecordCopyValue(record, kABPersonNoteProperty);// note(备注)
    
	if(nil != value){
        comment = [comment stringByAppendingString:value];
        [value release];
    }
   
    setFamilyNameBuilder(record, cb);         //FamilyName Builder
    
    setEmployBuilder(record, cb);            //Employ Builder
    
    setBirthdayBuilder(record, cb);              //Birthday Builder
    
    NSArray  * temp1 = setEmailBuilder(record, cb);//Email Builder
    if (temp1.count) {
        setCustomTypeEmailBuilder(temp1, cb);
    }
    
    NSArray * customTypePhones = setPhoneBuilder(record, cb);
    if (customTypePhones.count) {
        setCustomTypePhoneBuilder(customTypePhones, cb);
    }
    
    NSString *temp3 = setDateBuilder(record);
    if (temp3 != nil) {
        comment = [comment stringByAppendingString:temp3];          //Date Builder
    }
    
    NSString *temp4 = setIMBuilder(record, cb);
    if (temp4 != nil) {
        comment = [comment stringByAppendingString:temp4];     //IM Builder
    }
    
    NSString *temp5 = setUrlBuilder(record, cb);
    if (temp5 != nil) {
        comment = [comment stringByAppendingString:temp5];         //Url Builder
    }
    
    NSString *temp6 = setReleateNameBuilder(record);
    if (temp6 != nil) {
       comment = [comment stringByAppendingString:temp6];     //ReleateName Builder
    }
    
    NSString *temp7 = setAddressBuilder(record, cb);
    if (temp7 != nil) {
        comment = [comment stringByAppendingString:temp7];         //Address Builder
    }
    
    // 提交备注
    [cb setComment:comment];
    
    // build group list
    NSString* strPersonID = [[NSString alloc] initWithFormat:@"%d", cID];
    
    NSArray* groupIdArray = [contat2groupDict valueForKey:strPersonID];
    
    for (NSNumber *gid in groupIdArray){
        [cb addGroupId:[gid intValue]];
    }
    
    [strPersonID release];
    
    return SYNC_ERR_OK;
}

#pragma mark PimPhb_FindContactsInGroup ////////// // find all persons in the group.
/*
 * find all persons in the Group
 */
UInt32 PimPhb_FindContactsInGroup(ABRecordRef group, NSMutableDictionary* contat2groupDict) 
{
    CFIndex i, gSID;
    
    NSString* strPersonID;
    
    NSMutableArray* groupIDArray;
    
    ABRecordID gID;
    
    gID = ABRecordGetRecordID(group);
    
    gSID = [[MemAddressBook getInstance] getMemRecordByABRecordID:gID].serverId;
    
    NSNumber* nGroupID = [[NSNumber alloc] initWithInt:gSID];
    
    CFArrayRef persons = ABGroupCopyArrayOfAllMembers(group);     //group中所有联系人
    
    if(persons == nil){
        if (persons) {
            CFRelease(persons);
        }
        
        [nGroupID release];
        
        return SYNC_ERR_OK;
    }
    
    CFIndex personCount = CFArrayGetCount(persons);
    
    for (i = 0; i < personCount; i++)
    {
        ABRecordRef* person = (ABRecordRef*)CFArrayGetValueAtIndex(persons, i);
     // add group's serverId to it's persons.
        strPersonID = [[NSString alloc] initWithFormat:@"%d", ABRecordGetRecordID(person)];
        
        groupIDArray = [contat2groupDict valueForKey:strPersonID];
        
        if (nil == groupIDArray)
        {
            groupIDArray = [[[NSMutableArray alloc] init] autorelease];
            
            [contat2groupDict setValue:groupIDArray forKey:strPersonID];
        }
        
        [groupIDArray addObject:nGroupID];
        
        [strPersonID release];
    }
    
    if (persons) {
        CFRelease(persons);
    }
    
    [nGroupID release];
    
    return SYNC_ERR_OK;
}

#pragma mark //// PimPhb_ABRecord2Group(important)  // find all persons in the group.
UInt32 PimPhb_ABRecord2Group(ABRecordRef group, Group_Builder* gb, NSMutableDictionary* contat2groupDict, MemRecord* groupMR)
{
    NSString* value;
    
    value = (NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
    
    [gb setName:value];
    
    [value release];
    
    value = nil;
    
    CFIndex i;
    
    NSString* strPersonID;
    
    NSMutableArray* groupIDArray;
    
    NSNumber* nGroupID = [[[NSNumber alloc] initWithInt:[gb serverId]] autorelease];
    
    CFArrayRef persons = ABGroupCopyArrayOfAllMembers(group);    ///////该群组内的联系人
    
    if(persons == nil){
        if (persons) {
            CFRelease(persons);
        }
        return SYNC_ERR_OK;
    }
    
    CFIndex personCount = CFArrayGetCount(persons);
    
    for (i=0; i < personCount; i++)//遍历
    {
        ABRecordRef* person = (ABRecordRef*)CFArrayGetValueAtIndex(persons, i);
        // add group's serverId to it's persons.
        strPersonID = [[NSString alloc] initWithFormat:@"%d", ABRecordGetRecordID(person)];
        
        groupIDArray = [contat2groupDict valueForKey:strPersonID];
        
        if (nil == groupIDArray){
            groupIDArray = [[[NSMutableArray alloc] init] autorelease];
            
            [contat2groupDict setValue:groupIDArray forKey:strPersonID];//联系人属于哪些群组
        }
        
        [strPersonID release];
        
        [groupIDArray addObject:nGroupID];
        
        // add group's MemReocrd* to it's persons.
        if (groupMR){
            strPersonID = [[NSString alloc] initWithFormat:@"MR:%d", ABRecordGetRecordID(person)];
            
            groupIDArray = [contat2groupDict valueForKey:strPersonID];
            
            if (nil == groupIDArray){
                groupIDArray = [[[NSMutableArray alloc] init] autorelease];
                
                [contat2groupDict setValue:groupIDArray forKey:strPersonID];
            }
            
            [groupIDArray addObject:groupMR];
            
            [strPersonID release];
        }
    }
    
    if (persons) {
        CFRelease(persons);
    }
    
    return SYNC_ERR_OK;
}

#pragma mark PimPhb_Group2ABRecord  /////////////////
/*
 * 反序列化 后 Group 插入通讯录数据库
 */
UInt32 PimPhb_Group2ABRecord(Group* pGroup, ABRecordRef group)
{
    if(pGroup == NULL){
        return SML_ERR_WRONG_PARAM;
    }
    
    NSString *nsStr;
    
    CFErrorRef error = nil;
    // name
    nsStr = [pGroup name];    //群组名称
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABRecordSetValue(group, kABGroupNameProperty, nsStr, &error);  //beng //&error
    }
    
    // PG关系不在这里处理。
    return SYNC_ERR_OK;
}

NSString *covertGender(NSString *str){
    NSString *nsStr = @"";
    
    switch ([str intValue]) {
        case 1:{
            nsStr = @"男";
            
            break;
        }
        case 2:{
            nsStr = @"女";
            
            break;
        }
        default:{
            break;
        }
    }
    
    return nsStr;
}

//星座代号转换成中文
NSString *covertConstellation(NSString *str){
    NSString *nsStr = nil;
    
    switch ([str intValue])
    {
        case 1:{
            nsStr = @"摩羯座";
            
            break;
        }
        case 2:{
            nsStr = @"水瓶座";
            
            break;
        }
        case 3:{
            nsStr = @"双鱼座";
            
            break;
        }
        case 4:{
            nsStr = @"白羊座";
            
            break;
        }
        case 5:{
            nsStr = @"金牛座";
            
            break;
        }
        case 6:{
            nsStr = @"双子座";
            
            break;
        }
        case 7:{
            nsStr = @"巨蟹座";
            
            break;
        }
        case 8:{
            nsStr = @"狮子座";
            
            break;
        }
        case 9:{
            nsStr = @"处女座";
            
            break;
        }
        case 10:{
            nsStr = @"天枰座";
            
            break;
        }
        case 11:{
            nsStr = @"天蝎座";
            
            break;
        }
        case 12:{
            nsStr = @"射手座";
            
            break;
        }
            
        default:
            break;
    }
    
    return nsStr;
}

NSString *covertBlood(NSString *str){
    NSString *nsStr = nil;
    
    switch ([str intValue]) {
        case 1:{
            nsStr = @"A型";
            
            break;
        }
        case 2:{
            nsStr = @"B型";
            
            break;
        }
        case 3:{
            nsStr = @"O型";
            
            break;
        }
        case 4:{
            nsStr = @"AB型";
            
            break;
        }
        default:
            break;
    }
    
    return nsStr;
}

#pragma mark  --------
#pragma mark protocol Buffer值反序列化 插入通讯录数据库
void setPersonNameValue(Contact* pContact, ABRecordRef person){
    CFErrorRef error = nil;
	
    NSString* nsStr = [[pContact name] givenName];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABRecordSetValue(person, kABPersonFirstNameProperty, nsStr, &error);
    }
    
    nsStr = [[pContact name] familyName];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABRecordSetValue(person, kABPersonLastNameProperty, nsStr, &error);
    }
    
    nsStr = [[pContact name] nickName];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABRecordSetValue(person, kABPersonNicknameProperty, nsStr, &error);
    }
}

void setPersonEmployValue(Contact* pContact, ABRecordRef person){
    CFErrorRef error = nil;
    
    NSString *nsStr = [[pContact employed] empTitle];  //kABPersonJobTitleProperty
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABRecordSetValue(person, kABPersonJobTitleProperty, nsStr, &error);
	}
	
    nsStr = [[pContact employed] empDept];  // department
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABRecordSetValue(person, kABPersonDepartmentProperty, nsStr, &error);
    }
	
    nsStr = [[pContact employed] empCompany];   // company
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABRecordSetValue(person, kABPersonOrganizationProperty, nsStr, &error);
    }
}

void setPersonPhoneValue(Contact* pContact, ABRecordRef person){
    CFErrorRef error = nil;
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    NSString *nsStr = [[pContact mobilePhone] phoneValue];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiPhone, nsStr, kABPersonPhoneMobileLabel, NULL);   //mobilePhone
    }
    
    nsStr = [[pContact workMobilePhone] phoneValue];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiPhone, nsStr, kABPersonPhoneIPhoneLabel, NULL);  //workMobilePhone
    }
    
    nsStr = [[pContact telephone] phoneValue];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiPhone, nsStr, kABHomeLabel, NULL);    //telephone
    }
    
    nsStr = [[pContact workTelephone] phoneValue];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiPhone, nsStr, kABWorkLabel, NULL);   //workTelephone
    }
    
    nsStr = [[pContact homeTelephone] phoneValue];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiPhone, nsStr, kABPersonPhoneMainLabel, NULL);  //homeTelephone
    }
    // fax not find in AB, use Server record to store.
    nsStr = [[pContact fax] phoneValue];
   // NSLog(@"FAX: %@", nsStr);
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiPhone, nsStr, kABPersonPhonePagerLabel, NULL);  //fax
    }
    
    nsStr = [[pContact homeFax] phoneValue];
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiPhone, nsStr, kABPersonPhoneHomeFAXLabel, NULL);  //homeFax
    }
    
    nsStr = [[pContact workFax] phoneValue];
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiPhone, nsStr, kABPersonPhoneWorkFAXLabel, NULL);
        
    }
    
    
    // vpn not find in AB, use Server record to store.
    nsStr = [[pContact vpn] phoneValue];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiPhone, nsStr, kABOtherLabel, NULL);  //vpn
    }
    
    // ePhone not find in AB, use Server record to store.
//    nsStr = [[pContact ePhone] phoneValue];
//    
//    if(nil != nsStr && 0 < [nsStr length]){
//        ABMultiValueAddValueAndLabel(multiPhone, nsStr, (CFStringRef)kSABEPhoneLabel, NULL);  //ePhone
//    }
    
	if (ABMultiValueGetCount(multiPhone) > 0){
		ABRecordSetValue(person, kABPersonPhoneProperty, multiPhone, &error);    //kABPersonPhoneProperty
	}
    
    CFRelease(multiPhone);
}

void setPersonEmailValue(Contact* pContact, ABRecordRef person){
    CFErrorRef error = nil;
     //
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    NSString *nsStr = [[pContact email] emailValue];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiEmail,(CFStringRef)nsStr, kABHomeLabel, NULL);    //email
    }
    
    nsStr = [[pContact workEmail] emailValue];
 
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiEmail, (CFStringRef)nsStr, kABWorkLabel, NULL);  //workEmail
    }
    
    nsStr = [[pContact comEmail] emailValue];
  
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiEmail, (CFStringRef)nsStr, kABOtherLabel, NULL);  //comEmail
    }
    
    nsStr = [[pContact ePhone] phoneValue];
    //  NSLog(@"workFax: %@", nsStr);
    if(nil != nsStr && 0 < [nsStr length]){
        // NSLog(@"#### ePhone->其他邮箱2: %@", nsStr);
        ABMultiValueAddValueAndLabel(multiEmail,(CFStringRef)nsStr, (CFStringRef)@"iCloud", NULL);
    }
   
    
    nsStr = [[pContact msn] imValue];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiEmail, nsStr, (CFStringRef)kSABMSNLabel, NULL);     //MSN
    }
    
    nsStr = [pContact lunarBirthday];
    
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiEmail, nsStr, (CFStringRef)kSABLunarBirthdayLabel, NULL);   //LunarBirthday
    }
    
    if ([pContact hasGender]){
        nsStr = [NSString stringWithFormat:@"%d", [pContact gender]];
        
        nsStr = covertGender(nsStr);
        
        if (nsStr != nil && nsStr.length > 0) {
            ABMultiValueAddValueAndLabel(multiEmail, nsStr, (CFStringRef)kSABGenderLabel, NULL);    //Gender
        }
    }
    
    if ([pContact hasConstellation]){
        nsStr = [NSString stringWithFormat:@"%d", [pContact constellation]];
        
        nsStr = covertConstellation(nsStr);
        
        if (nsStr != nil && nsStr.length > 0) {
            ABMultiValueAddValueAndLabel(multiEmail, nsStr, (CFStringRef)kSABConstellationLabel, NULL);   //Constellation
        }
    }
    
    if ([pContact hasBloodType]){
        nsStr = [NSString stringWithFormat:@"%d", [pContact bloodType]];
        
        nsStr = covertBlood(nsStr);
        
        if (nsStr != nil && nsStr.length > 0) {
            ABMultiValueAddValueAndLabel(multiEmail, nsStr, (CFStringRef)kSABBloodTypeLabel, NULL);  //Blood
        }
	}
    
    if (ABMultiValueGetCount(multiEmail) > 0){
		ABRecordSetValue(person, kABPersonEmailProperty, multiEmail, &error);  //kABPersonEmailProperty
	}
	
	CFRelease(multiEmail);
}
void setIMRef(CFStringRef imType, NSString * imValue,ABMutableMultiValueRef multiqq)
{
    NSMutableDictionary *imDictionary = [NSMutableDictionary dictionary];
    //设置imType
    [imDictionary setObject:(NSString *)imType forKey:(NSString *)kABPersonInstantMessageServiceKey];
    //设置imValue
    [imDictionary setObject:imValue forKey:(NSString *)kABPersonInstantMessageUsernameKey];
    ABMultiValueAddValueAndLabel(multiqq, (CFDictionaryRef)imDictionary,(CFStringRef)imType, NULL);
}
void setPersonQqMsnGenderConstellationBloodValue(Contact* pContact, ABRecordRef person){
    CFErrorRef error = nil;
    
    ABMutableMultiValueRef multiqq = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    
    NSString *nsStr = [[pContact qq] imValue];
    if(nil != nsStr && 0 < [nsStr length]){
        setIMRef(kABPersonInstantMessageServiceQQ,nsStr,multiqq);
    }
    
    nsStr = [[pContact weixin] imValue];
    if(nil != nsStr && 0 < [nsStr length]){
        setIMRef((CFStringRef)kSABWeiXin,nsStr,multiqq);

    }
    
    nsStr = [[pContact yixin] imValue];
    if(nil != nsStr && 0 < [nsStr length]){
        setIMRef((CFStringRef)kSABYiXin,nsStr,multiqq);

    }
    
//    nsStr = [pContact lunarBirthday];
//    
//    if(nil != nsStr && 0 < [nsStr length]){
//        ABMultiValueAddValueAndLabel(multiqq, nsStr, (CFStringRef)kSABLunarBirthdayLabel, NULL);   //LunarBirthday
//    }
//    
//    if ([pContact hasGender]){
//        nsStr = [NSString stringWithFormat:@"%d", [pContact gender]];
//        
//        nsStr = covertGender(nsStr);
// 
//        if (nsStr != nil && nsStr.length > 0) {
//            ABMultiValueAddValueAndLabel(multiqq, nsStr, (CFStringRef)kSABGenderLabel, NULL);    //Gender
//        }
//    }
//    
//    if ([pContact hasConstellation]){
//        nsStr = [NSString stringWithFormat:@"%d", [pContact constellation]];
//        
//        nsStr = covertConstellation(nsStr);
//        
//        if (nsStr != nil && nsStr.length > 0) {
//           ABMultiValueAddValueAndLabel(multiqq, nsStr, (CFStringRef)kSABConstellationLabel, NULL);   //Constellation 
//        }
//    }
//    
//    if ([pContact hasBloodType]){
//         nsStr = [NSString stringWithFormat:@"%d", [pContact bloodType]];
//        
//        nsStr = covertBlood(nsStr);
//        
//        if (nsStr != nil && nsStr.length > 0) {
//             ABMultiValueAddValueAndLabel(multiqq, nsStr, (CFStringRef)kSABBloodTypeLabel, NULL);  //Blood
//        }
//	}
    
    if (ABMultiValueGetCount(multiqq) > 0){
        ABRecordSetValue(person, kABPersonInstantMessageProperty, multiqq, &error);        //kABPersonInstantMessageProperty
	}
	
	CFRelease(multiqq);
}

void setPersonUrlValue(Contact* pContact, ABRecordRef person){
    CFErrorRef error = nil;
    
    ABMutableMultiValueRef multiWeb = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
	NSString *nsStr = [[pContact personPage] pageValue];
    
	if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiWeb, nsStr, kABPersonHomePageLabel, NULL);   //personPage
  	}
    
    nsStr = [[pContact comPage] pageValue];
	
    if(nil != nsStr && 0 < [nsStr length]){
        ABMultiValueAddValueAndLabel(multiWeb, nsStr, kABWorkLabel, NULL);  //comPage
	}
    
	if (ABMultiValueGetCount(multiWeb) > 0){
		ABRecordSetValue(person, kABPersonURLProperty, multiWeb, &error);  //kABPersonURLProperty
	}
	
	CFRelease(multiWeb);
}

void setPersonBirthdayValue(Contact* pContact, ABRecordRef person){
    CFErrorRef error = nil;
    
    NSString *nsStr = [pContact birthday];
    
    if(nil != nsStr && 0 < [nsStr length]){
        NSDate* birthday = String2Date(nsStr);
        
        ABRecordSetValue(person, kABPersonBirthdayProperty, birthday, &error);
    }
}

void setPersonAddressValue(Contact* pContact, ABRecordRef person){
    //工作地址跟家庭地址，两者都必须至少要有一个字段不为空，否则下发的通讯录地址字段写不进机器（除非没有地址信息
    CFErrorRef error = nil;
    
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    NSMutableDictionary *homeAddressDictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *companyAddressDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *homeAddress = [[pContact homeAddr] addrValue];
    
    if (homeAddress != nil && homeAddress.length > 0) {
        [homeAddressDictionary setObject:homeAddress forKey:(NSString *) kABPersonAddressStreetKey];
    }
    
    NSString *homePostal = [[pContact homeAddr] addrPostal];
    
    if (homePostal != nil && homePostal.length > 0) {
         [homeAddressDictionary setObject:homePostal forKey:(NSString *)kABPersonAddressZIPKey];
    }
   
    NSString *companyAddress = [[pContact workAddr] addrValue];
    
    if (companyAddress != nil && companyAddress.length > 0) {
       [companyAddressDictionary setObject:companyAddress forKey:(NSString *) kABPersonAddressStreetKey];
    }

    NSString *companyPostal = [[pContact workAddr] addrPostal];
    
    if (companyPostal) {
        [companyAddressDictionary setObject:companyPostal forKey:(NSString *)kABPersonAddressZIPKey];
    }
    
    ABMultiValueAddValueAndLabel(multiAddress, homeAddressDictionary, kABHomeLabel, NULL);
    
    ABMultiValueAddValueAndLabel(multiAddress, companyAddressDictionary, kABWorkLabel, NULL);
    
    ABRecordSetValue(person, kABPersonAddressProperty, multiAddress,&error);
    
    CFRelease(multiAddress);
    
    [homeAddressDictionary release];
    
    [companyAddressDictionary release];    
}

void setPersonNoteValue(Contact* pContact, ABRecordRef person){
   NSString *nsStr = [pContact comment];
    
    CFErrorRef error = nil;
  
	if(nil != nsStr && 0 < [nsStr length]){
        ABRecordSetValue(person, kABPersonNoteProperty, nsStr, &error);
    }
}
#pragma mark //////////////// PimPhb_Contact2ABRecord
/*
 *  protocol buffer 反序列化后插入通讯录数据库
 */
UInt32 PimPhb_Contact2ABRecord(Contact* pContact, ABRecordRef person)
{
    if(pContact == nil){
        return SML_ERR_WRONG_PARAM;
	}
    
    ABRecordType type = ABRecordGetRecordType(person);
	
    if (type == kABGroupType){
		ZBLog(@"PimPhb_Contact2ABRecord  失败：type == kABGroupType");
		return SML_ERR_WRONG_PARAM;
	}
    
    setPersonNameValue(pContact, person);         //插入 Person Name 到通讯录数据库
    
    setPersonEmployValue(pContact, person);      //Employ
    
    setPersonPhoneValue(pContact, person);       //插入 Phone  到数据库
    
    setPersonEmailValue(pContact, person);    //Email
    
    setPersonQqMsnGenderConstellationBloodValue(pContact, person);         //QQ、MSN、Gender、Constellation、Blood
    
    setPersonUrlValue(pContact, person);        //Url

    setPersonBirthdayValue(pContact, person);    //Birthday
	
    setPersonAddressValue(pContact, person);       // address
    
    setPersonNoteValue(pContact, person);      //Note
	
    // PG关系不在这里处理。
    
    return SYNC_ERR_OK;
}

#pragma mark PimPhb_AddGroup ///////////////
UInt32 PimPhb_AddGroup(ABAddressBookRef abRef, Group* pGroup) {
 //   ZBLog(@"PimPhbGroup_Add");
    CFErrorRef error = nil;
    
    if(pGroup == NULL){
        return SML_ERR_WRONG_PARAM;
    }
    
    ABRecordRef group = ABGroupCreate();
    
    if(group == nil){
        ZBLog(@"PimPhb_AddGroup, group == nil");
        return DATA_ERR_FAIL_ADD_RECORD;
    }
    
    PimPhb_Group2ABRecord(pGroup, group);
    
    ABAddressBookAddRecord(abRef, group, &error);
    
    ABAddressBookSave(abRef, &error);
    
    CFRelease(group);
    
    return SYNC_ERR_OK;
}

#pragma mark ///////// PimPhb_AddContact
UInt32 PimPhb_AddContact(ABAddressBookRef abRef, Contact* pContact) {
    
    if(pContact == nil)
    {
        return SML_ERR_WRONG_PARAM;
    }
    
  //  ZBLog(@"phb add one contact start");
    ABRecordRef person = ABPersonCreate();
    
    if(person == nil)
    {
        ZBLog(@"PimPhb_Add,person == nil");
        if (person) {
            CFRelease(person);
        }
        
        return DATA_ERR_FAIL_ADD_RECORD;
    }
	// add the person message
	CFErrorRef error = nil;
    
    PimPhb_Contact2ABRecord(pContact, person);
    
	ABAddressBookAddRecord(abRef, person, &error);
    
    if (person) {
        CFRelease(person);
    }
    
    return SYNC_ERR_OK;
}

#pragma mark PimPhb_DeleteGroup

UInt32 PimPhb_DeleteGroup(ABAddressBookRef abRef,NSArray *groupIdList)
{
	ZBLog(@"PimPhb_DeleteGroup");
    
	CFErrorRef error = nil;
    
	UInt32 ret = SYNC_ERR_OK;
    
	for(CFIndex i = 0; i < [groupIdList count]; i++ )
    {
        int groupId = [[groupIdList objectAtIndex:i] intValue];
	
        ABRecordRef group = ABAddressBookGetGroupWithRecordID(abRef, groupId);
        
		if (group) {
            ABAddressBookRemoveRecord(abRef, group, &error);
        }
        
		if(error)
        {
			break;
		}
	}
    
	if(error)
    {
		ABAddressBookRevert(abRef);
		ret = DATA_ERR_FAIL_DELETE_RECORD;
	}
	
    ABAddressBookSave(abRef, &error);
    
	return ret;
}


#pragma mark PimPhb_DeleteAllGroup   ////////////
/*
 * 删除通讯录中所有的群组
 */
UInt32 PimPhb_DeleteAllGroup(ABAddressBookRef abRef)
{
	ZBLog(@"PimPhbGroup_DeleteAll");
	CFArrayRef all = ABAddressBookCopyArrayOfAllGroups(abRef);
    
    if (all == nil) {
        return -1;
    }
    
	CFIndex num = CFArrayGetCount(all);
    
	CFErrorRef error = nil;
    
	UInt32 ret = SYNC_ERR_OK;
    
	for(CFIndex i = 0; i < num; i++ )
    {
		ABRecordRef group = CFArrayGetValueAtIndex(all, i);
        
		if (group) {
            ABAddressBookRemoveRecord(abRef, group, &error);
        }
        
		if(error)
        {
			break;
		}
	}
    
	if(error)
    {
		ABAddressBookRevert(abRef);
		ret = DATA_ERR_FAIL_DELETE_RECORD;
	}
	
	CFRelease(all);
    
	return ret;
}

/*
 * 删除通讯录中联系人
 */
UInt32 PimPhb_DeleteContact(ABAddressBookRef abRef,NSArray *recordIdList){
    UInt32 ret = SYNC_ERR_OK;
    
	CFErrorRef error = nil;
    
	for(int  i = 0; i < [recordIdList count]; i++ )
    {
        int recordId = [[recordIdList objectAtIndex:i] intValue];
        
		ABRecordRef person = ABAddressBookGetPersonWithRecordID(abRef, recordId);
        
		if (person) {
            ABAddressBookRemoveRecord(abRef, person, &error);
        }
        
		if(error){
			break;
		}
	}
	
	if(error)
    {
		ABAddressBookRevert(abRef);
        
		ret = DATA_ERR_FAIL_DELETE_RECORD;
	}
    
    ABAddressBookSave(abRef, &error);
    
    return ret;
}

#pragma mark /////////////////// PimPhb_DeleteAllContact
/*
 * 删除通讯录所有的联系人
 */
UInt32 PimPhb_DeleteAllContact(ABAddressBookRef abRef)
{
    ZBLog(@"PimPhb_DeleteAll");
	CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(abRef);
    
	CFIndex num = CFArrayGetCount(all);
    
	CFErrorRef error = nil;
    
	UInt32 ret = SYNC_ERR_OK;
    
	for(CFIndex i = 0; i < num; i++ )
    {
		ABRecordRef person = CFArrayGetValueAtIndex(all, i);
        
		if (person) {
            ABAddressBookRemoveRecord(abRef, person, &error);
        }
        
		if(error)
        {
			break;
		}
	}
	
	if(error)
    {
		ABAddressBookRevert(abRef);
        
		ret = DATA_ERR_FAIL_DELETE_RECORD;
	}
	
	CFRelease(all);
    
	return ret;
}




