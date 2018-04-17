//
//  HB_ContactInfoCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import "HB_ContactInfoCellModel.h"

@implementation HB_ContactInfoCellModel
-(void)dealloc{
    [_listModel release];
    [_placeHolder release];
    [super dealloc];
}
+(instancetype)modelWithPlaceHolder:(NSString *)placeHolder andListModel:(HB_ContactDetailListModel *)listModel{
    HB_ContactInfoCellModel * model=[[[self alloc]init] autorelease];
    //属性名字赋值
    model.placeHolder=placeHolder;
    //listModel赋值
    model.listModel=listModel;
    return model;
}
/**
 *  listModel的setter方法
 */
-(void)setListModel:(HB_ContactDetailListModel *)listModel{
    _listModel=[listModel retain];
    //根据_placeHolder找出对应的属性值、图标
    if ([_placeHolder isEqualToString:@"姓名"]) {
        self.text = _listModel.name;
        self.icon = [UIImage imageNamed:@"姓名"];
    }else if ([_placeHolder isEqualToString:@"公司"]){
        self.text = _listModel.organization;
        self.icon = [UIImage imageNamed:@"公司"];
    }else if ([_placeHolder isEqualToString:@"职务"]){
        self.text = _listModel.jobTitle;
        self.icon = [UIImage imageNamed:@"职位"];
    }else if ([_placeHolder isEqualToString:@"在职部门"]){
        self.text = _listModel.department;
        self.icon = [UIImage imageNamed:@"在职部门"];
    }else if ([_placeHolder isEqualToString:@"称谓"]){
        self.text = _listModel.nickName;
        self.icon = [UIImage imageNamed:@"称谓"];
    }else if ([_placeHolder isEqualToString:@"分组"]){
        self.text = _listModel.groupsName;
        self.icon = [UIImage imageNamed:@"未分组"];
    }else if ([_placeHolder isEqualToString:@"QQ"]){
        self.text = _listModel.QQ;
        self.icon = [UIImage imageNamed:@"QQ"];
    }else if ([_placeHolder isEqualToString:@"易信"]){
        self.text = _listModel.yiXin;
        self.icon = [UIImage imageNamed:@"易信"];
    }else if ([_placeHolder isEqualToString:@"微信"]){
        self.text = _listModel.weiXin;
        self.icon = [UIImage imageNamed:@"微信"];
    }else if ([_placeHolder isEqualToString:@"公司地址"]){
        self.text = _listModel.address_company;
        self.icon = [UIImage imageNamed:@"公司地址"];
    }else if ([_placeHolder isEqualToString:@"公司邮编"]){
        self.text = _listModel.postcode_company;
        self.icon = [UIImage imageNamed:@"公司邮编"];
    }else if ([_placeHolder isEqualToString:@"公司主页"]){
        self.text = _listModel.url_company;
        self.icon = [UIImage imageNamed:@"公司主页地址"];
    }else if ([_placeHolder isEqualToString:@"家庭地址"]){
        self.text = _listModel.address_family;
        self.icon = [UIImage imageNamed:@"家庭地址"];
    }else if ([_placeHolder isEqualToString:@"个人邮编"]){
        self.text = _listModel.postcode_family;
        self.icon = [UIImage imageNamed:@"个人邮编"];
    }else if ([_placeHolder isEqualToString:@"个人主页"]){
        self.text = _listModel.url_person;
        self.icon = [UIImage imageNamed:@"个人主页"];
    }else if ([_placeHolder isEqualToString:@"生日"]){
        self.text = _listModel.birthday;
        self.icon = [UIImage imageNamed:@"生日"];
    }else if ([_placeHolder isEqualToString:@"备注"]){
        self.text = _listModel.note;
        self.icon = [UIImage imageNamed:@"备注"];
    }
}

@end
