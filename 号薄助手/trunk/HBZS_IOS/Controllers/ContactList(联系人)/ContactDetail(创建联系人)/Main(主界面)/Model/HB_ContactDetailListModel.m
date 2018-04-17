//
//  HB_ContactDetailListModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/9/15.
//
//

#import "HB_ContactDetailListModel.h"
#import "HB_ContactModel.h"
#import "HB_PhoneNumModel.h"//电话号码模型
#import "HB_ConvertPhoneNumArrTool.h"
#import "HB_EmailModel.h"//邮箱类型
#import "HB_ConvertEmailArrTool.h"
#import "HB_AddressModel.h"
#import "HB_UrlModel.h"
#import "HB_InstantMessageModel.h"

@implementation HB_ContactDetailListModel

-(void)dealloc{
    [_iconData_original release];
    [_name release];
    [_phoneArr release];
    [_eMailArr release];
    [_organization release];
    [_jobTitle release];
    [_department release];
    [_nickName release];
    [_groupsName release];
    [_QQ release];
    [_yiXin release];
    [_weiXin release];
    [_address_company release];
    [_postcode_company release];
    [_url_company release];
    [_address_family release];
    [_postcode_family release];
    [_url_person release];
    [_birthday release];
    [_note release];
    [_cardName release];
    [super dealloc];
}
-(NSMutableArray *)phoneArr{
    if (!_phoneArr) {
        _phoneArr=[[NSMutableArray alloc]init];
    }
    return _phoneArr;
}
-(NSMutableArray *)eMailArr{
    if (!_eMailArr) {
        _eMailArr=[[NSMutableArray alloc]init];
    }
    return _eMailArr;
}
@end
