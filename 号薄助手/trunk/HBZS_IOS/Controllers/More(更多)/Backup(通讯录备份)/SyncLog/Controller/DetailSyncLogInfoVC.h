//
//  DetailSyncLogInfoVC.h
//  HBZS_IOS
//
//  Created by zimbean on 14-8-12.
//
//

#import "BaseViewCtrl.h"
#import "SyncLogItem.h"

@interface DetailSyncLogInfoVC : BaseViewCtrl{
    
}

@property (nonatomic, retain)IBOutlet UILabel *syncTypeLabel;
@property (nonatomic, retain)IBOutlet UILabel *startTimeLabel;
@property (nonatomic, retain)IBOutlet UILabel *endTimeLabel;
@property (nonatomic, retain)IBOutlet UILabel *syncResultLabel;

@property (nonatomic, retain)SyncLogItem *logItem;

@end
