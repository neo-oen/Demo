//
//  HB_ContactInfoStore.m
//  HBZS_IOS
//
//  Created by zimbean on 16/1/26.
//
//

#import "HB_ContactInfoStore.h"
#import "HB_ContactInfoDialItemTool.h"
#import "HB_ConvertContactModelAndListModel.h"
//4种cell
#import "HB_ContactInfoCell.h"
#import "HB_ContactInfoPhoneCell.h"
#import "HB_ContactInfoEmailCell.h"
#import "HB_ContactInfoCallHistoryCell.h"

@interface HB_ContactInfoStore ()

@property(nonatomic,retain)NSMutableArray *dataGroup1;
@property(nonatomic,retain)NSMutableArray *dataGroup2;
@property(nonatomic,retain)NSMutableArray *dataGroup3;
@property(nonatomic,retain)NSMutableArray *dataGroup4;
@property(nonatomic,retain)NSMutableArray *dataGroup5_half;
@property(nonatomic,retain)NSMutableArray *dataGroup5_all;

@end

@implementation HB_ContactInfoStore
#pragma mark - life cycle
-(void)dealloc{
    [_dataArr release];
    [_contactModel release];
    [_listModel release];
    [_dataGroup1 release];
    [_dataGroup2 release];
    [_dataGroup3 release];
    [_dataGroup4 release];
    [_dataGroup5_half release];
    [_dataGroup5_all release];
    [super dealloc];
}

#pragma mark - public methods
-(void)addAllDataInGroup5{
    [self.dataArr removeLastObject];
    [self.dataArr addObject:self.dataGroup5_all];
}
-(void)addHalfDataInGroup5{
    [self.dataArr removeLastObject];
    [self.dataArr addObject:self.dataGroup5_half];
}
#pragma mark - setter and getter
-(void)setContactModel:(HB_ContactModel *)contactModel{
    if (_contactModel != contactModel) {
        [_contactModel release];
        _contactModel = [contactModel retain];
    }
    
    self.listModel =[[HB_ContactDetailListModel alloc]init];
    [HB_ConvertContactModelAndListModel convertContactModel:_contactModel toListModel:self.listModel];
    //删除原有的数据
    [self.dataArr removeAllObjects];
    [self.dataGroup1 removeAllObjects];
    [self.dataGroup2 removeAllObjects];
    [self.dataGroup3 removeAllObjects];
    [self.dataGroup4 removeAllObjects];
    [self.dataGroup5_half removeAllObjects];
}
-(HB_ContactDetailListModel *)listModel{
    if (!_listModel) {
        _listModel = [[HB_ContactDetailListModel alloc]init];
    }
    return _listModel;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    if (!_dataArr.count) {
//        [_dataArr addObject:self.dataGroup1];
        [_dataArr addObject:self.dataGroup2];
        [_dataArr addObject:self.dataGroup3];
        [_dataArr addObject:self.dataGroup4];
        [_dataArr addObject:self.dataGroup5_half];
    }
    return _dataArr;
}
-(NSMutableArray *)dataGroup1{
    if (!_dataGroup1) {
        _dataGroup1 = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup1.count) {
        if (self.listModel.name) {
            HB_ContactInfoCellModel * model=[HB_ContactInfoCellModel modelWithPlaceHolder:@"姓名" andListModel:self.listModel];
            [_dataGroup1 addObjectsFromArray:@[model]];
        }
    }
    return _dataGroup1;
}
-(NSMutableArray *)dataGroup2{
    if (!_dataGroup2) {
        _dataGroup2 = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup2.count) {
        for (int i=0; i<self.listModel.phoneArr.count; i++) {
            UIImage * icon = i==0?[UIImage imageNamed:@"拨号"]:nil;
            HB_ContactInfoPhoneCellModel * model=[HB_ContactInfoPhoneCellModel modelWithPhoneModel:self.listModel.phoneArr[i] andIcon:icon andIsLastCall:i==0];
            [_dataGroup2 addObjectsFromArray:@[model]];
        }
    }
    return _dataGroup2;
}
-(NSMutableArray *)dataGroup3{
    if (!_dataGroup3) {
        _dataGroup3 = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup3.count) {
        for (int i=0; i<self.listModel.eMailArr.count; i++) {
            UIImage * icon = i==0?[UIImage imageNamed:@"邮件"]:nil;
            HB_ContactInfoEmailCellModel * model = [HB_ContactInfoEmailCellModel modelWithEmailModel:self.listModel.eMailArr[i] andIcon:icon];
            [_dataGroup3 addObjectsFromArray:@[model]];
        }
    }
    return _dataGroup3;
}
-(NSMutableArray *)dataGroup4{
    if (!_dataGroup4) {
        _dataGroup4 = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup4.count) {
//        if (self.listModel.organization.length) {
//            HB_ContactInfoCellModel * model1=[HB_ContactInfoCellModel modelWithPlaceHolder:@"公司" andListModel:self.listModel];
//            [_dataGroup4 addObject:model1];
//        }
//        if (self.listModel.jobTitle.length) {
//            HB_ContactInfoCellModel * model2=[HB_ContactInfoCellModel modelWithPlaceHolder:@"职务" andListModel:self.listModel];
//            [_dataGroup4 addObject:model2];
//        }
        if (self.listModel.department.length) {
            HB_ContactInfoCellModel * model3=[HB_ContactInfoCellModel modelWithPlaceHolder:@"在职部门" andListModel:self.listModel];
            [_dataGroup4 addObject:model3];
        }
        if (self.listModel.nickName.length) {
            HB_ContactInfoCellModel * model4=[HB_ContactInfoCellModel modelWithPlaceHolder:@"称谓" andListModel:self.listModel];
            [_dataGroup4 addObject:model4];
        }
        if (self.listModel.groupsName.length) {
            HB_ContactInfoCellModel * model5=[HB_ContactInfoCellModel modelWithPlaceHolder:@"分组" andListModel:self.listModel];
            [_dataGroup4 addObject:model5];
        }
        //IM数组
        if (self.listModel.QQ.length) {
            HB_ContactInfoCellModel * model6=[HB_ContactInfoCellModel modelWithPlaceHolder:@"QQ" andListModel:self.listModel];
            [_dataGroup4 addObject:model6];
        }
        if (self.listModel.yiXin.length) {
            HB_ContactInfoCellModel * model7=[HB_ContactInfoCellModel modelWithPlaceHolder:@"易信" andListModel:self.listModel];
            [_dataGroup4 addObject:model7];
        }
        if (self.listModel.weiXin.length) {
            HB_ContactInfoCellModel * model8=[HB_ContactInfoCellModel modelWithPlaceHolder:@"微信" andListModel:self.listModel];
            [_dataGroup4 addObject:model8];
        }
        //地址、url数组
        if (self.listModel.address_company.length) {
            HB_ContactInfoCellModel * model9=[HB_ContactInfoCellModel modelWithPlaceHolder:@"公司地址" andListModel:self.listModel];
            [_dataGroup4 addObject:model9];
        }
        if (self.listModel.postcode_family.length) {
            HB_ContactInfoCellModel * model10=[HB_ContactInfoCellModel modelWithPlaceHolder:@"公司邮编" andListModel:self.listModel];
            [_dataGroup4 addObject:model10];
        }
        if (self.listModel.url_company.length) {
            HB_ContactInfoCellModel * model11=[HB_ContactInfoCellModel modelWithPlaceHolder:@"公司主页" andListModel:self.listModel];
            [_dataGroup4 addObject:model11];
        }
        if (self.listModel.address_family.length) {
            HB_ContactInfoCellModel * model12=[HB_ContactInfoCellModel modelWithPlaceHolder:@"家庭地址" andListModel:self.listModel];
            [_dataGroup4 addObject:model12];
        }
        if (self.listModel.postcode_family.length) {
            HB_ContactInfoCellModel * model13=[HB_ContactInfoCellModel modelWithPlaceHolder:@"个人邮编" andListModel:self.listModel];
            [_dataGroup4 addObject:model13];
        }
        if (self.listModel.url_person.length) {
            HB_ContactInfoCellModel * model14=[HB_ContactInfoCellModel modelWithPlaceHolder:@"个人主页" andListModel:self.listModel];
            [_dataGroup4 addObject:model14];
        }
        if (self.listModel.birthday.length) {
            HB_ContactInfoCellModel * model15=[HB_ContactInfoCellModel modelWithPlaceHolder:@"生日" andListModel:self.listModel];
            [_dataGroup4 addObject:model15];
        }
        if (self.listModel.note.length) {
            HB_ContactInfoCellModel * model16=[HB_ContactInfoCellModel modelWithPlaceHolder:@"备注" andListModel:self.listModel];
            [_dataGroup4 addObject:model16];
        }
    }
    return _dataGroup4;
}
-(NSMutableArray *)dataGroup5_half{
    if (!_dataGroup5_half) {
        _dataGroup5_half = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup5_half.count) {
        NSArray * dialItemModelArr=[HB_ContactInfoDialItemTool contactInfoDialItemArrWithRecordID:self.contactModel.contactID.integerValue];
        NSInteger count = dialItemModelArr.count>3?3:dialItemModelArr.count;
        for (int i=0; i<count; i++) {
            UIImage * icon = i==0?[UIImage imageNamed:@"时间"]:nil;
            HB_ContactInfoCallHistoryCellModel * model=[HB_ContactInfoCallHistoryCellModel modelWithDialItemModel:dialItemModelArr[i] andIcon:icon];
            [_dataGroup5_half addObjectsFromArray:@[model]];
        }
    }
    return _dataGroup5_half;
}
-(NSMutableArray *)dataGroup5_all{
    if (!_dataGroup5_all) {
        _dataGroup5_all = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup5_all.count) {
        NSArray * dialItemModelArr=[HB_ContactInfoDialItemTool contactInfoDialItemArrWithRecordID:self.contactModel.contactID.integerValue];
        for (int i=0; i<dialItemModelArr.count; i++) {
            UIImage * icon = i==0?[UIImage imageNamed:@"时间"]:nil;
            HB_ContactInfoCallHistoryCellModel * model=[HB_ContactInfoCallHistoryCellModel modelWithDialItemModel:dialItemModelArr[i] andIcon:icon];
            [_dataGroup5_all addObjectsFromArray:@[model]];
        }
    }
    return _dataGroup5_all;
}
@end
