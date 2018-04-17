//
//  HB_MaCardInfoVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/3/2.
//
//

#import "HB_MaCardInfoVc.h"

#define Padding     15
//#define ICON_Height 200.0

#import "HB_ContactInfoVC.h"
#import "HB_ContactModel.h"//联系人model
#import "HB_ContactDetailListModel.h"//联系人所有属性的列表model
#import "HB_PhoneNumModel.h"//电话模型
#import "HB_EmailModel.h"//邮箱模型
#import "HB_ContactSendTopTool.h"
#import "HB_ContactDataTool.h"
#import "HB_ContactDetailController.h"
#import "HB_ContactMyCardVC.h" //名片编辑

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

#import "HB_ShareByQRcodeMoreView.h"

#import "HB_MyCardQRCodeVc.h"


#import "HB_httpRequestNew.h"
#import "MainViewCtrl.h"

#import "HB_WebviewCtr.h"
#import "HB_MyCardCloudVc.h"
#import "SVProgressHUD.h"
#import "ContactProtoToContactModel.h"
#import "HB_editMyCardVc.h"
@interface HB_MaCardInfoVc ()<shareByQRcodeMoreViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

///** navigationBar 右侧“更多”btn */
//@property (nonatomic,retain) UIButton        *moreBtn_nav;
/** 通话记录按钮 */
@property (nonatomic,retain) UIButton        *callHistoryBtn;
/** navigationBar 右侧“编辑”BarButtonItem */
@property (nonatomic,retain) UIBarButtonItem *editBtnItem_nav;
/** navigationBar 右侧“编辑”btn */
@property (nonatomic,retain) UIButton        *editBtn_nav;
/** navigationBar 右侧空白的BarButtonItem(用于调整间距) */
@property (nonatomic,retain) UIBarButtonItem *blankBtnItem_nav;
/** navigationBar 右侧“更多”BarButtonItem */
@property (nonatomic,retain) UIBarButtonItem *moreBtnItem_nav;
/** navigationBar 右侧“更多”btn */
@property (nonatomic,retain) UIButton        *moreBtn_nav;

/** navigationBar 右侧“云”btn */
@property (nonatomic,retain) UIButton        *ClouddBtn_nav;

/** rightBarButtonItems 数组 */
@property (nonatomic,retain) NSMutableArray  *rightBarButtonItemsArr;

@property (nonatomic,retain) HB_ShareByQRcodeMoreView * shareMoreView;


@property (nonatomic,retain)HB_httpRequestNew * req;

@property (nonatomic,assign)BOOL isVisible;


@end

@implementation HB_MaCardInfoVc

-(void)dealloc
{
    [_req release];
    [_shareMoreView release];
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的名片";
    
    [self.view addSubview:self.shareMoreView];

}
-(void)viewWillAppear:(BOOL)animated
{
    Contact * MeContact = [[MemAddressBook getInstance] myCard];
    self.contactModel = [[ContactProtoToContactModel shareManager] memMycardToContactModel:MeContact];
    [super viewWillAppear:animated];
    self.isVisible = YES;
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isVisible = NO;

    self.shareMoreView.hidden = YES;
    [SVProgressHUD popActivity];
    [self.req stopcurrentRequest];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


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
        [_rightBarButtonItemsArr addObjectsFromArray:@[[self cloudMyCardBarButtonItem],self.blankBtnItem_nav,self.moreBtnItem_nav,self.blankBtnItem_nav,self.editBtnItem_nav]];
    }
    return _rightBarButtonItemsArr;
}

/**
 *  一个空白的、用于调整间距的item
 */
-(UIBarButtonItem *)blankBtnItem_nav{
//    if (!_blankBtnItem_nav) {
       UIBarButtonItem *  blank_nav=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil] autorelease];
        blank_nav.width=20;
//    }
    return blank_nav;
}


-(UIBarButtonItem *)cloudMyCardBarButtonItem
{
    _ClouddBtn_nav = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ClouddBtn_nav setFrame:CGRectMake(0, 0, 20, 20)];
    _ClouddBtn_nav.exclusiveTouch = YES;
    [_ClouddBtn_nav setImage:[UIImage imageNamed:@"heard_cloud"] forState:UIControlStateNormal];
    [_ClouddBtn_nav addTarget:self action:@selector(navigationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item = [[[UIBarButtonItem alloc] initWithCustomView:_ClouddBtn_nav] autorelease];
    
    return item;
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
 *  导航栏右侧‘分享‘btn
 */
-(UIButton *)moreBtn_nav{
    NSLog(@"==========");
    if (!_moreBtn_nav) {
        _moreBtn_nav = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn_nav setFrame:CGRectMake(0, 0, 20, 20)];
        _moreBtn_nav.exclusiveTouch = YES;
        [_moreBtn_nav setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_moreBtn_nav addTarget:self action:@selector(navigationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn_nav;
}

-(HB_ShareByQRcodeMoreView *)shareMoreView
{
    if (!_shareMoreView) {
        NSArray * arr = @[@"二维码分享",@"短信分享"];
        _shareMoreView = [[HB_ShareByQRcodeMoreView alloc] initWithNames:arr andStyle:More_View_Style_Middel];
        _shareMoreView.delegate = self;
        
    }
    return _shareMoreView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navigationBarButtonClick:(UIButton *)btn{
    if (btn==self.editBtn_nav) {
//        HB_ContactMyCardVC * CardeditController=[[HB_ContactMyCardVC alloc]init];
        HB_editMyCardVc * CardeditController = [[HB_editMyCardVc alloc] init];
        CardeditController.contactModel = self.contactModel;
        CardeditController.title=@"编辑联系人";
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:CardeditController];
        [self presentViewController:nav animated:YES completion:nil];
        [CardeditController release];
        [nav release];
    }else if (btn==self.moreBtn_nav){
        self.shareMoreView.hidden = !self.shareMoreView.hidden;
    }
    else//云名片
    {
        self.shareMoreView.hidden = YES;
        if (![[MainViewCtrl shareManager] isAccount:self]) {
            return;
        }
        
        self.req = [[HB_httpRequestNew alloc] init] ;
        
        [self setCloudEnableUser:NO];
        [self.req isOpenMyCardShareResult:^(BOOL isSuccess, NSInteger isOpenMycard) {
            if (!_isVisible) {
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setCloudEnableUser:YES];
                
                if (!isSuccess) {
                    UIAlertView * al =  [[UIAlertView alloc] initWithTitle:nil message:@"请求失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [al show];
                    [al release];
                    return ;
                }
                if (isOpenMycard) {
                    NSLog(@"云端已创建过云名片");
                    UIActionSheet * sheet  = [[UIActionSheet alloc] initWithTitle:@"云名片操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看云名片",@"删除云名片", nil];
                    
                    [sheet showInView:self.view];
                    [sheet release];
                }
                else
                {
                    NSLog(@"没创建过云名片");
                    
                    UIAlertView * al =  [[UIAlertView alloc] initWithTitle:@"创建云名片" message:@"云名片可方便您与其他人交换个人名片信息，创建后其他人可以通过网络查询到您的云名片。您也可以通过微信、QQ等工具将云名片发给你的好友。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"创建", nil];
                    al.tag = 101;
                    [al show];
                    [al release];
                    
                }
            });
            
        }];
    
    }
}

-(void)ShareMyCard
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
    [contentStr appendFormat:@"%@",phoneStr];
    [phoneStr release];
    //3.邮箱
    NSMutableString * emailStr=[[NSMutableString alloc]init];
    for (int i=0; i<self.contactModel.emailArr.count; i++) {
        HB_EmailModel *model = self.contactModel.emailArr[i];
        if (model.emailAddress.length) {
            [emailStr appendFormat:@"%@:%@\n",[HB_ConvertEmailArrTool convertEmailTypeSystemToHBZS:model.emailType],model.emailAddress];
        }
    }
    [contentStr appendFormat:@"%@",emailStr];
    [emailStr release];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:contentStr image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            ZBLog(@"分享成功！");
        }
    }];
}

-(void)shareByQRcodeMoreView:(HB_ShareByQRcodeMoreView *)moreView WithselectIndex:(NSInteger)index
{
    self.shareMoreView.hidden = !self.shareMoreView.hidden;
    switch (index) {
            //@[@"二维码分享",@"短信分享"];
        case 0:
        {
            if (self.contactModel) {
                HB_MyCardQRCodeVc * vc = [[HB_MyCardQRCodeVc alloc] initWithContactModel:self.contactModel];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
            else
            {
                
            }
            
        }
            break;
        case 1:
        {
            [self ShareMyCard];
        }
            break;
        default:
            break;
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        //更新
        [self UpdataMycardWithtype:1];
    }
    else if (buttonIndex == 1)
    {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"警告" message:@"云名片删除后，其他人将无法再访问到您的名片，您确定要删除吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
        al.tag = 102;
        [al show];
        [al release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //创建云名片
        if (alertView.tag == 101) {
            [self UpdataMycardWithtype:0];
        }
        else if (alertView.tag == 102)
        {
            [self UpdataMycardWithtype:2];
        }
        
        
    }
}

-(void)UpdataMycardWithtype:(NSInteger)type
{
    self.req = [[HB_httpRequestNew alloc] init];
    [self setCloudEnableUser:NO];
    [self.req UpdateMyCardWithType:type Result:^(BOOL isSucess, NSString *shareUrl, NSInteger resultCode) {
        
        
        if (!_isVisible) {
            return ;
        }

        
        if (!isSucess) {
            [self setCloudEnableUser:YES];
            UIAlertView * al =  [[UIAlertView alloc] initWithTitle:nil message:@"请求失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            [al release];
            return ;
        }
        if (type == 2) {
            self.ClouddBtn_nav.userInteractionEnabled = YES;
            if (resultCode == 0) {
                
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:@"删除完成"];
                
                //删除云名片地址
                [SettingInfo removeCardShareUrl];
            }
            else
            {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }
        }
        else if (shareUrl) {
            //保存云名片地址
            [SettingInfo saveCardShareUrl:shareUrl];
            
            [self setCloudEnableUser:YES];
            
            HB_MyCardCloudVc * web = [[HB_MyCardCloudVc alloc] init];
            web.url = [NSURL URLWithString:shareUrl];
            web.mycardModel = self.contactModel;
            web.titleName = @"我的云名片";
            [self.navigationController pushViewController:web animated:YES];
            
            [web release];
        }
    }];
}

-(void)setCloudEnableUser:(BOOL)Enable
{
    self.ClouddBtn_nav.userInteractionEnabled = Enable;
    if (!Enable) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD show];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

-(BOOL)isVisible
{
    return (self.isViewLoaded && self.view.window);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
