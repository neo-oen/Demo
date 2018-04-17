//
//  HB_MessageSettingVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_MessageSettingVC.h"
#import "HB_SettingSwitchCell.h"
#import "HB_SettingSwitchCellModel.h"
#import "SettingInfo.h"

@interface HB_MessageSettingVC ()<UITableViewDelegate,UITableViewDataSource,HB_SettingSwitchCellDelegate>
/**
 *  主tableView
 */
@property(nonatomic,retain)UITableView * tableView;
/**  数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;


@end

@implementation HB_MessageSettingVC

-(void)dealloc{
    [_tableView release];
    [_dataArr release];
    
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
-(void)initDataArr{
    [_dataArr removeAllObjects];
    
    HB_SettingSwitchCellModel * model1=[HB_SettingSwitchCellModel modelWithName:@"仅在WIFI下显示图片" andSwitchIsOn:[SettingInfo getIsShowPicInWifi]];
    HB_SettingSwitchCellModel * model2=[HB_SettingSwitchCellModel modelWithName:@"备份提醒" andSwitchIsOn:[SettingInfo getIsBackUpRemind]];
    
    [self.dataArr addObjectsFromArray:@[model1,model2]];
}
#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //标题
    
    self.title=@"消息设置";
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
    HB_SettingSwitchCell * cell=[HB_SettingSwitchCell cellWithTableView:tableView];
    cell.model=self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(void)settingSwitchCell:(HB_SettingSwitchCell *)cell switchValueChanged:(UISwitch *)switcher
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    switch (indexPath.row) {
        case 0://仅WiFi下显示图片
        {
            [SettingInfo setIsShowPicInWifi:switcher.on];
        }
            break;
        case 1://备份提醒
        {
            [SettingInfo setIsBackUpRemind:switcher.on];
            [self setBackUpRemind:switcher.on];
        }
            break;
        default:
            break;
    }
}

-(void)setBackUpRemind:(BOOL)isRemind
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    [self cancelRemind];
    if (isRemind) {
        [self registerLocalNotification];
    }
}

-(void)cancelRemind
{
    NSArray *notifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in notifications) {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo) {
            NSString *notificationName = [userInfo objectForKey:@"BackupReminderNotification"];
            
            if ([notificationName isEqualToString:@"BackupReminderNotification"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                NSLog(@"---->. cancelLocalNotification");
                break;
            }
        }
    }
    
}

-(void)registerLocalNotification
{
    if (yearformatter == nil) {
        yearformatter = [[NSDateFormatter alloc] init];
    }
    
    if (monthformatter == nil) {
        monthformatter = [[NSDateFormatter alloc] init];
    }
    
    if (dayformatter == nil) {
        dayformatter = [[NSDateFormatter alloc] init];
    }
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc]init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    [yearformatter setDateFormat:@"yyyy"];
    int year = [[yearformatter stringFromDate:[NSDate date]] intValue];
    
    [monthformatter setDateFormat:@"MM"];
    int month = [[monthformatter stringFromDate:[NSDate date]] intValue];
    
    [dayformatter setDateFormat:@"dd"];
    int day = [[dayformatter stringFromDate:[NSDate date]] intValue];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    [dateComponents setHour:10];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    [dateComponents setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    [dateComponents setCalendar:[NSCalendar currentCalendar]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];

    UILocalNotification *reminderNotication = [[UILocalNotification alloc]init];
    reminderNotication.timeZone = [NSTimeZone localTimeZone];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"BackupReminderNotification" forKey:@"BackupReminderNotification"];
    [reminderNotication setUserInfo:dict];
    reminderNotication.alertBody = @"您的通讯录已经一个月没有备份了";
    reminderNotication.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    reminderNotication.soundName = UILocalNotificationDefaultSoundName;
    
    [dateComponents setMonth:month +1];
    reminderNotication.fireDate = [calendar dateFromComponents:dateComponents];
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        reminderNotication.repeatInterval = NSCalendarUnitMonth;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        reminderNotication.repeatInterval = NSCalendarUnitMonth;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:reminderNotication];
}
@end
