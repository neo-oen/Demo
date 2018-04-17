//
//  TimeMachineCtrl.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/11/26.
//
//

#import "TimeMachineCtrl.h"
#import "TimeMachineCell.h"
#import "HBZSAppDelegate.h"
#import "HB_MachineDataModel.h"
#import "FMDB.h"
#import "UIViewController+TitleView.h"
#import "HB_TimeMachineContactPreviewVc.h"
#import "HB_LocalinfoCell.h"

#import "HB_UnlimitedBackUpReq.h"
#import "HB_UnlimitedBackUpContorller.h"
#import "GetMemberInfoProto.pb.h"
@interface TimeMachineCtrl ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TimeMachineCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setVCTitle:@"时光机"];
    [self initTimeMachineData];
    
    [self alert];
}
-(void)alert
{
    
    MemberInfoResponse * membInfo = [MemberInfoResponse parseFromData:[SettingInfo getMemberInfo]];
    if (membInfo.memberLevel == MemberLevelCommon) {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您是普通会员，系统将自动记录您5次通讯录下载或修改操作，您可以选择将手机通讯录恢复到其中某个时间点。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
        [al release];
    }
    
}

-(void)initTimeMachineData
{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

#pragma  mark 本地联系人count加入到数据源中
    
    [self.dataArray addObject:[self ContactCountLabelValue]];
/** 本地联系人count加入到数据源中 */
    
    
    FMDatabase * db = [[FMDatabase alloc] initWithPath:[HB_MachineDataModel TimeMachineDbPath]];
    if (![db open]) {
        NSLog(@"timeMachineDb can not open");
        [db release];
        return;
    }
    FMResultSet * timeMachineSet = [db executeQuery:@"SELECT syncTime,contactsCount,syncTypecode from TimeMachineTable order by syncTime desc"];
    while ([timeMachineSet next]) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:[timeMachineSet objectForColumnName:@"syncTime"] forKey:@"syncTime"];
        [dic setObject:[timeMachineSet objectForColumnName:@"contactsCount"] forKey:@"contactsCount"];
        [dic setObject:[timeMachineSet objectForColumnName:@"syncTypecode"] forKey:@"syncTypecode"];
        HB_MachineDataModel * model = [[HB_MachineDataModel alloc]initWithDictionary:dic];
        if (model.syncTime!=0) {//&&model.syncTypecode != 0
            [self.dataArray addObject:model];
        }
        
        [model release];
        
    }
    
    [db close];
    [db release];
}

-(NSString *)ContactCountLabelValue
{
    
    HBZSAppDelegate * delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [NSString stringWithFormat:@"%lu个联系人",ABAddressBookGetPersonCount([delegate getAddressBookRef])];
}

#pragma mark tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HB_LocalinfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocalinfoCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HB_LocalinfoCell" owner:nil options:nil] lastObject];
        }
        cell.localCount.text = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        TimeMachineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TimeMachinecell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimeMachineCell" owner:nil options:nil] lastObject];
        }
        [cell setDataWithModel:[self.dataArray objectAtIndex:indexPath.row]];
        return cell;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请选择需要回复的时间点";
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    HB_MachineDataModel * model = [self.dataArray objectAtIndex:indexPath.row];
    model = [model getContactsAndGropusDataToModel];
    HB_TimeMachineContactPreviewVc *vc = [[HB_TimeMachineContactPreviewVc alloc] init];
    vc.Mmodel = model;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self getmenberInfo];
    });
}

-(void)getmenberInfo
{
    [HB_UnlimitedBackUpReq MemberInfoRequestType:1 resultBlock:^(NSError * _Nullable error, NSInteger resultCode, NSString * _Nullable startdate) {
        if (!error) {
            if (resultCode == 1) {
                //不是会员
                [self.TimeMachinetable setTableHeaderView:[self tablehearderView]];
            }
            
        }
    }];
}

-(UIView*)tablehearderView
{
    CGFloat H = 46;
    UIView * view = [[UIView alloc] init];
    
    view.frame = CGRectMake(0, 0, Device_Width, H);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Device_Width-60, H)];
    label.text = @"本地版本不够？立即开通云端无限次时光倒流！";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    [label release];
    
    UIButton * headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = view.frame;
    [headerBtn addTarget:self action:@selector(tableHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
    headerBtn.tag = 1;
    [view addSubview:headerBtn];
    [headerBtn release];
    
    UIButton * cloBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cloBtn.frame = CGRectMake(Device_Width-50, 0, 50, H);
    [cloBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [cloBtn addTarget:self action:@selector(tableHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
    cloBtn.tag = 2;
    [view addSubview:cloBtn];
    [cloBtn release];
    
    return  view;
}

-(void)tableHeaderClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            HB_UnlimitedBackUpContorller * vc = [[HB_UnlimitedBackUpContorller alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
        case 2:
        {
            self.TimeMachinetable.tableHeaderView = nil;

        }
            break;
            
        default:
            break;
    }
}
- (void)dealloc {
    [_TimeMachinetable release];
    
    [super dealloc];
}
@end
