//
//  HB_GroupManageVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/26.
//
//

#import "HB_GroupManageVC.h"
#import "HB_GroupManageCell.h"
#import "GroupData.h"
#import "HB_GroupModel.h"
#import "HB_GroupMemberListVC.h"
#import "HB_CloudShareSuccessVc.h"
#import "HB_contactCloudReq.h"
#import "MainViewCtrl.h"

@interface HB_GroupManageVC ()<UITableViewDataSource,UITableViewDelegate,HB_GroupManageCellDelegate,UIAlertViewDelegate>
/**  列表 */
@property(nonatomic,assign)UITableView * tableView;
/**  数据源 */
@property(nonatomic,retain)NSMutableArray * dataArr;
/**  需要分享的联系人id数据*/
@property(nonatomic,retain)NSArray * ShareContacIds;

/**  警告框1（编辑） */
@property(nonatomic,assign)UIAlertView * alertView_edit;
/**  警告框2（删除） */
@property(nonatomic,assign)UIAlertView * alertView_delete;
/**  警告框3（新建分组） */
@property(nonatomic,assign)UIAlertView * alertView_newGroup;

@property(nonatomic,strong)UILabel * alertLabel;

@end

@implementation HB_GroupManageVC
-(void)dealloc{
    [_dataArr release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupInterface];
    
    [self.view addSubview:self.alertLabel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initDataArr];
    [_tableView reloadData];
}
-(void)setupNavigationBar{
    self.title=@"管理分组";
    //右侧加号按钮
    UIButton * rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton setFrame:CGRectMake(0, 0, 20, 20)];
    rightBarButton.exclusiveTouch = YES;
    [rightBarButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(titleRightBtnDo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
    [rightBarButtonItem release];
}
-(void)titleRightBtnDo:(UIButton *)btn{
    UIAlertView * alertView_newGroup=[[UIAlertView alloc]initWithTitle:@"新建分组" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView_newGroup.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alertView_newGroup show];
    _alertView_newGroup = alertView_newGroup;
    [alertView_newGroup release];
}
-(void)setupInterface{
    //添加tableView
    CGFloat tableView_X=0;
    CGFloat tableView_Y=0;
    CGFloat tableView_W=SCREEN_WIDTH;
    CGFloat tableView_H=SCREEN_HEIGHT-64;
    CGRect tableFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    UITableView * tableView=[[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.rowHeight=60;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    _tableView=tableView;
}
#pragma mark - 数据源
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
/** 初始化数据源 */
-(void)initDataArr{
    [self.dataArr removeAllObjects];
    //1.获取所有群组的名称以及ID
    NSArray * arr = [GroupData getAllGroupIDAndGroupNameArray];
    for (int i=0; i<arr.count; i++) {
        NSDictionary * dict=arr[i];
        HB_GroupModel * groupModel=[[HB_GroupModel alloc]init];
        [groupModel setValuesForKeysWithDictionary:dict];
        [self.dataArr addObject:groupModel];
        [groupModel release];
    }
}
#pragma mark - tableView的协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_GroupManageCell * cell=[HB_GroupManageCell cellWithTableView:tableView];
    cell.delegate=self;
    cell.model=self.dataArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArr.count) {
        self.alertLabel.hidden = YES;
    }
    else
    {
        self.alertLabel.hidden = NO;
    }
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HB_GroupMemberListVC * vc=[[HB_GroupMemberListVC alloc]init];
    HB_GroupModel * model=self.dataArr[indexPath.row];
    vc.title=model.groupName;
    vc.groupID=model.groupID;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
#pragma mark - HB_GroupManageCell的代理方法，分享、编辑、删除 按钮的点击事件
-(void)groupManageCell:(HB_GroupManageCell *)cell shareBtnClick:(UIButton *)shareBtn
{
//    __unsafe_unretained HB_GroupManageVC* weakself = self;
    if (![[MainViewCtrl shareManager]isAccount:self]) {
        return;
    }
    self.ShareContacIds = [GroupData getGroupAllContactIDByID:cell.model.groupID];
    NSString * name = cell.model.groupName;
    
    NSString * title = @"创建云分享";
    NSString * text = [NSString stringWithFormat:@"即将 %@ 组中的 %ld 位联系人创建云分享链接，是否继续？",name,(unsigned long)self.ShareContacIds.count];
    
    UIAlertView * al = [[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"创建", nil];
    al.tag = 300;
    [al show];
    
}
-(void)groupManageCell:(HB_GroupManageCell *)cell editBtnClick:(UIButton *)editBtn{
    UIAlertView * alertView_edit=[[UIAlertView alloc]initWithTitle:@"编辑组名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView_edit.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField * textField = [alertView_edit textFieldAtIndex:0];
    textField.text=cell.model.groupName;
    alertView_edit.tag=cell.model.groupID;
    [alertView_edit show];
    _alertView_edit=alertView_edit;
    [alertView_edit release];
}
-(void)groupManageCell:(HB_GroupManageCell *)cell deleteBtnClick:(UIButton *)deleteBtn{
     UIAlertView * alertView_delete=[[UIAlertView alloc]initWithTitle:@"删除分组" message:@"删除分组不会删除分组下的联系人信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView_delete.tag=cell.model.groupID;
    [alertView_delete show];
    _alertView_delete=alertView_delete;
    [alertView_delete release];
}
#pragma mark - UIAlertView 的代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _alertView_edit) {//编辑分组提示框
        if (buttonIndex==1) {//“确定”
            UITextField * textField = [alertView textFieldAtIndex:0];
            [GroupData editGroupNameByGroupID:alertView.tag withNewGroupName:textField.text];
            [self initDataArr];
            [_tableView reloadData];
        }
    }else if (alertView == _alertView_delete){//删除分组提示框
        if (buttonIndex==1) {//“确定”
            [GroupData deleteGroupMemberByGroupID:alertView.tag];
            [self initDataArr];
            [_tableView reloadData];
        }
    }else if (alertView == _alertView_newGroup){//新建分组提示框
        if (buttonIndex==1) {//“确定”
            UITextField * textField = [alertView textFieldAtIndex:0];
            for (HB_GroupModel *model in self.dataArr) {
                if ([model.groupName isEqualToString:textField.text]) {
                    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此分组已经存在，请勿重复创建" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [al show];
                    [al release];
                    return;
                }
            }
            [GroupData addNewGroupWithGroupName:textField.text];
            [self initDataArr];
            [_tableView reloadData];
        }
    }
    else if (alertView.tag == 300)
    {//组联系人分享
        if (buttonIndex == 1) {
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showWithStatus:@"正在创建云分享"];
            HB_contactCloudReq * req = [[[HB_contactCloudReq alloc] init] autorelease];
            [req CloudShareByContactIds:self.ShareContacIds andResult:^(ContactShareResponse *result, NSString *myName, NSInteger reqResCode) {
                [SVProgressHUD dismiss];
                if (result.resCode == 0) {
                    HB_CloudShareSuccessVc * vc = [[HB_CloudShareSuccessVc alloc] initWithNibName:nil bundle:nil];;
                    vc.shareSucModel = result;
                    vc.MyshareName = myName;
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc release];
                    
                }
            }];
        }
    }
}

-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel=[[UILabel alloc]init];
        _alertLabel.textColor=COLOR_H;
        _alertLabel.font=[UIFont boldSystemFontOfSize:30];
        _alertLabel.frame=CGRectMake(0, 150, SCREEN_WIDTH, 60);
        _alertLabel.textAlignment=NSTextAlignmentCenter;
        _alertLabel.text=@"没有分组数据";
        _alertLabel.hidden=YES;
    }
    return _alertLabel;
}

@end
