//
//  DetailSyncLogInfoVC.m
//  HBZS_IOS
//
//  Created by zimbean on 14-8-12.
//
//

#import "DetailSyncLogInfoVC.h"
#import "UIViewController+TitleView.h"
@interface DetailSyncLogInfoVC ()

@end

@implementation DetailSyncLogInfoVC

@synthesize syncTypeLabel;
@synthesize startTimeLabel;
@synthesize endTimeLabel;
@synthesize syncResultLabel;

@synthesize logItem;

- (void)dealloc{
    if (syncTypeLabel) {
        [syncTypeLabel release];
    }
    
    if (startTimeLabel) {
        [startTimeLabel release];
    }
    
    if (endTimeLabel) {
        [endTimeLabel release];
    }
    
    if (syncResultLabel) {
        [syncResultLabel release];
    }
    
    if (logItem) {
        [logItem release];
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
    
    [self setVCTitle:@"日志详情"];
    
    [self configureData];
    // Do any additional setup after loading the view from its nib.
}

- (void)configureData{
    syncTypeLabel.text = [NSString stringWithFormat:@"操作类型 : %@",logItem.syncType];
    startTimeLabel.text = [NSString stringWithFormat:@"开始时间 : %@",logItem.startTime];;
    endTimeLabel.text = [NSString stringWithFormat:@"结束时间 : %@", logItem.endTime];
    syncResultLabel.text = [NSString stringWithFormat:@"操作结果 : %@",logItem.syncResult];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
