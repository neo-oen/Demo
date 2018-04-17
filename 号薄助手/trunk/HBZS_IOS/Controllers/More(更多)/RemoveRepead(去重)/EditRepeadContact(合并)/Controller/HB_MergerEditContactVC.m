//
//  HB_MergerEditContactVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/20.
//
//

#import "HB_MergerEditContactVC.h"
#import "HB_ContactModel.h"
#import "HB_ContactDataTool.h"
#import "HB_EditContactCell.h"
#import "SVProgressHUD.h"
#import "HB_MergerHeaderImageCell.h"
#import "HB_MergerHeaderCollectionItemCell.h"
#import "HB_PhoneNumModel.h"
#import "HB_EmailModel.h"
#import "HB_AddressModel.h"
#import "HB_ConvertPhoneNumArrTool.h"
#import "HB_ConvertEmailArrTool.h"
@interface HB_MergerEditContactVC ()<UITableViewDataSource,
                                    UITableViewDelegate,
                                    HB_MergerHeaderImageCellDelegate>

/**  表格视图 */
@property(nonatomic,retain)UITableView *tableView;
/**  数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**  section 的 title数据源 */
@property(nonatomic,retain)NSMutableArray *sectionTitleArr;
/**  电话号码类型  数据源 */
@property(nonatomic,retain)NSMutableArray *phoneTypeArr;
/**  邮箱类型 数据源 */
@property(nonatomic,retain)NSMutableArray *emailTypeArr;
/**  右侧'完成'按钮 */
@property(nonatomic,retain)UIButton  *finishBtn;
/**  右侧‘完成’UIBarButtonItem按钮 */
@property(nonatomic,retain)UIBarButtonItem  *finishBarButtonItem;
/**  选中的头像的下标 */
@property(nonatomic,assign)NSInteger iconIndex;

@end

@implementation HB_MergerEditContactVC

#pragma mark - life cycle
-(void)dealloc{
    [_contactArr release];
    [_tableView release];
    [_dataArr release];
    [_phoneTypeArr release];
    [_emailTypeArr release];
    [_sectionTitleArr release];
    [_finishBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    //默认是第0个头像
    _iconIndex = 0;
    self.navigationItem.rightBarButtonItem = self.finishBarButtonItem;
    [self.view addSubview:self.tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //刚进入页面，先选中一些默认选项
    for (int i=0; i<self.dataArr.count; i++) {
        NSArray *arr = self.dataArr[i];
        if (arr.count) {
            if (i==0 || i==1 || i==4) {
                //头像单选;名字单选;家庭地址单选;（默认第一个）
                NSIndexPath * indexPath=[NSIndexPath indexPathForRow:0 inSection:i];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }else{//电话号码、邮箱。默认全选
                for (int j=0;j<arr.count; j++) {
                    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:j inSection:i];
                    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
        }
    }
}

#pragma mark - private methods
/**
 *  初始化数据源
 */
-(void)initDataArr{
    [_dataArr removeAllObjects];
    //1.头像数组
    NSMutableArray * iconArr=[[NSMutableArray alloc]init];
    //2.姓名
    NSMutableArray * nameArr=[[NSMutableArray alloc]init];
    //3.电话
    NSMutableArray * phoneArr=[[NSMutableArray alloc]init];
    //4.邮箱
    NSMutableArray * eMailArr=[[NSMutableArray alloc]init];
    //5.地址
    NSMutableArray * addressArr=[[NSMutableArray alloc]init];
    
    for (int i=0; i<self.contactArr.count;i++) {
        HB_ContactModel * model=self.contactArr[i];
        //1.添加头像
        if (model.iconData_thumbnail) {
            [iconArr addObject:model.iconData_thumbnail];
        }
        //2.添加姓名
        NSString * fullName=[HB_ContactDataTool contactGetFullNameWithModel:model];
        if (fullName) {
            [nameArr addObject:fullName];
        }
        //3.添加电话
        for (int j=0; j<model.phoneArr.count; j++) {
            HB_PhoneNumModel *phoneModel = model.phoneArr[j];
            [phoneArr addObject:phoneModel.phoneNum];
        }
        //4.添加邮箱
        for (int j=0; j<model.emailArr.count; j++) {
            HB_EmailModel *emailModel = model.emailArr[j];
            [eMailArr addObject:emailModel.emailAddress];
        }
        //5.添加地址
        for (int j=0; j<model.addressArr.count; j++) {
#warning 这里地址属性是多值属性，所以其实是应该多选的。由于UI设计图是要求单选，所以这里不能严谨的进行比较。具体实现以后还需要再商讨。   2016-1-6
            HB_AddressModel *addressModel = model.addressArr[j];
            NSMutableString *addressStr = [NSMutableString string];
            if (addressModel.country.length) {
                [addressStr appendString:addressModel.country];
            }
            if (addressModel.state.length) {
                [addressStr appendString:addressModel.state];
            }
            if (addressModel.city.length) {
                [addressStr appendString:addressModel.city];
            }
            if (addressModel.street.length) {
                [addressStr appendString:addressModel.street];
            }
            if (addressStr.length) {
                [addressArr addObject:addressStr];
            }
        }
    }
    //添加到数据源
    [_dataArr addObject:iconArr];
    [_dataArr addObject:nameArr];
    [_dataArr addObject:phoneArr];
    [_dataArr addObject:eMailArr];
    [_dataArr addObject:addressArr];
    //数组内容去重
    for (int i=0; i<_dataArr.count; i++) {
        NSMutableArray * tempArr=_dataArr[i];
        [self filterMutableArr:tempArr];
    }
    //释放
    [iconArr release];
    [nameArr release];
    [phoneArr release];
    [eMailArr release];
    [addressArr release];
}
/**
 *  给数组去重
 */
-(void)filterMutableArr:(NSMutableArray *)mutableArr{
    for (int i=mutableArr.count-1; i>=0; i--) {
        id obj1=mutableArr[i];
        //生成一个除了自己之外的数组
        NSMutableArray * tempArr=[mutableArr mutableCopy];
        NSRange range = NSMakeRange(i, 1);
        [tempArr removeObject:obj1 inRange:range];
        if ([tempArr containsObject:obj1]) {
            [mutableArr removeObject:obj1 inRange:range];
        }
        [tempArr release];
    }
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSMutableArray * arr=self.dataArr[section];
    if (arr.count) {
        return 30;
    }else{
        return 0.0001;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        //1.算出当前设备，一行可以放几个item
        NSInteger count = (SCREEN_WIDTH - 15*2 + 8)/(46+8);
        //2.算出当前的头像数组，需要放几行
        NSArray * iconArr=self.dataArr[indexPath.section];
        NSInteger rowCount= iconArr.count%count ? iconArr.count/count+1 : iconArr.count/count;
        //3.算出高度
        CGFloat height = rowCount * (46+8);
        return height;
    }else{
        return 50;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor=COLOR_I;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 || indexPath.section==1 || indexPath.section==4) {
        //让本组其他的cell取消选中
        for (int i=0; i<[self.dataArr[indexPath.section] count]; i++) {
            NSIndexPath * otherIndexPath=[NSIndexPath indexPathForRow:i inSection:indexPath.section];
            if (otherIndexPath.row != indexPath.row) {
                [tableView deselectRowAtIndexPath:otherIndexPath animated:NO];
            }
        }
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 || indexPath.section==1 || indexPath.section==4) {
        //再次点击不允许取消选中
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return [self.dataArr[section] count] ? 1 : 0 ;
    }else{
        return  [self.dataArr[section] count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section!=0) {//非头像分组
        static NSString *str=@"HB_EditContactCell";
        HB_EditContactCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil) {
            cell=[[[HB_EditContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
        }
        cell.textLabel.text=self.dataArr[indexPath.section][indexPath.row];
        return cell;
    }else{//头像
        static NSString * str=@"HB_MergerHeaderImageCell";
        HB_MergerHeaderImageCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"HB_MergerHeaderImageCell" owner:self options:nil]lastObject];
            cell.delegate=self;
        }
        cell.iconArr=self.dataArr[indexPath.section];
        return cell;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section!=0;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSMutableArray * arr=self.dataArr[section];
    if (arr.count) {
        return self.sectionTitleArr[section];
    }else{
        return nil;
    }
}
#pragma mark - HB_MergerHeaderImageCellDelegate
-(void)mergerHeaderImageCell:(HB_MergerHeaderImageCell *)cell didSelectHeaderImageViewWithIndex:(NSInteger)index{
    _iconIndex = index;
    ZBLog(@"%ld",(long)index);
}
#pragma mark - event response
-(void)finishBtnClick:(UIButton *)btn{
    [SVProgressHUD show];
    btn.userInteractionEnabled = NO;
    
    //取出任意一个联系人，在此基础上做更改
    HB_ContactModel *model = self.contactArr[0];
    //1.头像
    NSData *iconData = nil;
    //2.名字
    NSString *nameStr = nil;
    //3.电话号码
    NSMutableArray *phoneArr = [NSMutableArray array];
    //4.邮箱号码
    NSMutableArray *emailArr = [NSMutableArray array];
    //5.家庭地址
    NSMutableArray *addressArr = [NSMutableArray array];
    
    NSArray *arr = [_tableView indexPathsForSelectedRows];
    for (int i=0; i<arr.count; i++) {
        NSIndexPath *indexPath = arr[i];
        switch (indexPath.section) {
            case 0:{//头像分组
                NSArray *iconArr = self.dataArr[indexPath.section];
                iconData = iconArr[self.iconIndex];//赋值头像
            }break;
            case 1:{//名字分组
                nameStr=self.dataArr[indexPath.section][indexPath.row];
            }break;
            case 2:{//电话分组
                HB_PhoneNumModel *phoneModel = [[HB_PhoneNumModel alloc]init];
#warning 这里用 i%9 是为了防止下标越界。假如联系人A有5个联系人 联系人B有5个联系人，那么如果这两个联系人合并，且联系人都不一样，则最终有10个联系人，这样就超出了9个联系人的限制。具体的实现方式应该还需商讨  2016-1-6
                //号码类型 HB_ContactModel 中存系统字段 存入model时调用方法进行转换
                phoneModel.phoneType = [HB_ConvertPhoneNumArrTool convertPhoneTypeHBZSToPhoneSystem:self.phoneTypeArr[i%9]];
                phoneModel.phoneNum  = self.dataArr[indexPath.section][indexPath.row];
                [phoneArr addObject:phoneModel];
                [phoneModel release];
            }break;
            case 3:{//邮箱分组
                HB_EmailModel *emailModel = [[HB_EmailModel alloc]init];
                //邮箱类型 HB_ContactModel 中存系统字段 存入model时调用方法进行转换
                emailModel.emailType = [HB_ConvertEmailArrTool convertEmailTypeHBZSToSystem:self.emailTypeArr[i%4]];
                emailModel.emailAddress = self.dataArr[indexPath.section][indexPath.row];
                [emailArr addObject:emailModel];
                [emailModel release];
            }break;
            case 4:{//地址
                HB_AddressModel *addressModel = [[HB_AddressModel alloc]init];
                addressModel.type = @"家庭地址";
                addressModel.street = self.dataArr[indexPath.section][indexPath.row];
                [addressArr addObject:addressModel];
                [addressModel release];
            }break;
                
            default:
                break;
        }
    }
    //给Model赋值
    model.iconData_original = iconData;
    model.firstName = nil;
    model.middleName = nil;
    model.lastName = nameStr;
    model.phoneArr = phoneArr;
    model.emailArr = emailArr;
    model.addressArr = addressArr;
    [HB_ContactDataTool contactAddPeopleByModel:model];
    //删除其他联系人
    for (int i = (self.contactArr.count - 1); i >= 0; i--) {
        HB_ContactModel * model = self.contactArr[i];
        if (i != 0) {
            BOOL ret = [HB_ContactDataTool contactDeleteContactByID:model.contactID.integerValue];
            if (!ret) {
                ZBLog(@"合并联系人失败");
            }
        }
        [self.contactArr removeObject:model];
    }
    [SVProgressHUD showSuccessWithStatus:@"合并成功"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
   
}

#pragma mark - setter and getter
-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat tableView_W=SCREEN_WIDTH;
        CGFloat tableView_H=SCREEN_HEIGHT-64;
        CGFloat tableView_X=0;
        CGFloat tableView_Y=0;
        CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.editing=YES;
        _tableView.allowsMultipleSelectionDuringEditing=YES;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)phoneTypeArr{
    if (_phoneTypeArr==nil) {
        _phoneTypeArr=[[NSMutableArray alloc]init];
        [_phoneTypeArr addObjectsFromArray:@[@"住宅",@"iPhone",@"工作",@"手机",@"住宅传真",@"主要",@"工作传真",@"传呼",@"其他"]];
    }
    return _phoneTypeArr;
}
-(NSMutableArray *)emailTypeArr{
    if (_emailTypeArr==nil) {
        _emailTypeArr=[[NSMutableArray alloc]init];
        [_emailTypeArr addObjectsFromArray:@[@"常用邮箱",@"商务邮箱",@"个人邮箱",@"其他邮箱1",@"其他邮箱2"]];
    }
    return _emailTypeArr;
}
-(NSMutableArray *)sectionTitleArr{
    if (!_sectionTitleArr) {
        _sectionTitleArr=[[NSMutableArray alloc]init];
        [_sectionTitleArr addObjectsFromArray:@[@"头像(单选)",@"姓名(单选)",@"电话号码(可多选)",@"邮箱(可多选)",@"家庭地址(单选)"]];
    }
    return _sectionTitleArr;
}
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
        [self initDataArr];
    }
    return _dataArr;
}
-(UIBarButtonItem *)finishBarButtonItem{
    if (!_finishBarButtonItem) {
        _finishBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.finishBtn];
    }
    return _finishBarButtonItem;
}
-(UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setFrame:CGRectMake(0, 0, 44, 20)];
        _finishBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

@end
