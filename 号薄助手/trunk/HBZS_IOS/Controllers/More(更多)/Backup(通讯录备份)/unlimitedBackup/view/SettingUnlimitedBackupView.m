//
//  SettingUnlimitedBackupView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/7/29.
//
//

#import "SettingUnlimitedBackupView.h"

#import "step3View.h"

@implementation SettingUnlimitedBackupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [_dataArr release];
    [_step2_view release];
    [_tableView release];
    [_setp1 release];
    [_step2 release];
    [_step3 release];
    [_NextStepBtn release];
    [_topStepView release];
    [_memberCenterBtn release];
    [_contentSize release];
    [_baseView release];
    [super dealloc];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initDataArr];
    
}
-(NSMutableArray *)pickDataArr{
    if (_pickDataArr==nil) {
        _pickDataArr=[[NSMutableArray alloc]init];
        [_pickDataArr addObjectsFromArray:@[@"自动检测",@"每天",@"每周",@"每月"]];
    }
    return _pickDataArr;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.contentSize.constant = 1000;
    self.contentSize.constant = self.memberCenterBtn.frame.origin.y +40+10;
    UIScrollView * view = (UIScrollView *)self.baseView.superview;
    
    NSLog(@"%f,%f",view.contentSize.width,view.contentSize.height);
    
    self.memberCenterBtn.layer.borderWidth= 1;
    self.memberCenterBtn.layer.borderColor = COLOR_A.CGColor;
}


-(instancetype)init{
    self=[super init];
    if (self) {
//        [self initDataArr];
    }
    
    return self;
}

-(void)initDataArr{
    self.dataArr =[[NSMutableArray alloc] init];

    
    HB_SettingSwitchCellModel * model1=[HB_SettingSwitchCellModel modelWithName:@"自动同步通讯录" andSwitchIsOn:[SettingInfo getIsAutosyn]];
    
    
    [self.dataArr addObjectsFromArray:@[model1]];
    
    if ([SettingInfo getIsAutosyn]) {
        HB_SettingOptionCellModel * model2= [HB_SettingOptionCellModel modelWithName:@"同步方式" andOption:nil];
        
        model2.rightString = [self.pickDataArr objectAtIndex:[SettingInfo getAutoSyncType]];
        [self.dataArr addObject:model2];
    }
    
    [self.tableView reloadData];
    
    
    self.StepArr = [NSArray arrayWithObjects:self.setp1,_step2,_step3,nil];
}

#pragma mark  tableView delegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel * label = [[UILabel alloc] init];
    label.font=[UIFont systemFontOfSize:13];
    label.text = @"  请选择开启自动同步:";
    return label;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] init];
    label.textColor = [UIColor redColor];
    label.font=[UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"注：为及时备份通讯录变化，建议开启自动上传。";
    return label;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HB_SettingCellModel * model=self.dataArr[indexPath.row];
    if ([model isKindOfClass:[HB_SettingOptionCellModel class]]) {
        HB_SettingOptionCell * cell=(HB_SettingOptionCell*)[_tableView cellForRowAtIndexPath:indexPath];
        [cell.textfield becomeFirstResponder];
    }
}

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
    [self endEditing:YES];
    
    if (btn.tag == 1) {
        //tag为1 完成
        [SettingInfo setAutoSyncType:self.SelectType];
        
        HB_SettingOptionCellModel * model=[self.dataArr lastObject];
        model.rightString=self.pickDataArr[self.SelectType];
        
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
    if ([model.name isEqualToString:@"自动同步通讯录"]){
        [SettingInfo setIsAutosyn:switcher.on];
        model.switchIsOn = switcher.on;
        if (switcher.on) {
            
            HB_SettingOptionCellModel * model3=[HB_SettingOptionCellModel modelWithName:@"同步方式" andOption:nil];
            model3.rightString = [self.pickDataArr objectAtIndex:[SettingInfo getAutoSyncType]];
            [self.dataArr addObject:model3];
            //定义一个需要插入位置的indexPath
//            NSIndexPath * indexPath1=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            
            
//            [_tableView insertRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
//            [_tableView reloadData];
            
        }
        else
        {
            //删除一个cell(第2个cell)
            [self.dataArr removeLastObject];
            //定义一个需要删除位置的indexPath
//            NSIndexPath * indexPath1=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
//            [_tableView deleteRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
//            [_tableView reloadData];
        }
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
   
}

- (void)setCurrentStep:(NSInteger)currentStep
{
    
    for (NSInteger i = 1; i<=self.StepArr.count; i++) {
        UILabel * label = [self.StepArr objectAtIndex:i-1];
        if (i==currentStep) {
            label.backgroundColor = [UIColor colorFromHexString:@"88D33B"];
        }
        else
        {
            label.backgroundColor = [UIColor colorFromHexString:@"EBEBEB"];
        }
    }
    _currentStep = currentStep;
    if (self.currentStep == 1) {
        [self.NextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.memberCenterBtn.hidden = YES;
    }
    else if (self.currentStep == 2) {
        
        [self.NextStepBtn setTitle:@"立即初始化数据" forState:UIControlStateNormal];
        [self.tableView removeFromSuperview];
        [self initStep2View];
        self.memberCenterBtn.hidden = YES;

        
    }
    else if(self.currentStep == 3)
    {
        [self.tableView removeFromSuperview];
        [self.NextStepBtn setTitle:@"如何使用" forState:UIControlStateNormal];
        if (self.step2_view) {
            [self.step2_view removeFromSuperview];
            
        }

        [self initStep3View];
        self.memberCenterBtn.hidden = NO;

    }
}

- (IBAction)nextStepClick:(id)sender {
    if (self.currentStep == 1) {
        self.currentStep ++;
        return ;
    }
    if ([self.delegate respondsToSelector:@selector(BtnClickWithStep:)]) {
        [self.delegate BtnClickWithStep:self.currentStep];
    }
}

-(void)initStep3View
{
    //这里判断一下屏幕宽高
    
    
    [self layoutSubviews];
    CGFloat x = 0;
    CGFloat y = self.topStepView.frame.origin.y+self.topStepView.frame.size.height+60;
    CGFloat w = self.baseView.frame.size.width;
    CGFloat h = 301;
    step3View * view = [[[NSBundle mainBundle] loadNibNamed:@"step3View" owner:nil options:nil] firstObject];
    view.frame = CGRectMake(x, y, w, h);
    view.contentTextView.text =[NSString stringWithFormat:@"- 您已于%@成功开通云端无限次时光倒流服务；\r- 如需查看或恢复历史通讯录，请登录号簿助手官网(http://pim.189.cn）进行操作。",self.OpenTime];
    view.contentTextView.editable = NO;
    [self.baseView addSubview:view];
    
    self.NextStepBtn.hidden = NO;
}

-(void)initStep2View
{
    CGFloat x = 30;
    CGFloat y = 120;
    CGFloat w = Device_Width-60;
    CGFloat h = 300;
    self.step2_view = [[UITextView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.step2_view.text = @"提示:\r—为更好的体验无限时光机，请点击初始化数据进入下一步\r—初始化数据可能需要一会时间，请耐心等待";
    [self.step2_view setTextColor:[UIColor colorFromHexString:@"999999"]];
    self.step2_view.editable = NO;
    [self.baseView addSubview:self.step2_view];
}


- (IBAction)memberBtnclick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(toMemPrivilegeWeb)]) {
        [self.delegate toMemPrivilegeWeb];
    }
}


@end
