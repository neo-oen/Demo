//
//  SyncLogListCell.m
//  HBZS_IOS
//
//  Created by zimbean on 14-8-12.
//
//

#import "SyncLogListCell.h"
#import "SyncLogItem.h"
#import "UIColor+Extension.h"
@implementation SyncLogListCell

@synthesize statusImgView;
@synthesize syncTypeLabel;
@synthesize endTimeLabel;
@synthesize rightArrowImgView;

- (void)dealloc{
    if (statusImgView) {
        [statusImgView release];
    }
    
    if (syncTypeLabel) {
        [syncTypeLabel release];
    }
    
    if (endTimeLabel) {
        [endTimeLabel release];
    }
    
    if (rightArrowImgView) {
        [rightArrowImgView release];
    }
    
    [super dealloc];
}
- (void)awakeFromNib
{
    // Initialization code
    syncTypeLabel.textColor = [UIColor colorFromHexString:@"ff69A932"];
    endTimeLabel.textColor = [UIColor lightGrayColor];
}

- (void)configureCellWithSyncLog:(SyncLogItem *)logItem{
    self.syncTypeLabel.text = logItem.syncType;
    self.endTimeLabel.text = logItem.endTime;
  
    NSString *statusImgName = ([logItem.syncResult isEqualToString:@"任务成功"]) ? @"sync_success_icon.png" : @"sync_failure_icon.png";
    statusImgView.image = UIImageWithName(statusImgName);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
