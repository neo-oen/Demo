//
//  HB_ContactEditStore.m
//  HBZS_IOS
//
//  Created by zimbean on 16/1/25.
//
//

#import "HB_ContactEditStore.h"
#import "HB_ContactDataTool.h"
#import "HB_ContactDetailPhoneCell.h"
#import "HB_ContactDetailCell.h"
#import "HB_ContactDetailArrowCell.h"
#import "HB_ContactDetailGroupManagerVC.h"
#import "HB_ConvertContactModelAndListModel.h"
#import "HB_ConvertPhoneNumArrTool.h"
@interface HB_ContactEditStore ()



/** 电话号码类型 */
@property(nonatomic,retain)NSArray *phoneTypeArr;
/** 邮箱类型 */
@property(nonatomic,retain)NSArray *emailTypeArr;

@end

@implementation HB_ContactEditStore
#pragma mark - life cycle
-(void)dealloc{
    [_itemsArr release];
    [_dataGroup1 release];
    [_dataGroup2 release];
    [_dataGroup3 release];
    [_dataGroup4 release];
    [_dataGroup5 release];
    [_contactModel release];
    [_listModel release];
    [_phoneTypeArr release];
    [_emailTypeArr release];
    [super dealloc];
}
#pragma mark - public Methods
-(void)addDataGroup5{
    [self.itemsArr addObject:self.dataGroup5];
}
-(void)loadMorePhoneCell{
    HB_PhoneNumModel *blankPhoneModel = [[HB_PhoneNumModel alloc]init];
    blankPhoneModel.phoneType = self.phoneTypeArr[self.dataGroup2.count % self.phoneTypeArr.count];
    HB_ContactDetailPhoneCellModel *cellModel = [HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"电话号码" andModel:blankPhoneModel];
    
    [self.listModel.phoneArr addObject:blankPhoneModel];
    [blankPhoneModel release];
    
    [self.dataGroup2 addObject:cellModel];
}
-(void)loadMoreEmailCell{
    //构造emailModel
    HB_EmailModel *blankEmailModel = [[HB_EmailModel alloc]init];
    blankEmailModel.emailType = self.emailTypeArr[self.dataGroup3.count % self.emailTypeArr.count];
    //构造一个新的HB_ContactDetailPhoneCellModel
    HB_ContactDetailPhoneCellModel *cellModel = [HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"邮箱"                                                                                            andModel:blankEmailModel];
    //将这个构造的空白的blankEmailModel添加到emailModel数组
    [self.listModel.eMailArr addObject:blankEmailModel];
    [blankEmailModel release];
    
    [self.dataGroup3 addObject:cellModel];
}



#pragma mark - getter and setter
-(NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [[NSMutableArray alloc]init];
    }
    if (!_itemsArr.count) {
        [_itemsArr addObject:self.dataGroup1];
        [_itemsArr addObject:self.dataGroup2];
        [_itemsArr addObject:self.dataGroup3];
        [_itemsArr addObject:self.dataGroup4];
    }
    return _itemsArr;
}
-(NSMutableArray *)dataGroup1{
    if (!_dataGroup1) {
        _dataGroup1 = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup1.count) {
        HB_ContactDetailCellModel * model = nil;
        model = [HB_ContactDetailCellModel modelWithPlaceHolder:@"姓名"
                                                   andListModel:self.listModel
                                                        andIcon:[UIImage imageNamed:@"姓名"]];
        [_dataGroup1 addObjectsFromArray:@[model]];
    }
    return _dataGroup1;
}
-(NSMutableArray *)dataGroup2{
    if (!_dataGroup2) {
        _dataGroup2 = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup2.count) {
        for (int i=0; i<self.listModel.phoneArr.count; i++) {
            HB_ContactDetailPhoneCellModel *model = [HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"电话号码" andModel:self.listModel.phoneArr[i]];
            model.icon = (i==0 ? [UIImage imageNamed:@"拨号"]:nil);
            [_dataGroup2 addObject:model];
        }
        
        
        //构造phoneModel
        HB_PhoneNumModel *blankPhoneModel = [[HB_PhoneNumModel alloc]init];
        blankPhoneModel.phoneType = self.phoneTypeArr[_dataGroup2.count % self.phoneTypeArr.count];
        
        //将这个构造的空白的phoneModel添加到电话号码model数组
        [self.listModel.phoneArr addObject:blankPhoneModel];
        
        //构造一个新的HB_ContactDetailPhoneCellModel
        HB_ContactDetailPhoneCellModel *cellModel = [HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"电话号码"                                                                andModel:blankPhoneModel];
        UIImage *icon = (_dataGroup2.count == 0 ? [UIImage imageNamed:@"拨号"] : nil);
        cellModel.icon = icon;
        [blankPhoneModel release];
        [_dataGroup2 addObject:cellModel];
    }
    return _dataGroup2;
}
-(NSMutableArray *)dataGroup3{
    if (!_dataGroup3) {
        _dataGroup3 = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup3.count) {
        for (int i=0; i<self.listModel.eMailArr.count; i++) {
            UIImage * icon = (i==0?[UIImage imageNamed:@"邮件"]:nil);
            HB_ContactDetailPhoneCellModel * model = [HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"邮箱"                                                                andModel:self.listModel.eMailArr[i]];
            model.icon = icon;
            [_dataGroup3 addObject:model];
        }
        
        //构造emailModel
        HB_EmailModel *blankEmailModel = [[HB_EmailModel alloc]init];
        blankEmailModel.emailType = self.emailTypeArr[_dataGroup3.count % self.emailTypeArr.count];
        
        //将这个构造的空白的blankEmailModel添加到emailModel数组
        [self.listModel.eMailArr addObject:blankEmailModel];
        
        //构造一个新的HB_ContactDetailPhoneCellModel
        HB_ContactDetailPhoneCellModel *cellModel = [HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"邮箱"                                                                andModel:blankEmailModel];
        UIImage *icon = (_dataGroup3.count == 0 ? [UIImage imageNamed:@"邮件"] : nil);
        cellModel.icon = icon;
        
        [blankEmailModel release];
        [_dataGroup3 addObject:cellModel];
    }
    return _dataGroup3;
}
-(NSMutableArray *)dataGroup4{
    if (!_dataGroup4) {
        _dataGroup4 = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup4.count) {
        HB_ContactDetailCellModel * model1=[HB_ContactDetailCellModel modelWithPlaceHolder:@"公司" andListModel:self.listModel andIcon:[UIImage imageNamed:@"公司"]];
        HB_ContactDetailCellModel * model2=[HB_ContactDetailCellModel modelWithPlaceHolder:@"职务" andListModel:self.listModel andIcon:[UIImage imageNamed:@"职位"]];
        HB_ContactDetailCellModel * model3=[HB_ContactDetailCellModel modelWithPlaceHolder:@"在职部门" andListModel:self.listModel andIcon:[UIImage imageNamed:@"在职部门"]];
        HB_ContactDetailCellModel * model4=[HB_ContactDetailCellModel modelWithPlaceHolder:@"称谓" andListModel:self.listModel andIcon:[UIImage imageNamed:@"称谓"]];
        
        HB_ContactDetailArrowCellModel * model5=[HB_ContactDetailArrowCellModel modelWithPlaceHolder:@"未分组" andListModel:self.listModel andIcon:[UIImage imageNamed:@"未分组"] andViewController:[HB_ContactDetailGroupManagerVC class]];
        
        [_dataGroup4 addObjectsFromArray:@[model1,model2,model3,model4,model5]];
    }
    return _dataGroup4;
}
-(NSMutableArray *)dataGroup5{
    if (!_dataGroup5) {
        _dataGroup5 = [[NSMutableArray alloc]init];
    }
    if (!_dataGroup5.count) {
        HB_ContactDetailCellModel * model7=[HB_ContactDetailCellModel modelWithPlaceHolder:@"QQ" andListModel:self.listModel andIcon:[UIImage imageNamed:@"QQ"]];
        HB_ContactDetailCellModel * model8=[HB_ContactDetailCellModel modelWithPlaceHolder:@"易信" andListModel:self.listModel andIcon:[UIImage imageNamed:@"易信"]];
        HB_ContactDetailCellModel * model9=[HB_ContactDetailCellModel modelWithPlaceHolder:@"微信" andListModel:self.listModel andIcon:[UIImage imageNamed:@"微信"]];
        HB_ContactDetailCellModel * model10=[HB_ContactDetailCellModel modelWithPlaceHolder:@"公司地址" andListModel:self.listModel andIcon:[UIImage imageNamed:@"公司地址"]];
        HB_ContactDetailCellModel * model11=[HB_ContactDetailCellModel modelWithPlaceHolder:@"公司邮编" andListModel:self.listModel andIcon:[UIImage imageNamed:@"公司邮编"]];
        HB_ContactDetailCellModel * model12=[HB_ContactDetailCellModel modelWithPlaceHolder:@"公司主页" andListModel:self.listModel andIcon:[UIImage imageNamed:@"公司主页地址"]];
        HB_ContactDetailCellModel * model13=[HB_ContactDetailCellModel modelWithPlaceHolder:@"家庭地址" andListModel:self.listModel andIcon:[UIImage imageNamed:@"家庭地址"]];
        HB_ContactDetailCellModel * model14=[HB_ContactDetailCellModel modelWithPlaceHolder:@"家庭邮编" andListModel:self.listModel andIcon:[UIImage imageNamed:@"个人邮编"]];
        HB_ContactDetailCellModel * model15=[HB_ContactDetailCellModel modelWithPlaceHolder:@"个人主页" andListModel:self.listModel andIcon:[UIImage imageNamed:@"个人主页"]];
        HB_ContactDetailCellModel * model16=[HB_ContactDetailCellModel modelWithPlaceHolder:@"生日" andListModel:self.listModel andIcon:[UIImage imageNamed:@"生日"]];
        HB_ContactDetailCellModel * model17=[HB_ContactDetailCellModel modelWithPlaceHolder:@"备注" andListModel:self.listModel andIcon:[UIImage imageNamed:@"备注"]];
        HB_ContactDetailCellModel * model18=[HB_ContactDetailCellModel modelWithPlaceHolder:@"名片别名" andListModel:self.listModel andIcon:[UIImage imageNamed:@"职位"]];
        [_dataGroup5 addObjectsFromArray:@[model7,model8,model9,model10,model11,model12,model13,model14,model15,model16,model17,model18]];//model7,model8,model9,
    }
    return _dataGroup5;
}
-(HB_ContactDetailListModel *)listModel{
    if (!_listModel) {
        _listModel = [[HB_ContactDetailListModel alloc]init];
    }
    return _listModel;
}
-(NSArray *)phoneTypeArr{
    if (!_phoneTypeArr) {
        _phoneTypeArr = [[NSArray alloc]initWithArray: @[@"住宅",@"iPhone",@"工作",@"手机",@"住宅传真",@"主要",@"工作传真",@"传呼",@"其他"]];
    }
    return _phoneTypeArr;
}
-(NSArray *)emailTypeArr{
    if (!_emailTypeArr) {
        _emailTypeArr = [[NSArray alloc]initWithArray:@[@"常用邮箱",@"商务邮箱",@"个人邮箱",@"其他邮箱1",@"其他邮箱2"]];
    }
    return _emailTypeArr;
}

-(void)setContactModel:(HB_ContactModel *)contactModel{
    if (_contactModel != contactModel) {
        [_contactModel release];
        _contactModel = [contactModel retain];
    }
    
    if (_contactModel==nil && _phoneNumFromCallHistory) {
        //1.拨号界面，根据号码新建联系人
        _contactModel=[[HB_ContactModel alloc]init];
        NSMutableArray * tempPhoneArr=[NSMutableArray array];
        
        HB_PhoneNumModel *newPhoneModel = [[HB_PhoneNumModel alloc]init];
        newPhoneModel.phoneType = [HB_ConvertPhoneNumArrTool convertPhoneTypeHBZSToPhoneSystem:self.phoneTypeArr[3]];
        newPhoneModel.phoneNum = _phoneNumFromCallHistory;
        [tempPhoneArr addObject:newPhoneModel];
        [newPhoneModel release];
        
        _contactModel.phoneArr=tempPhoneArr;
    }else if (_contactModel && _phoneNumFromCallHistory){
        //2.拨号界面，给某一个联系人新增号码
        NSDictionary * dict = [HB_ContactDataTool contactPropertyArrWithRecordID:_contactModel.contactID.intValue];
        [_contactModel setValuesForKeysWithDictionary:dict];
        
        HB_PhoneNumModel *newPhoneModel = [[HB_PhoneNumModel alloc]init];
        newPhoneModel.phoneType = self.phoneTypeArr[0];
        newPhoneModel.phoneNum = _phoneNumFromCallHistory;
        [_contactModel.phoneArr addObject:newPhoneModel];
        [newPhoneModel release];
        
    }else if (_contactModel && !_phoneNumFromCallHistory){
        //3.分两种情况
        if (_contactModel.contactID) {
            //3.1.有id，则证明是编辑联系人
        }else{
            //3.2.无id，则证明是二维码扫描名片添加
        }
    }else if (!_contactModel && !_phoneNumFromCallHistory){
        //4.联系人主界面，左上角按钮‘新建联系人’
        _contactModel = [[HB_ContactModel alloc]init];
    }
    
    //把最初的联系人模型HB_ContactModel中的值赋给当前的HB_ContactDetailListModel
    [HB_ConvertContactModelAndListModel convertContactModel:_contactModel toListModel:self.listModel];
    
    [self itemsArr];
}


@end
