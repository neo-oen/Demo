    //
//  HB_BackupSettingVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_BackupSettingVC.h"
#import "HB_SettingSwitchCell.h"
#import "HB_SettingSwitchCellModel.h"
#import "HB_SettingOptionCell.h"
#import "HB_SettingOptionCellModel.h"

#import "SettingInfo.h"

#import "SVProgressHUD.h"
@interface HB_BackupSettingVC ()<UITableViewDelegate,UITableViewDataSource,HB_SettingSwitchCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate,HB_SettingOptionCellDelegate>
/**
 *  主tableView
 */
@property(nonatomic,retain)UITableView * tableView;
/**  tableView数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**  pickerView数据源 */
@property(nonatomic,retain)NSMutableArray *pickDataArr;


@property(nonatomic,assign)NSInteger SelectType;


@end

@implementation HB_BackupSettingVC

-(void)dealloc{
    [_tableView release];
    [_dataArr release];
    [_pickDataArr release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupInterface];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initDataArr];
    
    
}

#pragma mark - 数据源
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(NSMutableArray *)pickDataArr{
    if (_pickDataArr==nil) {
        _pickDataArr=[[NSMutableArray alloc]init];
        [_pickDataArr addObjectsFromArray:@[@"自动检测",@"每天",@"每周",@"每月"]];
    }
    return _pickDataArr;
}
-(void)initDataArr{
    [_dataArr removeAllObjects];
    
    HB_SettingSwitchCellModel * model1=[HB_SettingSwitchCellModel modelWithName:@"备份联系人头像" andSwitchIsOn:[SettingInfo getIsSyncHeadimg]];

    HB_SettingSwitchCellModel * model2=[HB_SettingSwitchCellModel modelWithName:@"自动同步通讯录" andSwitchIsOn:[SettingInfo getIsAutosyn]];
    

    [self.dataArr addObjectsFromArray:@[model1,model2]];
    
    if ([SettingInfo getIsAutosyn]) {
        HB_SettingOptionCellModel * model3= [HB_SettingOptionCellModel modelWithName:@"同步方式" andOption:nil];
        
        model3.rightString = [self.pickDataArr objectAtIndex:[SettingInfo getAutoSyncType]];
        [self.dataArr addObject:model3];
    }
}
#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //标题
    self.title=@"通讯录备份设置";
}
/**
 *  设置界面
 */
-(void)setupInterface{
    //tableView
    CGFloat tableView_W=SCREEN_WIDTH;
    CGFloat tableView_H=SCREEN_HEIGHT-64;
    CGFloat tableView_X=0;
    CGFloat tableView_Y=0;
    CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    UITableView * tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.rowHeight=50;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
}

#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_SettingCellModel * model=self.dataArr[indexPath.row];
    if ([model isKindOfClass:[HB_SettingOptionCellModel class]]) {
        HB_SettingOptionCell * cell=[HB_SettingOptionCell cellWithTableView:tableView];
        cell.model=(HB_SettingOptionCellModel *)model;
        cell.delegate=self;
        return cell;
    }else if ([model isKindOfClass:[HB_SettingSwitchCellModel class]]){
        HB_SettingSwitchCell * cell=[HB_SettingSwitchCell cellWithTableView:tableView];
        cell.model=(HB_SettingSwitchCellModel *)model;
        cell.delegate=self;
        return cell;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HB_SettingCellModel * model=self.dataArr[indexPath.row];
    if ([model isKindOfClass:[HB_SettingOptionCellModel class]]) {
        HB_SettingOptionCell * cell=(HB_SettingOptionCell*)[_tableView cellForRowAtIndexPath:indexPath];
        [cell.textfield becomeFirstResponder];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.view endEditing:YES];
}
#pragma mark - pickerView
-(UIView * )keyboardPickerView{
    UIView * view=[[[UIView alloc]init] autorelease];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 200);
    view.backgroundColor=[UIColor whiteColor];
    //取消按钮
    UIButton * cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat cancelBtn_W=40;
    CGFloat cancelBtn_H=50;
    CGFloat cancelBtn_X=15;
    CGFloat cancelBtn_Y=0;
    cancelBtn.frame=CGRectMake(cancelBtn_X, cancelBtn_Y, cancelBtn_W, cancelBtn_H);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:16.5];
    [cancelBtn setTitleColor:COLOR_D forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(keyboardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 0;
    [view addSubview:cancelBtn];
    //完成按钮
    UIButton * finishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat finishBtn_W=40;
    CGFloat finishBtn_H=50;
    CGFloat finishBtn_X=SCREEN_WIDTH-15-finishBtn_W;
    CGFloat finishBtn_Y=0;
    finishBtn.frame=CGRectMake(finishBtn_X, finishBtn_Y,finishBtn_W, finishBtn_H);
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font=[UIFont systemFontOfSize:16.5];
    [finishBtn setTitleColor:COLOR_A forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(keyboardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.tag = 1;

    [view addSubview:finishBtn];
    //pickerView
    UIPickerView * pickView=[[UIPickerView alloc]init];
    pickView.frame=CGRectMake(0, 50, SCREEN_WIDTH, 150);
    pickView.delegate=self;
    pickView.dataSource=self;
    //默认选中第
    [pickView selectRow:[SettingInfo getAutoSyncType] inComponent:0 animated:YES];
    pickView.backgroundColor=[UIColor whiteColor];
    [view addSubview:pickView];
    [pickView release];
    
    return view;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickDataArr.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickDataArr[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.SelectType = row;
//    NSArray * cellArr=[_tableView visibleCells];
//    HB_SettingOptionCell * cell=[cellArr lastObject];
//    cell.textfield.text=self.pickDataArr[row];
//    HB_SettingOptionCellModel * model=[self.dataArr lastObject];
//    model.rightString=self.pickDataArr[row];
    
#warning ..此处记录一些操作
}
-(void)keyboardBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    
    if (btn.tag == 1) {
        //tag为1 完成
        [SettingInfo setAutoSyncType:self.SelectType];
//        HB_SettingOptionCellModel * model=[self.dataArr lastObject];
//        model.rightString=self.pickDataArr[self.SelectType];
        [self initDataArr];
        [_tableView reloadData];
    }
    
}
#pragma mark - HB_SettingOptionCell的代理方法
-(void)settingOptionCell:(HB_SettingOptionCell *)cell textFieldBeginEdit:(UITextField *)textField{
    textField.inputView=[self keyboardPickerView];
}
#pragma mark - HB_SettingSwitchCell的代理方法
-(void)settingSwitchCell:(HB_SettingSwitchCell *)cell switchValueChanged:(UISwitch *)switcher{
    NSIndexPath * indexPath=[_tableView indexPathForCell:cell];
    HB_SettingSwitchCellModel * model=self.dataArr[indexPath.row];
    if ([model.name isEqualToString:@"备份联系人头像"]) {
        [SettingInfo setIsSyncHeadimg:switcher.on];
//        if (switcher.on) {
//            //添加一个cell(第2个cell)
//            HB_SettingSwitchCellModel * model2=[HB_SettingSwitchCellModel modelWithName:@"仅在WIFI下备份头像" andSwitchIsOn:NO];
//            [self.dataArr insertObject:model2 atIndex:1];
//            //定义一个需要插入位置的indexPath
//            NSIndexPath * indexPath1=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
//            [_tableView beginUpdates];
//            [_tableView insertRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationTop];
//            [_tableView endUpdates];
//        }else{
//            //删除一个cell(第2个cell)
//            [self.dataArr removeObjectAtIndex:1];
//            //定义一个需要删除位置的indexPath
//            NSIndexPath * indexPath1=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
//            [_tableView beginUpdates];
//            [_tableView deleteRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationTop];
//            [_tableView endUpdates];
//        }
    }else if ([model.name isEqualToString:@"自动同步通讯录"]){
        [SettingInfo setIsAutosyn:switcher.on];
        if (switcher.on) {
            
            HB_SettingOptionCellModel * model3=[HB_SettingOptionCellModel modelWithName:@"同步方式" andOption:nil];
            model3.rightString = [self.pickDataArr objectAtIndex:[SettingInfo getAutoSyncType]];
            [self.dataArr addObject:model3];
            //定义一个需要插入位置的indexPath
            NSIndexPath * indexPath1=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationTop];
            [_tableView endUpdates];
            
//            UIAlertView * al = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"开启自动同步，当检测到联系人有变动是，将会提示您是否进行自动同步" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
//            [al show];
        }
        else
        {
            //删除一个cell(第2个cell)
            [self.dataArr removeLastObject];
            //定义一个需要删除位置的indexPath
            NSIndexPath * indexPath1=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationTop];
            [_tableView endUpdates];
        }
        
    }
    else if ([model.name isEqualToString:@"仅在WIFI下备份头像"]){
        
        
    }
}

@end
