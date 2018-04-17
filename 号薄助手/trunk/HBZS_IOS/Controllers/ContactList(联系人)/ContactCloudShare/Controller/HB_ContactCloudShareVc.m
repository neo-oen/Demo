//
//  HB_ContactCloudShareVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/8/23.
//
//

#import "HB_ContactCloudShareVc.h"
#import "HBZSAppDelegate.h"
#import "HB_contactCloudReq.h"
#import "HB_WebviewCtr.h"
#import "HB_CloudShareSuccessVc.h"
#import "SVProgressHUD.h"
#import "MainViewCtrl.h"
#import "GetMemberInfoProto.pb.h"
#import "HB_httpRequestNew.h"

@interface HB_ContactCloudShareVc ()<UIAlertViewDelegate>

/** 底部（全选）底部工具条 */
@property(nonatomic,retain)UIView *bottomToolBar;
/** 底部（全选）按钮 */
@property(nonatomic,retain)UIButton * selectAllBtn;
/** 底部（确定）按钮 */
@property(nonatomic,retain)UIButton * confirmBtn;

@property(nonatomic,retain)NSMutableArray * SelectedSimpleModels;

@property(nonatomic,retain)MemberInfoResponse * memberInfo;
@end

@implementation HB_ContactCloudShareVc
-(void)dealloc
{
    [_bottomToolBar release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self restepInterface];
    self.SelectedSimpleModels = [NSMutableArray arrayWithCapacity:0];
    [self loadMemberInfoFormServer];
}

-(void)loadMemberInfoFormServer
{
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    [req getMemberInfoResult:^(BOOL isSuccess, MemberInfoResponse *memberInfo) {
        if (!isSuccess) {
            return ;
        }
        self.memberInfo  =  memberInfo;
        
    }];
    [req release];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - tableView代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_ContactCell * cell=[HB_ContactCell cellWithTableView:tableView];
    HB_ContactSimpleModel * model=self.dataArr[indexPath.section][indexPath.row];
    cell.contactModel=model;
    if ([self.SelectedSimpleModels containsObject:model])
    {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    return cell;
}

-(void)restepInterface
{
    self.tableView.frame = CGRectMake(0, 0, Device_Width, Device_Height-64-50);
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = YES;

    [self.view addSubview:self.bottomToolBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //当tableView处于非编辑状态的时候，才会跳转
    
    HB_ContactCell *cell = (HB_ContactCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    //把选中的indexPath对应的model添加到选中的数据源
    HB_ContactSimpleModel *model = self.dataArr[indexPath.section][indexPath.row];
    [self.SelectedSimpleModels addObject: model];
    NSInteger allcontactCount = ABAddressBookGetPersonCount([[HBZSAppDelegate getAppdelegate] getAddressBookRef]);
    NSLog(@"%ld",self.SelectedSimpleModels.count);
    
    if (self.SelectedSimpleModels.count == allcontactCount) {
        self.selectAllBtn.selected = YES;
    }
    else
    {
        self.selectAllBtn.selected = NO;
    }
    [self updataconfirmCount];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        HB_ContactCell *cell = (HB_ContactCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
        HB_ContactSimpleModel *model = self.dataArr[indexPath.section][indexPath.row];
        [self.SelectedSimpleModels removeObject:model];
        self.selectAllBtn.selected = NO;
    [self updataconfirmCount];

}


-(void)updataconfirmCount
{
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"确认(%ld)",self.SelectedSimpleModels.count] forState:UIControlStateNormal];
    if (self.SelectedSimpleModels.count>0) {
        [self.confirmBtn setTitleColor:COLOR_A forState:UIControlStateNormal];
        self.confirmBtn.userInteractionEnabled = YES;
        
    }
    else
    {
        [self.confirmBtn setTitleColor:COLOR_D forState:UIControlStateNormal];
        self.confirmBtn.userInteractionEnabled = NO;
    }
}

-(UIView *)bottomToolBar{
    if (!_bottomToolBar) {
        _bottomToolBar = [[UIView alloc]init];
        _bottomToolBar.userInteractionEnabled = YES;
        _bottomToolBar.frame = CGRectMake(0, Device_Height-64-bottomH, Device_Width,bottomH);
        [_bottomToolBar addSubview:[self toobarLineView]];
        //全选按钮
        [_bottomToolBar addSubview:self.selectAllBtn];
        [_bottomToolBar addSubview:self.confirmBtn];
//        self.selectAllBtn.frame = CGRectMake(13, 0, 100, toolBar_H);
    }
    return _bottomToolBar;
}
-(UIButton *)selectAllBtn{
    if (!_selectAllBtn) {
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllBtn.frame = CGRectMake(15, 0, 100, bottomH);
        [_selectAllBtn setImage:[UIImage imageNamed:@"选框"] forState:UIControlStateNormal];
        [_selectAllBtn setImage:[UIImage imageNamed:@"选框-选中"] forState:UIControlStateSelected];
        [_selectAllBtn setTitle:@"  全选" forState:UIControlStateNormal];
        _selectAllBtn.titleLabel.font= [UIFont systemFontOfSize:15];
        [_selectAllBtn setTitleColor:COLOR_D forState:UIControlStateNormal];
        [_selectAllBtn addTarget:self action:@selector(buttomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        _selectAllBtn.tag = Bottom_SelectAll;
        
    }
    return _selectAllBtn;
}

-(UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(Device_Width-93, 0, 85, bottomH);
//        _confirmBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_confirmBtn setTitle:@"确认(0)" forState:UIControlStateNormal];
        _confirmBtn.userInteractionEnabled = NO;
        _confirmBtn.titleLabel.font= [UIFont systemFontOfSize:15];
        [_confirmBtn setTitleColor:COLOR_D forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(buttomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        _confirmBtn.tag = Bottom_Confirm;
    }
    return _confirmBtn;
}

-(void)buttomBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case Bottom_SelectAll:
        {
            sender.selected = !sender.selected;
            
            if (sender.selected == YES) {
                //全选
                self.SelectedSimpleModels = [NSMutableArray arrayWithCapacity:0];
                for (NSArray * arr in self.dataArr) {
                    [self.SelectedSimpleModels addObjectsFromArray:arr];
                }
                
            }
            else
            {
                [self.SelectedSimpleModels removeAllObjects];
            }
            [self.tableView reloadData];
            [self updataconfirmCount];

        }
            break;
        case Bottom_Confirm:
        {
            if (!self.memberInfo) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"正在获取会员信息，请稍后"];
                return;
            }
            if (self.memberInfo.memberLevel == MemberLevelVip) {
                if (self.SelectedSimpleModels.count>100) {
                    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您选择分享的联系人数量超出最大限额（100条/次)，点击“继续”将分享选定的前100位联系人，点击“取消”可返回重新选择。" delegate:nil cancelButtonTitle:nil otherButtonTitles: @"继续",@"取消",nil];
                    al.delegate = self;
                    [al show];
                    [al release];
                    return;
                }
            }
            else if(self.memberInfo.memberLevel == MemberLevelCommon)
            {
                if (self.SelectedSimpleModels.count>20) {
                    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您选择分享的联系人数量超出最大限额（20条/次)，点击“继续”将分享选定的前20位联系人，点击“取消”可返回重新选择。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"继续",@"取消",nil];
                    al.delegate = self;
                    [al show];
                    [al release];
                    return;
                }
            }
            
            [self createCloudShareWithContacts:self.SelectedSimpleModels];
            
            
        }
            break;
            
        default:
            break;
    }
}

-(void)createCloudShareWithContacts:(NSArray *)contacts
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在创建云分享"];
    NSMutableArray * contactIds = [NSMutableArray arrayWithCapacity:0];
    for (HB_ContactSimpleModel * model in contacts) {
        [contactIds addObject:model.contactID];
    }
    HB_contactCloudReq * req = [HB_contactCloudReq shareManage];
    [req CloudShareByContactIds:contactIds andResult:^(ContactShareResponse *result, NSString *myName, NSInteger reqResCode) {
        
        [SVProgressHUD dismiss];
        
        if (reqResCode == reqResCode_suc) {
            if (result.resCode == 0) {
                HB_CloudShareSuccessVc * vc = [[HB_CloudShareSuccessVc alloc] initWithNibName:nil bundle:nil];;
                vc.shareSucModel = result;
                vc.MyshareName = myName;
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
            
        }
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //继续
        NSRange range;
        if (self.memberInfo.memberLevel == MemberLevelVip) {
            range = NSMakeRange(0, 100);
        }
        else if(self.memberInfo.memberLevel == MemberLevelCommon)
        {
            range  = NSMakeRange(0, 20);
        }
        
        NSArray * shareContacts = [self.SelectedSimpleModels subarrayWithRange:range];
        [self createCloudShareWithContacts:shareContacts];
    }
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
