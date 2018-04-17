//
//  HB_BusinessCardParse.m
//  HBZS_IOS
//
//  Created by zimbean on 15/12/10.
//
//

#import "HB_BusinessCardParser.h"
#import "HB_ContactModel.h"
#import "HB_PhoneNumModel.h"
#import "HB_EmailModel.h"
#import "HB_AddressModel.h"
#import "HB_UrlModel.h"
#import "HB_ConvertPhoneNumArrTool.h"
#import "HB_ConvertEmailArrTool.h"
//#import "QRCodeGenerator.h"
#import <AddressBook/AddressBook.h>

#import <CoreImage/CoreImage.h>

@implementation HB_BusinessCardParser


#pragma mark - public methods

+(HB_ContactModel *)parseWithPropertyString:(NSString *)propertyString{
    if ([propertyString rangeOfString:@"BEGIN:VCARD"].location != NSNotFound) {
        //VCard格式
        return [self parseWithVCardString:propertyString];
    }else if ([propertyString rangeOfString:@"MECARD:"].location != NSNotFound){
        //MECard格式
        return [self parseWithMECardString:propertyString];
    }else if ([propertyString rangeOfString:@"CARD:"].location != NSNotFound){
        //Card格式
        return [self parseWithCardString:propertyString];
    }
    return nil;
}

#pragma mark - 三种不同的名片解析方式(VCard,Card,MECard)
+(HB_ContactModel *)parseWithVCardString:(NSString *)VCardStr{
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"\n\r"];
    NSArray * propertyArr = [VCardStr componentsSeparatedByCharactersInSet:characterSet];
    NSMutableArray *propertyMutableArr = [propertyArr mutableCopy];
    [propertyMutableArr removeObject:@""];
    ZBLog(@"arr = %@",propertyMutableArr);
    /* 1.新建每一个属性对应的数组，这里的字段，按照国家二维码名片标准定义。参考：http://www.doc88.com/p-8059032989839.html
     *   后期可能需要补充，更改
     */
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *telArr = [NSMutableArray array];
    NSMutableArray *emailArr = [NSMutableArray array];
    NSMutableArray *orgArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *adrArr = [NSMutableArray array];
    NSMutableArray *urlArr = [NSMutableArray array];
    NSMutableArray *noteArr = [NSMutableArray array];
    
    //2.遍历数组，分别找出每一个属性，放到对应的属性数组里面
    [propertyMutableArr enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
        NSString *propertyString = obj;
        //名字的属性名可能是"N" 也可能是“FN”
        if ([propertyString rangeOfString:@"FN:"].location == 0 || [propertyString rangeOfString:@"N:"].location == 0) {
            [nameArr removeAllObjects];
            [nameArr addObject:propertyString];
        }
        if ([propertyString rangeOfString:@"TEL"].location == 0 ) {
            [telArr addObject:propertyString];
        }
        if ([propertyString rangeOfString:@"EMAIL"].location == 0 ) {
            [emailArr addObject:propertyString];
        }
        if ([propertyString rangeOfString:@"ORG"].location == 0) {
            [orgArr addObject:propertyString];
        }
        if ([propertyString rangeOfString:@"TITLE"].location == 0) {
            [titleArr addObject:propertyString];
        }
        if ([propertyString rangeOfString:@"ADR"].location == 0) {
            [adrArr addObject:propertyString];
        }
        if ([propertyString rangeOfString:@"URL"].location == 0) {
            [urlArr addObject:propertyString];
        }
        if ([propertyString rangeOfString:@"NOTE"].location == 0) {
            [noteArr addObject:propertyString];
        }
    }];
    [propertyMutableArr release];

    HB_ContactModel *contactModel = [[[HB_ContactModel alloc]init]autorelease];
    HB_BusinessCardParser *parse   = [[HB_BusinessCardParser alloc]init];
    [parse setVCardContactName:contactModel withNameArr:nameArr];
    [parse setVCardContactTelphone:contactModel withTelArr:telArr];
    [parse setVCardContactEmail:contactModel withEmailArr:emailArr];
    [parse setVCardContactOrg:contactModel withOrgArr:orgArr];
    [parse setVCardContactTitle:contactModel withTitleArr:titleArr];
    [parse setVCardContactAddress:contactModel withAddressArr:adrArr];
    [parse setVCardContactUrl:contactModel withUrlArr:urlArr];
    [parse setVCardContactNote:contactModel withNoteArr:noteArr];
    [parse release];
    
    return contactModel;
}
+(HB_ContactModel *)parseWithMECardString:(NSString *)MECardStr{
    ZBLog(@"MECard = %@",MECardStr);
    NSMutableString *mutableMeCardStr = [MECardStr mutableCopy];
    [mutableMeCardStr deleteCharactersInRange:NSMakeRange(0, @"MECARD:".length)];
    NSArray *meCardPropertiesArr = [mutableMeCardStr componentsSeparatedByString:@";"];
    [mutableMeCardStr release];
    
    /* 1.新建每一个属性对应的数组，这里的字段，按照国家二维码名片标准定义。参考：http://www.doc88.com/p-8059032989839.html
     *   后期可能需要补充，更改
     */
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *telArr = [NSMutableArray array];
    NSMutableArray *emailArr = [NSMutableArray array];
    NSMutableArray *noteArr = [NSMutableArray array];
    NSMutableArray *birthdayArr = [NSMutableArray array];
    NSMutableArray *adrArr = [NSMutableArray array];
    NSMutableArray *urlArr = [NSMutableArray array];
    NSMutableArray *nickNameArr = [NSMutableArray array];
    NSMutableArray *orgArr = [NSMutableArray array];
    NSMutableArray *tilArr = [NSMutableArray array];
    
    [meCardPropertiesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *propertyStr = (NSString *)obj;
        if ([propertyStr rangeOfString:@"N:"].location == 0) {
            [nameArr addObject:propertyStr];
        }else if ([propertyStr rangeOfString:@"TEL:"].location == 0) {
            [telArr addObject:propertyStr];
        }else if ([propertyStr rangeOfString:@"EMAIL:"].location == 0) {
            [emailArr addObject:propertyStr];
        }else if ([propertyStr rangeOfString:@"NOTE:"].location == 0) {
            [noteArr addObject:propertyStr];
        }else if ([propertyStr rangeOfString:@"BDAY:"].location == 0) {
            [birthdayArr addObject:propertyStr];
        }else if ([propertyStr rangeOfString:@"ADR:"].location == 0) {
            [adrArr addObject:propertyStr];
        }else if ([propertyStr rangeOfString:@"URL:"].location == 0) {
            [urlArr addObject:propertyStr];
        }else if ([propertyStr rangeOfString:@"NICKNAME:"].location == 0) {
            [nickNameArr addObject:propertyStr];
        }else if ([propertyStr rangeOfString:@"ORG:"].location == 0) {
            [orgArr addObject:propertyStr];
        }else if ([propertyStr rangeOfString:@"TIL:"].location == 0) {
            [tilArr addObject:propertyStr];
        }
    }];
    
    HB_ContactModel *contactModel = [[[HB_ContactModel alloc]init]autorelease];
    HB_BusinessCardParser *parse   = [[HB_BusinessCardParser alloc]init];
    [parse setMECardContactName:contactModel withNameArr:nameArr];
    [parse setMECardContactTelphone:contactModel withTelArr:telArr];
    [parse setMECardContactEmail:contactModel withEmailArr:emailArr];
    [parse setMECardContactNote:contactModel withNoteArr:noteArr];
    [parse setMECardContactBirthday:contactModel withBirthdayArr:birthdayArr];
    [parse setMECardContactAddress:contactModel withAddressArr:adrArr];
    [parse setMECardContactUrl:contactModel withUrlArr:urlArr];
    [parse setMECardContactNickname:contactModel withNickNameArr:nickNameArr];
    [parse setMECardContactOrg:contactModel withOrgArr:orgArr];
    [parse setMECardContactTitle:contactModel withTilArr:tilArr];
    [parse release];
    
    return contactModel;
}
+(HB_ContactModel *)parseWithCardString:(NSString *)CardStr{
    ZBLog(@"Card = %@",CardStr);
    NSMutableString *mutableMeCardStr = [CardStr mutableCopy];
    [mutableMeCardStr deleteCharactersInRange:NSMakeRange(0, @"CARD:".length)];
    NSArray *cardPropertiesArr = [mutableMeCardStr componentsSeparatedByString:@";"];
    [mutableMeCardStr release];
    
    /* 1.新建每一个属性对应的数组，这里的字段，按照国家二维码名片标准定义。参考：http://www.doc88.com/p-8059032989839.html
     *   后期可能需要补充，更改
     */
    NSString *name = nil;
    NSString *til = nil;
    NSString *div = nil;
    NSString *cor = nil;
    NSString *adr = nil;
    NSString *zip = nil;
    NSString *tel = nil;
    NSString *mobile = nil;
    NSString *fax = nil;
    NSString *email = nil;
    NSString *url = nil;
    NSString *nbc = nil;
    NSMutableArray *ueArr = [NSMutableArray array];
    for (int i=0; i<cardPropertiesArr.count; i++) {
        NSString *propertyStr = cardPropertiesArr[i];
        if ([propertyStr rangeOfString:@"N:"].location == 0) {
            name = propertyStr;
        }else if ([propertyStr rangeOfString:@"TIL:"].location == 0) {
            til = propertyStr;
        }else if ([propertyStr rangeOfString:@"DIV:"].location == 0) {
            div = propertyStr;
        }else if ([propertyStr rangeOfString:@"COR:"].location == 0) {
            cor = propertyStr;
        }else if ([propertyStr rangeOfString:@"ADR:"].location == 0) {
            adr = propertyStr;
        }else if ([propertyStr rangeOfString:@"ZIP:"].location == 0) {
            zip = propertyStr;
        }else if ([propertyStr rangeOfString:@"TEL:"].location == 0) {
            //固话
            tel = propertyStr;
        }else if ([propertyStr rangeOfString:@"M:"].location == 0) {
            //移动电话
            mobile = propertyStr;
        }else if ([propertyStr rangeOfString:@"FAX:"].location == 0) {
            fax = propertyStr;
        }else if ([propertyStr rangeOfString:@"EMAIL:"].location == 0) {
            email = propertyStr;
        }else if ([propertyStr rangeOfString:@"URL:"].location == 0) {
            //普通网址
            url = propertyStr;
        }else if ([propertyStr rangeOfString:@"NBC:"].location == 0) {
            //网络名片
            nbc = propertyStr;
        }else if ([propertyStr rangeOfString:@"UE"].location == 0) {
            //自定义属性区
            [ueArr addObject:propertyStr];
        }
    }
    
    HB_ContactModel *contactModel = [[[HB_ContactModel alloc]init]autorelease];
    HB_BusinessCardParser *parse   = [[HB_BusinessCardParser alloc]init];
    [parse setCardContactName:contactModel withName:name];
    [parse setCardContactTitle:contactModel withTil:til];
    [parse setCardContactDepartment:contactModel withDiv:div];
    [parse setCardContactOrg:contactModel withCor:cor];
    [parse setCardContactAddress:contactModel withAdr:adr andZIP:zip];
    [parse setCardContactPhoneArr:contactModel withTel:tel andMobile:mobile andFax:fax];
    [parse setCardContactEmailArr:contactModel withEmail:email];
    [parse setCardContactUrl:contactModel withUrl:url andNBC:nbc];
    [parse setCardContactNote:contactModel withUEArr:ueArr];
    [parse release];
    
    return contactModel;
}

#pragma mark - VCard属性解析
-(void)setVCardContactName:(HB_ContactModel *)contactModel withNameArr:(NSArray *)nameArr{
    NSString *namePropertyStr = [nameArr lastObject];
    //1.首先以‘:’分隔  例如：FN:张;三丰;Jone
    NSArray *tempArr = [namePropertyStr componentsSeparatedByString:@"N:"];
    NSString *lastStr = tempArr[1];
    //2.对姓名内容部分做进一步分隔
    NSArray *nameStrArr = [lastStr componentsSeparatedByString:@";"];
    NSMutableArray *mutableNameStrArr = [nameStrArr mutableCopy];
    [mutableNameStrArr removeObject:@""];
    //名字格式分为三种情况：1、张云中  2、张;云中  3、张;云中;Jone
    if (mutableNameStrArr.count > 1) {
        contactModel.lastName = nameArr[0];
        contactModel.firstName = nameArr[1];
        if (mutableNameStrArr.count > 2) {
            contactModel.nickName = nameArr[2];
        }
    }else{
        contactModel.lastName = mutableNameStrArr[0];
    }
    [mutableNameStrArr release];
}

-(void)setVCardContactTelphone:(HB_ContactModel *)contactModel withTelArr:(NSArray *)telArr{
    NSMutableArray *mutableTelArr = [NSMutableArray array];
    for (int i=0; i<telArr.count; i++) {
        //1.以‘:’分隔  例如：TEL;WORK;FAX:18033332255
        NSString *tempStr = telArr[i];
        NSArray *phonePropertyArr = [tempStr componentsSeparatedByString:@":"];
        NSString *phoneType = phonePropertyArr[0];
        NSString *phoneNumber = phonePropertyArr[1];
        
        HB_PhoneNumModel *model = [[HB_PhoneNumModel alloc]init];
        model.index = i;
        model.phoneNum = phoneNumber;
        /* 2.1在phoneType中查找一些特殊的关键字 例如：WORK FAX PREF HOME VOICE .....
         *   但是为了简单起见，我并没有把所有的属性都考虑到，仅仅考虑了几个常用的，它们和系统通讯录字段的对应含义如下：
         *                     WORK --->  工作
         *                     HOME --->  住宅
         *                     CELL --->  iPhone
         *                     FAX  --->  传真
         */
        //2.2首先判断是否含有“FAX”
        if ([phoneType rangeOfString:@"FAX"].location != NSNotFound) {
            //在里面判断是否含有‘HOME’这些字段，如果有的话，对应于：“住宅传真”。否则统统归类于“工作传真”
            if ([phoneType rangeOfString:@"HOME"].location != NSNotFound) {
                //“住宅传真”
                model.phoneType = @"住宅传真";
            }else{
                //“工作传真”
                model.phoneType = @"工作传真";
            }
        }else {
            //2.3如果不含“FAX”则表明是电话号码
            if ([phoneType rangeOfString:@"CELL"].location != NSNotFound){
                //“iPhone”
                model.phoneType = @"手机";
            }else if ([phoneType rangeOfString:@"HOME"].location != NSNotFound) {
                //“住宅”
                model.phoneType = @"住宅";
            }else if ([phoneType rangeOfString:@"WORK"].location != NSNotFound){
                //“工作”
                model.phoneType = @"工作";
            }else {
                //“手机”
                model.phoneType = @"手机";
            }
        }
        [mutableTelArr addObject:model];
        [model release];
    }
    contactModel.phoneArr = [HB_ConvertPhoneNumArrTool convertPhoneTypeWithPhoneArrHBZSToSystem:mutableTelArr];
}
-(void)setVCardContactEmail:(HB_ContactModel *)contactModel withEmailArr:(NSArray *)emailArr{
    NSMutableArray *mutableEmailArr = [NSMutableArray array];
    [emailArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *emailStr = (NSString *)obj;
        NSArray *emailArr = [emailStr componentsSeparatedByString:@":"];
        NSString * currentEmailtype = [[emailArr[0] componentsSeparatedByString:@"="] lastObject];
        HB_EmailModel *model = [[HB_EmailModel alloc]init];
        model.index = idx;
        //由于email类型判断
        if ([currentEmailtype isEqualToString:@"HOME"]) {
            model.emailType = @"常用邮箱";
        }
        else if ([currentEmailtype isEqualToString:@"WORK"])
        {
            model.emailType = @"商务邮箱";
        }
        else if ([currentEmailtype compare:@"internet" options:NSCaseInsensitiveSearch])
        {
            model.emailType = @"其他邮箱1";
        }
        else if ([currentEmailtype compare:@"pref" options:NSCaseInsensitiveSearch])
        {
            model.emailType = @"个人邮箱";
        }
        else
        {
            model.emailType = @"其他邮箱2";
        }
        
        model.emailAddress = emailArr[1];
        [mutableEmailArr addObject:model];
        [model release];
    }];
    contactModel.emailArr = [HB_ConvertEmailArrTool convertEmailTypeWithArrayHBZSToSystem:mutableEmailArr];
}
-(void)setVCardContactOrg:(HB_ContactModel *)contactModel withOrgArr:(NSArray *)orgArr{
    /*示例：  ORG:上海天信科技股份有限公司；技术部；iOS组
     * 其中后面的3个值分别为一级、二级、三级部门名称。可以省略
     * 在号簿助手中的处理方式是： 第一部分作为ContactModel的‘organization’字段
     *                        最后一级部门作为ContactModel的‘department’字段
     */
    NSString *orgValueStr = [[[orgArr firstObject] componentsSeparatedByString:@"ORG:"] lastObject];
    NSArray *orgSeparateArr = [orgValueStr componentsSeparatedByString:@";"];
    
    contactModel.organization = orgSeparateArr[0];

    NSMutableString *mutableDepartmentStr = [NSMutableString string];
    for (int i=1; i<orgSeparateArr.count; i++) {
        [mutableDepartmentStr appendString:orgSeparateArr[i]];
    }
    contactModel.department = mutableDepartmentStr;
}
-(void)setVCardContactTitle:(HB_ContactModel *)contactModel withTitleArr:(NSArray *)titleArr{
    NSString *titleStr = [titleArr firstObject];
    NSArray *separatedArr = [titleStr componentsSeparatedByString:@"TITLE:"];
    contactModel.jobTitle = separatedArr.lastObject;
}
-(void)setVCardContactAddress:(HB_ContactModel *)contactModel withAddressArr:(NSArray *)addressArr{
    NSMutableArray *mutableAddressArr = [NSMutableArray array];
    [addressArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *tempAddressArr = [(NSString *)obj componentsSeparatedByString:@":"];
        NSMutableString *addressType = [tempAddressArr[0] mutableCopy];
        NSMutableString *addressValue = [tempAddressArr[1] mutableCopy];
        
        HB_AddressModel *model = [[HB_AddressModel alloc]init];
        model.index = idx;
        //1.对addressType进行分解、转换 （这里是和系统通讯录字段转换）
        if ([addressType rangeOfString:@"HOME"].location != NSNotFound) {
            //找到‘HOME’字段，表明这是‘住宅’
            model.type = @"_$!<Home>!$_";
        }else if ([addressType rangeOfString:@"WORK"].location != NSNotFound){
            //找到‘WORK’字段，表明这是‘工作’
            model.type = @"_$!<Work>!$_";
        }else{
            //剩余的表示‘其它’
            model.type = @"其它";
        }
        //2.对addressValue进行分解、转换
        //2.1用正则，找出邮编
        NSString *regularPattern = @"[0-9]{6}";
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularPattern
                                                                                           options:NSRegularExpressionAnchorsMatchLines
                                                                                             error:nil];
        NSArray *matchResultArr = [regularExpression matchesInString:addressValue
                                                             options:NSMatchingReportCompletion
                                                               range:NSMakeRange(0, addressValue.length)];
        
        [matchResultArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSTextCheckingResult *result = (NSTextCheckingResult *)obj;
            model.zip = [addressValue substringWithRange:result.range];
            //删除addressValue中的邮编部分
            [addressValue deleteCharactersInRange:result.range];
            *stop = YES;
        }];
        //2.2除去‘;’，拼接成地址
        NSArray *finalAddressValueArr = [addressValue componentsSeparatedByString:@";"];
        NSString *finalAddressValueStr = [finalAddressValueArr componentsJoinedByString:@""];
        
        model.street = finalAddressValueStr;
        [mutableAddressArr addObject:model];
        
        [model release];
        [addressType release];
        [addressValue release];
    }];
    contactModel.addressArr = mutableAddressArr;
}
-(void)setVCardContactUrl:(HB_ContactModel *)contactModel withUrlArr:(NSArray *)urlArr{
    NSMutableArray *mutableUrlArr = [NSMutableArray array];
    [urlArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *tempUrlArr = [(NSString *)obj componentsSeparatedByString:@"URL:"];
        //取出真正url的值。这里主要是排除这种可能：  URL:http://www.baidu.com   这个示例网址有两个‘:’，需要考虑
        NSMutableArray *tempMutableUrlArr = [tempUrlArr mutableCopy];
        [tempMutableUrlArr removeObject:@""];
        [tempMutableUrlArr removeObjectAtIndex:0];
        NSString *value = [tempMutableUrlArr componentsJoinedByString:@""];
        [tempMutableUrlArr release];
        
        HB_UrlModel *urlModel = [[HB_UrlModel alloc]init];
        urlModel.type = (NSString *)kABPersonHomePageLabel;
        urlModel.url = value;
        urlModel.index = idx;
        [mutableUrlArr addObject:urlModel];
        [urlModel release];
    }];
    contactModel.urlArr = mutableUrlArr;
}
-(void)setVCardContactNote:(HB_ContactModel *)contactModel withNoteArr:(NSArray *)noteArr{
    NSString *noteStr = [noteArr firstObject];
    NSArray *separatedArr = [noteStr componentsSeparatedByString:@"NOTE:"];
    contactModel.note = separatedArr.lastObject;
}

#pragma mark - MECard属性解析
-(void)setMECardContactName:(HB_ContactModel *)contactModel withNameArr:(NSArray *)nameArr{
    //示例：  N:张，小三
    NSString *tempStr = [nameArr firstObject];
    NSString *nameStr = [[tempStr componentsSeparatedByString:@"N:"] lastObject];
    NSArray *nameSeparateArr = [nameStr componentsSeparatedByString:@","];
    NSString *finalNameStr = [nameSeparateArr componentsJoinedByString:@""];
    contactModel.lastName = finalNameStr;
}
-(void)setMECardContactTelphone:(HB_ContactModel *)contactModel withTelArr:(NSArray *)telArr{
    //示例：  TEL:13399988888
    NSArray * typearr =[[NSArray alloc]initWithArray: @[@"手机",@"住宅",@"iPhone",@"工作",@"住宅传真",@"主要",@"工作传真",@"传呼"]];
    NSMutableArray *mutableArr = [NSMutableArray array];
    [telArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *propertyStr = (NSString *)obj;
        NSArray *separateArr = [propertyStr componentsSeparatedByString:@"TEL:"];
        
        HB_PhoneNumModel *phoneModel = [[HB_PhoneNumModel alloc]init];
        phoneModel.phoneType = [typearr objectAtIndex:idx%9];
        phoneModel.phoneNum = [separateArr lastObject];
        phoneModel.index = idx;
        [mutableArr addObject:phoneModel];
        [phoneModel release];
    }];
    contactModel.phoneArr =[HB_ConvertPhoneNumArrTool convertPhoneTypeWithPhoneArrHBZSToSystem:mutableArr];
}
-(void)setMECardContactEmail:(HB_ContactModel *)contactModel withEmailArr:(NSArray *)emailArr{
    //示例：  EMAIL:1233244@qq.com
    NSMutableArray *mutableArr = [NSMutableArray array];
    NSArray * types = [[NSArray alloc]initWithArray:@[@"个人邮箱",@"常用邮箱",@"商务邮箱",@"其他邮箱1",@"其他邮箱2"]];
    [emailArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *propertyStr = (NSString *)obj;
        NSArray *separateArr = [propertyStr componentsSeparatedByString:@"EMAIL:"];
        HB_EmailModel *emailModel = [[HB_EmailModel alloc]init];
        emailModel.emailType = [types objectAtIndex:idx%5];
        emailModel.emailAddress = [separateArr lastObject];
        emailModel.index = idx;
        [mutableArr addObject:emailModel];
        [emailModel release];
    }];
    contactModel.emailArr =[HB_ConvertEmailArrTool convertEmailTypeWithArrayHBZSToSystem:mutableArr];
}
-(void)setMECardContactNote:(HB_ContactModel *)contactModel withNoteArr:(NSArray *)noteArr{
    //示例：  NOTE:备注信息
    NSArray *separateArr = [[noteArr firstObject] componentsSeparatedByString:@"NOTE:"];
    contactModel.note = [separateArr lastObject];
}
-(void)setMECardContactBirthday:(HB_ContactModel *)contactModel withBirthdayArr:(NSArray *)birthdayArr{
    //示例：  BDAY:20150101
    NSArray *separateArr = [[birthdayArr firstObject] componentsSeparatedByString:@"BDAY:"];
    contactModel.birthday = [separateArr lastObject];
}

-(void)setMECardContactAddress:(HB_ContactModel *)contactModel withAddressArr:(NSArray *)addressArr{
    //示例：  ADR:中国上海市松江区
    NSMutableArray *mutableArr = [NSMutableArray array];
    [addressArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *propertyStr = (NSString *)obj;
        NSArray *separateArr = [propertyStr componentsSeparatedByString:@"ADR:"];
        
        HB_AddressModel *addressModel = [[HB_AddressModel alloc]init];
        addressModel.type = @"_$!<Work>!$_";
        addressModel.street = [separateArr lastObject];
        addressModel.index = idx;
        [mutableArr addObject:addressModel];
        [addressModel release];
    }];
    contactModel.addressArr = mutableArr;
}
-(void)setMECardContactUrl:(HB_ContactModel *)contactModel withUrlArr:(NSArray *)urlArr{
    //示例：  URL:http://www.baidu.com
    NSMutableArray *mutableArr = [NSMutableArray array];
    [urlArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *propertyStr = (NSString *)obj;
        NSArray *separateArr = [propertyStr componentsSeparatedByString:@"URL:"];
        
        HB_UrlModel *urlModel = [[HB_UrlModel alloc]init];
        urlModel.type = (NSString *)kABPersonHomePageLabel;
        urlModel.url = [separateArr lastObject];
        urlModel.index = idx;
        [mutableArr addObject:urlModel];
        [urlModel release];
    }];
    contactModel.urlArr = mutableArr;
}
-(void)setMECardContactNickname:(HB_ContactModel *)contactModel withNickNameArr:(NSArray *)nickNameArr{
    //示例：  NICKNAME:小三
    NSArray *separateArr = [[nickNameArr firstObject] componentsSeparatedByString:@"NICKNAME:"];
    contactModel.nickName = [separateArr lastObject];
}
-(void)setMECardContactOrg:(HB_ContactModel *)contactModel withOrgArr:(NSArray *)orgArr{
    //示例：  ORG:上海天信
    NSArray *separateArr = [[orgArr firstObject] componentsSeparatedByString:@"ORG:"];
    contactModel.organization = [separateArr lastObject];
}
-(void)setMECardContactTitle:(HB_ContactModel *)contactModel withTilArr:(NSArray *)tilArr{
    //示例：  TIL:开发工程师
    NSArray *separateArr = [[tilArr firstObject] componentsSeparatedByString:@"TIL:"];
    contactModel.jobTitle = [separateArr lastObject];
}

#pragma mark - Card解析
-(void)setCardContactName:(HB_ContactModel *)contactModel withName:(NSString *)name{
    //示例：  N:张，小三  N:张 小三
    NSString *nameStr = [[name componentsSeparatedByString:@"N:"] lastObject];
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@", "];
    NSArray *nameSeparateArr = [nameStr componentsSeparatedByCharactersInSet:set];
    NSString *finalNameStr = [nameSeparateArr componentsJoinedByString:@""];
    contactModel.lastName = finalNameStr;
}
-(void)setCardContactTitle:(HB_ContactModel *)contactModel withTil:(NSString *)til{
    //示例：  TIL:开发工程师
    NSArray *separateArr = [til componentsSeparatedByString:@"TIL:"];
    contactModel.jobTitle = [separateArr lastObject];
}
-(void)setCardContactDepartment:(HB_ContactModel *)contactModel withDiv:(NSString *)div{
    //示例：  DIV:iOS组
    NSArray *separateArr = [div componentsSeparatedByString:@"DIV:"];
    contactModel.department = [separateArr lastObject];
}
-(void)setCardContactOrg:(HB_ContactModel *)contactModel withCor:(NSString *)cor{
    //示例：  COR:上海天信
    NSArray *separateArr = [cor componentsSeparatedByString:@"COR:"];
    contactModel.organization = [separateArr lastObject];
}
-(void)setCardContactAddress:(HB_ContactModel *)contactModel withAdr:(NSString *)adr andZIP:(NSString *)zip{
    //示例：  ADR:中国上海市松江区
    //       ZIP:201600
    NSMutableArray *mutableArr = [NSMutableArray array];
    
    NSArray *separateArr = [adr componentsSeparatedByString:@"ADR:"];
    HB_AddressModel *addressModel = [[HB_AddressModel alloc]init];
    addressModel.type = @"_$!<Work>!$_";
    addressModel.street = [separateArr lastObject];
    if (zip) {
        NSArray *tempArr = [zip componentsSeparatedByString:@"ZIP:"];
        addressModel.zip = [tempArr lastObject];
    }
    [mutableArr addObject:addressModel];
    [addressModel release];

    contactModel.addressArr = mutableArr;
}
-(void)setCardContactPhoneArr:(HB_ContactModel *)contactModel withTel:(NSString *)tel andMobile:(NSString *)mobile andFax:(NSString *)fax{
    //示例：  TEL:021-55556666
    //        M:13399988888
    NSMutableArray *mutableArr = [NSMutableArray array];
    
    NSArray *separateTelArr = [tel componentsSeparatedByString:@"TEL:"];
    NSArray *phoneNumberArr = [[separateTelArr lastObject] componentsSeparatedByString:@","];
    for (int i=0; i<phoneNumberArr.count; i++) {
        HB_PhoneNumModel *phoneModel = [[HB_PhoneNumModel alloc]init];
        phoneModel.phoneType = @"主要";
        phoneModel.phoneNum = phoneNumberArr[i];
        [mutableArr addObject:phoneModel];
        [phoneModel release];
    }
    
    NSArray *separateMobileArr = [mobile componentsSeparatedByString:@"M:"];
    NSArray *mobileNumberArr = [[separateMobileArr lastObject] componentsSeparatedByString:@","];
    for (int i=0; i<mobileNumberArr.count; i++) {
        HB_PhoneNumModel *phoneModel = [[HB_PhoneNumModel alloc]init];
        phoneModel.phoneType = @"手机";
        phoneModel.phoneNum = mobileNumberArr[i];
        [mutableArr addObject:phoneModel];
        [phoneModel release];
    }
    
    NSArray *separateFaxArr = [fax componentsSeparatedByString:@"FAX:"];
    NSArray *faxNumberArr = [[separateFaxArr lastObject] componentsSeparatedByString:@","];
    for (int i=0; i<faxNumberArr.count; i++) {
        HB_PhoneNumModel *phoneModel = [[HB_PhoneNumModel alloc]init];
        phoneModel.phoneType = @"工作传真";
        phoneModel.phoneNum = faxNumberArr[i];
        [mutableArr addObject:phoneModel];
        [phoneModel release];
    }
    
    contactModel.phoneArr =[HB_ConvertPhoneNumArrTool convertPhoneTypeWithPhoneArrHBZSToSystem:mutableArr];
}
-(void)setCardContactEmailArr:(HB_ContactModel *)contactModel withEmail:(NSString *)email{
    //示例： EMAIL:123345@qq.com,565543@qq.com,42332@163.com
    NSMutableArray *mutableArr = [NSMutableArray array];

    NSArray *separateEmailArr = [email componentsSeparatedByString:@"EMAIL:"];
    NSArray *emailArr = [[separateEmailArr lastObject] componentsSeparatedByString:@","];
    for (int i=0; i<emailArr.count; i++) {
        HB_EmailModel *emailModel = [[HB_EmailModel alloc]init];
        emailModel.emailType = @"个人邮箱";
        emailModel.emailAddress = emailArr[i];
        [mutableArr addObject:emailModel];
        [emailModel release];
    }
    
    contactModel.emailArr = [HB_ConvertEmailArrTool convertEmailTypeWithArrayHBZSToSystem:mutableArr];
}
-(void)setCardContactUrl:(HB_ContactModel *)contactModel withUrl:(NSString *)url andNBC:(NSString *)nbc{
    NSMutableArray *mutableArr = [NSMutableArray array];
    
    NSArray *urlSeparateArr = [url componentsSeparatedByString:@"URL:"];
    NSArray *urlArr = [[urlSeparateArr lastObject] componentsSeparatedByString:@","];
    for (int i=0; i<urlArr.count; i++) {
        HB_UrlModel *urlModel = [[HB_UrlModel alloc]init];
        urlModel.type = @"公司主页";
        urlModel.url = urlArr[i];
        [mutableArr addObject:urlModel];
        [urlModel release];
    }
    
    NSArray *nbcSeparateArr = [nbc componentsSeparatedByString:@"NBC:"];
    HB_UrlModel *nbcModel = [[HB_UrlModel alloc]init];
    nbcModel.type = @"个人主页";
    nbcModel.url = [nbcSeparateArr lastObject];
    [mutableArr addObject:nbcModel];
    [nbcModel release];

    contactModel.emailArr = mutableArr;
}
-(void)setCardContactNote:(HB_ContactModel *)contactModel withUEArr:(NSArray *)ueArr{
    /* 示例：
     *      UE0:qq:5454545
     *      UE1:appleID:223424@qq.com
     *      UE2:我的自定义字段
     */
    NSMutableString *mutableStr = [NSMutableString string];
    for (int i=0; i<ueArr.count; i++) {
        NSString *ueStr = ueArr[i];
        if (ueStr.length > 4) {
            if (i == (ueArr.count - 1)) {
                [mutableStr appendString:[ueStr substringFromIndex:4]];
            }else{
                [mutableStr appendFormat:@"%@\n",[ueStr substringFromIndex:4]];
            }
        }
    }
    contactModel.note = mutableStr;
}


#pragma mark 二维码名片
+(UIImage *)getQRcodeImageWithContact:(HB_ContactModel *)model ShowPhoneNum:(NSMutableString *)willShowPhoneNum
{
    UIImage * image;
    NSMutableString * VcardString = [NSMutableString stringWithCapacity:0];
    //开始
    [VcardString appendFormat:@"BEGIN:VCARD\nVERSION:3.0\n"];
    
    //名字
    HB_BusinessCardParser * parse   = [[HB_BusinessCardParser alloc]init];
    [parse setVCardStringName:VcardString WithContactModel:model];
    
    
    //显示号码设置
    NSString * str = [parse setVCardStingPhones:VcardString WithPhoneArray:model.phoneArr];
    str = str.length?str:@"无号码";
    
    [willShowPhoneNum appendFormat:@"%@",str];
    [parse setVCardStingEmalls:VcardString WithEmallArray:model.emailArr];
    
    //结束
    [VcardString appendFormat:@"END:VCARD\n"];
    
    
    
    image = [parse getQRImageBy:VcardString];
    [parse release];
    return image;
}



-(void)setVCardStringName:(NSMutableString *)vcardString WithContactModel:(HB_ContactModel *)model
{
    NSString * Namestring = [NSString stringWithFormat:@"%@%@",model.lastName.length?model.lastName:@"",model.firstName.length?model.firstName:@""];
    if (Namestring.length) {
        [vcardString appendFormat:@"N:;%@;;;\n",Namestring];
        [vcardString appendFormat:@"FN:%@\n",Namestring];
        [vcardString appendFormat:@"NAME:%@\n",Namestring];
    }
    

    
}

-(NSString *)setVCardStingPhones:(NSMutableString *)vcardString WithPhoneArray:(NSMutableArray *)PhoneArr
{
    NSInteger phoneNumCount = 0;//用于记录符合条件切已经写入VcardString的号码个数
    NSString * str = nil;
    
    for (HB_PhoneNumModel * phoneModel in PhoneArr) {
        
        NSString * VcardPhoneType = nil;
        if (!(phoneModel.phoneNum.length>0)) {
            continue;
        }
        if ([phoneModel.phoneType isEqualToString:@"_$!<Mobile>!$_"])
        {
            VcardPhoneType = [NSString stringWithFormat:@"CELL"];
            phoneNumCount++;
        }
        else if ([phoneModel.phoneType isEqualToString:@"_$!<Home>!$_"])
        {
            VcardPhoneType = [NSString stringWithFormat:@"HOME"];
            phoneNumCount++;
        }
        
        if (VcardPhoneType.length) {
            [vcardString appendFormat:@"TEL;TYPE=%@:%@\n",VcardPhoneType,phoneModel.phoneNum];
            if (!str.length) {
                str = [NSString stringWithFormat:@"%@",phoneModel.phoneNum];
            }
        }
       
        if (phoneNumCount>=2) {
            break;
        }
    }
    
    //如果没有上面2种标签则修改标签重新写入
    if (!phoneNumCount) {
        
        for (HB_PhoneNumModel * phoneModel in PhoneArr) {
            
            NSString * VcardPhoneType =nil;
            if (!(phoneModel.phoneNum.length>0)) {
                continue;
            }
            if ([phoneModel.phoneType isEqualToString:@"iPhone"])
            {
                VcardPhoneType = [NSString stringWithFormat:@"CELL"];
                phoneNumCount++;
            }
            else
            {
                VcardPhoneType = [NSString stringWithFormat:@"HOME"];
                phoneNumCount++;
            }
            
            
            if (VcardPhoneType.length)
            {
                [vcardString appendFormat:@"TEL;TYPE=%@:%@\n",VcardPhoneType,phoneModel.phoneNum];
                if (!str.length) {
                    str = [NSString stringWithFormat:@"%@",phoneModel.phoneNum];
                }
            }
            if (phoneNumCount>=2) {
                break;
            }
        }
        
    }
    
    return str;
    
}

-(void)setVCardStingEmalls:(NSMutableString *)vcardString WithEmallArray:(NSMutableArray *)emallArr
{
    BOOL isReaden=NO;
    for (HB_EmailModel *model in emallArr) {
        if (!model.emailAddress.length) {
            continue;
        }
        NSString * VcardEmallType;
        if ([model.emailType isEqualToString:(NSString *)kABHomeLabel]) {
            VcardEmallType = [NSString stringWithFormat:@"HOME"];
            [vcardString appendFormat:@"EMAIL;TYPE=%@:%@\n",VcardEmallType,model.emailAddress];
            isReaden = YES;
            break;
        }
    }
    
    if (!isReaden && emallArr.count) {
        HB_EmailModel * model = [emallArr firstObject];
        [vcardString appendFormat:@"EMAIL;TYPE=HOME:%@\n",model.emailAddress];
    }
}



-(UIImage *)getQRImageBy:(NSString * )QRString
{
    //二维码滤镜
    
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    
    [filter setDefaults];
    
    //将字符串转换成NSData
    
    NSData *data=[QRString dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    
    CIImage *outputImage=[filter outputImage];
    
    HB_BusinessCardParser * parser = [[HB_BusinessCardParser alloc] init];
    
    UIImage * image  = [parser createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    [parser release];
    return  image;

}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}


@end
