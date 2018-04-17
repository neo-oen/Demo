//
//  HB_ContactDetailController.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//

#import "HB_ContactDetailController.h"
#import "HB_ContactDetailCell.h"//普通的cell
#import "HB_ContactDetailArrowCell.h"//右侧带箭头的cell
#import "HB_ContactDetailPhoneCell.h"//电话号码，邮箱 cell
#import "HB_ContactDetailCellModel.h"//普通的cell模型
#import "HB_ContactDetailArrowCellModel.h"//右侧带箭头的cell模型
#import "HB_ContactDetailPhoneCellModel.h"//电话号码，邮箱 cell模型
#import "HB_ContactDetailListModel.h"//界面输入内容的Model
#import "HB_ContactDataTool.h"//联系人工具类
#import "HB_ContactDetailGroupManagerVC.h"//联系人分组
#import "GroupData.h"//分组工具类
#import "HB_HeaderIconView.h"//用户头像视图
#import "SVProgressHUD.h"
#import "HB_ConvertPhoneNumArrTool.h"//电话号码操作类
#import "HB_ConvertEmailArrTool.h"//邮箱操作类
#import "HB_ContactDetailPhoneEmailTypeManageVC.h"//电话号码和邮箱的标签选择VC

#import "HB_ContactEditStore.h"

#import "HB_ConvertContactModelAndListModel.h"

#import "HBZSAppDelegate.h"
#import "HB_ContactDetailGroupManagerVC.h"

#import "SettingInfo.h"

@interface HB_ContactDetailController ()<
                                        UITableViewDelegate,
                                        UITableViewDataSource,
                                        HB_ContactDetailPhoneCellDelegate,
                                        UINavigationControllerDelegate,
                                        HB_HeaderIconViewDelegate,
                                        UIImagePickerControllerDelegate,ContactDetailGroupManageDelegate>
#pragma mark 控件
/** 导航栏右侧 “完成”按钮 */
@property(nonatomic,retain)UIButton * finishBtn;
/** 导航栏右侧 “完成”按钮item */
@property(nonatomic,retain)UIBarButtonItem * finishBtnItem;
/** 用户头像视图 */
@property(nonatomic,retain)HB_HeaderIconView * iconHeaderView;
/** tableView底部 “更多资料” 按钮 */
@property(nonatomic,retain)UIButton * moreInformationBtn;

#pragma mark 数据
/**  数据源 */

@property(nonatomic,retain)NSArray * NewContactGroupArr;


@end
@implementation HB_ContactDetailController
#pragma mark - life cycle
-(void)dealloc{
    [_phoneNumFromCallHistory release];
    [_finishBtnItem release];
    [_iconHeaderView release];
    [_tableView release];
    [_contactModel release];
    [_store release];
    //移出键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    //关闭监听
    [SettingInfo setListenAppChangedAddressbook:NO];
    
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏底部细线隐藏
    UIImage *blankImage = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = blankImage;
    [blankImage release];
    //添加控件
    self.navigationItem.rightBarButtonItem = self.finishBtnItem;
    [self.view addSubview:self.tableView];
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChanged:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    self.title = @"联系人编辑";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    [self hiddenTabBar];
    [_tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self computeIconFrameAndNavigationBarFrameWithScrollView:self.tableView];
}

#pragma mark - public methods
/**
 *  重写父类的左侧返回按钮的方法
 */
-(void)titleLeftBackBtnDo:(UIButton *)btn{
    [self.view endEditing:YES];
    [self dismissThisViewController];
}
#pragma mark - private methods
/**
 *  消失当前控制器，这里判断用push还是present
 */
-(void)dismissThisViewController{
    //根据判断导航控制器栈里面有多少个控制器来判断是push进来还是present进来
    NSArray * vcArr=[self.navigationController viewControllers];
    if (vcArr.count>1) {//表示是push进来的
        NSArray * vcArr=self.navigationController.viewControllers;
        [self.navigationController popToViewController:vcArr[vcArr.count-3] animated:YES];
    }else{//表示是present进来的
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - HB_HeaderIconViewDelegate
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
    self.store.listModel.iconData_original = nil;
}

-(void)headerIconViewbInfoBtnClick:(HB_HeaderIconView *)headerview
{
    [self.view endEditing:YES];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * image = info[UIImagePickerControllerEditedImage];
    [self.iconHeaderView.iconImageView setImage:image];
    self.store.listModel.iconData_original = UIImagePNGRepresentation(image);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model=[self.store.itemsArr[indexPath.section] objectAtIndex:indexPath.row];
    //如果类型为普通cell
    
    
    if ([model isKindOfClass:[HB_ContactDetailCellModel class]]) {
        HB_ContactDetailCell *cell = [HB_ContactDetailCell cellWithTableView:tableView];
        HB_ContactDetailCellModel *model = [self.store.itemsArr[indexPath.section] objectAtIndex:indexPath.row];
        
        cell.model=model;
        return cell;
    }
    //如果类型为右侧带箭头cell
    else if ([model isKindOfClass:[HB_ContactDetailArrowCellModel class]]) {
        HB_ContactDetailArrowCell * cell=[HB_ContactDetailArrowCell cellWithTableView:tableView];
        HB_ContactDetailArrowCellModel * model=[self.store.itemsArr[indexPath.section] objectAtIndex:indexPath.row];
        cell.model=model;
        return cell;
    }
    //如果类型为手机号，邮箱号 cell
    else if ([model isKindOfClass:[HB_ContactDetailPhoneCellModel class]]) {
        HB_ContactDetailPhoneCell * cell=[HB_ContactDetailPhoneCell cellWithTableView:tableView];
        
        HB_ContactDetailPhoneCellModel *model = [self.store.itemsArr[indexPath.section] objectAtIndex:indexPath.row];

        if (indexPath.row == 0) {//[self.store.itemsArr[indexPath.section] count] == 1
            if (model.emailModel) {
                model.icon = [UIImage imageNamed:@"邮件"];
            }
            if (model.phoneModel) {
                model.icon = [UIImage imageNamed:@"拨号"];
            }
        }
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.store.itemsArr[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.store.itemsArr.count;
}
#pragma mark - UITableViewDelegate
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
    id model=[self.store.itemsArr[indexPath.section] objectAtIndex:indexPath.row];
    //如果类型为右侧带箭头cell，其它两种cell不需要任何操作
    if ([model isKindOfClass:[HB_ContactDetailArrowCellModel class]]) {
        HB_ContactDetailArrowCellModel * model1=(HB_ContactDetailArrowCellModel *)model;
        if (model1.viewController == [HB_ContactDetailGroupManagerVC class]) {
            [self.view endEditing:YES];

            HB_ContactDetailGroupManagerVC * vc =[[model1.viewController alloc]init];
            if (!self.contactModel.contactID) {
                vc.delegate = self;
            }
            vc.recordID=self.contactModel.contactID.integerValue;
            vc.arrowCellModel=model1;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            
           
        }
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //恢复所有可见的HB_ContactDetailPhoneCell的状态
    [self recoverAllVisiblePhoneOrEmailCells];
    //根据scrollview的偏移量 来计算头像的放大缩小，以及导航栏的渐变
    [self computeIconFrameAndNavigationBarFrameWithScrollView:scrollView];
}
/**
 *  根据scrollview的偏移量 来计算头像的放大缩小，以及导航栏的渐变
 */
-(void)computeIconFrameAndNavigationBarFrameWithScrollView:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y < (-ICON_Height)) {
//        CGRect frame=self.iconHeaderView.frame;
//        //计算出比例，便于下方计算icon放大的倍数
//        float a = -scrollView.contentOffset.y/frame.size.height;
//        CGFloat iconImageView_W=frame.size.width * a;
//        CGFloat iconImageView_H=frame.size.height * a;
//        CGFloat iconImageView_X= -(frame.size.width * a - SCREEN_WIDTH)*0.5;
//        CGFloat iconImageView_Y=scrollView.contentOffset.y;
//        self.iconHeaderView.frame=CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);
//    }
    NSArray *arr=self.navigationController.navigationBar.subviews;
    UIView *bgView=arr[0];
    CGFloat alpha = (ICON_Height + scrollView.contentOffset.y)/(ICON_Height - 64);
    bgView.alpha=alpha;
}

#pragma mark - HB_ContactDetailPhoneCellDelegate
-(void)contactDetailPhoneCellBeginInsert:(HB_ContactDetailPhoneCell *)cell{
    //获取开始编辑的cell的indexPath
    NSIndexPath * indexPath=[_tableView indexPathForCell:cell];
    //获取该分组一共有几行cell
    NSInteger numberOfRows=[_tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == numberOfRows-1) {//判断是否是最后一行，只有最后一行点击才添加
        //1.得到需要插入位置的indexPath
        NSIndexPath * finalIndexPath=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        
        //3.判断添加的是电话还是邮箱
        if (finalIndexPath.section==1) {//电话号码分组
            [self.store loadMorePhoneCell];
            
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[finalIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [_tableView endUpdates];
        }else if (finalIndexPath.section==2){//邮箱分组
            [self.store loadMoreEmailCell];
            
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[finalIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [_tableView endUpdates];
        }
    }
}

-(void)contactDetailPhoneCellBeginClear:(HB_ContactDetailPhoneCell *)cell{
    NSIndexPath * indexPath=[_tableView indexPathForCell:cell];
    //1.获取该组所有数据源
    NSMutableArray * groupArr=self.store.itemsArr[indexPath.section];
    //2.如果存在下一个cell的话，然后判断这个cell是不是空的，如果是空的，就删除
       if (indexPath.row < (groupArr.count-1)) {
        NSIndexPath * nextIndexPath=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        HB_ContactDetailPhoneCell * cell=(HB_ContactDetailPhoneCell*)[_tableView cellForRowAtIndexPath:nextIndexPath];
//        if (cell.textField.text.length==0) {
            if (indexPath.section==1) {//电话号码
//                BOOL ret = indexPath.row == (groupArr.count-1);
//                if (ret) {
//                    //不作操作，不删除
//                }else{
                

                    
                    [self.store.listModel.phoneArr removeObjectAtIndex:indexPath.row];
                
                    
//                }
            }else if(indexPath.section==2){//邮箱
                BOOL ret = indexPath.row == (groupArr.count-1);
                if (ret) {
                    //不作操作，不删除
                }else{

                    [self.store.listModel.eMailArr removeObjectAtIndex:indexPath.row];
                }
            }
           
            [_tableView beginUpdates];
            [groupArr removeObjectAtIndex:indexPath.row];
//            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
           
           [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [_tableView endUpdates];

    }
}
-(void)contactDetailPhoneCell:(HB_ContactDetailPhoneCell *)cell didEndEditingWithText:(NSString *)text{
    NSIndexPath * indexPath =[_tableView indexPathForCell:cell];
    if (indexPath.section==1) {//电话号码
        if (text.length) {//有电话号码的状态
            //1.取出该分组的数据源
            NSMutableArray * groupArr=self.store.itemsArr[indexPath.section];
            //2.取出该cell对应的model
            HB_ContactDetailPhoneCellModel * phoneCellModel=groupArr[indexPath.row];
            //3.给电话号码模型重新赋值
            phoneCellModel.phoneModel.phoneNum=text;
        }
    }else if (indexPath.section==2){//邮箱
        if (text.length) {//有邮箱地址的状态
            //1.取出该分组的数据源
            NSMutableArray * groupArr=self.store.itemsArr[indexPath.section];
            //2.取出该cell对应的model
            HB_ContactDetailPhoneCellModel * phoneCellModel=groupArr[indexPath.row];
            //3.给邮箱模型重新赋值
            phoneCellModel.emailModel.emailAddress=text;
        }
    }
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
    HB_ContactDetailPhoneCellModel *model = self.store.itemsArr[indexPath.section][indexPath.row];
    if (indexPath.section==1) {//电话
        //如果就剩一个电话了，就不允许删除了
        if (self.store.listModel.phoneArr.count == 1) {
            return;
        }

        [self.store.listModel.phoneArr removeObject:model.phoneModel];
        [self.store.itemsArr[indexPath.section] removeObject:model];
    }else if (indexPath.section==2){//邮箱
        //如果就剩一个邮箱了，就不允许删除了
        if (self.store.listModel.eMailArr.count == 1) {
            return;
        }

        [self.store.listModel.eMailArr removeObject:model.emailModel];
        [self.store.itemsArr[indexPath.section] removeObject:model];
    }
    
    [_tableView beginUpdates];
//    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
     [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    
    [_tableView endUpdates];
}
/**
 *  cell右侧类型选择按钮的点击(常用电话、常用邮箱之类的。。)
 */
-(void)contactDetailPhoneCell:(HB_ContactDetailPhoneCell *)cell typeChooseBtnClick:(UIButton *)chooseBtn{
    [self.view endEditing:YES];
    
    HB_ContactDetailPhoneEmailTypeManageVC * typeManageVC=[[HB_ContactDetailPhoneEmailTypeManageVC alloc]init];
    //1.传入cell的模型
    typeManageVC.phoneCellModel=cell.model;
    //2.传入剩余的标签数组_phoneTypeArr/_emailTypeArr
    
    
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
#pragma mark - event response
/**
 *  ‘完成’按钮点击
 */
-(void)finishBtnClick:(UIButton *)btn{
    
    //页面停止编辑
    [self.view endEditing:YES];
    //把listModel转换为HB_ContactModel;
    if (!self.contactModel) {
        self.contactModel = [[HB_ContactModel alloc] init];
    }
    [HB_ConvertContactModelAndListModel convertListModel:self.store.listModel toContactModel:self.contactModel];
    //保存联系人
    NSInteger NewContactId = [HB_ContactDataTool contactAddPeopleByModel:self.contactModel];
    [self.contactModel release];
    if (NewContactId>0) {
        [self dismissThisViewController];
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(ContactDetailController:SavedContact:)]) {
                 [self.delegate ContactDetailController:self SavedContact:NewContactId];
            }
//           
//            //刷新拨号界面所用数据
//            
//            HBZSAppDelegate * delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
//            [delegate initSearchContactData];
//
            //处理新建联系人组信息
            for (HB_GroupModel * model in self.NewContactGroupArr) {
                [GroupData addPerson:NewContactId toGroup:model.groupID];
            }

        }
    }else{
        [SVProgressHUD show];
        [SVProgressHUD dismiss];
    }
}
/**
 *  '更多资料'按钮click
 */
-(void)moreInformationBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if (btn.selected) {
        [_tableView beginUpdates];
        [self.store addDataGroup5];
        NSIndexSet * set=[NSIndexSet indexSetWithIndex:self.store.itemsArr.count-1];
        [_tableView insertSections:set withRowAnimation:UITableViewRowAnimationTop];
        [_tableView endUpdates];
    }else{
        [_tableView beginUpdates];
        [self.store.itemsArr removeLastObject];
        NSIndexSet * set=[NSIndexSet indexSetWithIndex:self.store.itemsArr.count];
        [_tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
    }
}
/**
 *  键盘的frameChanged事件
 */
-(void)keyboardFrameChanged:(NSNotification * )notification{
    NSDictionary * userInfo=notification.userInfo;
    CGFloat timeInterval=[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyBoardEndFrame.origin.y==SCREEN_HEIGHT) {//键盘收起
        [UIView animateWithDuration:timeInterval animations:^{
            UIEdgeInsets insets = self.tableView.contentInset;
            self.tableView.contentInset = UIEdgeInsetsMake(insets.top,
                                                           insets.left,
                                                           0,
                                                           insets.right);
        }];
    }else{//键盘弹出
        [UIView animateWithDuration:timeInterval animations:^{
            UIEdgeInsets insets = self.tableView.contentInset;
            self.tableView.contentInset = UIEdgeInsetsMake(insets.top,
                                                           insets.left,
                                                           SCREEN_HEIGHT-keyBoardEndFrame.origin.y,
                                                           insets.right);
        }];
        
        /*
         *键盘弹出，则表示，有cell进入编辑状态，不管是不是HB_ContactDetailPhoneCell类型，
         *都要保证，所有的HB_ContactDetailPhoneCell类型的cell都处于恢复原样的状态
         */
         [self recoverAllVisiblePhoneOrEmailCells];
    }
}

#pragma mark - setter and getter

-(UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.frame = CGRectMake(0, 0, 60, 20);
        _finishBtn.exclusiveTouch = YES;
        _finishBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_finishBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        _finishBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}
-(UIBarButtonItem *)finishBtnItem{
    if (!_finishBtnItem) {
        _finishBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.finishBtn];
    }
    return _finishBtnItem;
}
-(HB_HeaderIconView *)iconHeaderView{
    if (!_iconHeaderView) {
        CGRect headerIconViewFrame = CGRectMake(0, -ICON_Height, SCREEN_WIDTH, ICON_Height);
        _iconHeaderView=[[HB_HeaderIconView alloc]initWithFrame:headerIconViewFrame];
        _iconHeaderView.delegate = self;
        _iconHeaderView.contactModel = self.contactModel;
        if (self.Cardindex>0) {
            _iconHeaderView.bgimageindex = self.Cardindex-1;
        }
        else
        {
            _iconHeaderView.bgimageindex = arc4random()%10;
        }
    }
    return _iconHeaderView;
}
-(UITableView *)tableView{
    if (!_tableView) {
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
        _tableView.dataSource = self;
        _tableView.rowHeight=60;
        _tableView.contentInset=UIEdgeInsetsMake(ICON_Height, 0, 0, 0);
        //暂时不知道怎么隐藏掉tableHeaderView，以后再说
        UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
        _tableView.tableHeaderView=headerView;
        [headerView release];
        //底部视图
        self.moreInformationBtn.frame=CGRectMake(0, 0, tableView_W, 60);
        self.tableView.tableFooterView = self.moreInformationBtn;
        //头像
        [self.tableView addSubview:self.iconHeaderView];
    }
    return _tableView;
}
-(UIButton *)moreInformationBtn{
    if (!_moreInformationBtn) {
        _moreInformationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreInformationBtn setTitleColor:COLOR_A forState:UIControlStateNormal];
        _moreInformationBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_moreInformationBtn setTitle:@"添加更多资料" forState:UIControlStateNormal];
        [_moreInformationBtn setTitle:@"收起更多资料" forState:UIControlStateSelected];
        [_moreInformationBtn addTarget:self action:@selector(moreInformationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreInformationBtn;
}
-(HB_ContactEditStore *)store{
    if (!_store) {
        _store = [[HB_ContactEditStore alloc]init];
        _store.phoneNumFromCallHistory = self.phoneNumFromCallHistory;
        _store.contactModel = self.contactModel;
        
    }
    return _store;
}

#pragma mark 分组选择代理方法
-(void)GroupIdsforNewContact:(NSArray *)groupmodels
{
    NSMutableString * groupString = [NSMutableString stringWithCapacity:0];
    for (HB_GroupModel * model in groupmodels) {
        [groupString appendFormat:@"%@,",model.groupName];
    }
    self.store.listModel.groupsName = groupString;
    self.NewContactGroupArr = groupmodels;
    [self.tableView reloadData];
}
@end
