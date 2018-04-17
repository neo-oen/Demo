//
//  HB_BatchDeleteVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/9/20.
//
//

#import "HB_BatchDeleteVc.h"
#import "HB_ContactCloudShareVc.h"
#import "HBZSAppDelegate.h"
#import "HB_ContactDataTool.h"
#import "SVProgressHUD.h"
#import "HB_MachineDataModel.h"
@interface HB_BatchDeleteVc ()
/** 底部（全选）底部工具条 */
@property(nonatomic,retain)UIView *bottomToolBar;
/** 底部（全选）按钮 */
@property(nonatomic,retain)UIButton * selectAllBtn;
/** 底部（确定）按钮 */
@property(nonatomic,retain)UIButton * confirmBtn;

@property(nonatomic,retain)NSMutableArray * SelectedSimpleModels;
@end

@implementation HB_BatchDeleteVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self restepInterface];
    self.SelectedSimpleModels = [NSMutableArray arrayWithCapacity:0];
}
-(void)setupNavigationBar{
    self.title=@"批量删除联系人";
}

-(void)restepInterface
{
    self.tableView.frame = CGRectMake(0, 0, Device_Width, Device_Height-64-50);
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = YES;
    
    [self.view addSubview:self.bottomToolBar];
    
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
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",self.SelectedSimpleModels.count] forState:UIControlStateNormal];
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
        [_confirmBtn setTitle:@"删除(0)" forState:UIControlStateNormal];
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
            sender.userInteractionEnabled = NO;
            UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要删除所选联系人？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                sender.userInteractionEnabled = YES;
            }];
            UIAlertAction * okAct = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVProgressHUD showWithStatus:@"删除中"];
                //记录时光机处理
                HB_MachineDataModel * model = [HB_MachineDataModel getglobalMachineModel];
                [model getCurrentMachineDataWithSyncTask:0];
                
                [HB_ContactDataTool contactBatchDeleteByArr:self.SelectedSimpleModels];
                [SVProgressHUD showSuccessWithStatus:@"删除完成"];
                
                
                [model globalTimeMachineSave];
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            
            [alert addAction:cancelAct];
            [alert addAction:okAct];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        break;
        
        default:
        break;
    }
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

@end
