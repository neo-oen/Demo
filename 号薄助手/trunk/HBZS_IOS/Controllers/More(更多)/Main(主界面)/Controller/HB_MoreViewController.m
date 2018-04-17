//
//  HB_MoreViewController.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/11.
//
//
typedef enum {
    ButtonTypeBackUP=10,//通讯录备份
    ButtonTypeRemoveRepead,//联系人去重
    ButtonTypeMessageCenter,//消息中心--->4.1来电识别
    ButtonTypeNetMessage,//网络短信
}ButtonType;

#import "HB_MoreViewController.h"
#import "HB_MoreVCSettingCell.h"
#import "HB_MoreCellModel.h"
#import "HB_MoreVCTopButton.h"
#import "HB_BackupAddressBookVC.h"//1.通讯录备份
//#import "MyZbViewController.h" //2.扫一扫
#import "QRCodeScanViewController.h"//二维码扫描
#import "HB_MessageCenterVC.h"//3.消息中心
#import "NetMessageViewController.h"//4.网络短信
#import "newNetMsgVc.h"//新网络短信
#import "HB_IdentACallVc.h"//来电识别
#import "HB_MergerViewController.h"//5.联系人去重
#import "HB_SystemSettingVC.h"//6.系统设置

#import "HB_CommonQuestion.h"//8.常见问题
#import "HB_OnlineServiceVc.h" //在线客服
#import "HB_AboutVC.h"//9.关于

#import "HB_RemoveRepeadTool.h"//去重工具类
#import "HB_BusinessCardParser.h"//名片解析
#import "SyncProgressView.h"
#import "HB_ContactDetailController.h"

#import "HB_ScanResultAnalyze.h"

#import "HB_ContactInfoVC.h"
#import "HB_MoreTopNologinView.h"

#import "HB_httpRequestNew.h"

#import "HB_MemberCenterVc.h"
#import "SettingInfo.h"
#import "AccountVc.h"
#import "HB_WebviewCtr.h"
//#import "HB_MaCardInfoVc.h"
#import "HB_CardsViewCtrl.h"
#import "ContactProtoToContactModel.h"
#import "HB_shareByQrcodeController.h"
#import "HB_MyCardQRCodeVc.h"
#import "HB_IdentACall.h"
#import "HBZSAppDelegate.h"
@interface HB_MoreViewController ()<UITableViewDelegate,
                                    UITableViewDataSource,
                                    UIAlertViewDelegate,
                                    HB_RemoveRepeadToolDelegate,HB_ContactDetailDelagete,topNologinViewDelegate,TopMemberViewDelegate,HB_MoreVCSettingCellDelegate>

/**  去重的工具类 */
@property(nonatomic,retain)HB_RemoveRepeadTool *removeRepeadTool;
/**  主界面列表 */
@property(nonatomic,retain)UITableView * tableView;
/**  数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**  进度条 */
@property(nonatomic,retain)SyncProgressView * Progressview;
/**  已经合并的重复的联系人个数 */
@property(nonatomic,assign)NSInteger repeadCount;
/**  等待合并的相似联系人的个数 */
@property(nonatomic,assign)NSInteger similarCount;
/**  等待合并的相似联系人的分组数组 */
@property(nonatomic,retain)NSArray * similarContactArr;


@property(nonatomic,retain)HB_MoreTopMemberView * menberView;
@property(nonatomic,retain)HB_MoreTopNologinView * topNologinview;
@property(nonatomic,retain)HB_MoreVCTopButton * Callindetbtn;

@property(nonatomic,assign)BOOL isNeedUpdataPackage;
@end

@implementation HB_MoreViewController
-(void)dealloc{
    [_removeRepeadTool release];
    [_tableView release];
    [_menberView release];
    [_dataArr release];
    [_similarContactArr release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataArr];
    [HB_IdentACall registerDhb];
    [self setupNavigationBar];
    [self setupInterface];
    //初始化会员模块
    [self setMemberTableHeaderView];
}
-(void)checkIsneedUpataPackage
{
    HB_IdentACall * identCall = [[HB_IdentACall alloc] init];
    [identCall isneedUpdataPackage:^(BOOL isNeed) {
        self.Callindetbtn.redTip.hidden = !isNeed;
    }];
    [identCall release];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self showTabBar];
    
    if ([SettingInfo getAccountState]) {
        [self getmemberinfo];
    }
    else{
        [self.menberView reStepInterFaceWithloginStatu:NO];
    }
    
//*/
    [self checkIsneedUpataPackage];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - 数据源
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(void)initDataArr{
    __unsafe_unretained HB_MoreViewController * weakSelf = self;
    HB_MoreCellModel * model1=[HB_MoreCellModel modelWithIcon:[UIImage imageNamed:@"more_去重"] andNameStr:@"联系人去重" andViewController:nil andOption:^{
        [self allocProgressAlert];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            weakSelf.similarContactArr = [weakSelf.removeRepeadTool filterContactArr];
            
        });
    }];
    
    HB_MoreCellModel * model2= [HB_MoreCellModel modelWithIcon:[UIImage imageNamed:@"扫描-灰"] andNameStr:@"扫一扫" andViewController:[QRCodeScanViewController class] andOption:nil];
    
    HB_MoreCellModel * model3=[HB_MoreCellModel modelWithIcon:[UIImage imageNamed:@"more_系统设置"]
                                                   andNameStr:@"系统设置"
                                            andViewController:[HB_SystemSettingVC class]
                                                    andOption:nil
                               ];
    
    HB_MoreCellModel * model4=[HB_MoreCellModel modelWithIcon:[UIImage imageNamed:@"客服"]
                                                   andNameStr:@"在线客服"
                                            andViewController:[HB_OnlineServiceVc class]
                                                    andOption:nil
                               ];

    HB_MoreCellModel * model5=[HB_MoreCellModel modelWithIcon:[UIImage imageNamed:@"详情"]
                                                   andNameStr:@"常见问题"
                                            andViewController:[HB_CommonQuestion class]
                                                    andOption:nil
                               ];
    
    HB_MoreCellModel * model6=[HB_MoreCellModel modelWithIcon:[UIImage imageNamed:@"more_关于"]
                                                   andNameStr:@"关于"
                                            andViewController:[HB_AboutVC class]
                                                    andOption:nil
                               ];

    [self.dataArr addObjectsFromArray:@[model1,model2,model3,model4,model5,model6]];
}
#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //左侧按钮置为空
    self.leftBtnIsBack=NO;
    //标题
    self.title=@"我的";
}
/**
 *  设置界面
 */
-(void)setupInterface{
    //tableView
    CGFloat tableView_W=SCREEN_WIDTH;
    CGFloat tableView_H=SCREEN_HEIGHT-49-64;
    CGFloat tableView_X=0;
    CGFloat tableView_Y=0;
    CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    UITableView * tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorFromHexString:@"F5F5F5"];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
}




/**
 *  设置tableview的头视图
 */
-(void)setMemberTableHeaderView
{
    if (!self.menberView) {
        self.menberView = [[[NSBundle mainBundle] loadNibNamed:@"HB_MoreTopMemberView" owner:nil options:nil] firstObject];
        self.menberView.frame = CGRectMake(0, 0, Device_Width, 132);
        self.menberView.delegate = self;
    }
    
    
    self.tableView.tableHeaderView = self.menberView;
    [self.menberView reStepInterFaceWithloginStatu:NO];
    
  
}
-(void)setLoginTableHearderView
{
    if (!self.topNologinview) {
        self.topNologinview = [[[NSBundle mainBundle] loadNibNamed:@"HB_MoreTopNologinView" owner:nil options:nil] firstObject];
        self.topNologinview.frame = CGRectMake(0, 0, Device_Width, 70);
        self.topNologinview.delegate =self;
       
    }
    self.tableView.tableHeaderView = self.topNologinview;
    [self.tableView reloadData];
}
-(void)getmemberinfo
{
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    
    [self.menberView updateAlertViewWithType:moreTopGetMebInfo_getting];
    [req getMemberInfoResult:^(BOOL isSuccess, MemberInfoResponse *menberInfo) {
        
        NSLog(@"%d", isSuccess);
        if (!isSuccess) {
            
            [self.menberView updateAlertViewWithType:moreTopGetMebInfo_Error];
            return ;
        }
//        [self setMemberTableHeaderView];
        
        
        [self.menberView reStepInterFaceWithloginStatu:YES];
        [self.menberView updateAlertViewWithType:moreTopGetMebInfo_Suc];
        [self.menberView setdataWith:menberInfo];
    }];
    
    [req release];
   
}
#pragma mark - top4个按钮的点击事件
-(void)topBtnClick:(UIButton *)btn{
    if (btn.tag==ButtonTypeBackUP) {//联系人备份
        if (![HBZSAppDelegate checkAddressBookRABC]) {
            return;
        }
        HB_BackupAddressBookVC * backupVC=[[HB_BackupAddressBookVC alloc]init];
        [self.navigationController pushViewController:backupVC animated:YES];
        [backupVC release];
    }else if (btn.tag==ButtonTypeRemoveRepead){//短信备份指南
        HB_WebviewCtr * vc = [[HB_WebviewCtr alloc] init];
        vc.url = [NSURL URLWithString:@"http://pim.189.cn/help/iosmsshelp/iPhoneMessage.html"];
        vc.titleName = @"短信助手";
        [vc hiddenTabBar];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }else if (btn.tag==ButtonTypeMessageCenter){
        /*//4.1版中消息中心替换为来电识别
        HB_MessageCenterVC * messageVC=[[HB_MessageCenterVC alloc]init];
        [self.navigationController pushViewController:messageVC animated:YES];
        [messageVC release];
         *******/
        if (kSystemVersion<10) {
            UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此功能只支持iOS10以上的设备" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            [al release];
            return;
        }
        HB_IdentACallVc * ident_a_callVc=  [[HB_IdentACallVc alloc] init];
        [self.navigationController pushViewController:ident_a_callVc animated:YES];
    
        [ident_a_callVc release];
        
    }else if (btn.tag==ButtonTypeNetMessage){
        
//        newNetMsgVc * vc = [[newNetMsgVc alloc] initWithNibName:nil bundle:nil];
        NetMessageViewController * vc = [[NetMessageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
        
        
        

        
    }
}
#pragma mark - 提示框的协议方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_similarCount) {
        //跳转页面
        HB_MergerViewController * vc=[[HB_MergerViewController alloc]init];
        vc.similarGroupArr = [[self.similarContactArr mutableCopy] autorelease];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}
#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_MoreVCSettingCell * cell=[HB_MoreVCSettingCell cellWithTableView:tableView];
    cell.cellModelArr=self.dataArr;
    cell.delegate = self;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSLog(@"%ld",section);
    return 200;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * headerView=[[UIView alloc]init];
        headerView.backgroundColor=COLOR_H;
        headerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 200);
        NSArray * btnTitleArr=@[@"通讯录备份",
                                @"短信助手",
                                @"来电识别",
                                @"网络短信"
                                ];
        NSArray * btnImageArr=@[@"more_通讯备份",
                                @"短信备份指南",
                                @"more_来电识别",
                                @"more_网络短信"
                                ];
        for (int i=0; i<4; i++) {
            CGFloat btnPadding=0.5f;
            HB_MoreVCTopButton * btn=[[HB_MoreVCTopButton alloc]init];
            CGFloat btn_W=(SCREEN_WIDTH-btnPadding)*0.5;
            CGFloat btn_H=(headerView.bounds.size.height - 3*btnPadding)*0.5;
            CGFloat btn_X=(btn_W+btnPadding)* (i%2);
            CGFloat btn_Y=btnPadding + (btn_H+btnPadding)* (i/2);
            btn.frame=CGRectMake(btn_X, btn_Y, btn_W, btn_H);
            btn.tag=ButtonTypeBackUP+i;
            
            [btn setImage:[UIImage imageNamed:btnImageArr[i]] forState:UIControlStateNormal];
            [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:btn];
            if (btn.tag == ButtonTypeMessageCenter) {
                //                btn.redTip.hidden = !self.isNeedUpdataPackage;
                self.Callindetbtn = btn;
            }
            else
            {
                btn.redTip.hidden = YES;
            }

            [btn release];
        }
        
        return headerView;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger datacount = self.dataArr.count;
    return (datacount/2+datacount%2)*73+16;
}

#pragma mark - HB_MoreViewControllerDelegate
-(void)MoreVCSettingCell:(HB_MoreVCSettingCell *)MoreVCSettingCell selectedAtIdexPath:(NSIndexPath *)indexPath
{
    HB_MoreCellModel * model=self.dataArr[indexPath.row];
    if ([model.viewController isEqual:[QRCodeScanViewController class]]) {
        __unsafe_unretained HB_MoreViewController *weakSelf = self;
        QRCodeScanViewController * QRScanVc = [[QRCodeScanViewController alloc] initWithBlock:^(NSString * result, BOOL isSuccess) {
            NSLog(@"扫描数据：\n%@",result);
            
            HB_ScanResultAnalyze * analyzer = [[[HB_ScanResultAnalyze alloc] initWithCurrentVc:weakSelf] autorelease];
            [analyzer AnalyzeResult:result];
            
        }];
        QRScanVc.title = @"二维码扫描";
        QRScanVc.leftBtnIsBack = YES;
        [QRScanVc hiddenTabBar];
        [self.navigationController pushViewController:QRScanVc animated:YES];
        [QRScanVc release];
    }
    else if (model.viewController) {
        UIViewController * vc=[[model.viewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    if (model.block) {
        model.block();
    }
}

-(void)allocProgressAlert
{
    self.Progressview = [[SyncProgressView alloc] init];
    [self.Progressview setProTitleWithString:@"已完成"];
    [self.Progressview show];
    [self.Progressview setProgressMin];
}
#pragma mark - HB_RemoveRepeadToolDelegate
/**
 *  去重完成的回调
 */
-(void)removeRepeadTool:(HB_RemoveRepeadTool *)tool didFinishFilterContactArrWithRepeadCount:(NSInteger)repeadCount andSimilarCount:(NSInteger)similarCount{
    //赋值
    dispatch_async(dispatch_get_main_queue(), ^{
        self.Progressview.precentlabel.text = [NSString stringWithFormat:@"100.00%%"];
        [self.Progressview setProgressMax];
        self.repeadCount=repeadCount;
        self.similarCount=similarCount;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.Progressview dismiss];
            
            UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"成功自动合并了%ld个重复联系人，%ld相似联系人需要手动合并",(long)repeadCount,(long)similarCount] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
            [alertView release];
        });
    });
    
    //回调方法
//    self
    
    
}

/*
 *实时进度监控回调
 */
-(void)removeRepeadTool:(HB_RemoveRepeadTool *)tool compeletPercent:(CGFloat)percent
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.Progressview.precentlabel.text = [NSString stringWithFormat:@"%0.2f%%",percent*100];
        [self.Progressview.progressView setProgress:percent animated:YES];
    });
    
}
#pragma mark - setter and getter

-(HB_RemoveRepeadTool *)removeRepeadTool{
    if (!_removeRepeadTool) {
        _removeRepeadTool=[[HB_RemoveRepeadTool alloc]init];
        _removeRepeadTool.delegate=self;
    }
    return _removeRepeadTool;
}

#pragma mark - ContactDetailDelagete  //扫描并添加联系人成功后会条用 用于跳转到新联系人info
-(void)ContactDetailController:(HB_ContactDetailController *)ContactDetailController SavedContact:(NSInteger)contactId
{
    HB_ContactInfoVC * infoVC=[[HB_ContactInfoVC alloc]init];
    infoVC.recordID = (int)contactId;
    [self.navigationController pushViewController:infoVC animated:NO];
}

#pragma mark TopMemberDelegate
-(void)TopMemberView:(HB_MoreTopMemberView *)topMemberView BtnClick:(MoreTopClickType)btnType
{
    
    switch (btnType) {
            
            
        case MoreTopClick_Card:
        {
            
            HB_CardsViewCtrl * cardView = [[HB_CardsViewCtrl alloc] init];
            [self.navigationController pushViewController:cardView animated:YES];
            [cardView release];
        }
            break;
            
        case MoreTopClick_QRcode:
        {
            if (![self loginStatuCheck]) {
                return;
            }
            //名片二维码
            HB_MyCardQRCodeVc * vc = [[HB_MyCardQRCodeVc alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
        case MoreTopClick_MemberCenter:
        {
            if (![self loginStatuCheck]) {
                return;
            }
            HB_MemberCenterVc * vc = [[HB_MemberCenterVc alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
        case MoreTopClick_login:
        {
            //登录
            AccountVc * vc = [[AccountVc alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            [self hiddenTabBar];
        }
            break;
        case MoreTopClick_Register:
        {
            //注册
            
            HB_WebviewCtr * webvc = [[HB_WebviewCtr alloc] init];
            webvc.titleName = [NSString stringWithFormat:@"注册"];
            webvc.url = [NSURL URLWithString:@"http://passport.189.cn/SelfS/Reg/Cellphone.aspx"];
            [self.navigationController pushViewController:webvc animated:YES];
            [webvc release];
            [self hiddenTabBar];
        }
            break;
        case MoreTopClick_RegetInfo:
        {
            [self getmemberinfo];
        }
            break;
        default:
            break;
    }
}

#pragma mark topNologViewdelegate
-(void)topNologinView:(HB_MoreTopNologinView *)topView btnClickWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
           
        }
            break;
        case 1:
        {
           
        }
            break;
            
        default:
            break;
    }
    
}

-(BOOL)loginStatuCheck
{
    BOOL statu = [SettingInfo getAccountState];
    if (!statu) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    }
    return statu;
}

@end
