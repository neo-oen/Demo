//
//  HB_ContactInfoVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//
#define Padding     15


#import <MessageUI/MessageUI.h>

#import "HB_ContactInfoVC.h"
#import "HB_shareByQrcodeController.h"//联系人二维码分享
#import "HB_ContactModel.h"//联系人model
#import "HB_ContactDetailListModel.h"//联系人所有属性的列表model
#import "HB_PhoneNumModel.h"//电话模型
#import "HB_EmailModel.h"//邮箱模型
#import "HB_ContactSendTopTool.h"
#import "HB_ContactDataTool.h"
#import "HB_ContactDetailController.h"
#import "HB_ContactInfoDialItemModel.h"//详情页的通话记录模型
#import "HB_ContactInfoDialItemTool.h"//把系统的通话记录模型转变成详情页需要的模型
//4种model
#import "HB_ContactInfoCellModel.h"
#import "HB_ContactInfoPhoneCellModel.h"
#import "HB_ContactInfoEmailCellModel.h"
#import "HB_ContactInfoCallHistoryCellModel.h"
//4种cell
#import "HB_ContactInfoCell.h"
#import "HB_ContactInfoPhoneCell.h"
#import "HB_ContactInfoEmailCell.h"
#import "HB_ContactInfoCallHistoryCell.h"

#import "UMSocial.h"//友盟

#import "SettingInfo.h"

#import "HB_ConvertPhoneNumArrTool.h"
#import "HB_ConvertEmailArrTool.h"

#import "GetContactAdProto.pb.h"

#import "UIImageView+WebCache.h"
#import "HB_WebviewCtr.h"
#import "HBZSAppDelegate.h"

#import "HB_CallSettingVC.h"

#define ActSheet_IPDial 100
#define ActSheet_Share 101
@interface HB_ContactInfoVC ()< UITableViewDelegate,
                                UITableViewDataSource,
                                HB_ContactInfoMoreViewDelegate,
                                HB_ContactInfoEmailCellDelegate,
                                HB_ContactInfoPhoneCellDelegate,UIActionSheetDelegate,HB_HeaderIconViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>

/** 通话记录按钮 */
@property (nonatomic,retain) UIButton        *callHistoryBtn;
/** navigationBar 右侧“编辑”BarButtonItem */
@property (nonatomic,retain) UIBarButtonItem *editBtnItem_nav;
/** navigationBar 右侧“编辑”btn */
@property (nonatomic,retain) UIButton        *editBtn_nav;

/** navigationBar 右侧“更多”BarButtonItem */
@property (nonatomic,retain) UIBarButtonItem *moreBtnItem_nav;
/** navigationBar 右侧“更多”btn */
@property (nonatomic,retain) UIButton        *moreBtn_nav;
/** rightBarButtonItems 数组 */
@property (nonatomic,retain) NSMutableArray  *rightBarButtonItemsArr;

/** navigationBar 右侧“分享” button*/
@property(nonatomic,retain) UIButton * shareBtn_nav;
/** navigationBar 右侧“分享” item */
@property(nonatomic,retain) UIBarButtonItem * shareBtnItem_nav;

@end

@implementation HB_ContactInfoVC

#pragma mark - life cycle
-(void)dealloc{
    [_tableView release];
    [_editBtnItem_nav release];
    [_moreBtnItem_nav release];
    [_rightBarButtonItemsArr release];
    [_moreView release];
    [_contactModel release];
    [_store release];
//    [_headerIconView release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏底部细线隐藏
    UIImage *blankImage = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = blankImage;
    [blankImage release];
    
    self.title=@"详情";
    [self hiddenTabBar];
    self.navigationItem.rightBarButtonItems = self.rightBarButtonItemsArr;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.moreView];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果tableView没有偏移，则导航栏应该是透明的
    UIView *bgView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    bgView.alpha=(_tableView.contentOffset.y + ICON_Height)/(ICON_Height-64);
    //初始化数据源
//    if (_recordID) {
//        NSDictionary *dict = [HB_ContactDataTool contactPropertyArrWithRecordID:_recordID];
//        [self.contactModel setValuesForKeysWithDictionary:dict];
//
//    }
    self.store.contactModel = self.contactModel;
    self.headerIconView.contactModel = self.contactModel;
    self.headerIconView.bgimageindex = arc4random()%10;
    //刷新视图
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self computeIconFrameAndNavigationBarFrameWithScrollView:self.tableView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView *bgView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    bgView.alpha=1;
    
}
#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.store.dataArr[indexPath.section][indexPath.row];
    if ([model isKindOfClass:[HB_ContactInfoCellModel class]]) {
        //1.如果是普通的模型
        HB_ContactInfoCell * cell = [HB_ContactInfoCell cellWithTableView:tableView];
        cell.model=(HB_ContactInfoCellModel *)model;
        return cell;
    }else if ([model isKindOfClass:[HB_ContactInfoPhoneCellModel class]]){
        //2.如果是“电话号码”模型
        HB_ContactInfoPhoneCell * cell=[HB_ContactInfoPhoneCell cellWithTableView:tableView];
        NSLog(@"%ld",indexPath.section);
        cell.model=(HB_ContactInfoPhoneCellModel *)model;
        cell.delegate=self;
        return cell;
    }else if ([model isKindOfClass:[HB_ContactInfoEmailCellModel class]]){
        //3.如果是“邮箱”模型
        HB_ContactInfoEmailCell * cell=[HB_ContactInfoEmailCell cellWithTableView:tableView];
        cell.model=(HB_ContactInfoEmailCellModel *)model;
        cell.delegate=self;
        return cell;
    }else if ([model isKindOfClass:[HB_ContactInfoCallHistoryCellModel class]]){
        //4.如果是“通话记录”模型
        HB_ContactInfoCallHistoryCell * cell=[HB_ContactInfoCallHistoryCell cellWithTableView:tableView];
        cell.model=(HB_ContactInfoCallHistoryCellModel *)model;
        return cell;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.store.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.store.dataArr[section] count];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * view=[[UIView alloc]init];
//    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
//    if (section==1 || section==2) {
//        UILabel * label=[[[UILabel alloc]init]autorelease];
//        label.backgroundColor=COLOR_H;
//        label.frame=CGRectMake(15, -0.5, 15+20, 0.5);
//        [view addSubview:label];
//    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1 || section==2) {
        return 0.5;
    }
    return 0.0000000001;
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self computeIconFrameAndNavigationBarFrameWithScrollView:scrollView];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hiddenRightView];
}
#pragma mark - HB_ContactInfoMoreViewDelegate
/**  分享联系人 */
-(void)contactInfoMoreView:(HB_ContactInfoMoreView *)moreView didShareContactWithIndexPath:(NSIndexPath *)indexPath{
    
    
    
    [self hiddenRightView];
}
/**  置顶联系人 */
-(void)contactInfoMoreView:(HB_ContactInfoMoreView *)moreView sendTopContactWithIndexPath:(NSIndexPath *)indexPath{
    
    //1.先判断当前是否置顶，如果已经置顶，就取消；如果未置顶，则置顶
    BOOL isTop = [HB_ContactSendTopTool contactIsSendTopWithRecordID:_recordID];
    if (isTop) {
        //取消置顶
        [HB_ContactSendTopTool contactCancelBackWithRecordID:self.recordID];
    }else{
        //置顶
        [HB_ContactSendTopTool contactSendTopWithRecordID:self.recordID];
    }
    [moreView moreViewBackClick:indexPath];
    
    [self hiddenRightView];
}
/**  IP通话 */
-(void)contactInfoMoreView:(HB_ContactInfoMoreView *)moreView IPCallWithIndexPath:(NSIndexPath *)indexPath{
    [self hiddenRightView];
    if ([SettingInfo getIPDialNumber].length<1) {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没设置IP前缀，请前往设置里添加。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"立即设置",nil];
        [al show];
        return;
    }
    NSArray * arr = [self.store.dataArr objectAtIndex:1];//1为联系人模型
    if (arr.count>1) {
        NSLog(@"%ld",[[self.store.dataArr objectAtIndex:1] count]);
        UIActionSheet * sheet = [[UIActionSheet alloc ]initWithTitle:@"选择号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
        sheet.tag = ActSheet_IPDial;
        for (HB_ContactInfoPhoneCellModel * model in arr) {
            [sheet addButtonWithTitle:model.phoneModel.phoneNum];
        }
        [sheet showInView:self.view];
        [sheet release];
        
    }
    else if(arr.count == 1)
    {
        HB_ContactInfoPhoneCellModel * model = [arr firstObject];
        [self IPdial:model];
    }
}
/**  删除联系人 */
-(void)contactInfoMoreView:(HB_ContactInfoMoreView *)moreView deleteContactWithIndexPath:(NSIndexPath *)indexPath{
    [self hiddenRightView];
    
    [HB_ContactDataTool contactDeleteContactByID:self.recordID];
    
     
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - HB_ContactInfoPhoneCellDelegate
/**
 *  拨打电话
 */
-(void)contactInfoPhoneCellDidPhoneCall:(HB_ContactInfoPhoneCell *)phoneCell{
    //全局的拨号的方法
    [self dialPhone:phoneCell.model.phoneModel.phoneNum contactID:self.contactModel.contactID.integerValue Called:nil];
}
/**
 *  发送短信
 */
-(void)contactInfoPhoneCellDidSendMessage:(HB_ContactInfoPhoneCell *)phoneCell{
    //全局的发送短信的方法
    [self doSendMessage:@[phoneCell.model.phoneModel.phoneNum]];
}
#pragma mark - HB_ContactInfoEmailCellDelegate
/**
 *  发送邮件
 */
-(void)contactInfoEmailCellDidSendEmail:(HB_ContactInfoEmailCell *)emailCell{
    //全局发送邮件的方法
    [self sendEmailWithEmailArr:@[emailCell.model.emailModel.emailAddress]];
}

#pragma mark - event response
-(void)navigationBarButtonClick:(UIButton *)btn{
    if (btn==self.editBtn_nav) {
        HB_ContactDetailController * editController=[[HB_ContactDetailController alloc]init];
        editController.contactModel = self.contactModel;
        editController.title=@"编辑联系人";
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:editController];
        [self presentViewController:nav animated:YES completion:nil];
        [editController release];
        [nav release];
        [self hiddenRightView];
    }
    else if (btn==self.moreBtn_nav)
    {
        btn.selected=!btn.selected;
        if (btn.selected) {
            self.moreView.clipsToBounds=NO;
            CGFloat rightView_W=120;
            CGFloat rightView_H=170;
            CGFloat rightView_X=self.view.bounds.size.width-Padding-rightView_W;
            CGFloat rightView_Y=0;
            self.moreView.frame=CGRectMake(rightView_X, rightView_Y, rightView_W, rightView_H);
        }else{
            self.moreView.clipsToBounds=YES;
            self.moreView.frame=CGRectZero;
        }
    }
    else if (btn == self.shareBtn_nav)
    {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择分享方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"二维码分享",@"短信分享", nil];
        sheet.tag = ActSheet_Share;
        [sheet showInView:self.view];
        [sheet release];
    }
}
-(void)callHistoryBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    //1.重新加载第5组通话记录数据
    if (btn.selected) {
        [self.store addAllDataInGroup5];
    }else{
        [self.store addHalfDataInGroup5];
    }
    //2.刷新数据
    [self.tableView reloadData];
}
#pragma mark - private methods
/**
 *  隐藏右侧视图
 */
-(void)hiddenRightView{
    self.moreBtn_nav.selected=NO;
    self.moreView.frame=CGRectZero;
    self.moreView.clipsToBounds=YES;
}
/**
 *  根据scrollview的偏移量 来计算头像的放大缩小，以及导航栏的渐变
 */
-(void)computeIconFrameAndNavigationBarFrameWithScrollView:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y < (-ICON_Height)) {
//        CGRect frame=self.headerIconView.frame;
//        //计算出比例，便于下方计算icon放大的倍数
//        float a = -scrollView.contentOffset.y/frame.size.height;
//        CGFloat iconImageView_W = frame.size.width * a;
//        CGFloat iconImageView_H = frame.size.height * a;
//        CGFloat iconImageView_X = -(frame.size.width * a - SCREEN_WIDTH)*0.5;
//        CGFloat iconImageView_Y = scrollView.contentOffset.y;
//        self.headerIconView.frame=CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);
//    }
    UIView *bgView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    bgView.alpha = (ICON_Height + scrollView.contentOffset.y)/(ICON_Height - 64);
}

#pragma mark - setter and getter
/**
 *  导航栏右侧‘编辑’item
 */
-(UIBarButtonItem *)editBtnItem_nav{
    if (!_editBtnItem_nav) {
        _editBtnItem_nav = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn_nav];
    }
    return _editBtnItem_nav;
}
/**
 *  导航栏右侧‘编辑’btn
 */
-(UIButton *)editBtn_nav{
    if (!_editBtn_nav) {
        _editBtn_nav = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn_nav setFrame:CGRectMake(0, 0, 20, 20)];
        _editBtn_nav.exclusiveTouch = YES;
        [_editBtn_nav setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        [_editBtn_nav addTarget:self action:@selector(navigationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn_nav;
}
/**
 *  导航栏右侧‘更多’item
 */
-(UIBarButtonItem *)moreBtnItem_nav{
    if (!_moreBtnItem_nav) {
        _moreBtnItem_nav = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn_nav];
    }
    return _moreBtnItem_nav;
}
/**
 *  导航栏右侧‘更多’btn
 */
-(UIButton *)moreBtn_nav{
    if (!_moreBtn_nav) {
        _moreBtn_nav = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn_nav setFrame:CGRectMake(0, 0, 20, 20)];
        _moreBtn_nav.exclusiveTouch = YES;
        [_moreBtn_nav setImage:[UIImage imageNamed:@"更多_header"] forState:UIControlStateNormal];
        [_moreBtn_nav addTarget:self action:@selector(navigationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn_nav;
}

/**
 *  导航栏右侧‘分享’item
 */
-(UIBarButtonItem *)shareBtnItem_nav{
    if (!_shareBtnItem_nav) {
        _shareBtnItem_nav = [[UIBarButtonItem alloc] initWithCustomView:self.shareBtn_nav];
    }
    return _shareBtnItem_nav;
}
/**
 *  导航栏右侧‘分享’btn
 */
-(UIButton *)shareBtn_nav{
    if (!_shareBtn_nav) {
        _shareBtn_nav = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn_nav setFrame:CGRectMake(0, 0, 20, 20)];
        _shareBtn_nav.exclusiveTouch = YES;
        [_shareBtn_nav setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_shareBtn_nav addTarget:self action:@selector(navigationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn_nav;
}


/**
 *  一个空白的、用于调整间距的item
 */
-(UIBarButtonItem *)blankBtnItem_nav{
    UIBarButtonItem * _blankBtnItem_nav=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil] autorelease];
    _blankBtnItem_nav.width=12;
    return _blankBtnItem_nav;
}
/**
 *  导航栏右侧的rightBarButtonItems 数组
 */
-(NSArray *)rightBarButtonItemsArr{
    if (!_rightBarButtonItemsArr) {
        _rightBarButtonItemsArr=[[NSMutableArray alloc]init];
        /*
         * 1.'编辑'item
         * 2.为了间隔，添加一个空白item
         * 3.‘更多’item
         */
        [_rightBarButtonItemsArr addObjectsFromArray:@[self.moreBtnItem_nav,[self blankBtnItem_nav],self.shareBtnItem_nav,[self blankBtnItem_nav],self.editBtnItem_nav]];
    }
    return _rightBarButtonItemsArr;
}
-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat tableView_W=SCREEN_WIDTH;
        CGFloat tableView_H=SCREEN_HEIGHT;
        CGFloat tableView_X=0;
        CGFloat tableView_Y=-64;
        CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
        _tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeInteractive;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=COLOR_I;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight=60;
        _tableView.contentInset = UIEdgeInsetsMake(ICON_Height, 0, 0, 0);
        _tableView.tableFooterView = self.callHistoryBtn;
        //隐藏headerView
        UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
        _tableView.tableHeaderView=headerView;
        [headerView release];
        //头像
        [_tableView addSubview:self.headerIconView];
    }
    return _tableView;
}
-(UIButton *)callHistoryBtn{
    if (!_callHistoryBtn) {
        _callHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _callHistoryBtn.frame=CGRectMake(0, 0, SCREEN_WIDTH, 60);
        [_callHistoryBtn setTitleColor:COLOR_A forState:UIControlStateNormal];
        _callHistoryBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_callHistoryBtn setTitle:@"查看通话记录" forState:UIControlStateNormal];
        [_callHistoryBtn setTitle:@"收起通话记录" forState:UIControlStateSelected];
        [_callHistoryBtn addTarget:self
                            action:@selector(callHistoryBtnClick:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _callHistoryBtn;
}
-(HB_HeaderIconView *)headerIconView{
    if (!_headerIconView) {
        CGRect frame = CGRectMake(0, -ICON_Height, SCREEN_WIDTH, ICON_Height);
        _headerIconView = [[HB_HeaderIconView alloc]initWithFrame:frame];
        _headerIconView.delegate = self;
        _headerIconView.editIconBtn.hidden = YES;
    }
    return _headerIconView;
}
-(HB_ContactInfoMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[HB_ContactInfoMoreView alloc]init];
        _moreView.recordID=_recordID;
        _moreView.delegate=self;
        _moreView.clipsToBounds=YES;//保证一开始隐藏起来
    }
    return _moreView;
}
-(HB_ContactInfoStore *)store{
    if (!_store) {
        _store = [[HB_ContactInfoStore alloc]init];
        _store.contactModel = self.contactModel;
    }
    return _store;
}
-(HB_ContactModel *)contactModel{
    if (!_contactModel) {
        _contactModel=[[HB_ContactModel alloc]init];
        NSDictionary * dict = [HB_ContactDataTool contactPropertyArrWithRecordID:_recordID];
        [_contactModel setValuesForKeysWithDictionary:dict];
    }
    return _contactModel;
}


#pragma mark actionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ActSheet_IPDial) {
        HB_ContactInfoPhoneCellModel * model = self.store.dataArr[1][buttonIndex-1];
        [self IPdial:model];
    }
    else if (actionSheet.tag == ActSheet_Share)
    {
        switch (buttonIndex) {
            case 0:
            {
                HB_shareByQrcodeController * vc = [[HB_shareByQrcodeController alloc] initWithContactModel:self.contactModel];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
                break;
            case 1:
            {
                //需要分享的内容
                NSMutableString * contentStr=[[NSMutableString alloc]init];
                //1.name
                [contentStr appendFormat:@"姓名：%@\n",[HB_ContactDataTool contactGetFullNameWithModel:self.contactModel]];
                //2.电话
                NSMutableString * phoneStr = [[NSMutableString alloc]init];
                for (int i=0; i<self.contactModel.phoneArr.count; i++) {
                    HB_PhoneNumModel *model = self.contactModel.phoneArr[i];
                    if (model.phoneNum.length) {
                        [phoneStr appendFormat:@"%@:%@\n",[HB_ConvertPhoneNumArrTool convertPhoneTypePhoneSystemToHBZS:model.phoneType],model.phoneNum];
                    }
                }
                [contentStr appendFormat:@"\n%@",phoneStr];
                [phoneStr release];
                //3.邮箱
                NSMutableString * emailStr=[[NSMutableString alloc]init];
                for (int i=0; i<self.contactModel.emailArr.count; i++) {
                    HB_EmailModel *model = self.contactModel.emailArr[i];
                    if (model.emailAddress.length) {
                        [emailStr appendFormat:@"%@:%@\n",[HB_ConvertEmailArrTool convertEmailTypeSystemToHBZS:model.emailType],model.emailAddress];
                    }
                }
                [contentStr appendFormat:@"\n%@",emailStr];
                [emailStr release];
                
                [self shareContactByMessage:contentStr];
                
                [contentStr release];
            }
                break;
                
            default:
                break;
        }
    }
    
    
}

#pragma mark alertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            HB_CallSettingVC * vc = [[HB_CallSettingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
            
        default:
            break;
    }
}


-(void)IPdial:(HB_ContactInfoPhoneCellModel *)model
{
    NSString * str = [NSString stringWithFormat:@"%@%@",[SettingInfo getIPDialNumber],model.phoneModel.phoneNum];
    [self dialPhone:str contactID:self.recordID Called:nil];
}

-(void)headerIconViewbInfoBtnClick:(HB_HeaderIconView *)headerview
{
//    ConfigMgr * mgr = ;
    GetContactAdResponse * LocalContactAd = [GetContactAdResponse parseFromData:[[ConfigMgr getInstance] getValueForKey:@"ContactAdResponsedata" forDomain:nil]];
    HB_WebviewCtr * web = [[HB_WebviewCtr alloc] init];
    web.titleName = [NSString stringWithFormat:@"详情"];
    web.url = [NSURL URLWithString:LocalContactAd.contactAd.adurl];
    [self.navigationController pushViewController:web animated:YES];
    [web release];
}


-(void)shareContactByMessage:(NSString *)infoString
{
    if([SYSTEMVERSION floatValue]<8)
    {
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (messageClass != nil) {
            if ([messageClass canSendText]) {
                if (kSystemVersion >= 7.0) {
                    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
                }
                MFMessageComposeViewController *view = [[MFMessageComposeViewController alloc]init];
                view.navigationBar.tintColor = [UIColor whiteColor];
                view.messageComposeDelegate = self;
                view.body = infoString;

                [self presentViewController:view animated:YES completion:NULL];
                [view release];
            }
        }

    }
    else
    {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:infoString image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                ZBLog(@"分享成功！");
            }
        }];
    }
}

@end
