//
//  HB_ContactMyCardVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/20.
//
//

#import "HB_ContactMyCardVC.h"
//#define ICON_Height 200.0

#import "HB_ContactDetailController.h"
#import "HB_ContactDetailCell.h"//普通的cell
#import "HB_ContactDetailPhoneCell.h"//电话号码，邮箱 cell
#import "HB_ContactDetailCellModel.h"//普通的cell模型
#import "HB_ContactDetailPhoneCellModel.h"//电话号码，邮箱 cell模型
#import "HB_ContactModel.h"//联系人完整的模型
#import "HB_ContactDetailListModel.h"//界面输入内容的Model
#import "HB_ContactDataTool.h"//联系人工具类
#import "HB_HeaderIconView.h"//用户头像视图
#import "SVProgressHUD.h"
#import "HB_ConvertPhoneNumArrTool.h"//电话号码操作类
#import "HB_ConvertEmailArrTool.h"//邮箱操作类
#import "HB_ContactDetailPhoneEmailTypeManageVC.h"//电话号码和邮箱的标签选择VC
#import "SettingInfo.h"//全局的一些设置
#import "HB_ConvertContactModelAndListModel.h"

#import "ContactProtoToContactModel.h"
#import "HB_httpRequestNew.h"
@interface HB_ContactMyCardVC ()<UITableViewDataSource,
                                UITableViewDelegate,
                                HB_ContactDetailPhoneCellDelegate,
                                UINavigationControllerDelegate,
                                HB_HeaderIconViewDelegate,UIImagePickerControllerDelegate>

/** 导航栏右侧 “完成”按钮 */
@property(nonatomic,retain)UIButton * finishBtn_navigationBar;
/** 用户头像视图 */
@property(nonatomic,retain)HB_HeaderIconView * iconHeaderView;
/** tableView */
@property(nonatomic,retain)UITableView *tableView;
/** 数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/** 获取到系统键盘的size */
@property(nonatomic,assign)CGRect keyBoardEndFrame;

/** 电话号码类型 */
@property(nonatomic,retain)NSMutableArray *phoneTypeArr;
/** 邮箱类型 */
@property(nonatomic,retain)NSMutableArray *emailTypeArr;

/** 同步联系人模型**/
@property(nonatomic,retain)Contact * MeContact;
/** 界面输入内容列表的model */
@property(nonatomic,retain)HB_ContactDetailListModel *listModel;

@end

@implementation HB_ContactMyCardVC

-(void)dealloc{
    [_finishBtn_navigationBar release];
    [_iconHeaderView release];
    [_tableView release];
    [_dataArr release];
    
    [_phoneTypeArr release];
    [_emailTypeArr release];
    
    [_contactModel release];
    [_listModel release];
    
    [self removeObserverOfKeyBoard];//移出键盘监听
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initDataArr];
    [self setupTableView];
    [self setupNavigationBar];
    [self addObserverToListeningKeyBoard];//添加键盘监听
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hiddenTabBar];
    
    [self initDataArr];
    [_tableView reloadData];
}
#pragma mark - 设置导航栏和tableView
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    self.title=@"个人名片编辑";
    //右侧完成按钮
    UIButton * finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setFrame:CGRectMake(0, 0, 60, 20)];
    finishBtn.exclusiveTouch = YES;
    finishBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [finishBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    finishBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(navigationBarItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * finishItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
    self.finishBtn_navigationBar=finishBtn;
    self.navigationItem.rightBarButtonItem=finishItem;
    [finishItem release];
    
    UIImage *shadowImage = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = shadowImage;
    [shadowImage release];
}
/**
 *  重写父类的左侧返回按钮的方法
 */
-(void)titleLeftBackBtnDo:(UIButton *)btn{
    [self.view endEditing:YES];
    [self dismissThisViewController];
}
/**
 *  消失当前控制器，这里判断用push还是present
 */
-(void)dismissThisViewController{
    //根据判断导航控制器栈里面有多少个控制器来判断是push进来还是present进来
    NSArray * vcArr=[self.navigationController viewControllers];
    if (vcArr.count>1) {//表示是push进来的
        [self.navigationController popViewControllerAnimated:YES];
    }else{//表示是present进来的
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)navigationBarItemAction{
    //页面停止编辑
    [self.view endEditing:YES];
    
    [HB_ConvertContactModelAndListModel convertListModel:self.listModel toContactModel:self.contactModel];

    //保存名片
    Contact * memcontact = [[ContactProtoToContactModel shareManager] ContactModelmemMycard:self.contactModel];
    //头像
    PortraitData * pordata = [[[PortraitData builder] setImageData:self.contactModel.iconData_original] build];
    [[MemAddressBook getInstance] updMyCard:memcontact];
    [[MemAddressBook getInstance] updMyPortrait:pordata];

    
    
//    [SettingInfo setMyCardContactModel:self.contactModel];
    [self UpdateMyCard];
    

}


-(void)UpdateMyCard
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    [req UpdateMyCardWithType:1 Result:^(BOOL isSucess, NSString *shareUrl, NSInteger resultCode) {
        
        if (!isSucess) {
            [SVProgressHUD dismiss];
            UIAlertView * al =  [[UIAlertView alloc] initWithTitle:nil message:@"云端名片更新失败，请在个人名片中手动点击更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            [al release];
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:@"名片更新成功"];
        [self dismissThisViewController];
    }];
    
    [req release];

}

/**
 *  设置tableView
 */
-(void)setupTableView{
    //设置主tableView
    CGFloat tableView_W=SCREEN_WIDTH;
    CGFloat tableView_H=SCREEN_HEIGHT;
    CGFloat tableView_X=0;
    CGFloat tableView_Y= -64;
    CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    self.tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeInteractive;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=COLOR_I;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=60;
    _tableView.contentInset=UIEdgeInsetsMake(ICON_Height, 0, 0, 0);
    [self.view addSubview:_tableView];
    //设置底部的tableFooterView为按钮
    UIButton * footerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame=CGRectMake(0, 0, tableView_W, 60);
    [footerButton setTitleColor:COLOR_A forState:UIControlStateNormal];
    footerButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [footerButton setTitle:@"添加更多资料" forState:UIControlStateNormal];
    [footerButton setTitle:@"收起更多资料" forState:UIControlStateSelected];
    [footerButton addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView=footerButton;
    //暂时不知道怎么隐藏掉tableHeaderView，以后再说
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    _tableView.tableHeaderView=headerView;
    [headerView release];
    //添加头像视图
    CGRect headerIconViewFrame = CGRectMake(0, -ICON_Height, SCREEN_WIDTH, ICON_Height);
    _iconHeaderView=[[HB_HeaderIconView alloc]initWithFrame:headerIconViewFrame];
    _iconHeaderView.delegate=self;
    _iconHeaderView.contactModel=self.contactModel;
    [self.tableView addSubview:_iconHeaderView];
}
#pragma mark - HB_HeaderIconView协议方法编辑头像--打开相机、相册
-(void)headerIconViewDidOpenCamera:(HB_HeaderIconView *)headerView{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
        imagePicker.delegate=self;
        imagePicker.allowsEditing=YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        [imagePicker release];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"该设备不支持相机" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
-(void)headerIconViewDidOpenLibrary:(HB_HeaderIconView *)headerView{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        imagePicker.delegate=self;
        imagePicker.allowsEditing=YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        [imagePicker release];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"该设备不支持相册打开" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
-(void)headerIconViewDeleteIcon:(HB_HeaderIconView *)headerView
{
    self.listModel.iconData_original = nil;
//    self.iconHeaderView.iconImageView.image = nil;
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * image = info[UIImagePickerControllerEditedImage];
    [self.iconHeaderView.iconImageView setImage:image];
    self.listModel.iconData_original = UIImagePNGRepresentation(image);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 底部添加更多资料的按钮点击事件
-(void)footerButtonClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if (btn.selected) {
        [_tableView beginUpdates];
        [self setupDataToGroup5];
        NSIndexSet * set=[NSIndexSet indexSetWithIndex:self.dataArr.count-1];
        [_tableView insertSections:set withRowAnimation:UITableViewRowAnimationTop];
        [_tableView endUpdates];
    }else{
        [_tableView beginUpdates];
        [self.dataArr removeLastObject];
        NSIndexSet * set=[NSIndexSet indexSetWithIndex:self.dataArr.count];
        [_tableView deleteSections:set withRowAnimation:UITableViewRowAnimationTop];
        [_tableView endUpdates];
    }
}

#pragma mark - 数据源
/**
 *  获取contactModel
 */
-(HB_ContactModel *)contactModel{
    if (_contactModel==nil) {
        //1.从本地存储中取出
        self.MeContact = [[MemAddressBook getInstance] myCard];
        if (self.MeContact) {
            _contactModel = [[ContactProtoToContactModel shareManager] memMycardToContactModel:self.MeContact];
        }
    }
    if (_contactModel==nil) {
        //2.如果还为空，则重新创建一个
        _contactModel=[[HB_ContactModel alloc]init];
        [SettingInfo setMyCardContactModel:_contactModel];
    }
    return _contactModel;
}
/** 现在显示的列表的数据模型 */
-(HB_ContactDetailListModel *)listModel{
    if (_listModel==nil) {
        _listModel=[[HB_ContactDetailListModel alloc]init];
        //把最初的联系人模型HB_ContactModel中的值赋给当前的HB_ContactDetailListModel
        [HB_ConvertContactModelAndListModel convertContactModel:self.contactModel toListModel:_listModel];
    }
    return _listModel;
}
-(NSMutableArray *)phoneTypeArr{
    if (_phoneTypeArr==nil) {
        _phoneTypeArr=[[NSMutableArray alloc]init];
        [_phoneTypeArr addObjectsFromArray:@[@"住宅",@"iPhone",@"工作",@"手机",@"住宅传真",@"主要",@"工作传真",@"传呼",@"其他"]];
    }
    [self removeAlreadyIncludePhoneType];
    return _phoneTypeArr;
}
/**
 * 去除已经占用的电话号码类型
 */
-(void)removeAlreadyIncludePhoneType{
    for (int i=0; i<self.listModel.phoneArr.count; i++) {
        for (NSInteger j=_phoneTypeArr.count-1;j>=0; j--) {
            HB_PhoneNumModel * model=self.listModel.phoneArr[i];
            if ([model.phoneType isEqualToString:_phoneTypeArr[j]]) {
                [_phoneTypeArr removeObjectAtIndex:j];
            }
        }
    }
}
-(NSMutableArray *)emailTypeArr{
    if (_emailTypeArr==nil) {
        _emailTypeArr=[[NSMutableArray alloc]init];
        [_emailTypeArr addObjectsFromArray:@[@"常用邮箱",@"商务邮箱",@"其它邮箱"]];
    }
    [self removeAlreadyIncludeEmailType];
    return _emailTypeArr;
}
/**
 * 去除已经占用的邮箱类型
 */
-(void)removeAlreadyIncludeEmailType{
    for (int i=0; i<self.listModel.eMailArr.count; i++) {
        for (NSInteger j=_emailTypeArr.count-1;j>=0; j--) {
            HB_EmailModel * model=self.listModel.eMailArr[i];
            if ([model.emailType isEqualToString:_emailTypeArr[j]]) {
                [_emailTypeArr removeObjectAtIndex:j];
            }
        }
    }
}
/** tableView的数据源 */
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
/** 重新初始化数据源 */
-(void)initDataArr{
    //把listModel转换为HB_ContactModel;
    [HB_ConvertContactModelAndListModel convertListModel:self.listModel toContactModel:self.contactModel];
    [self.dataArr removeAllObjects];
    [self addDataToDataArr];
}
/**
 *  向数据源里面添加数据
 */
-(void)addDataToDataArr{
    [self setupDataToGroup1];
    [self setupDataToGroup2];
    [self setupDataToGroup3];
    [self setupDataToGroup4];
    //初始化的时候，先不添加更多属性
}
/**
 *  添加第一组默认的数据(只有“姓名”)
 */
-(void)setupDataToGroup1{
    NSMutableArray * group1=[[NSMutableArray alloc]init];
    HB_ContactDetailCellModel * model=[HB_ContactDetailCellModel modelWithPlaceHolder:@"姓名" andListModel:self.listModel andIcon:[UIImage imageNamed:@"姓名"]];
    [group1 addObjectsFromArray:@[model]];
    [self.dataArr addObject:group1];
    [group1 release];
}
/**
 *  添加第二组默认的数据（手机号码）
 */
-(void)setupDataToGroup2{
    NSMutableArray * group=[[NSMutableArray alloc]init];
    for (int i=0; i<self.listModel.phoneArr.count; i++) {
        UIImage * icon = (i==0 ? [UIImage imageNamed:@"拨号"]:nil);
        HB_ContactDetailPhoneCellModel * model=[HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"电话号码" andModel:self.listModel.phoneArr[i]];
        model.icon = icon;
        [group addObject:model];
    }
    //如果phoneTypeArr还有数据，则证明不够9个电话
    if (self.phoneTypeArr.count) {
        //并且如果最后一个cell本身不是空白的话，那么最后需要添加一个空白的Model
        HB_PhoneNumModel * lastPhoneModel=[self.listModel.phoneArr lastObject];
        if (lastPhoneModel.phoneNum.length || !self.listModel.phoneArr.count) {
            //构造phoneModel
            HB_PhoneNumModel * blankPhoneModel=[[HB_PhoneNumModel alloc]init];
            blankPhoneModel.phoneType=self.phoneTypeArr[0];
            [self.phoneTypeArr removeObjectAtIndex:0];//移出这个类型名字，因为已经添加过了
            //将这个构造的空白的phoneModel添加到电话号码model数组
            [self.listModel.phoneArr addObject:blankPhoneModel];
            //构造一个新的HB_ContactDetailPhoneCellModel
            UIImage * icon = (self.listModel.phoneArr.count==0 ? [UIImage imageNamed:@"拨号"]:nil);
            HB_ContactDetailPhoneCellModel * model=[HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"电话号码" andModel:blankPhoneModel];
            model.icon = icon;
            [blankPhoneModel release];
            [group addObject:model];
        }
    }
    [self.dataArr addObject:group];
    [group release];
}
/**
 *  添加第3组默认的数据（邮箱号码）
 */
-(void)setupDataToGroup3{
    NSMutableArray * group=[[NSMutableArray alloc]init];
    for (int i=0; i<self.listModel.eMailArr.count; i++) {
        UIImage * icon = (i==0?[UIImage imageNamed:@"邮件"]:nil);
        HB_ContactDetailPhoneCellModel * model=[HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"邮箱" andModel:self.listModel.eMailArr[i]];
        model.icon = icon;
        [group addObject:model];
    }
    //如果emailTypeArr还有数据，则证明不够4个邮箱
    if (self.emailTypeArr.count) {
        //并且如果最后一个cell本身不是空白的话，那么最后需要添加一个空白的Model
        HB_EmailModel * emailModel=[self.listModel.eMailArr lastObject];
        if (emailModel.emailAddress.length || !self.listModel.eMailArr.count) {
            //构造一个新的emailModel
            HB_EmailModel * blankEmailModel=[[HB_EmailModel alloc]init];
            blankEmailModel.emailType=self.emailTypeArr[0];
            [self.emailTypeArr removeObjectAtIndex:0];//移出这个类型名字，因为已经添加过了
            //添加到邮件模型数组里面
            [self.listModel.eMailArr addObject:blankEmailModel];
            //构造一个新的cell模型（HB_ContactDetailPhoneCellModel）
            UIImage * icon = (self.listModel.eMailArr.count==0 ? [UIImage imageNamed:@"邮件"]:nil);
            HB_ContactDetailPhoneCellModel * phoneCellModel=[HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"邮箱" andModel:blankEmailModel];
            phoneCellModel.icon = icon;
            [blankEmailModel release];
            [group addObject:phoneCellModel];
        }
    }
    [self.dataArr addObject:group];
    [group release];
}
/**
 *  添加第4组默认的数据（其它的一些属性）
 */
-(void)setupDataToGroup4{
    NSMutableArray * group=[[NSMutableArray alloc]init];
    HB_ContactDetailCellModel * model1=[HB_ContactDetailCellModel modelWithPlaceHolder:@"公司" andListModel:self.listModel andIcon:[UIImage imageNamed:@"公司"]];
    HB_ContactDetailCellModel * model2=[HB_ContactDetailCellModel modelWithPlaceHolder:@"职务" andListModel:self.listModel andIcon:[UIImage imageNamed:@"职位"]];
    HB_ContactDetailCellModel * model3=[HB_ContactDetailCellModel modelWithPlaceHolder:@"在职部门" andListModel:self.listModel andIcon:[UIImage imageNamed:@"在职部门"]];
    HB_ContactDetailCellModel * model4=[HB_ContactDetailCellModel modelWithPlaceHolder:@"称谓" andListModel:self.listModel andIcon:[UIImage imageNamed:@"称谓"]];
    
    [group addObjectsFromArray:@[model1,model2,model3,model4]];
    [self.dataArr addObject:group];
    [group release];
}
/**
 *  添加第5组默认的数据（更多的属性）
 */
-(void)setupDataToGroup5{
    NSMutableArray * group=[[NSMutableArray alloc]init];
    
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
    
    [group addObjectsFromArray:@[model7,model8,model9,model10,model11,model12,model13,model14,model15,model16,model17]];
    
    [self.dataArr addObject:group];
    [group release];
}
#pragma mark - Table view 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model=[self.dataArr[indexPath.section] objectAtIndex:indexPath.row];
    //如果类型为普通cell
    if ([model isKindOfClass:[HB_ContactDetailCellModel class]]) {
        HB_ContactDetailCell * cell=[HB_ContactDetailCell cellWithTableView:tableView];
        HB_ContactDetailCellModel * model=[self.dataArr[indexPath.section] objectAtIndex:indexPath.row];
        cell.model=model;
        return cell;
    }
    
    //如果类型为手机号，邮箱号 cell
    else if ([model isKindOfClass:[HB_ContactDetailPhoneCellModel class]]) {
        HB_ContactDetailPhoneCell * cell=[HB_ContactDetailPhoneCell cellWithTableView:tableView];
        HB_ContactDetailPhoneCellModel * model=[self.dataArr[indexPath.section] objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0) {//[self.store.itemsArr[indexPath.section] count] == 1
            if (model.emailModel) {
                model.icon = [UIImage imageNamed:@"邮件"];
            }
            if (model.phoneModel) {
                model.icon = [UIImage imageNamed:@"拨号"];
            }
        }
        
        cell.model=model;
        cell.delegate=self;
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[[UIView alloc]init]autorelease];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    if (section==1 || section==2) {
        UILabel * label=[[UILabel alloc]init];
        label.backgroundColor=COLOR_H;
        label.frame=CGRectMake(15, -0.5, 15+20, 0.5);
        [view addSubview:label];
        [label release];
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1 || section==2) {
        return 0.5;
    }
    return 0.0000000001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不需要操作
}
#pragma mark - scrollView协议方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //恢复所有可见的HB_ContactDetailPhoneCell的状态
    [self recoverAllVisiblePhoneOrEmailCells];
    //如果不是手势引起的滚动就不执行操作
    if (scrollView.panGestureRecognizer.numberOfTouches == 0) {
        //不操作
    }else{
        CGPoint point = [scrollView.panGestureRecognizer locationInView:nil];
        if (point.y >= SCREEN_HEIGHT - _keyBoardEndFrame.size.height) {
            if (_keyBoardEndFrame.origin.y<SCREEN_HEIGHT) {
                CGRect tableFrame=_tableView.frame;
                _tableView.frame=CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, point.y);
                return;
            }
        }
    }
    //根据scrollview的偏移量 来计算头像的放大缩小，以及导航栏的渐变
    [self computeIconFrameAndNavigationBarFrameWithScrollView:scrollView];
}
/**
 *  根据scrollview的偏移量 来计算头像的放大缩小，以及导航栏的渐变
 */
-(void)computeIconFrameAndNavigationBarFrameWithScrollView:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < (-ICON_Height)) {
        CGRect frame=self.iconHeaderView.frame;
        //计算出比例，便于下方计算icon放大的倍数
        float a = -scrollView.contentOffset.y/frame.size.height;
        CGFloat iconImageView_W=frame.size.width * a;
        CGFloat iconImageView_H=frame.size.height * a;
        CGFloat iconImageView_X= -(frame.size.width * a - SCREEN_WIDTH)*0.5;
        CGFloat iconImageView_Y=scrollView.contentOffset.y;
        self.iconHeaderView.frame=CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);
    }
    NSArray *arr=self.navigationController.navigationBar.subviews;
    UIView *bgView=arr[0];
    CGFloat alpha = (ICON_Height + scrollView.contentOffset.y)/(ICON_Height - 64);
    bgView.alpha=alpha;
}
#pragma mark - 监听键盘弹出 相关
/**
 *  添加监听
 */
-(void)addObserverToListeningKeyBoard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
/**
 *  移出监听
 */
-(void)removeObserverOfKeyBoard{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
/**
 *  监听到的动作处理
 */
-(void)keyboardFrameChanged:(NSNotification * )notification{
    NSDictionary * userInfo=notification.userInfo;
    CGFloat timeInterval=[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _keyBoardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_keyBoardEndFrame.origin.y==SCREEN_HEIGHT) {//键盘收起
        [UIView animateWithDuration:timeInterval animations:^{
            CGRect tableFrame=_tableView.frame;
            _tableView.frame=CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width,  _keyBoardEndFrame.origin.y);
        }];
    }else{//键盘弹出
        [UIView animateWithDuration:timeInterval animations:^{
            CGRect tableFrame=_tableView.frame;
            _tableView.frame=CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width,  _keyBoardEndFrame.origin.y);
        }];
        //键盘弹出，则表示，有cell进入编辑状态，不管是不是HB_ContactDetailPhoneCell类型，
        //都要保证，所有的HB_ContactDetailPhoneCell类型的cell都处于恢复原样的状态
        [self recoverAllVisiblePhoneOrEmailCells];
    }
}
#pragma mark - 电话号码/邮箱 cell的协议方法(HB_ContactDetailPhoneCell)
-(void)contactDetailPhoneCellBeginInsert:(HB_ContactDetailPhoneCell *)cell{
    //获取开始编辑的cell的indexPath
    NSIndexPath * indexPath=[_tableView indexPathForCell:cell];
    //获取该分组一共有几行cell
    NSInteger numberOfRows=[self tableView:_tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == numberOfRows-1) {//判断是否是最后一行，只有最后一行点击才添加
        //1.得到需要插入位置的indexPath
        NSIndexPath * finalIndexPath=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        //2.数据源插入数据
        NSMutableArray  * groupArr = self.dataArr[indexPath.section];
        //3.判断添加的是电话还是邮箱
        if (finalIndexPath.section==1) {//电话号码分组
            if (numberOfRows==9) {//如果等于9行的话，就不允许插入新号码了
                return;
            }
            if (self.phoneTypeArr.count) {
                //构造phoneModel
                HB_PhoneNumModel * blankPhoneModel=[[HB_PhoneNumModel alloc]init];
                blankPhoneModel.phoneType=self.phoneTypeArr[0];
                [self.phoneTypeArr removeObjectAtIndex:0];//移出这个类型名字，因为已经添加过了
                HB_ContactDetailPhoneCellModel * model=[HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"电话号码" andModel:blankPhoneModel];
                [self.listModel.phoneArr addObject:blankPhoneModel];
                [blankPhoneModel release];
                
                [groupArr insertObject:model atIndex:finalIndexPath.row];
                [_tableView beginUpdates];
                [_tableView insertRowsAtIndexPaths:@[finalIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
                [_tableView endUpdates];
                
            }
        }else if (finalIndexPath.section==2){//邮箱分组
//            if (numberOfRows==4) {//如果等于4行的话，就不允许插入新邮箱了
//                return;
//            }
            if (self.emailTypeArr.count) {
                //构造emailModel
                HB_EmailModel * blankEmailModel=[[HB_EmailModel alloc]init];
                blankEmailModel.emailType=self.emailTypeArr[0];
                [self.emailTypeArr removeObjectAtIndex:0];//移出这个类型名字，因为已经添加过了
                HB_ContactDetailPhoneCellModel * model=[HB_ContactDetailPhoneCellModel modelWithPlaceHolder:@"邮箱" andModel:blankEmailModel];
                [self.listModel.eMailArr addObject:blankEmailModel];
                [blankEmailModel release];
                //插入cell模型到第三个section的数据源
                [groupArr insertObject:model atIndex:finalIndexPath.row];
                [_tableView beginUpdates];
                [_tableView insertRowsAtIndexPaths:@[finalIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
                [_tableView endUpdates];
            }
        }
    }
}

-(void)contactDetailPhoneCellBeginClear:(HB_ContactDetailPhoneCell *)cell{
    NSIndexPath * indexPath=[_tableView indexPathForCell:cell];
    //1.获取该组所有数据源
    NSMutableArray * groupArr=self.dataArr[indexPath.section];
    //2.如果存在下一个cell的话，然后判断这个cell是不是空的，如果是空的，就删除
    if (indexPath.row < (groupArr.count-1)) {
        NSIndexPath * nextIndexPath=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        HB_ContactDetailPhoneCell * cell=(HB_ContactDetailPhoneCell*)[_tableView cellForRowAtIndexPath:nextIndexPath];
//        if (cell.textField.text.length==0) {
            if (indexPath.section==1) {//电话号码
                BOOL ret = indexPath.row == (groupArr.count-1);
                if (ret) {
                    //不作操作，不删除
                }else{
                    //回收类型名称
                    HB_ContactDetailPhoneCellModel * phoneCellModel=groupArr[indexPath.row+1];
                    [_phoneTypeArr insertObject:phoneCellModel.phoneModel.phoneType atIndex:0];
                    [self.listModel.phoneArr removeObjectAtIndex:indexPath.row];
                }
            }else if(indexPath.section==2){//邮箱
                BOOL ret = indexPath.row == (groupArr.count-1);
                if (ret) {
                    //不作操作，不删除
                }else{
                    //回收类型名称
                    HB_ContactDetailPhoneCellModel * phoneCellModel=groupArr[indexPath.row];
                    [_emailTypeArr insertObject:phoneCellModel.emailModel.emailType atIndex:0];
                    [self.listModel.eMailArr removeObjectAtIndex:indexPath.row];
                }
            }
            [_tableView beginUpdates];
            [groupArr removeObjectAtIndex:indexPath.row];
             [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [_tableView endUpdates];
//        }
    }
}
-(void)contactDetailPhoneCell:(HB_ContactDetailPhoneCell *)cell didEndEditingWithText:(NSString *)text{
    NSIndexPath * indexPath =[_tableView indexPathForCell:cell];
    if (indexPath.section==1) {//电话号码
        if (text.length) {//有电话号码的状态
            //1.取出该分组的数据源
            NSMutableArray * groupArr=self.dataArr[indexPath.section];
            //2.取出该cell对应的model
            HB_ContactDetailPhoneCellModel * phoneCellModel=groupArr[indexPath.row];
            //3.给电话号码模型重新赋值
            phoneCellModel.phoneModel.phoneNum=text;
        }
    }else if (indexPath.section==2){//邮箱
        if (text.length) {//有邮箱地址的状态
            //1.取出该分组的数据源
            NSMutableArray * groupArr=self.dataArr[indexPath.section];
            //2.取出该cell对应的model
            HB_ContactDetailPhoneCellModel * phoneCellModel=groupArr[indexPath.row];
            //3.给邮箱模型重新赋值
            phoneCellModel.emailModel.emailAddress=text;
        }
    }
    //把listModel转换为HB_ContactModel;
    [HB_ConvertContactModelAndListModel convertListModel:self.listModel toContactModel:self.contactModel];
}
/**
 *  cell左侧删除按钮的点击
 */
-(void)contactDetailPhoneCell:(HB_ContactDetailPhoneCell *)cell deleteLeftBtnClick:(UIButton *)deleteBtn{
    [self.view endEditing:YES];
    NSArray * cellArr=_tableView.visibleCells;
    for (int i=0; i<cellArr.count; i++) {
        if ([cellArr[i] isKindOfClass:[HB_ContactDetailPhoneCell class]]) {
            HB_ContactDetailPhoneCell * cell=cellArr[i];
            cell.contentView.userInteractionEnabled=NO;
        }
    }
}

/**
 *  cell右侧删除按钮的点击
 */
-(void)contactDetailPhoneCell:(HB_ContactDetailPhoneCell *)cell deleteRightBtnClick:(UIButton *)deleteBtn{
    //恢复所有cell的状态
    [self recoverAllVisiblePhoneOrEmailCells];
    
    NSIndexPath * indexPath=[_tableView indexPathForCell:cell];
    HB_ContactDetailPhoneCellModel * model=self.dataArr[indexPath.section][indexPath.row];
    if (indexPath.section==1) {//电话
        //回收类型名称
        [self.phoneTypeArr insertObject:model.phoneModel.phoneType atIndex:0];
        [self.listModel.phoneArr removeObject:model.phoneModel];
    }else if (indexPath.section==2){//邮箱
        //回收类型名称
        [self.emailTypeArr insertObject:model.emailModel.emailType atIndex:0];
        [self.listModel.eMailArr removeObject:model.emailModel];
    }
    [self.dataArr[indexPath.section] removeObject:model];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    //重新添加数据源，刷新页面
    [self initDataArr];
    [_tableView reloadData];
}
/**
 *  cell右侧类型选择按钮的点击(常用电话、常用邮箱之类的。。)
 */
-(void)contactDetailPhoneCell:(HB_ContactDetailPhoneCell *)cell typeChooseBtnClick:(UIButton *)chooseBtn{
    [self.view endEditing:YES];
    
    HB_ContactDetailPhoneEmailTypeManageVC * typeManageVC=[[HB_ContactDetailPhoneEmailTypeManageVC alloc]init];
    //1.传入cell的模型
    typeManageVC.phoneCellModel=cell.model;
    typeManageVC.typeArr = [NSMutableArray arrayWithArray:@[@"住宅",@"iPhone",@"工作",@"手机",@"住宅传真",@"主要",@"工作传真",@"传呼",@"其他"]];
    //2.传入剩余的标签数组_phoneTypeArr/_emailTypeArr
//    if (cell.model.phoneModel) {
//        typeManageVC.typeArr=self.phoneTypeArr;
//    }else if (cell.model.emailModel){
//        typeManageVC.typeArr=self.emailTypeArr;
//    }
    //push
    [self.navigationController pushViewController:typeManageVC animated:YES];
    [typeManageVC release];
}
/**
 *  cell的触摸开始方法
 */
-(void)contactDetailPhoneCellTouchBegin:(HB_ContactDetailPhoneCell *)cell{
    [self recoverAllVisiblePhoneOrEmailCells];
}
/**
 *  自定义方法，恢复所有可见的cell的状态
 */
-(void)recoverAllVisiblePhoneOrEmailCells{
    NSArray * cellArr=_tableView.visibleCells;
    for (int i=0; i<cellArr.count; i++) {
        if ([cellArr[i] isKindOfClass:[HB_ContactDetailPhoneCell class]]) {
            HB_ContactDetailPhoneCell * cell=cellArr[i];
            [cell recoveryCell];
            cell.contentView.userInteractionEnabled=YES;
        }
    }
}
#pragma mark - 普通HB_ContactDetailCell的协议方法（HB_ContactDetailCell停止编辑）
-(void)contactDetailCell:(HB_ContactDetailCell *)cell didEndEditingWithText:(NSString *)text{
    NSString * nameStr=cell.model.placeHolder;
    if ([nameStr isEqualToString:@"姓名"]) {
        self.listModel.name=text;
    }else if ([nameStr isEqualToString:@"公司"]){
        self.listModel.organization=text;
    }else if ([nameStr isEqualToString:@"职务"]){
        self.listModel.jobTitle=text;
    }else if ([nameStr isEqualToString:@"在职部门"]){
        self.listModel.department=text;
    }else if ([nameStr isEqualToString:@"称谓"]){
        self.listModel.nickName=text;
    }else if ([nameStr isEqualToString:@"QQ"]){
        self.listModel.QQ=text;
    }else if ([nameStr isEqualToString:@"易信"]){
        self.listModel.yiXin=text;
    }else if ([nameStr isEqualToString:@"微信"]){
        self.listModel.weiXin=text;
    }else if ([nameStr isEqualToString:@"公司地址"]){
        self.listModel.address_company=text;
    }else if ([nameStr isEqualToString:@"公司邮编"]){
        self.listModel.postcode_company=text;
    }else if ([nameStr isEqualToString:@"公司主页"]){
        self.listModel.url_company=text;
    }else if ([nameStr isEqualToString:@"家庭地址"]){
        self.listModel.address_family=text;
    }else if ([nameStr isEqualToString:@"家庭邮编"]){
        self.listModel.postcode_family=text;
    }else if ([nameStr isEqualToString:@"个人主页"]){
        self.listModel.url_person=text;
    }else if ([nameStr isEqualToString:@"生日"]){
        self.listModel.birthday=text;
    }else if ([nameStr isEqualToString:@"备注"]){
        self.listModel.note=text;
    }
    //把listModel转换为HB_ContactModel;
    [HB_ConvertContactModelAndListModel convertListModel:self.listModel toContactModel:self.contactModel];
}


@end
