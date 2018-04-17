//
//  SyncLogListVC.m
//  HBZS_IOS
//
//  Created by zimbean on 14-8-12.
//
//

#import "SyncLogListVC.h"
#import "SyncLogListCell.h"
#import "SyncLogItem.h"
#import "SettingInfo.h"
#import "UIViewController+TitleView.h"
#import "DetailSyncLogInfoVC.h"


@interface SyncLogListVC ()

@property(nonatomic,strong)UILabel * alertLabel;

@end

@implementation SyncLogListVC
@synthesize syncLogListTable;

- (void)dealloc{
    if (syncLogListTable) {
        [syncLogListTable reloadData];
    }
    
    if (syncLogs) {
        [syncLogs release];
    }
    
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setVCTitle:@"操作日志"];
    syncLogs = [[NSMutableArray alloc]init];
    self.view.backgroundColor = UIColorWithRGB(215, 215, 215);
    [self loadSyncLog];
    
    [self.view addSubview:self.alertLabel];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self hiddenTabBar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)loadSyncLog{
    
//    for (int i = 0; i<13; i++) {
//        SyncLogItem * item = [[SyncLogItem alloc] init];
//        
//        item.endTime = [NSString stringWithFormat:@"%d",i];
//        item.syncType = [NSString stringWithFormat:@"t-%d",i];
//        item.startTime = [NSString stringWithFormat:@"s-%d",i];
//        item.syncResult =[NSString stringWithFormat:@"R-%d",i];
//        [syncLogs addObject:item];
//        [item release];
//        
//    }
//    return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *tempArray = [SettingInfo getSyncLogs];
        
        if (tempArray) {
            [syncLogs addObjectsFromArray:tempArray];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [syncLogListTable reloadData];
        });
    });
}

#pragma mark UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    
    if (syncLogs){
        rowCount = [syncLogs count];
    }
    
    if (rowCount) {
        self.alertLabel.hidden = YES;
    }
    else
    {
        self.alertLabel.hidden = NO;
    }
    
    return rowCount;
}
-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel=[[UILabel alloc]init];
        _alertLabel.textColor=COLOR_H;
        _alertLabel.font=[UIFont boldSystemFontOfSize:30];
        _alertLabel.frame=CGRectMake(0, 150, SCREEN_WIDTH, 60);
        _alertLabel.textAlignment=NSTextAlignmentCenter;
        _alertLabel.text=@"暂无操作日志";
        _alertLabel.hidden=YES;
    }
    return _alertLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SyncLogListCell";
    
    SyncLogListCell *cell = (SyncLogListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SyncLogListCell" owner:self options:nil] lastObject];
    }
    
    SyncLogItem *item = [syncLogs objectAtIndex:indexPath.row];
    
    [cell configureCellWithSyncLog:item];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor = ((indexPath.row % 2) == 0) ? UIColorWithRGB(237, 237, 237) : UIColorWithRGB(243, 243, 243);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SyncLogItem *logItem = [syncLogs objectAtIndex:indexPath.row];
    DetailSyncLogInfoVC *logInfoVC = [[DetailSyncLogInfoVC alloc]initWithNibName:nil bundle:nil];
    logInfoVC.leftBtnIsBack = YES;
    logInfoVC.logItem = logItem;
    [self.navigationController pushViewController:logInfoVC animated:YES];
    [logInfoVC release];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
