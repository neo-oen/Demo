//
//  HB_IndividualitySettingVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_IndividualitySettingVC.h"
#import "HB_SettingOptionCell.h"
#import "HB_SettingOptionCellModel.h"
#import "SettingInfo.h"

@interface HB_IndividualitySettingVC ()<UITableViewDelegate,UITableViewDataSource,HB_SettingOptionCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
/**
 *  主tableView
 */
@property(nonatomic,retain)UITableView * tableView;
/**  tableView数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**  pickerView数据源_启动首页 */
@property(nonatomic,retain)NSMutableArray *pickLunchDataArr;
/**  pickerView数据源_字体大小 */
@property(nonatomic,retain)NSMutableArray *pickFontSizeDataArr;
/**  当前点击的cell */
@property(nonatomic,assign)HB_SettingOptionCell *currentCell;

@property(nonatomic,assign)NSInteger pickRow;

@end

@implementation HB_IndividualitySettingVC

-(void)dealloc{
    [_tableView release];
    [_dataArr release];
    [_pickLunchDataArr release];
    [_pickFontSizeDataArr release];
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
-(NSMutableArray *)pickLunchDataArr{
    if (_pickLunchDataArr==nil) {
        _pickLunchDataArr=[[NSMutableArray alloc]init];
        [_pickLunchDataArr addObjectsFromArray:@[@"拨号",@"联系人",@"上次页面"]];
    }
    return _pickLunchDataArr;
}
-(NSMutableArray *)pickFontSizeDataArr{
    if (_pickFontSizeDataArr==nil) {
        _pickFontSizeDataArr=[[NSMutableArray alloc]init];
        [_pickFontSizeDataArr addObjectsFromArray:@[@"小",@"中",@"大"]];
    }
    return _pickFontSizeDataArr;
}
-(void)initDataArr{
    [_dataArr removeAllObjects];
    
    HB_SettingOptionCellModel * model1=[HB_SettingOptionCellModel modelWithName:@"默认首界面" andOption:nil];
    model1.rightString=[self.pickLunchDataArr objectAtIndex:[SettingInfo getFirstPageNum]-1];
#warning ...这里的默认设置需要更改，暂时屏蔽‘字体大小’选项
//    HB_SettingOptionCellModel * model2=[HB_SettingOptionCellModel modelWithName:@"字体大小" andOption:nil];
//    model2.rightString=@"中";
    
    [self.dataArr addObjectsFromArray:@[model1]];
}
#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //标题
    self.title=@"个性化设置";
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
    HB_SettingOptionCell * cell=[HB_SettingOptionCell cellWithTableView:tableView];
    cell.model=self.dataArr[indexPath.row];
    cell.delegate=self;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HB_SettingOptionCell * cell=(HB_SettingOptionCell*)[_tableView cellForRowAtIndexPath:indexPath];
    _currentCell=cell;
    [cell.textfield becomeFirstResponder];
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
    cancelBtn.tag = 0;
    [cancelBtn addTarget:self action:@selector(keyboardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
    finishBtn.tag = 1;
    [finishBtn addTarget:self action:@selector(keyboardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:finishBtn];
    //pickerView
    UIPickerView * pickView=[[UIPickerView alloc]init];
    pickView.frame=CGRectMake(0, 50, SCREEN_WIDTH, 150);
    pickView.delegate=self;
    pickView.dataSource=self;
    //默认选中第1行
    
    [pickView selectRow:[SettingInfo getFirstPageNum]-1 inComponent:0 animated:YES];
    pickView.backgroundColor=[UIColor whiteColor];
    [view addSubview:pickView];
    [pickView release];
    
    return view;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger  count;
    if ([_currentCell.nameLabel.text isEqualToString:@"默认首界面"]) {
        count=self.pickLunchDataArr.count;
    }else if ([_currentCell.nameLabel.text isEqualToString:@"字体大小"]){
        count=self.pickFontSizeDataArr.count;
    }
    return count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString * title=nil;
    if ([_currentCell.nameLabel.text isEqualToString:@"默认首界面"]) {
        title=self.pickLunchDataArr[row];
    }else if ([_currentCell.nameLabel.text isEqualToString:@"字体大小"]){
        title=self.pickFontSizeDataArr[row];
    }
    return title;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([_currentCell.nameLabel.text isEqualToString:@"默认首界面"]) {
        _currentCell.textfield.text=self.pickLunchDataArr[row];//默认首界面
        HB_SettingOptionCellModel * model = self.dataArr[0];
        model.rightString=self.pickLunchDataArr[row];
        self.pickRow = row;
    }else if ([_currentCell.nameLabel.text isEqualToString:@"字体大小"]){
        _currentCell.textfield.text=self.pickFontSizeDataArr[row];//字体大小
        HB_SettingOptionCellModel * model = self.dataArr[1];
        model.rightString=self.pickFontSizeDataArr[row];
    }
#warning ..此处记录一些操作
}
-(void)keyboardBtnClick:(UIButton *)btn{
    if (btn.tag) {
        [SettingInfo setFirstPageNum:self.pickRow +1];
    }
    [self.view endEditing:YES];
}
#pragma mark - HB_SettingOptionCell的代理方法
-(void)settingOptionCell:(HB_SettingOptionCell *)cell textFieldBeginEdit:(UITextField *)textField{
    _currentCell=cell;
    textField.inputView=[self keyboardPickerView];
}
@end
