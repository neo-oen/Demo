//
//  HB_TimeMachineDetailvc.m
//  HBZS_IOS
//
//  Created by chengfei on 16/1/27.
//
//

#import "HB_TimeMachineDetailvc.h"
#import "HB_ContactModel.h"
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


#import "HB_ContactDataTool.h"

#import "HB_timeMachineSucessView.h"

@interface HB_TimeMachineDetailvc ()
@end

@implementation HB_TimeMachineDetailvc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self allocRightNavItem];
}
-(void)allocRightNavItem
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitle:@"恢复" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
}
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
        cell.model=(HB_ContactInfoPhoneCellModel *)model;
        cell.messageBtn.hidden = YES;
        cell.callBtn.userInteractionEnabled = NO;
        cell.isLastCall = NO;
        return cell;
    }else if ([model isKindOfClass:[HB_ContactInfoEmailCellModel class]]){
        //3.如果是“邮箱”模型
        HB_ContactInfoEmailCell * cell=[HB_ContactInfoEmailCell cellWithTableView:tableView];
        cell.model=(HB_ContactInfoEmailCellModel *)model;
        return cell;
    }else if ([model isKindOfClass:[HB_ContactInfoCallHistoryCellModel class]]){
        //4.如果是“通话记录”模型
        HB_ContactInfoCallHistoryCell * cell=[HB_ContactInfoCallHistoryCell cellWithTableView:tableView];
        cell.model=(HB_ContactInfoCallHistoryCellModel *)model;
        return cell;
    }
    return nil;
}
-(void)viewWillAppear:(BOOL)animated{
    self.store.contactModel = self.contactModel;
    self.headerIconView.contactModel = self.contactModel;
    self.headerIconView.bgimageindex = arc4random()%10;
    //刷新视图
    [self.tableView reloadData];
    self.tableView.tableFooterView.hidden = YES;
}
-(instancetype)initWithModel:(HB_ContactModel*)model
{
    self  = [super init];
    if (self) {
        self.contactModel = model;
    }
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)Click
{
    [HB_ContactDataTool contactAddPeopleByModel:self.contactModel];
    
    [self.view addSubview:[[[HB_timeMachineSucessView alloc] init] autorelease]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        
    });
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
